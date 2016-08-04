//
//  PPSysMessageReceiver.m
//  PPMessage
//
//  Created by PPMessage on 3/10/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPSysMessageReceiver.h"

#import "PPSDKUtils.h"

@implementation PPSysMessageReceiver

- (void)onArrived:(NSDictionary *)msg handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler {
    NSDictionary *msgDict = msg[@"msg"];
    NSString *ms = msgDict[@"ms"];
    
    // `LOGOUT`
    // {"msg": {"mt": "SYS", "bo": "48fb0cf5-e5dc-11e5-91f1-acbc327f19e9", "ms": "LOGOUT"}, "type": "MSG"}
    if ([ms isEqualToString:@"LOGOUT"]) {
        if (completedHandler) {
            NSDictionary *obj = @{ @"sysType":@"LOGOUT", @"info":msg };
            completedHandler(obj, YES);
        }
    }
    
}

@end
