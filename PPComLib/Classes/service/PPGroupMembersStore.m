//
//  PPGroupMembersStore.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGroupMembersStore.h"

#import "PPSDK.h"
#import "PPUser.h"

#import "PPGetConversationUserListHttpModel.h"

static NSString *const kPPGroupMembersStoreUsersCacheKey = @"PPGroupMembersStoreUsersCacheKey";

@interface PPGroupMembersStore ()

@property (nonatomic) PPCom *client;
@property (nonatomic) NSCache *store;

@end

@implementation PPGroupMembersStore

+ (instancetype)storeWithClient:(PPCom *)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPCom *)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

#pragma mark - 

- (NSMutableArray*)groupMembersInConversation:(NSString *)conversationUUID {
    return [self usersForConversationUUID:conversationUUID];
}

- (void)groupMembersInConversation:(NSString *)conversationUUID
                     findCompleted:(void (^)(NSMutableArray *, BOOL))completedBlock {
    // Generally, we should require the new group members on each new request, but
    // because current group members rarely changed so far ... so I decide to use a
    // group members for cache here
    NSMutableArray *cachedUsers = [self groupMembersInConversation:conversationUUID];
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
    
    id obj = [self.store objectForKey:kPPGroupMembersStoreUsersCacheKey];
    if (!obj) return nil;
    
    NSMutableDictionary *users = obj;
    return [users objectForKey:userUUID];
}

- (void)cacheUser:(PPUser*)user {
    if (!user) return;
    
    NSString *userUUID = user.userUuid;
    id obj = [self.store objectForKey:kPPGroupMembersStoreUsersCacheKey];
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        [self.store setObject:obj forKey:kPPGroupMembersStoreUsersCacheKey];
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
