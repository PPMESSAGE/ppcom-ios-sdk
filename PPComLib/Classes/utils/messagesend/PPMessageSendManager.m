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

    // TODO send text
//    [self asyncFindConversationJobWithConversationUUID:conversationUUID withBlock:^(BOOL success, id obj, NSDictionary *jobInfo) {
//        
//        if (success) {
//            
//            PPMessage *message = [PPMessage messageForSend:PPRandomUUID() text:textToBeSend conversation:obj toUser:toUser];
//            
//            if (block) block(message, nil, PPMessageSendStateBeforeSend);
//            
//            [self asyncAddMessage:message completedBlock:^(BOOL success, id obj, NSDictionary *jobInfo) {
//                
//                if (success) {
//                    if (block) block(message, obj, PPMessageSendStateSendOut);
//                }
//                
//                id<PPMessageSendProtocol> messageSender = sdk.messageSender;
//                [messageSender sendMessage:message withBlock:^(BOOL quickError) {
//                    if (quickError) {
//                        message.status = PPMessageStatusError;
//                        if (block) block(message, nil, PPMessageSendStateError);
//                    }
//                }];
//                
//            }];
//            
//        } else {
//            
//            PPFastLog(@"failed to find conversation");
//            if (block) block(nil, nil, PPMessageSendStateErrorNoConversationId);
//            
//        }
//        
//    }];
}

#pragma mark - helpers

//- (void)asyncFindConversationJobWithConversationUUID:(NSString*)conversationUUID
//                                           withBlock:(PPJobCompletedBlock)block {
//    if (!conversationUUID) {
//        PPFastLog(@"!conversationUUID");
//        if (block) block(NO, nil, nil);
//        return;
//    }
//    
//    PPFindConversationJob *findConversationJob = [[PPFindConversationJob alloc]initWithClient:[PPClient sharedClient] params:@{PPFindConversationJobParamConversationUUID: conversationUUID} completedBlock:block];
//    [[PPClient sharedClient].jobScheduler postJob:findConversationJob];
//}
//
//- (void)asyncAddMessage:(PPMessage*)message
//         completedBlock:(PPJobCompletedBlock)completed {
//    PPUpdateMessageJob *updateMessageJob = [[PPUpdateMessageJob alloc]initWithClient:[PPClient sharedClient] params:@{PPUpdateMessageJobParamAction: [NSNumber numberWithInteger:PPUpdateMessageJobActionAdd], PPUpdateMessageJobParamMessage: message, PPUpdateMessageJobParamIncreUnread: [NSNumber numberWithBool:NO]} completedBlock:completed];
//    [[PPClient sharedClient].jobScheduler postJob:updateMessageJob];
//}

@end
