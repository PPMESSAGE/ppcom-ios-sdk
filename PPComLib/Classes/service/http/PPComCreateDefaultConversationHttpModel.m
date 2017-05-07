//
//  PPComCreateDefaultConversationHttpModel.m
//  Pods
//
//  Created by Guijin Ding on 07/05/2017.
//
//

#import "PPComCreateDefaultConversationHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@interface PPComCreateDefaultConversationHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPComCreateDefaultConversationHttpModel


+ (instancetype)modelWithSdk:(PPSDK *)sdk {
    return [[self alloc] initWithSdk:sdk];
}

- (instancetype)initWithSdk:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void) request {

    NSDictionary *params = @{@"is_app_user": @YES,
                             @"app_uuid": self.sdk.app.appUuid,
                             @"user_uuid": self.sdk.user.userUuid,
                             @"device_uuid": self.sdk.user.mobileDeviceUuid};

    [self.sdk.api createPPComDefaultConversation:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        NSLog(@"PPCOM Create Conversation %@", response);
    }];
}

@end
