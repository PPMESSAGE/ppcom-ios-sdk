//
//  PPGetConversationInfoFromHTTP.m
//  Pods
//
//  Created by Jin He on 7/5/16.
//
//

#import "PPGetConversationFromHTTP.h"
#import "PPAPI.h"
#import "PPApp.h"
#import "PPServiceUser.h"
#import "PPConversationItem.h"

@implementation PPGetConversationFromHTTP

- (void) getConversation: (NSString *)conversationUUID withBlock: (PPHttpServiceCompletedBlock)block {
    NSString *appUUID = self.app.appUuid;
    NSString *userUUID = self.user.userUuid;

    if (!appUUID || !userUUID || !conversationUUID) {
        if (block) block(nil);
        return;
    }
    
    NSDictionary *params = @{ @"user_uuid": userUUID,
                              @"app_uuid": appUUID,
                              @"conversation_uuid": conversationUUID };
    
    [self.api getConversation:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        PPConversationItem *conversation = nil;
        
        if (!error && response && ([response[@"error_code"] integerValue] == 0)) {
            conversation = [PPConversationItem conversationWithDictionary:response];
        }
        
        if (block) block(conversation);
    }];
}

@end
