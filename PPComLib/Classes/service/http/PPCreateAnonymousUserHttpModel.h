//
//  PPCreateAnonymousUser.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPCreateAnonymousUserHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)createAnonymousUserWithTraceUUID:(NSString*)traceUUID
                               withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
