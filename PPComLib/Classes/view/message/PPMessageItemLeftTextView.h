//
//  PPMessageItemLeftTextView.h
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftView.h"

extern NSString *const PPMessageItemLeftTextViewIdentifier;
extern CGFloat const PPMessageItemLeftTextContentWidthPadding;
extern CGFloat const PPMessageItemLeftTextContentHeightPadding;

@interface PPMessageItemLeftTextView : PPMessageItemLeftView

@property (nonatomic) UITextView *leftMsgTextLabel;

+ (NSString*)textContentInMessage:(PPMessage*)message;
- (NSString*)textContentInMessage:(PPMessage*)message;

@end
