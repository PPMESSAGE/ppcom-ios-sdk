//
//  PPGetUserUUIDHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPGetUserUUIDHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"

#import "PPSDKUtils.h"

@interface PPGetUserUUIDHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPGetUserUUIDHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)getUserUUIDWithEmail:(NSString *)userEmail
                   withBlock:(PPHttpModelCompletedBlock)aBlock {
    NSDictionary *params = @{ @"user_email":userEmail,
                              @"app_uuid":self.sdk.app.appUuid };
    [self.sdk.api getUserUuid:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        NSString *userUUID = nil;
        if (!error && !PPIsApiResponseError(response)) {
            userUUID = [response objectForKey:@"user_uuid"];
        }
        
        if (aBlock) {
            aBlock(userUUID, response, [NSError errorWithDomain:PPErrorDomain
                                                           code:PPErrorCodeAPIError
                                                       userInfo:error]);
        }
        
    }];
}

@end
