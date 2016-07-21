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

// send text
- (void)sendText:(NSString*)textContent
withConversation:(NSString*)conversationUUID
      completion:(PPMessageSendStateBlock)block;

// send image
- (void)sendImage:(UIImage *)image
withConversation:(NSString*)conversationUUID
      completion:(PPMessageSendStateBlock)block;

/**
 * Send audio 
 *
 * @param audioFilePath disk audio path
 * @param audioDuration audio duration
 * @param conversation conversation uuid
 */
- (void)sendAudio:(NSString*)audioFilePath
    audioDuration:(CGFloat)duration
     conversation:(NSString*)conversationUUID
       completion:(PPMessageSendStateBlock)block;

@end
