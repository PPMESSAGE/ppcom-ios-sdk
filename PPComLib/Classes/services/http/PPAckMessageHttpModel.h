//
//  PPAckMessageHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPAckMessageHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)ackMessageWithMessagePushUUID:(NSString*)pushUUID
                            withBlock:(PPHttpModelCompletedBlock)aBlock;

- (void)ackMessageWithMessagePushUUIDArray:(NSMutableArray*)pushUUIDArray
                                 withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
