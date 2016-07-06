//
//  PPGetConversationUserListHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetConversationUserListHttpModel.h"

#import "PPSDK.h"
#import "PPApp.h"
#import "PPAPI.h"
#import "PPUser.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@interface PPGetConversationUserListHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetConversationUserListHttpModel

#pragma mark - constructor

+ (instancetype)modelWithClient:(PPSDK *)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

#pragma mark -

//list =     (
//            {
//                group =             {
//                    "group_name" = "\U5206\U7ec41";
//                    uuid = "53d20747-009f-11e6-87fb-acbc327f19e9";
//                };
//                "is_browser_online" = 0;
//                "is_mobile_online" = 0;
//                updatetime = "2016-04-12 19:11:08 444910";
//                "user_email" = "kefu1@gmail.com";
//                "user_fullname" = kefu1;
//                "user_icon" = "<null>";
//                "user_signature" = "<null>";
//                uuid = "41c0ac2e-009f-11e6-a12b-acbc327f19e9";
//            },
//            {
//                group = "<null>";
//                "is_browser_online" = 0;
//                "is_mobile_online" = 0;
//                updatetime = "2016-04-14 15:59:40 097738";
//                "user_email" = "afd9b5@7c144f";
//                "user_fullname" = "Local Area.User";
//                "user_icon" = "http://192.168.0.206:8080/identicon/afd9b5b5-01e9-11e6-a20b-acbc327f19e9.png";
//                "user_signature" = "<null>";
//                uuid = "afd9b5b5-01e9-11e6-a20b-acbc327f19e9";
//            },
//            {
//                group =             {
//                    "group_name" = "\U5206\U7ec41";
//                    uuid = "53d20747-009f-11e6-87fb-acbc327f19e9";
//                };
//                "is_browser_online" = 0;
//                "is_mobile_online" = 1;
//                updatetime = "2016-04-12 11:56:54 591276";
//                "user_email" = "dingguijin@gmail.com";
//                "user_fullname" = "Guijin Ding";
//                "user_icon" = "<null>";
//                "user_signature" = "<null>";
//                uuid = "7c11ec6b-f728-11e5-9dbf-acbc327f19e9";
//            }
//            );
- (void)usersWithConversationUUID:(NSString *)conversationUUID
                   completedBlock:(PPHttpModelCompletedBlock)completedBlock {
    
    NSString *appUUID = self.client.app.appUuid;
    NSDictionary *params = @{ @"app_uuid": appUUID, @"conversation_uuid":conversationUUID };
    
    [self.client.api getConversationUserList:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        NSMutableArray *users = nil;
        
        if (response && [response[@"error_code"] integerValue] == 0) {
            NSArray *array = response[@"list"];
            users = [NSMutableArray arrayWithCapacity:array.count];
            
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PPUser *user = [[PPUser alloc] initWithUuid:obj[@"uuid"]];
                user.userName = obj[@"user_fullname"];
                user.userIcon = PPSafeString(PPFileURL(obj[@"user_icon"]));
                
                [users addObject:user];
            }];
            
        }
        
        if (completedBlock) completedBlock(users, response, error);
        
    }];
    
}

@end
