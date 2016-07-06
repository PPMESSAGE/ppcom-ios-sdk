//
//  PPGetAppInfoHttpModel.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetAppInfoHttpModel : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)getAppInfoWithBlock:(PPHttpModelCompletedBlock)aBlock;

@end
