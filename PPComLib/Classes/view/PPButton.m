//
//  PPButton.m
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPButton.h"
#import <QuartzCore/QuartzCore.h>
#import "PPImageUtils.h"

@implementation PPButton

CGFloat const PPButtonCornerRadius = 5;

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
    self.layer.cornerRadius = PPButtonCornerRadius;
    self.clipsToBounds = YES;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)setBgColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    UIImage *image = PPImageWithColor(backgroundColor);
    [self setBackgroundImage:image forState:state];
}

@end
