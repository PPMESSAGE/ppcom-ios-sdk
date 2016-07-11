//
//  PPGetAppInfoHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPGetAppInfoHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"

#import "PPSDKUtils.h"

@interface PPGetAppInfoHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPGetAppInfoHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)getAppInfoWithBlock:(PPHttpModelCompletedBlock)aBlock {
    NSString *appUUID = self.sdk.configuration.appUUID;
    NSDictionary *params = @{ @"app_uuid": appUUID };
    
    [self.sdk.api getAppInfo:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPApp *app = nil;
        if (!error && !PPIsApiResponseError(response)) {
            app = [PPApp appWithDictionary:response];
        }
        
        if (aBlock) {
            aBlock(app, response, [NSError errorWithDomain:PPErrorDomain
                                                      code:PPErrorCodeAPIError
                                                  userInfo:error]);
        }
        
    }];
}

@end
