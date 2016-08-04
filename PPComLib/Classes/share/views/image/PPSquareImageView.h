//
//  PPSquareImageView.h
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPImageView.h"
#import "CustomBadge.h"

@interface PPSquareImageView : PPImageView

@property (nonatomic) CustomBadge *badge;

/**
 * 是否圆角矩形边框，默认为`NO`
 */
@property (nonatomic) BOOL roundRectBorder;

- (void)squareTo:(UIView *)superView width:(CGFloat)width;

@end
