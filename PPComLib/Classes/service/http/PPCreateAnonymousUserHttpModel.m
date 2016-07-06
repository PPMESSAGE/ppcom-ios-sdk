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
#import "PPUser.h"

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
    NSDictionary *params = @{ @"app_uuid": self.sdk.configuration.appUUID,
                              @"ppcom_trace_uuid": traceUUID };
    
    [self.sdk.api createAnonymousUser:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
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
