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

#import "PPLog.h"

@implementation PPMessageReceiver

// `NORMAL MESSAGE`
// {"msg": {"fi": "c80c9b54-da18-11e5-87f3-acbc327f19e9", "ci": "c82aff73-da18-11e5-822d-acbc327f19e9", "ft": "DU", "tt": "AP", "bo": "asdf", "pid": "61746b59-dea3-11e5-92e2-acbc327f19e9", "ts": 1456722899.0, "mt": "NOTI", "tl": null, "ms": "TEXT", "from_user": {"updatetime": 1456722837, "user_fullname": "\u672c\u673a\u7528\u6237", "uuid": "c80c9b54-da18-11e5-87f3-acbc327f19e9", "user_email": "ppmessage-c80c9b", "user_icon": "http://192.168.0.206:8080/identicon/c80c9b54-da18-11e5-87f3-acbc327f19e9.png"}, "ti": "c82aff73-da18-11e5-822d-acbc327f19e9", "id": "d37dd6ff-c597-4651-d29d-1b3e77a5dab5", "ct": "P2S"}, "type": "MSG"}
- (void)onArrived:(NSDictionary *)msg
  handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler {
    
    PPMessage *message = [PPMessage messageWithDictionary:msg[@"msg"]];
    
    PPFastLog(@"=========message arrived=======");
    // TODO
    
    // find conversation
//    [self findConversationAssociatedWithMessage:message completed:^(BOOL success, id obj, NSDictionary *jobInfo) {
//        
//        if (!success) return ;
//        
//        PPFastLog(@"=========findConversationAssociatedWithMessage=======");
//        PPConversationItem *conversation = obj;
//        conversation.latestMessage = message;
//        
//        // find conversation name
//        [self findConversationNameAssociatedWithConversation:conversation completed:^(BOOL success, id obj, NSDictionary *jobInfo) {
//            
//            if (!success) return ;
//            
//            // update conversation name
//            [self updateConversation:conversation];
//            
//            PPFastLog(@"=========findConversationNameAssociatedWithConversation=======");
//            
//            switch (message.type) {
//                case PPMessageTypeText:
//                case PPMessageTypeFile:
//                case PPMessageTypeImage:
//                    [self ackMessageWithPushID:message.pushID];
//                    [self makeResponseWithMessage:message success:YES withHandler:completedHandler];
//                    break;
//                    
//                case PPMessageTypeTxt: {
//                    [self pp_handleTxtMessage:message handleCompleted:^(id obj, BOOL success) {
//                        [self makeResponseWithMessage:message success:success withHandler:completedHandler];
//                    }];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//        }];
//        
//    }];
    
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
    PPFastLog(@"=== Ack message with pushID:%@===", pushId);
    
    if (!pushId) {
        PPFastLog(@"=== Push ID not exit ===");
        return;
    }

    // TODO
//    [[PPClient sharedClient] inAPI:^(PPSDK *sdk, PPAPI *api) {
//        
//        NSMutableArray *ackIdList = [NSMutableArray array];
//        [ackIdList addObject:pushId];
//        NSDictionary *params = @{@"list": ackIdList};
//        
//        [api ackMessage:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
//            PPFastLog(@"===Ack message:%@ response:%@, error:%@===", pushId, response, error);
//        }];
//        
//    }];
}

//- (void)findConversationAssociatedWithMessage:(PPMessage*)message
//                                    completed:(PPJobCompletedBlock)completedHandler {
//    PPFindConversationJob *findConversationJob = [[PPFindConversationJob alloc] initWithClient:[PPClient sharedClient] params:@{PPFindConversationJobParamConversationUUID: message.conversationUUID} completedBlock:^(BOOL success, id obj, NSDictionary *jobInfo) {
//        if (completedHandler) completedHandler(YES, obj, jobInfo);
//    }];
//    findConversationJob.stopIfFind = YES;
//    [[PPClient sharedClient].jobScheduler postJob:findConversationJob];
//}
//
//- (void)findConversationNameAssociatedWithConversation:(PPConversationItem*)conversation
//                                             completed:(PPJobCompletedBlock)completedHandler {
//    if (!conversation) {
//        if (completedHandler) completedHandler(NO, nil, nil);
//        return;
//    }
//    
//    PPFetchConversationNameJob *fetchConversationNameJob = [[PPFetchConversationNameJob alloc] initWithClient:[PPClient sharedClient] params:@{PPFetchConversationNameJobParamConversation: conversation} completedBlock:^(BOOL success, id obj, NSDictionary *jobInfo) {
//        if (completedHandler) completedHandler(success, obj, jobInfo);
//    }];
//    [[PPClient sharedClient].jobScheduler postJob:fetchConversationNameJob];
//}
//
//- (void)updateConversation:(PPConversationItem*)conversation {
//    PPUpdateConversationJob *updateConversationJob = [[PPUpdateConversationJob alloc] initWithClient:[PPClient sharedClient] params:@{PPUpdateConversationJobParamConversation: conversation} completedBlock:nil];
//    [[PPClient sharedClient].jobScheduler postJob:updateConversationJob];
//}

#pragma mark -

- (void)makeResponseWithMessage:(PPMessage*)message
                        success:(BOOL)success
                    withHandler:(PPArrivedMsgHandleCompletedBlock)handler {
    
    if (handler) handler(message, success);
    
    if (success) {
        PPFastLog(@"----broadcast Message arrived info globally--------");
        NSDictionary *obj = @{@"success": [NSNumber numberWithBool:success],
                              @"msg": message};
        // TODO
//        [[NSNotificationCenter defaultCenter] postNotificationName:PPClientNotificationMsgArrived object:obj];
    }
    
}

@end
