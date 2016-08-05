//
//  PPConversationItemView.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationItemViewCell.h"

#import "PPLog.h"
#import "PPBadgeSquareImageView.h"

NSString *const PPConversationItemViewCellIdentifier = @"PPConversationItemViewCellIdentifier";

@interface PPConversationItemViewCell ()

@end

@implementation PPConversationItemViewCell

CGFloat const PPAvatarWidth = 48;
CGFloat const PPTimestampWidth = 100;
CGFloat const PPConversationItemViewHeight = 64;

- (instancetype)init {
    if (self = [super init]) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    
    _avatarView = [PPBadgeSquareImageView new];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _displayNameLabel = [UILabel new];
    _displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_displayNameLabel];
    
    _msgSummaryLabel = [UILabel new];
    _msgSummaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgSummaryLabel.textColor = [UIColor lightGrayColor];
    _msgSummaryLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_msgSummaryLabel];
    
    _msgTimestampLabel = [UILabel new];
    _msgTimestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgTimestampLabel.textAlignment = NSTextAlignmentRight;
    _msgTimestampLabel.font = [UIFont systemFontOfSize:12];
    _msgTimestampLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_msgTimestampLabel];
    
    [self configureAvatarLayoutConstraints];
    [self configureDisplayNameLayoutConstraints];
    [self configureMsgTimestampLayoutConstraints];
    [self configureMsgSummaryLayoutConstraints];
    
}

- (void)configureAvatarLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [_avatarView.imageView squareTo:self.contentView width:PPAvatarWidth];
}

- (void)configureDisplayNameLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_displayNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_avatarView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];

}

- (void)configureMsgTimestampLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgTimestampLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_displayNameLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgTimestampLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgTimestampLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgTimestampLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PPTimestampWidth]];
    
}

- (void)configureMsgSummaryLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgSummaryLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_avatarView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgSummaryLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_displayNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgSummaryLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_msgSummaryLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0]];
    
}

@end
