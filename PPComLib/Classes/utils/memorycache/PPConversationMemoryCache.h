//
//  PPConversationMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPPageIndex;
@class PPMemoryCache;
@class PPConversationItem;
@class PPMessage;

@interface PPConversationMemoryCache : NSObject

- (instancetype)initWithMemoryCache:(PPMemoryCache*)memoryCache;

#pragma mark -

- (void)updateStatusWithConversationUUID:(NSString*)conversationUUID
                               newStatus:(NSString*)status;
- (NSMutableOrderedSet*)conversations;

- (void)updateCacheWithConversations:(NSMutableOrderedSet*)conversations;
- (void)updateCacheWithConversation:(PPConversationItem*)conversation;
- (void)updateCacheWithConversationsPageInfo:(PPPageIndex*)pageInfo;
- (PPPageIndex*)conversationsPageInfo;

- (void)updateConversationWithMessage:(PPMessage*)message
                      incrementUnread:(BOOL)incre;

- (void)addConversations:(NSMutableOrderedSet*)conversations;

/**
 * 找到`conversationUUID`在当前所有conversations数组中的位置
 *
 * @param conversationUUID conversation uuid
 *
 * @return index if success, -1 if not
 *
 */
- (NSInteger)findConversationIndexWithUUID:(NSString*)conversationUUID;

/**
 * 找到`conversationUUID`在当前所有conversations数组中对应的conversation
 *
 * @param conversationUUID conversation uuid
 *
 * @return `<PPConversationItem>` if success, `nil` if not
 *
 */
- (PPConversationItem*)findConversationWithUUID:(NSString*)conversationUUID;

@end
