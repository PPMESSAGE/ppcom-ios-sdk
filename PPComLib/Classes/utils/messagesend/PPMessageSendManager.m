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

@implementation PPMessageSendManager

+ (instancetype)getInstance {
    static PPMessageSendManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PPMessageSendManager alloc] init];
    });
    return manager;
}

- (void)sendText:(NSString *)textContent
withConversation:(NSString *)conversationUUID
      completion:(PPMessageSendStateBlock)block {
    
    NSString *textToBeSend = textContent;
    
    PPSDK *sdk = [PPSDK sharedSDK];
    
    PPUser *toUser = [[PPUser alloc] initWithUuid:conversationUUID];
    toUser.userType = @"AG";
    
    PPConversationsStore *conversationsStore = [PPStoreManager instanceWithClient:sdk].conversationStore;
    PPMessagesStore *messagesStore = [PPStoreManager instanceWithClient:sdk].messagesStore;
    
    [conversationsStore asyncFindConversationWithConversationUUID:conversationUUID withBlock:^(PPConversationItem *conversationItem) {
        if (conversationItem) {
            PPMessage *message = [PPMessage messageForSend:PPRandomUUID() text:textToBeSend conversation:conversationItem toUser:toUser];
            
            [messagesStore updateWithNewMessage:message];
            if (block) block(message, [messagesStore messagesInCovnersation:conversationUUID], PPMessageSendStateSendOut);
            
            id<PPMessageSendProtocol> messageSender = sdk.messageSender;
            [messageSender sendMessage:message withBlock:^(BOOL quickError) {
                if (quickError) {
                    [messagesStore updateMessageStatus:PPMessageSendStateError
                                    messageIndentifier:message.identifier
                                      conversationUUID:conversationUUID];
                    if (block) block(message, [messagesStore messages], PPMessageSendStateError);
                }
            }];
            
        } else {
            PPFastLog(@"[PPMessageSendManager] Try send text:%@, but can not find conversation:%@, ignore it", textToBeSend, conversationUUID);
            if (block) block(nil, nil, PPMessageSendStateErrorNoConversationId);
        }
    }];

}

@end
