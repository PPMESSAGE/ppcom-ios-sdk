//
//  PPMessageSendManager.m
//  PPMessage
//
//  Created by PPMessage on 3/29/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageSendManager.h"

#import "PPUser.h"
#import "PPMessage.h"

#import "PPLog.h"
#import "PPSDKUtils.h"

#import "PPSDK.h"

#import "PPStoreManager.h"
#import "PPConversationsStore.h"
#import "PPMessagesStore.h"

#import "PPMessageAudioMediaPart.h"
#import "PPMessageImageMediaPart.h"

@implementation PPMessageSendManager

+ (instancetype)getInstance {
    static PPMessageSendManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PPMessageSendManager alloc] init];
    });
    return manager;
}

- (void)sendMessage:(PPMessage *)message
         completion:(PPMessageSendStateBlock)block {
    PPSDK *sdk = [PPSDK sharedSDK];
    
    NSString *conversationUUID = message.conversationUUID;
    PPMessagesStore *messagesStore = [PPStoreManager instanceWithClient:sdk].messagesStore;
    [messagesStore updateWithNewMessage:message];
    if (block) block(message, [messagesStore messagesInCovnersation:conversationUUID], PPMessageSendStateSendOut);
    
    id<PPMessageSendProtocol> messageSender = sdk.messageSender;
    [messageSender sendMessage:message withBlock:^(BOOL quickError) {
        if (quickError) {
            [messagesStore updateMessageStatus:PPMessageStatusError
                            messageIndentifier:message.identifier
                              conversationUUID:conversationUUID];
            if (block) block(message, [messagesStore messages], PPMessageSendStateError);
        }
    }];
}

- (void)sendText:(NSString *)textContent
withConversation:(NSString *)conversationUUID
      completion:(PPMessageSendStateBlock)block {
    __weak typeof(self) wself = self;
    [self findWithConversationUUID:conversationUUID done:^(PPConversationItem *conversationItem) {
        if (!conversationItem) {
            if (block) block(nil, nil, PPMessageSendStateErrorNoConversationId);
        } else {
            [wself sendMessage:[wself buildMessageWithText:textContent
                                      withConversationItem:conversationItem]
                   completion:block];
        }
    }];
}

- (void)sendImage:(UIImage *)image
withConversation:(NSString *)conversationUUID
      completion:(PPMessageSendStateBlock)block {
    __weak typeof(self) wself = self;
    [self findWithConversationUUID:conversationUUID done:^(PPConversationItem *conversationItem) {
        if (!conversationItem) {
            if (block) block(nil, nil, PPMessageSendStateErrorNoConversationId);
        } else {
            [wself sendMessage:[wself buildMessageWithImage:image
                                      withConversationItem:conversationItem]
                    completion:block];
        }
    }];
}

- (void)sendAudio:(NSString *)audioFilePath
    audioDuration:(NSTimeInterval)duration
     conversation:(NSString *)conversationUUID
       completion:(PPMessageSendStateBlock)block {
    __weak typeof(self) wself = self;
    [self findWithConversationUUID:conversationUUID done:^(PPConversationItem *conversationItem) {
        if (!conversationItem) {
            if (block) block(nil, nil, PPMessageSendStateErrorNoConversationId);
        } else {
            [wself sendMessage:[wself buildMessageWithAudioFilePath:audioFilePath
                                                  withAudioDuration:duration
                                               withConversationItem:conversationItem]
                    completion:block];
        }
    }];
}

// ==============
// Helper
// ==============
- (void)findWithConversationUUID:(NSString*)conversationUUID
                            done:(void (^)(PPConversationItem *conversationItem))aBlock {
    if (!aBlock) return;
    
    PPSDK *sdk = [PPSDK sharedSDK];
    PPConversationsStore *conversationsStore = [PPStoreManager instanceWithClient:sdk].conversationsStore;
    
    [conversationsStore asyncFindConversationWithConversationUUID:conversationUUID withBlock:^(PPConversationItem *conversationItem) {
        aBlock(conversationItem);
    }];
}

- (PPMessage*)buildMessageWithText:(NSString*)text
              withConversationItem:(PPConversationItem*)conversationItem {
    return [PPMessage messageForSend:PPRandomUUID()
                                text:text
                        conversation:conversationItem];
}

- (PPMessage *)buildMessageWithImage:(UIImage *)image
                withConversationItem:(PPConversationItem *)conversationItem {
    PPMessageImageMediaPart *imageMediaPart = [PPMessageImageMediaPart mediaPartWithUIImage:image];
    return [PPMessage messageForSend:PPRandomUUID()
                                text:nil
                        conversation:conversationItem
                           mediaPart:imageMediaPart];
}

- (PPMessage*)buildMessageWithAudioFilePath:(NSString*)audioFilePath
                          withAudioDuration:(NSTimeInterval)audioDuration
                       withConversationItem:(PPConversationItem*)conversationItem {
    PPMessageAudioMediaPart *audioMediaPart = [PPMessageAudioMediaPart new];
    audioMediaPart.localFilePath = audioFilePath;
    audioMediaPart.duration = audioDuration;
    return [PPMessage messageForSend:PPRandomUUID()
                                text:nil
                        conversation:conversationItem
                           mediaPart:audioMediaPart];
}

@end
