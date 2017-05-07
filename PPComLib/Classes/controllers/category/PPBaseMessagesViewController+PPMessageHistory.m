//
//  PPConversationsViewController.m
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import "PPBaseMessagesViewController+PPMessageHistory.h"
#import "PPLog.h"

#import "PPStoreManager.h"
#import "PPMessagesStore.h"

@implementation PPBaseMessagesViewController (PPMessageHistory)

- (void)pp_loadMessageHistory:(PPNoArgBlock)block {
    PPSDK *sdk = [PPSDK sharedSDK];
    NSMutableArray *messages = [self pp_localMessages];
    PPGetMessageHistoryHttpModel *getMessageHistoryHttpModel = [PPGetMessageHistoryHttpModel modelWithClient:sdk];

    if (self.conversationUUID == nil) {
        return;
    }

    if (messages == nil || messages.count == 0) {
        [getMessageHistoryHttpModel requestWithConversationUUID:self.conversationUUID pageOffset:0 completed:^(id obj, NSDictionary *response, NSError *error) {
            [self pp_loadMessageHistory:obj withBlock:block];
        }];
        return;
    }
    
    PPMessage *message = messages[0];
    PPFastLog(@"[PPMessageHistory] load page with maxUUID:%@", message.identifier);
    [getMessageHistoryHttpModel requestWithConversationUUID:self.conversationUUID maxUUID:message.identifier completed:^(id obj, NSDictionary *response, NSError *error) {
        [self pp_loadMessageHistory:obj withBlock:block];
    }];
}

// private

- (void)pp_loadMessageHistory:(NSMutableArray *)responseMessages withBlock:(PPNoArgBlock)block {
    if (responseMessages) {
        [[self pp_messagesStore] insertAtHeadWithMessages:responseMessages];
        [self reloadTableViewWithMessages:[self pp_localMessages]];
    }
    if (block) block();
}

- (PPMessagesStore*)pp_messagesStore {
    return [PPStoreManager instanceWithClient:[PPSDK sharedSDK]].messagesStore;
}

- (NSMutableArray*)pp_localMessages {
    return [[self pp_messagesStore] messagesInCovnersation:self.conversationUUID autoCreate:YES];
}

@end
