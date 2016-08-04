//
//  PPStoreManager.m
//  PPComLib
//
//  Created by PPMessage on 4/1/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPStoreManager.h"

#import "PPConversationsStore.h"
#import "PPConversationMembersStore.h"
#import "PPMessagesStore.h"
#import "PPUsersStore.h"

#import "PPSDK.h"

@implementation PPStoreManager

+ (instancetype)instanceWithClient:(PPSDK *)client {
    static dispatch_once_t onceToken;
    static PPStoreManager *storeManager;
    dispatch_once(&onceToken, ^{
        storeManager = [[PPStoreManager alloc] initWithClient:client];
    });
    return storeManager;
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.conversationStore = [PPConversationsStore storeWithClient:client];
        self.conversationMembersStore = [PPConversationMembersStore storeWithClient:client];
        self.messagesStore = [PPMessagesStore storeWithClient:client];
        self.usersStore = [PPUsersStore storeWithClient:client];
    }
    return self;
}

@end
