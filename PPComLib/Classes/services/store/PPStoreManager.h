//
//  PPStoreManager.h
//  PPComLib
//
//  Created by PPMessage on 4/1/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSDK, PPConversationsStore, PPConversationMembersStore, PPMessagesStore, PPUsersStore;

@interface PPStoreManager : NSObject

+ (instancetype)instanceWithClient:(PPSDK*)client;

@property (nonatomic) PPConversationsStore *conversationStore;
@property (nonatomic) PPConversationMembersStore *conversationMembersStore;
@property (nonatomic) PPMessagesStore *messagesStore;
@property (nonatomic) PPUsersStore *usersStore;

@end
