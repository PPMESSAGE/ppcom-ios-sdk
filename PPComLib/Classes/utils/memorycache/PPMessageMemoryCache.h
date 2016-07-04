//
//  PPMessageMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMessage.h"

@class PPPageIndex;
@class PPMemoryCache;

@interface PPMessageMemoryCache : NSObject

- (instancetype)initWithMemoryCache:(PPMemoryCache*)cache;

#pragma mark -

- (void)updateCacheWithMessage:(PPMessage*)message;
- (void)updateCacheWithMessage:(PPMessage*)message
               incrementUnread:(BOOL)incre;
- (void)updateMessageWithUUID:(NSString*)messageUUID
                   withStatus:(PPMessageStatus)status
               inConversation:(NSString*)conversationUUID;
- (void)updateCacheWithMessages:(NSMutableArray*)messages;
- (void)updateCacheWithMessages:(NSMutableArray*)messages
                 inConversation:(NSString*)conversationUUID
                         atHead:(BOOL)atHead;
- (void)replaceCacheWithMessages:(NSMutableArray*)messages
                  inConversation:(NSString*)conversationUUID;
- (void)updateCacheWithMessagesPageInfo:(PPPageIndex*)pageInfo
                         inConversation:(NSString*)conversationUUID;

- (NSMutableArray*)messagesInConversation:(NSString*)conversationUUID;
- (PPPageIndex*)messagesPageInfoInConversation:(NSString*)conversationUUID;

- (PPMessage*)findMessageWithUUID:(NSString*)uuid
                   inConversation:(NSString*)conversationUUID;

/**
 * 某个conversationId内的消息是否从DB和Server加载过
 *
 * @param conversationUUID 会话ID
 * @return YES if fetched, else NO
 */
- (BOOL)fetchedFromDBAndServerInConversation:(NSString*)conversationUUID;

/**
 * 将某个conversationId内的消息标记为还没有从DB何Server加载过
 *
 * @param conversationUUID 会话ID
 * @param fetched 是否加载过
 */
- (void)setFetchedFromDBAndServerInConversation:(NSString*)conversationUUID
                                             to:(BOOL)fetched;

@end
