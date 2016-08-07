//
//  PPMessageReceiver.h
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPReceiverProtocol.h"

@class PPMessage, PPArrivedMsgHandlerCompleteBlock;

@interface PPMessageReceiver : NSObject<PPReceiverProtocol>

- (void)handleTxtMessage:(PPMessage*)txtMessage withBlock:(PPArrivedMsgHandleCompletedBlock)block;

@end
