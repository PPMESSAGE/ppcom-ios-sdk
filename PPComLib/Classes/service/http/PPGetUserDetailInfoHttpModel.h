//
//  PPGetUserDetailInfoHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetUserDetailInfoHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)getUserDetailInfoWithUUID:(NSString*)userUUID
                        withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
