//
//  PPGetConversationInfoHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 5/5/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetConversationInfoHttpModel.h"

#import "PPSDK.h"
#import "PPApp.h"
#import "PPUser.h"
#import "PPServiceUser.h"
#import "PPAPI.h"

#import "PPConversationItem.h"

@interface PPGetConversationInfoHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetConversationInfoHttpModel

- (instancetype)initWithClient:(PPSDK *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

- (void)getWithConversationUUID:(NSString *)conversationUUID
                 completedBlock:(PPHttpModelCompletedBlock)completedBlock {
    NSDictionary *requestParams = @{ @"app_uuid":self.client.app.appUuid,
                                     @"user_uuid":self.client.user.userUuid,
                                     @"conversation_uuid": conversationUUID };
    [self.client.api getConversationInfo:requestParams completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPConversationItem *conversation = nil;
        if (response && [response[@"error_code"] integerValue] == 0) {
            conversation = [PPConversationItem conversationWithDictionary:response];
        }
        
        if (completedBlock) {
            completedBlock(conversation, response, error);
        }
        
    }];
}

@end
