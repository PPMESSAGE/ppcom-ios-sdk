//
//  PPMessageUtils.m
//  PPMessage
//
//  Created by PPMessage on 2/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageUtils.h"
#import "PPLog.h"
#import "PPMessage.h"

#pragma mark - Max Cell Dimensions

CGFloat const PPMessageMaxContentWidthRatio = 0.7;
CGFloat const PPMessageFileIconHeight = 64;
NSUInteger const PPMessageTextMaxLengthLimit = 128;
NSInteger const PPMessageTimestampDelay = 5 * 60; // 300s

#pragma mark - Private
BOOL pp_shouldShowTimestamp(double bigTimestamp, double smallTimestamp) {
    return bigTimestamp - smallTimestamp > PPMessageTimestampDelay;
}

#pragma mark - Public
CGFloat PPMaxCellWidth() {
    return ( [UIScreen mainScreen].bounds.size.width - 58 ) * PPMessageMaxContentWidthRatio;
}

CGFloat PPMaxImageMessageCellHeight() {
    return 300;
}

CGSize PPTextPlainSize(NSString *text, UIFont *font) {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(PPMaxCellWidth(), CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    return rect.size;
}

CGSize PPImageCellTargetSize(CGSize originImageSize) {
    CGSize targetSize = CGSizeZero;
    
    CGFloat maxCellWidth = PPMaxCellWidth();
    CGFloat maxCellHeight = PPMaxImageMessageCellHeight();
    CGFloat imgWidth = originImageSize.width;
    CGFloat imgHeight = originImageSize.height;
    CGFloat finalWidth = .0f;
    CGFloat finalHeight = .0f;
    
    if (imgWidth <= maxCellWidth && imgHeight <= maxCellHeight) {
        finalWidth = imgWidth;
        finalHeight = imgHeight;
    } else {

        CGFloat ratio = MIN(maxCellWidth / imgWidth, maxCellHeight / imgHeight);
        finalWidth = imgWidth * ratio;
        finalHeight = imgHeight * ratio;
        
    }
    
    targetSize.width = finalWidth;
    targetSize.height = finalHeight;
    
    return targetSize;
}

NSUInteger PPTextViewLineNumber(UITextView *textView) {
    return textView.contentSize.height / textView.font.lineHeight;
}

NSDictionary* PPJSONStringToDictionary(NSString* jsonString) {
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (jsonError) {
        PPFastLog(@"%@ to dictionary error: %@.", jsonString, jsonError);
        return nil;
    }
    
    return json;
}

NSString* PPDictionaryToJsonString(NSDictionary* dictionary) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

BOOL PPIsLargeTxtMessage(NSString *text) {
    NSUInteger bytes = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned long length = (unsigned long)bytes;
    return length > PPMessageTextMaxLengthLimit;
}

void PPAddTimestampToMessages(NSMutableArray* messages, double referenceTimstamp) {
    
    if (messages && messages.count > 0) {
        
        // 1. 扫描出一个 bool 数组 [0,0,0,1,0,1,0,...0,1,0,0], 0表示该message不需要显示timestamp, 1表示需要
        __block long lastOneTimestamp = referenceTimstamp;
        NSMutableArray* diffTimestamp = [NSMutableArray arrayWithCapacity:messages.count];
        [messages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PPMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL showTimestamp = pp_shouldShowTimestamp(lastOneTimestamp, message.timestamp);
            [diffTimestamp insertObject:[NSNumber numberWithBool:showTimestamp] atIndex:0];
            lastOneTimestamp = message.timestamp;
        }];
        
        // 2. 修正扫描出来的数组，移除最后一个元素，同时添加一个新的元素(首元素默认显示)至顶部，即整体向后移动一位，同时
        // 0-->[0,0,0,1,0,1,0,...0,1,0,0]==>[0,0,0,0,1,0,1,0,...0,1,0]
        // 得到最终的是否显示timestamp的数组
        [diffTimestamp insertObject:[NSNumber numberWithBool:YES] atIndex:0];
        [diffTimestamp removeLastObject];
        
        // 3. 将 bool 数组中的每个值一一赋给每个 message 元素
        [messages enumerateObjectsUsingBlock:^(PPMessage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.showTimestamp = [[diffTimestamp objectAtIndex:idx] boolValue];
        }];
        
    }
    
}

void PPAddTimestampIfNeedToMessage(NSMutableArray* memoryMessages, PPMessage* tailMessage) {
    
    if (memoryMessages && memoryMessages.lastObject) {
        PPMessage *oldOne = memoryMessages.lastObject;
        if (pp_shouldShowTimestamp(tailMessage.timestamp, oldOne.timestamp)) {
            tailMessage.showTimestamp = YES;
        }
    }
    
}

BOOL PPRandomBool() {
    u_int32_t randomNumber = (arc4random() % ((unsigned)RAND_MAX + 1));
    if(randomNumber % 5 ==0)
        return YES;
    return NO;
}