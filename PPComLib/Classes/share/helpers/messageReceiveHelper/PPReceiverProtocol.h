//
//  PPReceiverProtocol.h
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PPArrivedMsgHandleCompletedBlock)(id obj, BOOL success);

@protocol PPReceiverProtocol <NSObject>

- (void)onArrived:(NSDictionary*)msg
  handleCompleted:(PPArrivedMsgHandleCompletedBlock)completedHandler;

@end
