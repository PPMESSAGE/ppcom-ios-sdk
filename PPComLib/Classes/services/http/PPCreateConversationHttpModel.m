//
//  PPCreateConversationHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 4/13/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPCreateConversationHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPUser.h"
#import "PPApp.h"
#import "PPserviceUser.h"

#import "PPConversationItem.h"

static NSString *const kPPCreateConversationDefaultConversationType = @"P2S";

@interface PPCreateConversationHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPCreateConversationHttpModel

+ (instancetype)modelWithClient:(PPSDK*)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

//response:
//
//{
//    "app_uuid" = "7c144f63-f728-11e5-9b10-acbc327f19e9";
//    "assigned_uuid" = "<null>";
//    "conversation_icon" = "http://192.168.0.206:8080/identicon/f26c895179b41edad150f9fe0a516c160b9f843c.png";
//    "conversation_name" = "\U5206\U7ec41";
//    "conversation_type" = P2S;
//    createtime = "2016-04-13 10:47:57 691236";
//    "error_code" = 0;
//    "error_string" = "success.";
//    "group_uuid" = "53d20747-009f-11e6-87fb-acbc327f19e9";
//    status = NEW;
//    updatetime = "2016-04-13 10:47:57 691231";
//    uri = "/PP_CREATE_CONVERSATION";
//    "user_list" = (
//        "41c0ac2e-009f-11e6-a12b-acbc327f19e9",
//        "7c11ec6b-f728-11e5-9dbf-acbc327f19e9"
//    );
//    "user_uuid" = "0e615f61-ffd3-11e5-b692-acbc327f19e9";
//    uuid = "211216c5-0122-11e6-84b4-acbc327f19e9";
//}
- (void)createWithGroupUUID:(NSString *)groupUUID
                  completed:(PPHttpModelCompletedBlock)completedBlock {
    
    NSString *userUUID = self.client.user.userUuid;
    NSString *appUUID = self.client.app.appUuid;
    NSString *conversationType = kPPCreateConversationDefaultConversationType;
    NSString *deviceUUID = self.client.user.mobileDeviceUuid;
    NSDictionary *params = @{ @"user_uuid": userUUID,
                              @"app_uuid": appUUID,
                              @"device_uuid": deviceUUID,
                              @"conversation_type": conversationType,
                              @"group_uuid": groupUUID };
    
    [self.client.api createPPComConversation:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPConversationItem *conversationItem = nil;
        
        if (response && [response[@"error_code"] integerValue] == 0) {
            
            conversationItem = [PPConversationItem conversationWithDictionary:response];
            
        }
        
        if (completedBlock) {
            completedBlock(conversationItem, response, [NSError errorWithDomain:PPErrorDomain
                                                                           code:PPErrorCodeAPIError
                                                                       userInfo:error]);
        }
        
    }];
    
}

- (void)createWithUserUUID:(NSString *)userUUID
                 completed:(PPHttpModelCompletedBlock)completedBlock {
    
    NSString *selfUserUUID = self.client.user.userUuid;
    NSString *appUUID = self.client.app.appUuid;
    NSString *conversationType = kPPCreateConversationDefaultConversationType;
    NSString *deviceUUID = self.client.user.mobileDeviceUuid;
    NSArray *memberList = @[ userUUID ];
    
    NSDictionary *params = @{ @"user_uuid": selfUserUUID,
                              @"app_uuid": appUUID,
                              @"device_uuid": deviceUUID,
                              @"conversation_type": conversationType,
                              @"member_list": memberList };
    
    [self.client.api createPPComConversation:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        PPConversationItem *conversationItem = nil;
        
        if (response && [response[@"error_code"] integerValue] == 0) {
            conversationItem = [PPConversationItem conversationWithDictionary:response];
        }
        
        if (completedBlock) completedBlock(conversationItem, response, [NSError errorWithDomain:PPErrorDomain
                                                                                           code:PPErrorCodeAPIError
                                                                                       userInfo:error]);
        
    }];
    
}

@end
