//
//  PPCreateDeviceHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPCreateDeviceHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)createDeviceWithMobileUniqueID:(NSString*)mobileDeviceUUID
                             withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
