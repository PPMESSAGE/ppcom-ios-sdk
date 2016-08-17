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

- (void)getUserUUIDWithEmail:(NSString*)userEmail
                   withBlock:(PPHttpModelCompletedBlock)aBlock;

- (void)getUserUUIDWithEmail:(NSString*)userEmail
                    withIcon:(NSString *)userIcon
                withFullname:(NSString *)userFullName
                   withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
