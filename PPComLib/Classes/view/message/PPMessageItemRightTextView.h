//
//  PPMessageItemRightTextView.h
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightView.h"

extern NSString *const PPMessageItemRightTextViewIdentifier;
extern CGFloat const PPMessageItemRightTextContentWidthPadding;
extern CGFloat const PPMessageItemRightTextContentHeightPadding;

@interface PPMessageItemRightTextView : PPMessageItemRightView

@property (nonatomic) UITextView *msgTextLabel;

+ (NSString*)textContentInMessage:(PPMessage*)message;
- (NSString*)textContentInMessage:(PPMessage*)message;

@end
