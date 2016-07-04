//
//  PPBadgeImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/21/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPBadgeSquareImageView.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPLog.h"
#import "PPConstants.h"

static CGFloat const kPPBadgeSquareImageViewMargin = 5.0f;
static CGFloat const kPPBadgeSquareImageViewBadgeWidth = 20.0f;

@interface PPBadgeSquareImageView ()

@property (nonatomic) NSLayoutConstraint *badgeViewWidthConstraint;
@property (nonatomic) NSLayoutConstraint *badgeViewHeightConstraint;

@end

@implementation PPBadgeSquareImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self pp_init];
    }
    return self;
}

#pragma mark - Private Methods

- (void)pp_init {
    _imageView = [PPSquareImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageView];
    
    BadgeStyle *badgeStyle = [BadgeStyle defaultStyle];
    badgeStyle.badgeInsetColor = PPBadgeRedColor();
    _badgeView = [CustomBadge customBadgeWithString:nil withScale:0.7 withStyle:badgeStyle];
    _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_badgeView];
    
    [self pp_configureImageViewLayoutConstraints];
    [self pp_configureBadgeViewLayoutConstraints];
    
}

- (void)pp_configureImageViewLayoutConstraints {
    PPPaddingAll(_imageView, self, kPPBadgeSquareImageViewMargin);
}

- (void)pp_configureBadgeViewLayoutConstraints {
    PPPadding(_badgeView, self, 0, PPPaddingMaskTop | PPPaddingMaskTrailing);
    
    _badgeViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:.0];
    
    _badgeViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:.0];
    
    [self addConstraint:_badgeViewWidthConstraint];
    [self addConstraint:_badgeViewHeightConstraint];
    
}

#pragma mark - Getter

- (void)setBadgeText:(NSString *)badgeText {
    CGFloat badgeWidth = .0f;
    
    if (badgeText) {
        badgeWidth = kPPBadgeSquareImageViewBadgeWidth;
        _badgeView.badgeText = badgeText;
    } else {
        _badgeView.badgeText = nil;
    }
    
    _badgeViewWidthConstraint.constant = badgeWidth;
    _badgeViewHeightConstraint.constant = badgeWidth;
    
    [_badgeView setNeedsDisplay];
    
}

@end
