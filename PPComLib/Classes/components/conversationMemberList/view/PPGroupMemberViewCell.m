//
//  PPGroupMemberViewCell.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGroupMemberViewCell.h"

#import "PPUser.h"
#import "PPImageView.h"
#import "PPSDKUtils.h"
#import "UIImage+PPSDK.h"

#import "PPLayoutConstraintsUtils.h"

static CGFloat const kPPGroupMemberViewCellDefaultAvatarWidth = 55.f;
static CGFloat const kPPGroupMemberViewCellDefaultPadding = 5.f;
static CGFloat const kPPGroupMemberViewCellDefaultWidth = 75.f;
static CGFloat const kPPGroupMemberViewCellDefaultLabelFontSize = 15.f;

CGFloat const PPGroupMemberViewCellWidth = kPPGroupMemberViewCellDefaultWidth;
CGFloat const PPGroupMemberViewCellHeight = kPPGroupMemberViewCellDefaultAvatarWidth + kPPGroupMemberViewCellDefaultPadding * 3 + kPPGroupMemberViewCellDefaultLabelFontSize;

NSString *const PPGroupMemberViewCellIdentifier = @"PPGroupMemberViewCellIdentifier";

@interface PPGroupMemberViewCell ()

@property (nonatomic) PPImageView *memberAvatarImageView;
@property (nonatomic) UILabel *memberNameLabel;

@end

@implementation PPGroupMemberViewCell

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
    self.memberNameLabel.font = [UIFont systemFontOfSize:kPPGroupMemberViewCellDefaultLabelFontSize];
    
    [self.contentView addSubview:self.memberAvatarImageView];
    [self.contentView addSubview:self.memberNameLabel];
    
    [self configureLayoutConstraints];
}

- (void)configureLayoutConstraints {
    
    CGFloat padding = (kPPGroupMemberViewCellDefaultWidth - kPPGroupMemberViewCellDefaultAvatarWidth) / 2;
    
    PPPadding(self.memberAvatarImageView, self.contentView, kPPGroupMemberViewCellDefaultPadding, PPPaddingMaskTop);
    PPPadding(self.memberAvatarImageView, self.contentView, padding, PPPaddingMaskLeading | PPPaddingMaskTrailing );
    PPPadding(self.memberAvatarImageView, self.contentView, kPPGroupMemberViewCellDefaultAvatarWidth, PPPaddingMaskWidth | PPPaddingMaskHeight);
    PPPadding(self.memberNameLabel, self.contentView, kPPGroupMemberViewCellDefaultPadding, PPPaddingMaskBottom);
    PPPadding(self.memberNameLabel, self.contentView, 0, PPPaddingMaskCenterX);
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.memberNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kPPGroupMemberViewCellDefaultWidth]];
    
}

#pragma mark - getter

- (void)setGroupMember:(PPUser *)groupMember {
    _groupMember = groupMember;
    
    if (_groupMember) {
        NSURL *userIcon = _groupMember.userIcon ? [NSURL URLWithString:_groupMember.userIcon] : nil;
        [self.memberAvatarImageView loadWithUrl:userIcon placeHolderImage:[UIImage pp_defaultAvatarImage] completionHandler:nil];
        self.memberNameLabel.text = _groupMember.userName;
    }
}

@end
