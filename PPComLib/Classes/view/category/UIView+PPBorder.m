//
//  UIView+PPBorder.m
//  PPMessage
//
//  Created by PPMessage on 4/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "UIView+PPBorder.h"

@implementation UIView (PPBorder)

- (void)PPMakeBorder {
    [self PPMakeBorderWithWidth:1.0];
}

- (void)PPMakeBorderWithWidth:(CGFloat)borderWidth {
    [self PPMakeBorderWithWidth:borderWidth withColor:[UIColor blackColor]];
}

- (void)PPMakeBorderWithColor:(UIColor *)borderColor {
    [self PPMakeBorderWithWidth:1.0 withColor:borderColor];
}

- (void)PPMakeBorderWithWidth:(CGFloat)borderWidth
                    withColor:(UIColor *)borderColor {
    self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
