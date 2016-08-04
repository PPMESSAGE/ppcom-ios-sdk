//
//  PPGroupMembersStore.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSDK, PPUser;

@interface PPConversationMembersStore : NSObject

+ (instancetype) storeWithClient:(PPSDK*)client;

- (NSMutableArray *) membersInConversation:(NSString*)conversationUUID;

- (void) membersInConversation:(NSString*)conversationUUID
                     findCompleted:(void (^)(NSMutableArray *members, BOOL success))completedBlock;

@end
