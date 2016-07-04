//
//  UIView+PPBorder.h
//  PPMessage
//
//  Created by PPMessage on 4/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PPBorder)

- (void)PPMakeBorder;
- (void)PPMakeBorderWithWidth:(CGFloat)borderWidth;
- (void)PPMakeBorderWithColor:(UIColor*)borderColor;
- (void)PPMakeBorderWithWidth:(CGFloat)borderWidth
                    withColor:(UIColor*)borderColor;

@end
