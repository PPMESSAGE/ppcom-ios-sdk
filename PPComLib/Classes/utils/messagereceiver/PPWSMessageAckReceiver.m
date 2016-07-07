//
//  PPWSMessageAckReceiver.m
//  PPMessage
//
//  Created by PPMessage on 3/8/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPWSMessageAckReceiver.h"
#import "PPLog.h"

@implementation PPWSMessageAckReceiver

//2016-03-08 10:37:47.318 PPMessage[54325:6275301] [PP] unknown message: {
//    code = 0;
//    extra =     {
//        "conversation_uuid" = "c82aff73-da18-11e5-822d-acbc327f19e9";
//        uuid = "61ABFEC7-1A25-434A-A899-8B1C0F5EFDE5";
//    };
//    reason = "success, nothing to say.";
//    type = ACK;
//    what = SEND;
//}
- (void)onArrived:(NSDictionary *)msg handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler {
    
    NSDictionary *ackInfo = msg;
    NSInteger errorCode = [ackInfo[@"code"] integerValue];
    NSString *conversationUUID = ackInfo[@"extra"][@"conversation_uuid"];
    NSString *messageUUID = ackInfo[@"extra"][@"uuid"];
    NSString *reason = ackInfo[@"reason"];

    // The final notify obj
    NSDictionary *notifyObj = @{ @"conversation_uuid": conversationUUID,
                                 @"message_uuid": messageUUID,
                                 @"reason": reason,
                                 @"error_code": [NSNumber numberWithInteger:errorCode] };
    if (completedHandler) {
        completedHandler(notifyObj, YES);
    }

}

@end
