//
//  PPMessageItemRightView.m
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightView.h"

#import "PPLayoutConstraintsUtils.h"
#import "UIImage+PPSDK.h"
#import "PPMessageUtils.h"
#import "PPLog.h"
#import "PPConstants.h"
#import "UIView+PPBorder.h"

#import "PPUser.h"

static CGFloat const kPPMessageItemRightViewStatusViewWidth = 18;
CGFloat const PPMessageItemRightViewDefaultBubbleCornerRadius = 7.0f;

@interface PPMessageItemRightView ()

@property (nonatomic) UIView *rightColumnView;
@property (nonatomic) UIView *msgContentView;
@property (nonatomic) UIView *msgTimestampView;

@property (nonatomic) UIView *msgStatusView;
@property (nonatomic) UIActivityIndicatorView *msgStatusLoadingView;
@property (nonatomic) PPSquareImageView *msgStatusErrorView;

@property NSLayoutConstraint *msgTimestampConstraintCenterX;
@property NSLayoutConstraint *msgTimestampConstraintMarginTop;
@property NSLayoutConstraint *msgTimestmapConstraintHeight;
@property NSLayoutConstraint *avatarConstraintMarginTopWithMsgTimestamp;
@property NSLayoutConstraint *rightColumnConstraintMarginTopWithMsgTimestamp;

@property NSLayoutConstraint *messageContentViewConstraintWidth;
@property NSLayoutConstraint *messageContentViewConstraintHeight;

@property (nonatomic) NSLayoutConstraint *messageStatusViewConstraintWidth;
@property (nonatomic) NSLayoutConstraint *messageStatusViewConstraintHeight;

@end

@implementation PPMessageItemRightView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    
    _bubbleColor = PPBlueColor();
    _bubbleCornerRadius = PPMessageItemRightViewDefaultBubbleCornerRadius;
    
    _msgTimestampView = [self messageTimestampView];
    _msgTimestampView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_msgTimestampView];

    _rightColumnView = [UIView new];
    _rightColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_rightColumnView];

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
    
    _msgStatusView = [UIView new];
    _msgStatusView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_msgStatusView];
    
    self.leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftView];
    
    [self configureMessageTimestampLayoutConstraints];
    [self configureRightColumnViewLayoutConstraints];
    [self configureMessageContentLayoutConstraints];
    [self pp_configureMessageStatusViewLayoutConstraints];
    [self configureLeftViewLayoutConstraints];
    
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    // TODO: Unable to simultaneously satisfy constraints.
    if (message.showTimestamp) {
        self.msgTimestmapConstraintHeight.constant = PPMessageItemViewTimestampHeight;
        self.msgTimestampConstraintMarginTop.constant = 8.0f;
    } else {
        self.msgTimestmapConstraintHeight.constant = .0;
        self.msgTimestampConstraintMarginTop.constant = .0;
    }
    
    [self setNeedsUpdateConstraints];

    [self pp_presentMessage:message forStatus:message.status];
    
}

- (void)pp_presentMessage:(PPMessage*)message
                forStatus:(PPMessageStatus)messageStatus {
    
    switch (messageStatus) {
        case PPMessageStatusError:
            [self pp_showMessageStatusView];
            [self pp_presentMessageForErrorStatus:message];
            break;
            
        case PPMessageStatusLoading:
            [self pp_showMessageStatusView];
            [self pp_presentMessageForLoadingStatus:message];
            break;
            
        case PPMessageStatusOk:
            break;
    }
    
}

- (void)pp_presentMessageForLoadingStatus:(PPMessage*)message {
    
    // Hidden `ERROR` view
    if (_msgStatusErrorView) {
        _msgStatusErrorView.hidden = YES;
    }
    
    if (!_msgStatusLoadingView) {
        _msgStatusLoadingView = [UIActivityIndicatorView new];
        _msgStatusLoadingView.color = [UIColor lightGrayColor];
        _msgStatusLoadingView.translatesAutoresizingMaskIntoConstraints = NO;
        [_msgStatusView addSubview:_msgStatusLoadingView];
        
        PPPaddingAll(_msgStatusLoadingView, _msgStatusView, .0);
    }
    
    if (_msgStatusLoadingView) {
        _msgStatusLoadingView.hidden = NO;
        [_msgStatusLoadingView startAnimating];
    }
}

