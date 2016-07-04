//
//  PPMessageSendManager.h
//  PPMessage
//
//  Created by PPMessage on 3/29/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMessage;

typedef NS_ENUM(NSInteger, PPMessageSendState) {
    PPMessageSendStateErrorNoConversationId, /** 没有conversationUUID **/
    PPMessageSendStateBeforeSend, /** 发送之前 **/
    PPMessageSendStateSendOut, /** 刚刚发送出去，不一定成功 **/
    PPMessageSendStateError /** 发送失败 **/
};

/** 发送回调接口 **/
typedef void(^PPMessageSendStateBlock)(PPMessage *message, id obj, PPMessageSendState state);

/** 发送消息的入口 **/
@interface PPMessageSendManager : NSObject

+ (instancetype)getInstance;

- (void)sendText:(NSString*)textContent
withConversation:(NSString*)conversationUUID
      completion:(PPMessageSendStateBlock)block;

@end
