//
//  PPUpdateUserInfoHttpModel.h
//  Pods
//
//  Created by Jason Li on 8/16/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPUpdateUserInfoHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)updateUserWithUUID:(NSString*)userUUID
                  withIcon:(NSString *)userIcon
                 withBlock:(PPHttpModelCompletedBlock)aBlock;

@end
