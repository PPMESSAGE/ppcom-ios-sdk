//
//  PPCreateAnonymousUser.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPCreateAnonymousUserHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@interface PPCreateAnonymousUserHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPCreateAnonymousUserHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)createAnonymousUserWithTraceUUID:(NSString *)traceUUID
                               withBlock:(PPHttpModelCompletedBlock)aBlock {
    NSDictionary *params = @{
        @"app_uuid": self.sdk.configuration.appUUID,
        @"is_app_user": @YES,
        @"is_browser_user": @NO,
        @"ppcom_trace_uuid": traceUUID
    };
    
    [self.sdk.api createAnonymousUser:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPUser *user = nil;
        if (!error && !PPIsApiResponseError(response)) {
            user = [PPServiceUser userWithDictionary:response];
        }
        
        if (aBlock) {
            aBlock(user, response, [NSError errorWithDomain:PPErrorDomain
                                                       code:PPErrorCodeAPIError
                                                   userInfo:error]);
        }
        
    }];
}

@end
