//
//  PPCreateDeviceHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPCreateDeviceHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@interface PPCreateDeviceHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPCreateDeviceHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)createDeviceWithMobileUniqueID:(NSString *)mobileDeviceUUID
                             withBlock:(PPHttpModelCompletedBlock)aBlock {
    
    NSDictionary *params = @{ @"app_uuid": self.sdk.configuration.appUUID,
                              @"device_id": mobileDeviceUUID,
                              @"device_ostype": @"IOS",
                              @"user_uuid":self.sdk.user.userUuid };
    [self.sdk.api createDevice:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        NSString *deviceUUID = nil;
        // We not check response[@"error_code"] is equals to 0, because, the server may
        // return error_code: 26 when the device is exist. we consider this case is a right
        // case
        if (!error) {
            deviceUUID = response[@"device_uuid"];
        }
        
        if (aBlock) {
            aBlock(deviceUUID, response, error);
        }
        
    }];
    
}

@end
