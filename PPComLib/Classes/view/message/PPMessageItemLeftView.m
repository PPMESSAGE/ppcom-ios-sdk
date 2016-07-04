//
//  PPMessageItemLeftView.m
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftView.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPMessageUtils.h"
#import "PPImageUtils.h"
#import "PPLog.h"
#import "PPConstants.h"

#import "PPUser.h"

CGFloat const PPMessageItemLeftViewDefaultBubbleCornerRadius = 17.0f;

@interface PPMessageItemLeftView ()

@property (nonatomic) UIView *rightColumnView;
@property (nonatomic) UIView *msgContentView;
@property (nonatomic) UIView *msgTimestampView;

@property NSLayoutConstraint *msgTimestampConstraintCenterX;
@property NSLayoutConstraint *msgTimestampConstraintMarginTop;
@property NSLayoutConstraint *msgTimestampConstraintHeight;
@property NSLayoutConstraint *avatarConstraintMarginTopWithMsgTimestamp;
@property NSLayoutConstraint *rightColumnConstraintMarginTopWithMsgTimestamp;

@property NSLayoutConstraint *messageContentViewConstraintWidth;
@property NSLayoutConstraint *messageContentViewConstraintHeight;

@end

@implementation PPMessageItemLeftView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    _bubbleColor = PPLightGrayColor();
    _bubbleCornerRadius = PPMessageItemLeftViewDefaultBubbleCornerRadius;
    
    _msgTimestampView = [self messageTimestampView];
    _msgTimestampView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_msgTimestampView];
    
    _avatarImageView = [PPSquareImageView new];
    _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_avatarImageView];
    
    _rightColumnView = [UIView new];
    _rightColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_rightColumnView];
    
    _nameLabel = [UILabel new];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_rightColumnView addSubview:_nameLabel];
    
    _msgContentView = [self messageContentView];
    _msgContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _msgContentView.backgroundColor = _bubbleColor;
    _msgContentView.layer.cornerRadius = _bubbleCornerRadius;
    _msgContentView.clipsToBounds = YES;
    if ([self addTapGestureRecognizer]) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onMessageItemTapped:)];
        [_msgContentView addGestureRecognizer:tapGestureRecognizer];
    }
    [_rightColumnView addSubview:_msgContentView];
    
    [self configureMessageTimestampLayoutConstraints];
    [self configureAvatarImageViewLayoutConstraints];
    [self configureRightColumnViewLayoutConstraints];
    [self configureNameLabelLayoutConstraints];
    [self configureMessageContentLayoutConstraints];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.bubbleCornerRadius = PPMessageItemLeftViewDefaultBubbleCornerRadius;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    if (message.showTimestamp) {
        self.msgTimestampConstraintMarginTop.constant = 8.0f;
        self.msgTimestampConstraintHeight.constant = PPMessageItemViewTimestampHeight;
    } else {
        self.msgTimestampConstraintMarginTop.constant = .0f;
        self.msgTimestampConstraintHeight.constant = .0f;
    }
    
    [self setNeedsUpdateConstraints];
    
    self.messageContentViewSize = CGSizeMake(PPMaxCellWidth(), 0);
    
    NSString *userName = message.fromUser.userName;
    NSURL *userUrl = [NSURL URLWithString:message.fromUser.userIcon];
    
    [self.avatarImageView loadWithUrl:userUrl placeHolderImage:PPDefaultAvatar() completionHandler:nil];
    self.nameLabel.text = userName;
}

- (void)setMessageContentViewSize:(CGSize)messageContentViewSize {
    super.messageContentViewSize = messageContentViewSize;
    
    CGFloat width = messageContentViewSize.width;
    CGFloat height = messageContentViewSize.height;
    
    if (width > .0f) {
        self.messageContentViewConstraintWidth.constant = width;
    }
    
    if (height > .0f) {
        self.messageContentViewConstraintHeight.constant = height;
    }
    
}

- (void)setBubbleCornerRadius:(CGFloat)bubbleCornerRadius {
    _bubbleCornerRadius = bubbleCornerRadius;
    self.messageContentView.layer.cornerRadius = bubbleCornerRadius;
}

- (void)configureMessageTimestampLayoutConstraints {
    _msgTimestampConstraintCenterX = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    _msgTimestampConstraintMarginTop = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0];
    _msgTimestampConstraintMarginTop.priority = UILayoutPriorityDefaultLow;
    
    _msgTimestampConstraintHeight = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPMessageItemViewTimestampHeight];
    
    [self addConstraint:_msgTimestampConstraintCenterX];
    [self addConstraint:_msgTimestampConstraintMarginTop];
    [self addConstraint:_msgTimestampConstraintHeight];
    
}

- (void)configureAvatarImageViewLayoutConstraints {
    [_avatarImageView squareTo:self width:PPMessageItemViewAvatarWidth];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0]];
    
    _avatarConstraintMarginTopWithMsgTimestamp = [NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_msgTimestampView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    
    [self addConstraint:_avatarConstraintMarginTopWithMsgTimestamp];
    
}

- (void)configureRightColumnViewLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_avatarImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];
    
    _rightColumnConstraintMarginTopWithMsgTimestamp = [NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_msgTimestampView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    
    [self addConstraint:_rightColumnConstraintMarginTopWithMsgTimestamp];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0]];
}

- (void)configureNameLabelLayoutConstraints {
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_rightColumnView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_rightColumnView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPMessageItemViewNameLabelHeight]];
    
}

- (void)configureMessageContentLayoutConstraints {
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0]];
    
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_rightColumnView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [_rightColumnView addConstraint:[NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_rightColumnView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    _messageContentViewConstraintWidth = [NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPMaxCellWidth()];
    
    _messageContentViewConstraintHeight = [NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    [_rightColumnView addConstraint:_messageContentViewConstraintWidth];
    [_rightColumnView addConstraint:_messageContentViewConstraintHeight];
    
}

@end
