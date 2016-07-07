//
//  PPGetUnackedMessagesHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetUnackedMessagesHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)getUnackeMessagesWithBlock:(PPHttpModelCompletedBlock)aBlock;

@end
