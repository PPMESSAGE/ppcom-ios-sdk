//
//  PPMessageReceiver.m
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageReceiver.h"

#import "PPMessage.h"
#import "PPMessageTxtMediaPart.h"
#import "PPConversationItem.h"
#import "PPUser.h"

#import "PPTxtLoader.h"
#import "PPAPI.h"

#import "PPStoreManager.h"
#import "PPConversationsStore.h"

#import "PPAckMessageHttpModel.h"

#import "PPLog.h"

@implementation PPMessageReceiver

// `NORMAL MESSAGE`
// {"msg": {"fi": "c80c9b54-da18-11e5-87f3-acbc327f19e9", "ci": "c82aff73-da18-11e5-822d-acbc327f19e9", "ft": "DU", "tt": "AP", "bo": "asdf", "pid": "61746b59-dea3-11e5-92e2-acbc327f19e9", "ts": 1456722899.0, "mt": "NOTI", "tl": null, "ms": "TEXT", "from_user": {"updatetime": 1456722837, "user_fullname": "\u672c\u673a\u7528\u6237", "uuid": "c80c9b54-da18-11e5-87f3-acbc327f19e9", "user_email": "ppmessage-c80c9b", "user_icon": "http://192.168.0.206:8080/identicon/c80c9b54-da18-11e5-87f3-acbc327f19e9.png"}, "ti": "c82aff73-da18-11e5-822d-acbc327f19e9", "id": "d37dd6ff-c597-4651-d29d-1b3e77a5dab5", "ct": "P2S"}, "type": "MSG"}
- (void)onArrived:(NSDictionary *)msg
  handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler {
    
    PPMessage *message = [PPMessage messageWithDictionary:msg[@"msg"]];
    
    PPFastLog(@"[MessageArrived] message arrived: %@", message);
    
    [self findConversationItemWithUUID:message.conversationUUID done:^(PPConversationItem *conversationItem) {
        if (conversationItem) {
            PPFastLog(@"[MessageArrived] find conversation:%@.", conversationItem);
            
            // Ack message
            // make callback
            switch (message.type) {
                case PPMessageTypeAudio:
                case PPMessageTypeText:
                case PPMessageTypeFile:
                case PPMessageTypeImage:
                    [self ackMessageWithPushID:message.pushID];
                    [self makeResponseWithMessage:message
                                          success:YES
                                      withHandler:completedHandler];
                    break;
                    
                case PPMessageTypeTxt: {
                    [self pp_handleTxtMessage:message
                              handleCompleted:^(id obj, BOOL success) {
                                  [self makeResponseWithMessage:message
                                                        success:success
                                                    withHandler:completedHandler];
                              }];
                }
                    break;
                    
                default:
                    break;
            }
            
            
        } else {
            PPFastLog(@"[MessageArrived] cannot get conversation with messageUUID:%@, ignore this message", message.identifier);
        }
    }];
    
}

- (void)pp_handleTxtMessage:(PPMessage*)txtMessage
            handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler {
    PPMessageTxtMediaPart *txtMediaPart = txtMessage.mediaPart;
    [[PPTxtLoader sharedLoader] loadTxtWithURL:txtMediaPart.txtURL completed:^(NSString *text, NSError *error, NSURL *txtURL) {
        if (!error) {
            txtMediaPart.txtContent = text;
            [self ackMessageWithPushID:txtMessage.pushID];
        }
        if (completedHandler) completedHandler(txtMessage, !error);
    }];
}

- (void)ackMessageWithPushID:(NSString*)pushId {
    
    if (!pushId) {
        PPFastLog(@"[AckMessage] pushID == nil");
        return;
    }
    
    PPFastLog(@"[AckMessage] with pushID:%@", pushId);
    PPAckMessageHttpModel *ackMessageModel = [[PPAckMessageHttpModel alloc] initWithSDK:[PPSDK sharedSDK]];
    // We don't care about the ack result
    [ackMessageModel ackMessageWithMessagePushUUID:pushId withBlock:nil];

}

- (void)findConversationItemWithUUID:(NSString*)conversationUUID
                                done:(void (^)(PPConversationItem *conversationItem))aBlock {
    PPSDK *sdk = [PPSDK sharedSDK];
    PPStoreManager *storeManager = [PPStoreManager instanceWithClient:sdk];
    PPConversationsStore *conversationsStore = storeManager.conversationsStore;
    [conversationsStore asyncFindConversationWithConversationUUID:conversationUUID withBlock:aBlock];
}

#pragma mark -

- (void)makeResponseWithMessage:(PPMessage*)message
                        success:(BOOL)success
                    withHandler:(PPArrivedMsgHandleCompletedBlock)handler {
    
    if (handler) handler(message, success);
    
}

@end
