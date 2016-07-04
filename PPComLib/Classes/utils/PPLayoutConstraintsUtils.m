//
//  PPLayoutConstraintsUtils.m
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPLayoutConstraintsUtils.h"
#import "PPLog.h"

void PPPadding(UIView *view, UIView *superView, CGFloat constant, PPPaddingMask paddingMask) {
    
    if (paddingMask & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:constant]];
    }
    
    if ((paddingMask >> 1) & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant]];
    }
    
    if ((paddingMask >> 2) & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-constant]];
    }
    
    if ((paddingMask >> 3) & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-constant]];
    }
    
    if ((paddingMask >> 4) & 1) { // not use `constant`
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }
    
    if ((paddingMask >> 5) & 1) { // not use `constant`
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    
    if ((paddingMask >> 6) & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant]];
    }
    
    if ((paddingMask >> 7) & 1) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant]];
    }
    
}

void PPPaddingAll(UIView* view, UIView* superView, CGFloat padding) {
    PPPadding(view, superView, padding, PPPaddingMaskLeading | PPPaddingMaskTop | PPPaddingMaskTrailing | PPPaddingMaskBottom);
}