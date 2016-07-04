//
//  PPConversationService.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

#import "PPConversationItem.h"
#import "PPSDK.h"

// On get conversations from memory/http completed block
typedef void(^PPConversationServiceGetListBlock)(NSMutableArray* conversationList);
// On find conversation completed block
typedef void(^PPConversationServiceFindConversationBlock)(PPConversationItem* conversationItem);

@interface PPConversationService : NSObject

- (instancetype)initWithPPSDK:(PPSDK*)sdk;

// get current conversations.
- (void)getConversationsWithBlock:(PPConversationServiceGetListBlock)aBlock;

// get sorted conversations from memory.
// - (NSMutableArray*)sortedConversations;

// add conversation
- (void)addConversation:(PPConversationItem*)conversation;

// add conversation array
- (void)addConversations:(NSMutableArray*)conversations;

// find conversation with conversation's UUID
- (void)findConversationWithUUID:(NSString*)conversationUUID
                       withBlock:(PPConversationServiceFindConversationBlock)aBlock;

@end
