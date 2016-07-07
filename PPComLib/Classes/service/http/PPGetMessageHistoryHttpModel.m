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
    NSDictionary *params = @{
                             @"conversation_uuid": conversationUUID,
                             @"max_uuid": maxUUID,
                             @"page_size": [NSNumber numberWithInteger:DEFAULT_MESSAGE_PAGESIZE]
                             };
    [self requestWithConversationUUID:conversationUUID params:params completed:completedBlock];
}

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                         pageOffset:(NSInteger)pageOffset
                           pageSize:(NSInteger)pageSize
                          completed:(PPHttpModelCompletedBlock)completedBlock {
    
    NSDictionary *params = @{
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
                if ( completedBlock ) completedBlock(messages, response, error);
            } else {
                if ( completedBlock ) completedBlock(nil, response, error);
            }
            
        } else {
            if ( completedBlock ) completedBlock(nil, response, error);
        }
    }];
    
}

- (NSMutableArray*)messagesFromResponse:(NSDictionary*)response {
    NSArray *array = response[@"list"];
    NSMutableArray *messages = [NSMutableArray array];
    if (array && [array count] > 0) {
        
        for (NSDictionary* obj in array) {
            PPMessage *message = [PPMessage messageWithDictionary:obj];
            [messages addObject:message];
        }
    }
    return messages;
}

@end
