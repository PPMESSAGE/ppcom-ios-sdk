//
//  PPConstants.m
//  PPMessage
//
//  Created by PPMessage on 2/16/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConstants.h"

UIColor* PPHalfTransparentColor() {
    return PPTransparentColor(0.5);
}

UIColor* PPTransparentColor(CGFloat alpha) {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}

UIColor *PPLightGrayColor() {
    return [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0];
}

UIColor *PPBlueColor() {
    return [UIColor colorWithRed:33.0f/255.0f green:170.0f/255.0f blue:225.0f/255.0f alpha:1.0];
}

UIColor *PPBadgeRedColor() {
    return [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.0f blue:48.0f/255.0f alpha:1.0];
}