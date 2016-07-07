//
//  PPConversationsViewController.m
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import "PPBaseMessagesViewController+PPMessageHistory.h"

@implementation PPBaseMessagesViewController (PPMessageHistory)

- (void)loadMessageHistory:(PPNoArgBlock)block {
    PPSDK *sdk = [PPSDK sharedSDK];
    NSMutableArray *messages = [self.messagesDataSource messages];
    PPGetMessageHistoryHttpModel *getMessageHistoryHttpModel = [PPGetMessageHistoryHttpModel modelWithClient:sdk];
    
    if (!messages && messages.count == 0) {
        [getMessageHistoryHttpModel requestWithConversationUUID:self.conversationUUID pageOffset:@0 completed:^(id obj, NSDictionary *response, NSError *error) {
            [self loadMessageHistory:obj withBlock:block];
        }];
        return;
    }
    
    PPMessage *message = messages[0];
    [getMessageHistoryHttpModel requestWithConversationUUID:self.conversationUUID maxUUID:message.identifier completed:^(id obj, NSDictionary *response, NSError *error) {
        [self loadMessageHistory:obj withBlock:block];
    }];
}

// private

- (void)loadMessageHistory:(NSMutableArray *)responseMessages withBlock:(PPNoArgBlock)block {
    if (responseMessages) {
        NSMutableArray *messages = [self.messagesDataSource messages];
        [messages  addObjectsFromArray:responseMessages];
    }
    if (block) block();
}

@end
