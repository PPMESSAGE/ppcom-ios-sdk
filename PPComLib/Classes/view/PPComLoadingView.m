//
//  PPLoadingView.m
//  PPComLib
//
//  Created by PPMessage on 5/4/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPComLoadingView.h"
#import "PPLayoutConstraintsUtils.h"

@interface PPComLoadingView ()

@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PPComLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - helpers

- (void)commonInit {
    self.frame = CGRectMake(0, 0, 140, 140);
    self.loadingText = @"Loading...";
    self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:0.6f];
    self.layer.cornerRadius = 5.0f;
    
    _loadingLabel = [[UILabel alloc] init];
    _loadingLabel.text = self.loadingText;
    _loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_loadingLabel];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_activityIndicatorView startAnimating];
    [self addSubview:_activityIndicatorView];
    
    [self configureLayoutConstraints];
}

- (void)configureLayoutConstraints {
    PPPadding(_activityIndicatorView, self, 0, PPPaddingMaskCenterX); // Horizontally center
    PPPadding(_loadingLabel, self, 0, PPPaddingMaskCenterX); // Horizontally center
    PPPadding(_activityIndicatorView, self, -10, PPPaddingMaskCenterY);
    PPPadding(_loadingLabel, self, 15, PPPaddingMaskCenterY);
}

#pragma mark - setter getter

- (void)setLoadingText:(NSString *)loadingText {
    if (![loadingText isEqualToString:_loadingText]) {
        _loadingText = loadingText;
        _loadingLabel.text = loadingText;
    }
}

@end
