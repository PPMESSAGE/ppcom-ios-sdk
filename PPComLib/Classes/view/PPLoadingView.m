//
//  PPLoadingView.m
//  PPMessage
//
//  Created by PPMessage on 2/14/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPLoadingView.h"

#import "PPSDKUtils.h"
#import "PPLayoutConstraintsUtils.h"

#import <QuartzCore/QuartzCore.h>
#import "PPConstants.h"

@interface PPLoadingView ()

@property (nonatomic) UILabel *loadingTextLabel;
@property (nonatomic) UIActivityIndicatorView *loadingIndicatorView;

@end

@implementation PPLoadingView

CGFloat const PPLoadingViewPadding = 45;

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

- (void)pp_init {
    
    self.backgroundColor = PPHalfTransparentColor();
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.zPosition = MAXFLOAT;
    self.loading = NO;
    self.loadingText = PPLocalizedString(@"Please Wait");
    
    _loadingTextLabel = [UILabel new];
    _loadingTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingTextLabel.textColor = [UIColor whiteColor];
    [self addSubview:_loadingTextLabel];
    
    _loadingIndicatorView = [UIActivityIndicatorView new];
    _loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_loadingIndicatorView];
    
    [self configureLoadingTextLabelLayoutConstraints];
    [self configureLoadingIndicatorViewLayoutConstraints];
    
}

- (void)setLoading:(BOOL)loading {
    self.hidden = !loading;
    if (loading) {
        _loadingTextLabel.text = self.loadingText;
        [_loadingIndicatorView startAnimating];
    } else {
        [_loadingIndicatorView stopAnimating];
    }
}

- (void)configureLoadingTextLabelLayoutConstraints {
    // bottom
    PPPadding(_loadingTextLabel, self, 10, PPPaddingMaskBottom);
    
    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loadingTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_loadingIndicatorView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:PPLoadingViewPadding - 25]];
    
    // leading and trailing
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loadingTextLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
}

- (void)configureLoadingIndicatorViewLayoutConstraints {
    
    // top | leading | trailing
    PPPadding(_loadingIndicatorView, self, PPLoadingViewPadding, PPPaddingMaskLeading | PPPaddingMaskTop | PPPaddingMaskTrailing );
    
}

@end
