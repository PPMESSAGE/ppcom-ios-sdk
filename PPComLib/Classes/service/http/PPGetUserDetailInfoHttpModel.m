//
//  PPGetUserDetailInfoHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPGetUserDetailInfoHttpModel.h"

#import "PPSDK.h"
#import "PPUser.h"
#import "PPAPI.h"

#import "PPSDKUtils.h"

@interface PPGetUserDetailInfoHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPGetUserDetailInfoHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)getUserDetailInfoWithUUID:(NSString *)userUUID
                        withBlock:(PPHttpModelCompletedBlock)aBlock {
    
    NSDictionary *params = @{ @"type": @"DU",
                              @"uuid": userUUID };
    
    [self.sdk.api getPPComDeviceUser:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPUser *user = nil;
        if (!error && !PPIsApiResponseError(response)) {
            user = [PPUser userWithDictionary:response];
        }
        
        if (aBlock) {
            aBlock(user, response, error);
        }
        
    }];
    
}

@end
