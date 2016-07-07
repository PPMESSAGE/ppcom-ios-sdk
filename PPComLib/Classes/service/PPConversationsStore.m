//
//  PPConversationsStore.m
//  PPComLib
//
//  Created by PPMessage on 4/1/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPConversationsStore.h"

#import "PPApp.h"
#import "PPMessage.h"
#import "PPConversationItem.h"

#import "PPLog.h"
#import "PPSDKUtils.h"

#import "PPGetConversationListHttpModel.h"
#import "PPCreateConversationHttpModel.h"
#import "PPGetDefaultConversationHttpModels.h"
#import "PPGetConversationInfoHttpModel.h"

#define PP_ENABLE_LOG 1

@interface PPConversationsStore ()

@property (nonatomic) NSMutableArray *conversationItems;
@property (nonatomic) PPSDK *client;
@property (nonatomic) BOOL fetchedFromServer; // 是否从服务器下载过conversation_list

@property (nonatomic) PPConversationItem *defaultConversation;

@end

@implementation PPConversationsStore

+ (instancetype)storeWithClient:(PPSDK*)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.conversationItems = [NSMutableArray array];
        self.client = client;
    }
    return self;
}

- (void)setWithConversations:(NSArray *)conversations {
    if (conversations && conversations.count > 0) {
        self.conversationItems = [NSMutableArray arrayWithArray:conversations];
    }
}

- (void)addConversation:(PPConversationItem *)conversation {
    if (conversation) {
        NSInteger existIndex = [self indexForConversation:conversation.uuid];
        if (existIndex != NSNotFound) {
            PPConversationItem *exitConversationItem = [self.conversationItems objectAtIndex:existIndex];
            
            conversation.conversationName = PPIsNotNull(conversation.conversationName) ? conversation.conversationName : exitConversationItem.conversationName;
            conversation.conversationSummary = PPIsNotNull(conversation.conversationSummary) ? conversation.conversationSummary : exitConversationItem.conversationSummary;
            
            [self.conversationItems replaceObjectAtIndex:existIndex withObject:conversation];
            
        } else {
            [self.conversationItems addObject:conversation];
        }
    }
}

- (void)addDefaultConversation:(PPConversationItem *)defaultConversation {
    self.defaultConversation = defaultConversation;
    [self addConversation:defaultConversation];
}

- (NSArray*)sortedConversations {
    return [self.conversationItems sortedArrayUsingComparator:^NSComparisonResult(PPConversationItem *obj1, PPConversationItem *obj2) {
        return [obj1 compare:obj2];
    }];
}

- (void)sortedConversationsWithBlock:(void (^)(NSArray *, NSError *))block {
    if (self.conversationItems && self.conversationItems.count > 0 && self.fetchedFromServer) {
        if (PP_ENABLE_LOG) PPFastLog(@"Find conversations from memory");
        if (block) block([self sortedConversations], nil);
        return;
    }
    
    // 1. get conversations
    PPGetConversationListHttpModel *getConversationsTask = [PPGetConversationListHttpModel modelWithClient:self.client];
    [getConversationsTask getConversationListWithBlock:^(id obj, NSDictionary *response, NSError *error) {
        
        self.fetchedFromServer = YES;
        
        if (obj) {
            [self addConversations:obj];
        }
        
        if (block) block([self sortedConversations], error);
        
    }];
    
}

- (void)updateConversationsWithMessage:(PPMessage *)message {
    PPConversationItem *conversationItem = [self buildConversationItemFromPPMessage:message];
    NSInteger conversationIndex = [self indexForConversation:conversationItem.uuid];
    if (conversationIndex == NSNotFound) {
        [self.conversationItems addObject:conversationItem];
    } else {
        PPConversationItem *conversationItem = self.conversationItems[conversationIndex];
        conversationItem.conversationSummary = [PPMessage summaryInMessage:message];
        conversationItem.updateTimestamp = message.timestamp;
    }
}

