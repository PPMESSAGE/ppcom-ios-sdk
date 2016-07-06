//
//  PPGetWaitingQueueLengthHttpModel.h
//  PPComLib
//
//  Created by PPMessage on 5/4/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetWaitingQueueLengthHttpModel : NSObject

+ (instancetype)modelWithClient:(PPSDK*)client;

- (void)getWaitingQueueLengthWithCompletedBlock:(PPHttpModelCompletedBlock)completedBlock;

@end
