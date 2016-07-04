//
//  PPSquareImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPSquareImageView.h"
#import "PPLayoutConstraintsUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation PPSquareImageView

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
    self.roundRectBorder = NO;
}

- (void)squareTo:(UIView *)superView width:(CGFloat)width {
    PPPadding(self, superView, width, PPPaddingMaskWidth | PPPaddingMaskHeight);
    
    self.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setRoundRectBorder:(BOOL)roundRectBorder {
    if (roundRectBorder) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
    } else {
        self.layer.cornerRadius = 0.0f;
        self.layer.masksToBounds = NO;
    }
}

@end
