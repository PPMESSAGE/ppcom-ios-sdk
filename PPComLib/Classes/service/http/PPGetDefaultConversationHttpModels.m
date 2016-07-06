//
//  PPGetDefaultConversationHttpModels.m
//  PPComLib
//
//  Created by PPMessage on 3/31/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetDefaultConversationHttpModels.h"

#import "PPAPI.h"
#import "PPSDK.h"
#import "PPConversationItem.h"
#import "PPApp.h"
#import "PPUser.h"
#import "PPSDKUtils.h"
#import "PPServiceUser.h"

#import "PPGetConversationInfoHttpModel.h"

@interface PPGetDefaultConversationHttpModels ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetDefaultConversationHttpModels

+ (instancetype)modelWithClient:(PPSDK *)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

- (void)requestWithBlock:(PPHttpModelCompletedBlock)completed {
    
    NSDictionary *params = @{ @"app_uuid": self.client.app.appUuid,
                              @"user_uuid": self.client.user.userUuid,
                              @"device_uuid": self.client.user.mobileDeviceUuid };
    
    [self.client.api getPPComDefaultConversation:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPConversationItem *defaultConversation = nil;
        
        // When we get a `empty successful response`, it marked we should waiting avaliable conversation
        // So we must check `PPIsApiResponseEmpty`
        if (!error &&
            response &&
            [response[@"error_code"] integerValue] == 0
            && !PPIsApiResponseEmpty(response)) {
            
            defaultConversation = [PPConversationItem conversationWithDictionary:response];
            
            [self getConversationInfoWithConversationUUID:defaultConversation.uuid completed:^(id obj, NSDictionary *response, NSError *error) {
                if (completed) completed(obj, response, error);
            }];
            
        } else {

            if (completed) completed(defaultConversation, response, error);
            
        }
        
    }];
    
}

- (void)getConversationInfoWithConversationUUID:(NSString*)conversationUUID completed:(PPHttpModelCompletedBlock)completedBlock {
    PPGetConversationInfoHttpModel *getConversationInfoHttpModel = [[PPGetConversationInfoHttpModel alloc] initWithClient:self.client];
    [getConversationInfoHttpModel getWithConversationUUID:conversationUUID completedBlock:completedBlock];
}

@end
