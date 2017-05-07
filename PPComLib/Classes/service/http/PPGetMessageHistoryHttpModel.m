//
//  PPGetMessageHistoryHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 4/11/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetMessageHistoryHttpModel.h"

#import "PPAPI.h"
#import "PPSDK.h"
#import "PPMessage.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"
#import "PPLog.h"
#import "PPMessageUtils.h"

static NSInteger const DEFAULT_MESSAGE_PAGESIZE = 20;

@interface PPGetMessageHistoryHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetMessageHistoryHttpModel

+ (instancetype)modelWithClient:(PPSDK *)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                         pageOffset:(NSInteger)pageOffset
                          completed:(PPHttpModelCompletedBlock)completedBlock {
    [self requestWithConversationUUID:conversationUUID pageOffset:pageOffset pageSize:DEFAULT_MESSAGE_PAGESIZE completed:completedBlock];
}

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                         maxUUID:(NSString *)maxUUID
                          completed:(PPHttpModelCompletedBlock)completedBlock {
    NSDictionary *params = @{@"app_uuid":self.client.app.appUuid,
                             @"user_uuid":self.client.user.userUuid,
                             @"conversation_uuid": conversationUUID,
                             @"max_uuid": PPSafeString(maxUUID),
                             @"page_size": [NSNumber numberWithInteger:DEFAULT_MESSAGE_PAGESIZE]
                             };
    [self requestWithConversationUUID:conversationUUID params:params completed:completedBlock];
}

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                         pageOffset:(NSInteger)pageOffset
                           pageSize:(NSInteger)pageSize
                          completed:(PPHttpModelCompletedBlock)completedBlock {
    
    NSDictionary *params = @{@"app_uuid":self.client.app.appUuid,
                             @"user_uuid":self.client.user.userUuid,
                             @"conversation_uuid":conversationUUID,
                             @"page_offset":[NSNumber numberWithInteger:pageOffset],
                             @"page_size":[NSNumber numberWithInteger:pageSize]
                             };
    [self requestWithConversationUUID:conversationUUID params:params completed:completedBlock];
}

- (void) requestWithConversationUUID:(NSString *)conversationUUID
                          params:(NSDictionary*)params
                           completed:(PPHttpModelCompletedBlock)completedBlock {
    
    PPAPI *api = self.client.api;
    [api getMessageHistory:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        if (!error) {
            
            if ( [response[@"error_code"] integerValue] == 0 ) {
                NSMutableArray *messages = [self messagesFromResponse:response];
                if ( completedBlock ) completedBlock(messages, response, [NSError errorWithDomain:PPErrorDomain
                                                                                             code:PPErrorCodeAPIError
                                                                                         userInfo:error]);
            } else {
                if ( completedBlock ) completedBlock(nil, response, [NSError errorWithDomain:PPErrorDomain
                                                                                        code:PPErrorCodeAPIError
                                                                                    userInfo:error]);
            }
            
        } else {
            if ( completedBlock ) completedBlock(nil, response, [NSError errorWithDomain:PPErrorDomain
                                                                                    code:PPErrorCodeAPIError
                                                                                userInfo:error]);
        }
    }];
    
}

- (NSMutableArray*)messagesFromResponse:(NSDictionary*)response {
    NSArray *array = response[@"list"];
    NSMutableArray *messages = [NSMutableArray array];
    if (array && [array count] > 0) {
        
        for (NSDictionary* obj in array) {
            NSMutableDictionary *messageDictionary = [PPJSONStringToDictionary(obj[@"message_body"]) mutableCopy];
            messageDictionary[@"from_user"] = obj[@"from_user"];
            PPMessage *message = [PPMessage messageWithDictionary:messageDictionary];
            [messages addObject:message];
        }
    }
    return [NSMutableArray arrayWithArray:[[messages reverseObjectEnumerator] allObjects]];
}

@end
