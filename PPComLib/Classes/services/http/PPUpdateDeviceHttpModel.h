//
//  PPUpdateDeviceHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPUpdateDeviceHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)updateDeviceWithDeviceUUID:(NSString*)deviceUUID
                        withOnline:(BOOL)online
                         withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
