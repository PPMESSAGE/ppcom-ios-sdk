//
//  PPMessageItemLeftTextView.m
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftTextView.h"

#import "PPMessageUtils.h"
#import "PPLog.h"

@implementation PPMessageItemLeftTextView

NSString *const PPMessageItemLeftTextViewIdentifier = @"PPMessageItemLeftTextView";
CGFloat const PPMessageItemLeftTextContentWidthPadding = 15;
CGFloat const PPMessageItemLeftTextContentHeightPadding = 17;

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellSize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellSize, CGSizeZero)) {
        CGSize textSize = PPTextPlainSize([self textContentInMessage:message], [UIFont systemFontOfSize:17]);
        
        textSize.width += PPMessageItemLeftTextContentWidthPadding;
        textSize.height += PPMessageItemLeftTextContentHeightPadding;
        
        cellSize = textSize;
        
        [self setCellBodySize:cellSize forMessage:message];
    }
    return cellSize;
}

+ (NSString*)textContentInMessage:(PPMessage *)message {
    return message.body;
}

- (UIView*)messageContentView {
    if (!_leftMsgTextLabel) {
        _leftMsgTextLabel = [UITextView new];
        _leftMsgTextLabel.font = [UIFont systemFontOfSize:17];
        _leftMsgTextLabel.editable = NO;
        _leftMsgTextLabel.scrollEnabled = NO;
        _leftMsgTextLabel.selectable = YES;
        _leftMsgTextLabel.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _leftMsgTextLabel;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];

    self.leftMsgTextLabel.text = [self textContentInMessage:message];
    self.messageContentViewSize = [PPMessageItemLeftTextView cellBodySizeForMessage:message];
    
    if (self.messageContentViewSize.width < PPMessageItemLeftViewDefaultBubbleCornerRadius * 3) {
        self.bubbleCornerRadius = MIN(self.messageContentViewSize.width, self.messageContentViewSize.height) / 2;
    }
    
}

- (NSString*)textContentInMessage:(PPMessage*)message {
    return [PPMessageItemLeftTextView textContentInMessage:message];
}

@end
