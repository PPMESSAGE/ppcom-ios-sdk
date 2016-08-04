//
//  PPReceiverFactory.h
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PPReceiverMessageType) {
    PPReceiverMessageTypeUnknown,
    PPReceiverMessageTypeMsg,
    PPReceiverMessageTypeSendAck,
    PPReceiverMessageTypeLogout
};

@interface PPReceiver : NSObject

+ (instancetype)sharedReceiver;

- (void)handle:(id)obj
handleCompleted:(void (^)(id obj, PPReceiverMessageType type, BOOL success))completedHandler;

@end
