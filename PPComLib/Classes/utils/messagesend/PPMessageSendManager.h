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
    PPMessageSendStateErrorNoConversationId,
    PPMessageSendStateBeforeSend,
    PPMessageSendStateSendOut,
    PPMessageSendStateError 
};


typedef void(^PPMessageSendStateBlock)(PPMessage *message, id obj, PPMessageSendState state);

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
    audioDuration:(NSTimeInterval)duration
     conversation:(NSString*)conversationUUID
       completion:(PPMessageSendStateBlock)block;

@end
