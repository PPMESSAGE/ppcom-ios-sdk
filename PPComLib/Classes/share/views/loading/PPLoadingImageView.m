//
//  PPLoadingImageView.m
//  PPMessage
//
//  Created by PPMessage on 5/24/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPLoadingImageView.h"
#import "PPLayoutConstraintsUtils.h"

@interface PPLoadingImageView ()

@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation PPLoadingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.indicatorView];
    
    [self configureLayoutConstratins];
}

- (void)configureLayoutConstratins {
    PPPadding(self.indicatorView, self, 0, PPPaddingMaskCenterX | PPPaddingMaskCenterY);
}

#pragma mark - getter

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    if (_loading) {
        [self.indicatorView startAnimating];
    } else {
        [self.indicatorView stopAnimating];
    }
}

- (UIActivityIndicatorView*)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
