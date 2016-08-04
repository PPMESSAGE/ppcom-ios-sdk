//
//  PPLayoutConstraintsUtils.h
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, PPPaddingMask) {
    PPPaddingMaskLeading = 1 << 0,
    PPPaddingMaskTop = 1 << 1,
    PPPaddingMaskTrailing = 1 << 2,
    PPPaddingMaskBottom = 1 << 3,
    PPPaddingMaskCenterX = 1 << 4,
    PPPaddingMaskCenterY = 1 << 5,
    PPPaddingMaskWidth = 1 << 6,
    PPPaddingMaskHeight = 1 << 7
};

void PPPadding(UIView *view, UIView *superView, CGFloat constant, PPPaddingMask paddingMask);
void PPPaddingAll(UIView* view, UIView* superView, CGFloat padding);