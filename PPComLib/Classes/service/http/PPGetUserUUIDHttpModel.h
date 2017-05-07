//
//  PPGetUserUUIDHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetUserUUIDHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)getUserUUIDWithEntUser:(NSDictionary*)entUser
                   withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
