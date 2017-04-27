//
//  PPUpdateUserInfoHttpModel.m
//  Pods
//
//  Created by Jason Li on 8/16/16.
//
//

#import "PPUpdateUserInfoHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@interface PPUpdateUserInfoHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPUpdateUserInfoHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)updateUserWithUUID:(NSString *)userUUID
                  withIcon:(NSString *)userIcon
              withFullName:(NSString *)fullName
                 withBlock:(PPHttpModelCompletedBlock)aBlock {
    
    NSDictionary *params = @{ @"user_uuid":self.sdk.user.userUuid,
                              @"user_icon":userIcon?userIcon:@"",
                              @"user_fullname":fullName?fullName:@"",
                              @"app_uuid":self.sdk.app.appUuid };
    [self.sdk.api updatePPComUser:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
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
