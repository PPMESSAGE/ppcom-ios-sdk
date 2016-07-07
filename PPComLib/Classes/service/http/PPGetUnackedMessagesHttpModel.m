//
//  PPGetUnackedMessagesHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import "PPGetUnackedMessagesHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"
#import "PPServiceUser.h"

#import "PPMessageUtils.h"

@interface PPGetUnackedMessagesHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPGetUnackedMessagesHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)getUnackeMessagesWithBlock:(PPHttpModelCompletedBlock)aBlock {
    // Build param
    NSDictionary *params = nil;
    if (self.sdk.user &&
        self.sdk.user.userUuid &&
        self.sdk.user.mobileDeviceUuid &&
        self.sdk.app.appUuid) {
        params = @{@"from_uuid": self.sdk.user.userUuid,
                   @"device_uuid": self.sdk.user.mobileDeviceUuid,
                   @"app_uuid": self.sdk.app.appUuid};
    }
    
    if (params) {
        [self.sdk.api getUnackedMessages:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
            NSMutableArray *webSocketMessages = nil;
            if (!error) {
                webSocketMessages = [self parseUnackedMessagesFromResponse:response];
            }
            if (aBlock) {
                aBlock(webSocketMessages, response, error);
            }
        }];
    }
}

// =============
// Private
// =============

- (NSMutableArray*)parseUnackedMessagesFromResponse:(NSDictionary*)response {
    NSMutableArray *msgIdArray = response[@"list"];
    if (!msgIdArray || msgIdArray.count == 0) {
        return [NSMutableArray array];
    }
    
    NSDictionary *msgDictionary = response[@"message"];
    NSMutableArray *msgs = [NSMutableArray array];
    [msgIdArray enumerateObjectsUsingBlock:^(NSString *msgId, NSUInteger idx, BOOL * _Nonnull stop) {
        if (msgDictionary[msgId]) {
            
            NSMutableDictionary *msg = [NSMutableDictionary dictionaryWithDictionary:PPJSONStringToDictionary(msgDictionary[msgId])];
            // msg from `getUnackedMessages` api lack of `pid`
            // so, we have to add `pid` to dict manually here
            msg[@"pid"] = msgId;
            
            NSDictionary *msgDict = @{@"type": @"MSG",
                                      @"msg": msg};
            [msgs addObject:msgDict];
        }
    }];
    
    return msgs;
}

@end