- (void)pp_presentMessageForErrorStatus:(PPMessage*)message {
    // Hidden `Loading` View
    if (_msgStatusLoadingView) {
        _msgStatusLoadingView.hidden = YES;
    }
    
    if (!_msgStatusErrorView) {
        _msgStatusErrorView = [PPSquareImageView new];
        _msgStatusErrorView.translatesAutoresizingMaskIntoConstraints = NO;
        [_msgStatusView addSubview:_msgStatusErrorView];
        
        PPPaddingAll(_msgStatusErrorView, _msgStatusView, .0);
    }
    if (_msgStatusErrorView) {
        _msgStatusErrorView.hidden = NO;
        _msgStatusErrorView.image = [UIImage pp_defaultMessageErrorImage];
    }
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

- (void)prepareForReuse {
    [super prepareForReuse];
    self.bubbleCornerRadius = PPMessageItemRightViewDefaultBubbleCornerRadius;
    [self pp_hideMessageStatusView];
    
}

- (void)setBubbleCornerRadius:(CGFloat)bubbleCornerRadius {
    _bubbleCornerRadius = bubbleCornerRadius;
    self.messageContentView.layer.cornerRadius = _bubbleCornerRadius;
}

- (void)configureMessageTimestampLayoutConstraints {
    _msgTimestampConstraintCenterX = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    _msgTimestampConstraintMarginTop = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0];
    _msgTimestampConstraintMarginTop.priority = UILayoutPriorityDefaultLow;
    
    _msgTimestmapConstraintHeight = [NSLayoutConstraint constraintWithItem:_msgTimestampView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPMessageItemViewTimestampHeight];
    
    [self addConstraint:_msgTimestampConstraintCenterX];
    [self addConstraint:_msgTimestampConstraintMarginTop];
    [self addConstraint:_msgTimestmapConstraintHeight];
    
}



- (void)configureRightColumnViewLayoutConstraints {
    // Trailing
    // [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_avatarImageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0]];


    // top
    _rightColumnConstraintMarginTopWithMsgTimestamp = [NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_msgTimestampView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    
    [self addConstraint:_rightColumnConstraintMarginTopWithMsgTimestamp];
    
    // leading
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightColumnView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0]];
}


- (void)configureMessageContentLayoutConstraints {
    // ----------
    // |    ++++| (nameLabel)
    // |    ****| (contentView)
    // |    ****|
    // ----------

    PPPadding(_msgContentView, _rightColumnView, 1.0, PPPaddingMaskTop | PPPaddingMaskTrailing);

    
    // trailing & bottom
    PPPadding(_msgContentView, _rightColumnView, .0, PPPaddingMaskBottom | PPPaddingMaskTrailing);
    
    // width
    _messageContentViewConstraintWidth = [NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPMaxCellWidth()];
    [_rightColumnView addConstraint:_messageContentViewConstraintWidth];
    
    // height
    _messageContentViewConstraintHeight = [NSLayoutConstraint constraintWithItem:_msgContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    [_rightColumnView addConstraint:_messageContentViewConstraintHeight];
    
}

//
// [status]-(8)-[leftview]-(8)-[rightColumnView]-(8)-[user-avatar]
//
- (void)configureLeftViewLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_msgContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_msgContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_msgStatusView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];
}

- (void)pp_configureMessageStatusViewLayoutConstraints {
    // width & height
    _messageStatusViewConstraintHeight = [NSLayoutConstraint constraintWithItem:_msgStatusView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kPPMessageItemRightViewStatusViewWidth];
    
    _messageStatusViewConstraintWidth = [NSLayoutConstraint constraintWithItem:_msgStatusView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:kPPMessageItemRightViewStatusViewWidth];
    
    [self addConstraint:_messageStatusViewConstraintHeight];
    [self addConstraint:_messageStatusViewConstraintWidth];
    
    // centerY with msgContentView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgStatusView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_msgContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
}

- (void)pp_configureMessageStatusViewLayoutConstraintsWithWidth:(CGFloat)width
                                                         height:(CGFloat)heigh {
    _messageStatusViewConstraintHeight.constant = heigh;
    _messageStatusViewConstraintWidth.constant = width;
}

- (void)pp_showMessageStatusView {
    [self pp_configureMessageStatusViewLayoutConstraintsWithWidth:kPPMessageItemRightViewStatusViewWidth height:kPPMessageItemRightViewStatusViewWidth];
}

- (void)pp_hideMessageStatusView {
    [self pp_configureMessageStatusViewLayoutConstraintsWithWidth:.0f height:.0f];
}

// =====================
// Getter Setter
// =====================
- (UIView*)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
    }
    return _leftView;
}

@end
