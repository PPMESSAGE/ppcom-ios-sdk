//
//  PPConversationMemberViewCell.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPConversationMemberViewCell.h"

#import "PPUser.h"
#import "PPImageView.h"
#import "PPSDKUtils.h"
#import "UIImage+PPSDK.h"

#import "PPLayoutConstraintsUtils.h"

static CGFloat const kPPConversationMemberViewCellDefaultAvatarWidth = 55.f;
static CGFloat const kPPConversationMemberViewCellDefaultPadding = 5.f;
static CGFloat const kPPConversationMemberViewCellDefaultWidth = 75.f;
static CGFloat const kPPConversationMemberViewCellDefaultLabelFontSize = 15.f;

CGFloat const PPConversationMemberViewCellWidth = kPPConversationMemberViewCellDefaultWidth;
CGFloat const PPConversationMemberViewCellHeight = kPPConversationMemberViewCellDefaultAvatarWidth + kPPConversationMemberViewCellDefaultPadding * 3 + kPPConversationMemberViewCellDefaultLabelFontSize;

NSString *const PPConversationMemberViewCellIdentifier = @"PPConversationMemberViewCellIdentifier";

@interface PPConversationMemberViewCell ()

@property (nonatomic) PPImageView *memberAvatarImageView;
@property (nonatomic) UILabel *memberNameLabel;

@end

@implementation PPConversationMemberViewCell

#pragma mark - constructor

- (instancetype)init {
    if (self = [super init]) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    
    self.memberAvatarImageView = [PPImageView new];
    self.memberAvatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.memberNameLabel = [UILabel new];
    self.memberNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.memberNameLabel.font = [UIFont systemFontOfSize:kPPConversationMemberViewCellDefaultLabelFontSize];
    
    [self.contentView addSubview:self.memberAvatarImageView];
    [self.contentView addSubview:self.memberNameLabel];
    
    [self configureLayoutConstraints];
}

- (void)configureLayoutConstraints {
    
    CGFloat padding = (kPPConversationMemberViewCellDefaultWidth - kPPConversationMemberViewCellDefaultAvatarWidth) / 2;
    
    PPPadding(self.memberAvatarImageView, self.contentView, kPPConversationMemberViewCellDefaultPadding, PPPaddingMaskTop);
    PPPadding(self.memberAvatarImageView, self.contentView, padding, PPPaddingMaskLeading | PPPaddingMaskTrailing );
    PPPadding(self.memberAvatarImageView, self.contentView, kPPConversationMemberViewCellDefaultAvatarWidth, PPPaddingMaskWidth | PPPaddingMaskHeight);
    PPPadding(self.memberNameLabel, self.contentView, kPPConversationMemberViewCellDefaultPadding, PPPaddingMaskBottom);
    PPPadding(self.memberNameLabel, self.contentView, 0, PPPaddingMaskCenterX);
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.memberNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kPPConversationMemberViewCellDefaultWidth]];
    
}

#pragma mark - getter

- (void)setMember:(PPUser *)member {
    _member = member;
    
    if (_member) {
        NSURL *userIcon = _member.userIcon ? [NSURL URLWithString:_member.userIcon] : nil;
        [self.memberAvatarImageView loadWithUrl:userIcon placeHolderImage:[UIImage pp_defaultAvatarImage] completionHandler:nil];
        self.memberNameLabel.text = _member.userName;
    }
}

@end
