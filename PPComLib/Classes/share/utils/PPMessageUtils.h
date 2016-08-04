//
//  PPMessageUtils.h
//  PPMessage
//
//  Created by PPMessage on 2/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PPMessage.h"

extern CGFloat const PPMessageMaxContentWidthRatio;
extern CGFloat const PPMessageFileIconHeight;
extern NSUInteger const PPMessageTextMaxLengthLimit;
extern CGFloat const PPMessageItemVoiceViewMinimumLength;

typedef NS_ENUM(NSInteger, PPTableViewScrollDirection) {
    PPTableViewScrollDirectionNone,
    PPTableViewScrollDirectionUp,
    PPTableViewScrollDirectionDown
};

CGFloat PPMaxCellWidth();
CGFloat PPMaxImageMessageCellHeight();
CGSize PPImageCellTargetSize(CGSize originImageSize);
CGSize PPVoiceMessageCellWidth(CGFloat duration);

CGSize PPTextPlainSize(NSString *text, UIFont *font);

NSUInteger PPTextViewLineNumber(UITextView *textView);

NSDictionary* PPJSONStringToDictionary(NSString* jsonString);
NSString* PPDictionaryToJsonString(NSDictionary* dictionary);

BOOL PPIsLargeTxtMessage(NSString *text);

/**
 * 参考`referenceTimestamp`, 确定`messages`中的每个`PPMesage`是否应该显示timestamp
 */
void PPAddTimestampToMessages(NSMutableArray* messages, double referenceTimstamp);

/**
 *
 * 用以确认新产生的消息`tailMessage`是否应该显示timestamp，相对于内存中已经存在的消息数组`memoryMessags`来说
 *
 * `tailMessage`产生来源于两种途径：
 *
 * 1.新消息到来
 * 2.消息发送出去
 *
 * @param memoryMessages 当前`conversation`中在内存中的消息数组
 * @param tailMessage 刚刚产生的新消息
 *
 */
void PPAddTimestampIfNeedToMessage(NSMutableArray* memoryMessages, PPMessage* tailMessage);

/**
 * 仅用于开发模拟数据
 */
BOOL PPRandomBool();