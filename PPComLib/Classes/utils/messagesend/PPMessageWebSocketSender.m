//
//  PPMessageWebSocketSender.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageWebSocketSender.h"

#import "PPSDK.h"

#import "PPMessageUtils.h"
#import "PPTxtUploader.h"
#import "PPLog.h"

#import "PPWebSocketPool.h"

#import "PPApiMessage.h"
#import "PPMessage.h"
#import "PPMessageTxtMediaPart.h"

@implementation PPMessageWebSocketSender

- (void)sendMessage:(PPMessage *)message {
    [self sendMessage:message withBlock:nil];
}

- (void)sendMessage:(PPMessage *)message withBlock:(PPMessageSendCompletedBlock)quickErrorNotifyBlock {
    
    PPSDK *sdk = [PPSDK sharedSDK];
    PPWebSocketPool *webSocket = sdk.webSocket;
    
    if (![webSocket isOpen]) {
        PPFastLog(@"webSocket is Not Open");
        if (quickErrorNotifyBlock) quickErrorNotifyBlock(YES);
        return;
    }
    
    [self pp_prepareToSend:message completed:^(BOOL prepareOK) {
        
        if (!prepareOK) {
            PPFastLog(@"!prepareOK 无法发送消息");
            if (quickErrorNotifyBlock) quickErrorNotifyBlock(YES);
            return;
        }
        
        PPApiMessage *apiMessage = [message toApiMessage];
        NSDictionary *apiMessageDict = [apiMessage toDictionary];
        NSDictionary *sendParams = @{@"type": @"send",
                                     @"send": apiMessageDict};
        
        PPFastLog(@"[WebSocket] send message: %@", sendParams);
        BOOL sendOK = [webSocket send:PPDictionaryToJsonString(sendParams)];
        if (quickErrorNotifyBlock) quickErrorNotifyBlock(!sendOK);
        
    }];
    
}

#pragma mark - send message by type

- (void)pp_prepareToSend:(PPMessage *)message
               completed:(void (^)(BOOL prepareOK))completed {
    switch (message.type) {
        case PPMessageTypeText:
            [self pp_prepareTextMessageToSend:message completed:completed];
            break;
            
        case PPMessageTypeTxt:
            [self pp_prepareTxtMessageToSend:message completed:completed];
            break;
            
        default:
            break;
    }
}

- (void)pp_prepareTextMessageToSend:(PPMessage *)message
                          completed:(void (^)(BOOL prepareOK))completed {
    if (completed) completed(YES);
}

- (void)pp_prepareTxtMessageToSend:(PPMessage *)message
                         completed:(void (^)(BOOL prepareOK))completed {
    PPTxtUploader *txtUploader = [PPTxtUploader new];
    PPMessageTxtMediaPart *txtMediaPart = message.mediaPart;
    NSString *txt = txtMediaPart.txtContent;
    [txtUploader uploadWithText:txt completed:^(NSDictionary *response, NSError *error) {
        if (error) {
            if (completed) completed(NO);
        } else {
            txtMediaPart.txtFid = response[@"fuuid"];
            if (completed) completed(YES);
        }
    }];
}

@end
