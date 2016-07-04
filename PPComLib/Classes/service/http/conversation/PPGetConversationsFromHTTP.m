//
//  PPGetConversationsFromHTTP.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPGetConversationsFromHTTP.h"

#import "PPAPI.h"
#import "PPApp.h"
#import "PPServiceUser.h"

#import "PPConversationItem.h"

@implementation PPGetConversationsFromHTTP

- (void)getConversationsWithBlock:(PPGetConversationsBlock)block {
    
    NSString *appUUID = self.app.appUuid;
    NSString *userUUID = self.user.userUuid;
    
    if (!appUUID || !userUUID) {
        if (block) {
            block(nil);
        }
        return;
    }
    
    NSDictionary *params = @{ @"user_uuid": userUUID,
                              @"app_uuid": appUUID };
    
    [self.api getPPComConversationList:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        
        NSMutableArray *conversations = nil;
        
        if (!error && response && ([response[@"error_code"] integerValue] == 0)) {
            
            NSMutableArray *array = response[@"list"];
            conversations = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PPConversationItem *conversationItem = [PPConversationItem conversationWithDictionary:obj];
                [conversations addObject:conversationItem];
            }];
            
        }
        
        if (block) block(conversations);
        
    }];
    
}

@end