- (void)findConversationAssociatedWithUserUUID:(NSString *)userUUID
                                 findCompleted:(void (^)(PPConversationItem *, BOOL))completedBlock {
    
    // Find from memory
    NSInteger findIndex = [self indexForAssignedUserConversation:userUUID];
    if (findIndex != NSNotFound) {
        if (completedBlock) completedBlock(self.conversationItems[findIndex], YES);
        return;
    }
    
    // find from server
    PPCreateConversationHttpModel *createConversationTask = [PPCreateConversationHttpModel modelWithClient:self.client];
    [createConversationTask createWithUserUUID:userUUID completed:^(id obj, NSDictionary *response, NSError *error) {
        
        if (obj) {
            [self addConversation:obj];
        }
        
        if (completedBlock) completedBlock(obj, obj != nil);
        
    }];
    
}

- (void)asyncGetDefaultConversationWithCompletedBlock:(void (^)(PPConversationItem *))completedBlock {
    if ([self isDefaultConversationAvaliable]) {
        if (completedBlock) completedBlock(self.defaultConversation);
        return;
    }
    
    PPGetDefaultConversationHttpModels *fetchDefaultConversation = [PPGetDefaultConversationHttpModels modelWithClient:self.client];
    [fetchDefaultConversation requestWithBlock:^(PPConversationItem *conversation, NSDictionary *response, NSError *error) {
        if (conversation) {
            [self addConversation:conversation];
            self.defaultConversation = conversation;
        }
        if (completedBlock) completedBlock(self.defaultConversation);
    }];
}

- (void)asyncFindConversationWithConversationUUID:(NSString *)conversationUUID
                                        withBlock:(void (^)(PPConversationItem *))aBlock {
    // check memory
    if (self.conversationItems) {
        NSInteger findIndex = [self indexForConversation:conversationUUID];
        if (findIndex != NSNotFound) {
            PPConversationItem *find = self.conversationItems[findIndex];
            if (aBlock) {
                aBlock(find);
            }
            return;
        }
    }
    
    // try get from http
    PPGetConversationInfoHttpModel *findConversationTask = [[PPGetConversationInfoHttpModel alloc] initWithClient:self.client];
    [findConversationTask getWithConversationUUID:conversationUUID
                                   completedBlock:^(id obj, NSDictionary *response, NSError *error) {
                                       PPConversationItem *conversationItem = nil;
                                       if (obj) {
                                           conversationItem = obj;
                                           [self addConversation:conversationItem];
                                       }
                                       
                                       if (aBlock) {
                                           aBlock(conversationItem);
                                       }
    }];
    
}

- (BOOL)isDefaultConversationAvaliable {
    return self.defaultConversation != nil;
}

#pragma mark - Helper

- (NSInteger)indexForConversation:(NSString*)conversationUUID {
    __block NSInteger findIndex = NSNotFound;
    if (self.conversationItems && self.conversationItems.count > 0) {
        [self.conversationItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PPConversationItem *conversationItem = obj;
            
            if ([conversationItem.uuid isEqualToString:conversationUUID]) {
                findIndex = idx;
                *stop = YES;
            }
            
        }];
    }
    return findIndex;
}

- (NSInteger)indexForAssignedUserConversation:(NSString*)userUUID {
    __block NSInteger findIndex = NSNotFound;
    if (self.conversationItems && self.conversationItems.count > 0) {
        [self.conversationItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PPConversationItem *conversationItem = obj;
            if (PPIsNotNull(conversationItem.conversationS2SUserUUID) && [conversationItem.conversationS2SUserUUID isEqualToString:userUUID]) {
                findIndex = idx;
                *stop = YES;
            }
        }];
    }
    return findIndex;
}

- (BOOL)isConversationExit:(NSString*)conversationoUUID {
    return [self indexForConversation:conversationoUUID] != NSNotFound;
}

- (void)addConversations:(NSMutableArray*)conversations {
    if (conversations && conversations.count > 0) {
        [conversations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addConversation:obj];
        }];
    }
}

- (PPConversationItem*)buildConversationItemFromPPMessage:(PPMessage*)message {
    PPConversationItem *conversationItem = [[PPConversationItem alloc] init];
    conversationItem.uuid = message.conversationUUID;
    conversationItem.updateTimestamp = message.timestamp;
    conversationItem.conversationSummary = [PPMessage summaryInMessage:message];
    return conversationItem;
}

@end
