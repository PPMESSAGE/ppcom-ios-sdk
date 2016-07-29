//
//  PPGetUnackedMessagesHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import "PPPageUnackedMessageHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"
#import "PPServiceUser.h"

#import "PPMessageUtils.h"

@interface PPPageUnackedMessageHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPPageUnackedMessageHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)pageUnackeMessageWithBlock:(PPHttpModelCompletedBlock)aBlock {

    NSDictionary *params = @{ @"page_offset": @0,
                              @"page_size": @30,
                              @"app_uuid": self.sdk.app.appUuid,
                              @"user_uuid": self.sdk.user.userUuid };

    [self.sdk.api pageUnackedMessage:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        NSMutableArray *webSocketMessages = nil;
        if (!error) {
            webSocketMessages = [self parseUnackedMessagesFromResponse:response];
        }
        if (aBlock) {
            aBlock(webSocketMessages, response, [NSError errorWithDomain:PPErrorDomain
                                                                    code:PPErrorCodeAPIError
                                                                userInfo:error]);
        }
    }];
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
