//
//  PPConversationItem.h
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMessage;

extern NSString *const PPConversationItemStatusNew;
extern NSString *const PPConversationItemStatusOpen;
extern NSString *const PPConversationItemStatusClosed;

extern NSString *const PPConversationItemTypeS2S;
extern NSString *const PPConversationItemTypeS2P;

@interface PPConversationItem : NSObject

+ (PPConversationItem*)conversationWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic) NSString *conversationUserUUID;
@property (nonatomic) PPMessage *latestMessage;
@property (nonatomic) NSString *conversationIcon;
@property (nonatomic) NSString *conversationType;
@property (nonatomic) NSString *conversationStatus;
@property (nonatomic) NSString *conversationName;
@property (nonatomic) NSString *uuid;
@property (nonatomic) int unreadMsgNumber;
@property (nonatomic) double updateTimestamp;
@property (nonatomic) NSString *conversationS2SUserUUID;
@property (nonatomic) NSMutableArray *conversationMemberIdsArray;

@end
