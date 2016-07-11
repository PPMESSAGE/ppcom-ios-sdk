//
//  PPUpdateDeviceHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPUpdateDeviceHttpModel.h"

#import "PPSDK.h"
#import "PPUser.h"
#import "PPAPI.h"

#import "PPSDKUtils.h"

@interface PPUpdateDeviceHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPUpdateDeviceHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)updateDeviceWithDeviceUUID:(NSString *)deviceUUID
                        withOnline:(BOOL)online
                         withBlock:(PPHttpModelCompletedBlock)aBlock {
    NSDictionary *params = @{ @"device_uuid": deviceUUID,
                              @"device_ostype": @"IOS",
                              @"device_is_online": @(online) };
    [self.sdk.api updateDevice:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        BOOL success = NO;
        
        if (!error && !PPIsApiResponseError(response)) {
            success = YES;
        }
        
        if (aBlock) {
            aBlock(@(success), response, [NSError errorWithDomain:PPErrorDomain
                                                             code:PPErrorCodeAPIError
                                                         userInfo:error]);
        }
        
    }];
}

@end
