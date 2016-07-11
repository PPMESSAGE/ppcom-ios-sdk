//
//  PPGetConversationListHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 4/1/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetConversationListHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPApp.h"
#import "PPUser.h"
#import "PPServiceUser.h"
#import "PPConversationItem.h"

#import "PPLog.h"

@interface PPGetConversationListHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetConversationListHttpModel

- (instancetype)initWithClient:(PPSDK *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

+ (instancetype)modelWithClient:(PPSDK *)client {
    return [[self alloc] initWithClient:client];
}

- (void)getConversationListWithBlock:(PPHttpModelCompletedBlock)block {
    
    NSString *appUUID = self.client.app.appUuid;
    NSString *userUUID = self.client.user.userUuid;
    NSDictionary *params = @{ @"user_uuid": userUUID, @"app_uuid": appUUID };
    
    [self.client.api getConversationList:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        NSMutableArray *conversations = nil;
        
        if (!error && response && ([response[@"error_code"] integerValue] == 0)) {
            NSMutableArray *array = response[@"list"];
            conversations = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PPConversationItem *conversationItem = [PPConversationItem conversationWithDictionary:obj];
                [conversations addObject:conversationItem];
            }];
        }
        
        if (block) block(conversations, response, [NSError errorWithDomain:PPErrorDomain
                                                                      code:PPErrorCodeAPIError
                                                                  userInfo:error]);
        
    }];
    
}

@end
