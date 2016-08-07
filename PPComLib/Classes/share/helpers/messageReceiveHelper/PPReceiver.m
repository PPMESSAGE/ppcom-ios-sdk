//
//  PPReceiverFactory.m
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPReceiver.h"

#import "PPMessageReceiver.h"
#import "PPWSMessageAckReceiver.h"
#import "PPSysMessageReceiver.h"

#import "PPMessageUtils.h"
#import "PPLog.h"

NSString *const kPPReceiverMessageTypeMsg = @"MSG";
NSString *const kPPReceiverMessageTypeAck = @"ACK";

NSString *const kPPReceiverMessageWhatSend = @"SEND";

NSString *const kPPReceiverMessageMsgNoti = @"NOTI";
NSString *const kPPReceiverMessageMsgSys = @"SYS";

@interface PPReceiver ()

@end

@implementation PPReceiver

+ (instancetype)sharedReceiver {
    static PPReceiver *receiver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        receiver = [PPReceiver new];
    });
    return receiver;
}

- (void)handle:(id)obj
handleCompleted:(void (^)(id, PPReceiverMessageType, BOOL))completedHandler {
    if (!obj) return;
    
    NSDictionary *objDict = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        objDict = PPJSONStringToDictionary((NSString*)obj);
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        objDict = obj;
    }
    
    NSString *objType = objDict[@"type"];
    
    id<PPReceiverProtocol> objHandler = nil;
    PPReceiverMessageType type = PPReceiverMessageTypeUnknown;
    if ([objType isEqualToString:kPPReceiverMessageTypeMsg]) {
        
        NSString *mt = objDict[@"msg"][@"mt"];
        if ([mt isEqualToString:kPPReceiverMessageMsgNoti]) {
            
            objHandler = self.messageHandler;
            type = PPReceiverMessageTypeMsg;
            
        } else if ([mt isEqualToString:kPPReceiverMessageMsgSys]) {

            type = PPReceiverMessageTypeLogout;
            objHandler = self.sysMessageHandler;
            
        }
        
    } else if ([objType isEqualToString:kPPReceiverMessageTypeAck]) {
        NSString *what = objDict[@"what"];
        if (what && [what isEqualToString:kPPReceiverMessageWhatSend]) {
            objHandler = self.messageAckHandler;
            type = PPReceiverMessageTypeSendAck;
        }
    }
    
    if (objHandler != nil) {
        [objHandler onArrived:objDict handleCompleted:^(id obj, BOOL success) {
            if (completedHandler) completedHandler(obj, type, success);
        }];
    } else {
        PPFastLog(@"unknown message: %@", objDict);
    }
}

#pragma mark - getter

- (PPMessageReceiver*)messageHandler {
    if (!_messageHandler) {
        _messageHandler = [PPMessageReceiver new];
    }
    return _messageHandler;
}

- (PPWSMessageAckReceiver*)messageAckHandler {
    if (!_messageAckHandler) {
        _messageAckHandler = [PPWSMessageAckReceiver new];
    }
    return _messageAckHandler;
}

- (PPSysMessageReceiver*)sysMessageHandler {
    if (!_sysMessageHandler) {
        _sysMessageHandler = [PPSysMessageReceiver new];
    }
    return _sysMessageHandler;
}

@end
