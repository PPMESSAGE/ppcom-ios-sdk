//
//  PPConversationMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationMemoryCache.h"

#import "PPMemoryCache.h"
#import "PPConversationItem.h"
#import "PPMessage.h"

#import "PPLog.h"

static NSString * const kConversationsCacheKey = @"conversations";
static NSString * const kPPConversationsPageInfoCacheKey = @"conversations_pageinfos";

@interface PPConversationMemoryCache ()

@property (nonatomic) PPMemoryCache *cache;

@end

@implementation PPConversationMemoryCache

- (instancetype)initWithMemoryCache:(PPMemoryCache*)memoryCache {
    if (self = [super init]) {
        _cache = memoryCache;
    }
    return self;
}

#pragma mark -

- (void)updateStatusWithConversationUUID:(NSString *)conversationUUID
                               newStatus:(NSString *)status {
    NSMutableOrderedSet *conversations = [self conversations];
    [conversations enumerateObjectsUsingBlock:^(PPConversationItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uuid isEqualToString:conversationUUID]) {
            obj.conversationStatus = status;
            [conversations removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (void)updateCacheWithConversations:(NSMutableOrderedSet *)conversations {
    [self.cache setObject:conversations forKey:kConversationsCacheKey];
}

- (void)updateCacheWithConversation:(PPConversationItem *)conversation {
    NSInteger index = [self findConversationIndexWithUUID:conversation.uuid];
    if (index != -1) {
        [[self conversations] replaceObjectAtIndex:index withObject:conversation];
    } else {
        [self.conversations addObject:conversation];
    }
}

- (NSMutableOrderedSet*)conversations {
    return [self.cache objectForKey:kConversationsCacheKey];
}

- (PPPageIndex*)conversationsPageInfo {
    return [self.cache objectForKey:kPPConversationsPageInfoCacheKey];
}

- (void)updateCacheWithConversationsPageInfo:(PPPageIndex *)pageInfo {
    [self.cache setObject:pageInfo forKey:kPPConversationsPageInfoCacheKey];
}

#pragma mark - 

- (void)updateConversationWithMessage:(PPMessage*)message
                      incrementUnread:(BOOL)incre {
    PPConversationItem *conversation = [self findConversationWithUUID:message.conversationUUID];
    if (conversation) {
        conversation.latestMessage = message;
        conversation.updateTimestamp = message.timestamp;
        if (incre) {
            conversation.unreadMsgNumber++;
        }
    }
}

- (void)addConversations:(NSMutableOrderedSet*)conversations {
    NSMutableOrderedSet *existConversations = [self conversations];
    
    if (conversations && conversations.count > 0) {
        [conversations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![existConversations containsObject:obj]) {
                PPFastLog(@"contains object:%@", obj);
                [existConversations addObject:obj];
            }
        }];
    }
    
}

- (NSInteger)findConversationIndexWithUUID:(NSString *)conversationUUID {
    NSMutableOrderedSet *conversations = [self conversations];
    if (!conversations) {
        conversations = [NSMutableOrderedSet orderedSet];
        [self updateCacheWithConversations:conversations];
    }
    __block NSInteger index = -1;
    [conversations enumerateObjectsUsingBlock:^(PPConversationItem *conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([conversation.uuid isEqualToString:conversationUUID]) {
            index = (NSInteger)idx;
            *stop = YES;
        }
    }];
    return index;
}

- (PPConversationItem*)findConversationWithUUID:(NSString*)conversationUUID {
    NSInteger index = [self findConversationIndexWithUUID:conversationUUID];
    if (index == -1) {
        return nil;
    }
    
    return [self conversations][index];
}

@end
