//
//  PPGroupMembersStore.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPConversationMembersStore.h"

#import "PPSDK.h"
#import "PPUser.h"

#import "PPGetConversationUserListHttpModel.h"

static NSString *const kPPConversationMembersStoreUsersCacheKey = @"PPConversationMembersStoreUsersCacheKey";

@interface PPConversationMembersStore ()

@property (nonatomic) PPSDK *client;
@property (nonatomic) NSCache *store;

@end

@implementation PPConversationMembersStore

+ (instancetype)storeWithClient:(PPSDK *)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

#pragma mark - 

- (NSMutableArray*)membersInConversation:(NSString *)conversationUUID {
    return [self usersForConversationUUID:conversationUUID];
}

- (void) membersInConversation:(NSString *)conversationUUID
                     findCompleted:(void (^)(NSMutableArray *, BOOL))completedBlock {
    // Generally, we should require the new group members on each new request, but
    // because current group members rarely changed so far ... so I decide to use a
    // group members for cache here
    NSMutableArray *cachedUsers = [self membersInConversation:conversationUUID];
    if (cachedUsers) {
        if (completedBlock) {
            completedBlock(cachedUsers, YES);
        }
        return;
    }
    
    PPGetConversationUserListHttpModel *getConversationUserList = [PPGetConversationUserListHttpModel modelWithClient:self.client];
    [getConversationUserList usersWithConversationUUID:conversationUUID completedBlock:^(id obj, NSDictionary *response, NSError *error) {
        
        if (obj) {
            [self cacheUsers:obj forCVUUID:conversationUUID];
        }
        
        if (completedBlock) {
            completedBlock(obj, obj != nil);
        }
            
    }];
    
}

#pragma mark - helpers

- (PPUser*)userForUUID:(NSString*)userUUID {
    if (!userUUID) return nil;
    
    id obj = [self.store objectForKey:kPPConversationMembersStoreUsersCacheKey];
    if (!obj) return nil;
    
    NSMutableDictionary *users = obj;
    return [users objectForKey:userUUID];
}

- (void)cacheUser:(PPUser*)user {
    if (!user) return;
    
    NSString *userUUID = user.userUuid;
    id obj = [self.store objectForKey:kPPConversationMembersStoreUsersCacheKey];
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        [self.store setObject:obj forKey:kPPConversationMembersStoreUsersCacheKey];
    }
    
    NSMutableDictionary *users = obj;
    [users setObject:user forKey:userUUID];
}

- (NSMutableArray*)usersForConversationUUID:(NSString*)conversationUUID {
    if (!conversationUUID) return nil;
    return [self.store objectForKey:conversationUUID];
}

- (void)cacheUsers:(NSMutableArray*)users
         forCVUUID:(NSString*)conversationUUID {
    [self.store setObject:users forKey:conversationUUID];
}

#pragma mark - getter

- (NSCache*)store {
    if (!_store) {
        _store = [NSCache new];
    }
    return _store;
}

@end
