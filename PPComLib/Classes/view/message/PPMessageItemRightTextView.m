//
//  PPMessageItemRightTextView.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightTextView.h"
#import "PPMessageUtils.h"
#import "PPLog.h"

@implementation PPMessageItemRightTextView

CGFloat const PPMessageTextNeedRelayoutThreshold = 10.0f;
CGFloat const PPMessageItemRightTextContentWidthPadding = 15;
CGFloat const PPMessageItemRightTextContentHeightPadding = 17;

NSString *const PPMessageItemRightTextViewIdentifier = @"PPMessageItemRightTextView";

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellSize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellSize, CGSizeZero)) {
        CGSize textSize = PPTextPlainSize([self textContentInMessage:message], [UIFont systemFontOfSize:17]);
        textSize.width += PPMessageItemRightTextContentWidthPadding;
        textSize.height += PPMessageItemRightTextContentHeightPadding;
        cellSize = textSize;
        
        [self setCellBodySize:cellSize forMessage:message];
    }
    return cellSize;
}

+ (NSString*)textContentInMessage:(PPMessage *)message {
    return message.body;
}

- (UIView*)messageContentView {
    if (!_msgTextLabel) {
        _msgTextLabel = [UITextView new];
        _msgTextLabel.textColor = [UIColor whiteColor];
        _msgTextLabel.font = [UIFont systemFontOfSize:17];
        _msgTextLabel.editable = NO;
    }
    return _msgTextLabel;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    self.msgTextLabel.text = [self textContentInMessage:message];
    self.messageContentViewSize = [PPMessageItemRightTextView cellBodySizeForMessage:message];
    
    if (self.messageContentViewSize.width < PPMessageItemRightViewDefaultBubbleCornerRadius * 3) {
        self.bubbleCornerRadius = MIN(self.messageContentViewSize.width, self.messageContentViewSize.height) / 2;
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.msgTextLabel.textAlignment = NSTextAlignmentLeft;
}

- (NSString*)textContentInMessage:(PPMessage *)message {
    return [PPMessageItemRightTextView textContentInMessage:message];
}

@end
