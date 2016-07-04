//
//  PPMessageMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageMemoryCache.h"

#import "PPLog.h"

#import "PPConversationItem.h"

#import "PPMemoryCache.h"
#import "PPConversationMemoryCache.h"

static NSString * const kMessageDictionaryCacheKey = @"message_conversations";
static NSString * const kMessagePageInfoDictionaryCacheKey = @"message_pageinfos";
static NSString * const kMessageFetchedFromDBAndServerDictionaryCacheKey = @"fetched_from_db_and_server_info";

@interface PPMessageMemoryCache ()

@property (nonatomic) PPMemoryCache *cache;

@end

@implementation PPMessageMemoryCache

- (instancetype)initWithMemoryCache:(PPMemoryCache *)cache {
    if (self = [super init]) {
        _cache = cache;
    }
    return self;
}

#pragma mark -

- (void)updateCacheWithMessage:(PPMessage *)message {
    [self updateCacheWithMessage:message incrementUnread:NO];
}

- (void)updateCacheWithMessage:(PPMessage *)message
               incrementUnread:(BOOL)incre {
    NSString *conversationUUId = message.conversationUUID;
    
    // update messages
    NSMutableOrderedSet *messages = [self messagesInConversation:conversationUUId autoCreated:YES];
    [messages addObject:message];
    
    // update conversation
    [[PPMemoryCache sharedInstance].conversationCache updateConversationWithMessage:message incrementUnread:incre];
}

- (void)updateMessageWithUUID:(NSString *)messageUUID
                   withStatus:(PPMessageStatus)status
               inConversation:(NSString *)conversationUUID {
    
    PPMessage *message = [self findMessageWithUUID:messageUUID inConversation:conversationUUID];
    if (message) {
        message.status = status;
    }
    
}

- (void)updateCacheWithMessages:(NSMutableArray *)messages
                 inConversation:(NSString *)conversationUUID
                         atHead:(BOOL)atHead {
    NSMutableOrderedSet *msgs = [self messagesInConversation:conversationUUID autoCreated:YES];
    if (atHead) {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(0,[messages count])];
        [msgs insertObjects:messages atIndexes:indexes];
    } else {
        [msgs addObjectsFromArray:messages];
    }
}

- (void)replaceCacheWithMessages:(NSMutableArray *)messages
                  inConversation:(NSString *)conversationUUID {
    NSMutableDictionary *messagesStore = [self messagesStore];
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithArray:messages];
    [messagesStore setObject:orderedSet forKey:conversationUUID];
}

- (void)updateCacheWithMessages:(NSMutableArray *)messages {
    [messages enumerateObjectsUsingBlock:^(PPMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        [self updateCacheWithMessage:message];
    }];
}

- (void)updateCacheWithMessagesPageInfo:(PPPageIndex *)pageInfo
                         inConversation:(NSString *)conversationUUID {
    [[self pageInfoDictionary] setObject:pageInfo forKey:conversationUUID];
}

- (NSMutableOrderedSet*)messagesInConversation:(NSString *)conversationUUID {
    return [self messagesInConversation:conversationUUID autoCreated:NO];
}

- (PPPageIndex*)messagesPageInfoInConversation:(NSString *)conversationUUID {
    NSMutableDictionary *pageDictionary = [self pageInfoDictionary];
    return [pageDictionary objectForKey:conversationUUID];
}

- (PPMessage*)findMessageWithUUID:(NSString *)uuid
                   inConversation:(NSString *)conversationUUID {
    NSUInteger index = [self findMessageIndexWithUUID:uuid inConversation:conversationUUID];
    if (index == NSNotFound) {
        return nil;
    }
    return [self messagesInConversation:conversationUUID][index];
}

#pragma mark -

- (BOOL)fetchedFromDBAndServerInConversation:(NSString *)conversationUUID {
    NSMutableDictionary *dict = [self fetchedFromDBAndServerDictionary];
    
    if (dict[conversationUUID]) {
        return [dict[conversationUUID] boolValue];
    }
    
    return FALSE;
}

- (void)setFetchedFromDBAndServerInConversation:(NSString *)conversationUUID
                                             to:(BOOL)fetched {
    NSMutableDictionary *dict = [self fetchedFromDBAndServerDictionary];
    dict[conversationUUID] = [NSNumber numberWithBool:fetched];
}

#pragma mark - private

- (NSInteger)findMessageIndexWithUUID:(NSString*)uuid
                       inConversation:(NSString*)conversationUUID {
    NSMutableOrderedSet *messages = [self messagesInConversation:conversationUUID autoCreated:NO];
    if (!messages || messages.count == 0) return NSNotFound;
    
    NSUInteger index = [messages indexOfObjectPassingTest:^BOOL(PPMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message.identifier isEqualToString:uuid]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return index;
}

- (NSMutableOrderedSet*)messagesInConversation:(NSString *)conversationUUID
                              autoCreated:(BOOL)autoCreated {
    NSMutableDictionary *messageDictionary = [self messagesStore];
    NSMutableOrderedSet *messages = [messageDictionary objectForKey:conversationUUID];
    if (!messages) {
        if (autoCreated) {
            messages = [NSMutableOrderedSet orderedSet];
            [messageDictionary setValue:messages forKey:conversationUUID];
        }
    }
    
    return messages;
}

- (NSMutableDictionary*)messagesStore {
    NSMutableDictionary *messageDictionary = [self.cache objectForKey:kMessageDictionaryCacheKey];
    if (!messageDictionary) {
        messageDictionary = [NSMutableDictionary dictionary];
        [self.cache setObject:messageDictionary forKey:kMessageDictionaryCacheKey];
    }
    return messageDictionary;
}

- (NSMutableDictionary*)pageInfoDictionary {
    NSMutableDictionary *pageDictionary = [self.cache objectForKey:kMessagePageInfoDictionaryCacheKey];
    if (!pageDictionary) {
        pageDictionary = [NSMutableDictionary dictionary];
        [self.cache setObject:pageDictionary forKey:kMessagePageInfoDictionaryCacheKey];
    }
    return pageDictionary;
}

- (NSMutableDictionary*)fetchedFromDBAndServerDictionary {
    NSMutableDictionary *dict  = [self.cache objectForKey:kMessageFetchedFromDBAndServerDictionaryCacheKey];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        [self.cache setObject:dict forKey:kMessageFetchedFromDBAndServerDictionaryCacheKey];
    }
    return dict;
}

@end
