//
//  PPGroupMembersStore.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSDK, PPUser;

@interface PPGroupMembersStore : NSObject

+ (instancetype)storeWithClient:(PPSDK*)client;

- (NSMutableArray*)groupMembersInConversation:(NSString*)conversationUUID;
- (void)groupMembersInConversation:(NSString*)conversationUUID
                     findCompleted:(void (^)(NSMutableArray *members, BOOL success))completedBlock;

@end
