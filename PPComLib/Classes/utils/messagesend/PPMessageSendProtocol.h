//
//  PPMessageSendProtocol.h
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMessage;

typedef void (^PPMessageSendCompletedBlock)(BOOL quickError);

@protocol PPMessageSendProtocol <NSObject>

- (void)sendMessage:(PPMessage*)message;
- (void)sendMessage:(PPMessage *)message
          withBlock:(PPMessageSendCompletedBlock)quickErrorNotifyBlock;

@end
