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

#import "PPUser.h"
#import "PPServiceUser.h"

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

- (void)getUserUUIDWithEntUser:(NSDictionary *)entUser
                   withBlock:(PPHttpModelCompletedBlock)aBlock {
    NSDictionary *params = @{@"app_uuid":self.sdk.app.appUuid,
                             @"ent_user_id": entUser[@"ent_user_id"],
                             @"ent_user_name": entUser[@"ent_user_name"],
                             @"ent_user_icon": entUser[@"ent_user_icon"],
                             @"ent_user_create_time": entUser[@"ent_user_create_time"]};
    [self.sdk.api getUserUuid:params completionHandler:^(NSDictionary *response, NSDictionary *error) {


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
