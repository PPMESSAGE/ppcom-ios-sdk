//
//  PPConversationsStore.h
//  PPComLib
//
//  Created by PPMessage on 4/1/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPConversationItem.h"

@class PPSDK, PPMessage;

/**
 *
 * 1. 方法`- (void)sortedConversationsWithBlock:(void (^)(NSArray *conversations, NSError *error))block`
 *    首先会检查是否已经从服务器拿到过，并且拿到的列表不为空，如果正确的话，直接返回本地已有的；
 *    否则，从服务器尝试拿取
 *
 */
@interface PPConversationsStore : NSObject

+ (instancetype)storeWithClient:(PPSDK*)client;

- (void)setWithConversations:(NSArray*)conversations;

/**
 * Add conversation
 */
- (void)addConversation:(PPConversationItem*)conversation;

/**
 * Add a default conversation
 */
- (void)addDefaultConversation:(PPConversationItem*)defaultConversation;

/**
 * 从`cache`拿去
 */
- (NSArray*)sortedConversations;

/**
 * 异步拿取`conversations`
 *
 * 1.先查看`cache`
 * 2.后查看Http
 */
- (void)sortedConversationsWithBlock:(void (^)(NSArray *conversations, NSError *error))block;

/**
 * 当产生新消息的时候，调用此方法更新`conversations`列表
 */
- (void)updateConversationsWithMessage:(PPMessage*)message;

/**
 * find conversation by conversation uuid, only from memory
 */
- (PPConversationItem *)findConversationWithConversationUUID:(NSString*)conversationUUID;

/**
 * Async find conversation by user uuid
 */
- (void)findConversationAssociatedWithUserUUID:(NSString*)userUUID
                                 findCompleted:(void (^)(PPConversationItem *conversationItem, BOOL success))completedBlock;

// Async find conversation by uuid
- (void)asyncFindConversationWithConversationUUID:(NSString*)conversationUUID
                                        withBlock:(void (^)(PPConversationItem *conversationItem))aBlock;

/**
 * Async get default conversation with completed block
 */
- (void)asyncGetDefaultConversationWithCompletedBlock:(void (^)(PPConversationItem *conversation))completedBlock;

/**
 * Is default conversation avaliable now
 */
- (BOOL)isDefaultConversationAvaliable;

/**
 * set members
 */
- (void)setMembers:(NSMutableArray *)members withConversationUUID:(NSString *)conversationUUID;

@end
