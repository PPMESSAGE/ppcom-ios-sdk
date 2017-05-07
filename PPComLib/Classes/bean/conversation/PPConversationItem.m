//
//  PPConversationItem.m
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationItem.h"

#import "PPMessage.h"
#import "PPUser.h"
#import "PPServiceUser.h"

#import "PPSDK.h"
#import "PPLog.h"
#import "PPSDKUtils.h"
#import "PPMessageUtils.h"

NSString *const PPConversationItemStatusNew = @"NEW";
NSString *const PPConversationItemStatusOpen = @"OPEN";
NSString *const PPConversationItemStatusClosed = @"CLOSE";

NSString *const PPConversationItemTypeS2S = @"S2S";
NSString *const PPConversationItemTypeS2P = @"P2S";

@implementation PPConversationItem

+ (PPConversationItem*)conversationWithDictionary:(NSDictionary*)dictionary {
    PPConversationItem* conversationItem = [[PPConversationItem alloc] init];
    
    NSDictionary *conversationDataDict = dictionary[@"conversation_data"];

    conversationItem.conversationIcon = nil;

    if (conversationDataDict) {
        conversationItem.conversationStatus = conversationDataDict[@"conversation_status"];
        conversationItem.uuid = conversationDataDict[@"conversation_uuid"];
        conversationItem.updateTimestamp = PPRetrieveTimestampFromString(conversationDataDict[@"updatetime"]);
        conversationItem.conversationName = conversationDataDict[@"conversation_name"];
        conversationItem.conversationUserUUID = conversationDataDict[@"user_uuid"];
        conversationItem.conversationType = conversationDataDict[@"conversation_type"];
    }

    PPMessage *latestMessage = nil;
    NSDictionary *latestMessageDict = dictionary[@"latest_message"];
    if (PPIsNotNull((NSString*)latestMessageDict) && PPIsNotNull([latestMessageDict objectForKey:@"message_body"])) {
        latestMessage = [PPMessage messageWithDictionary:PPJSONStringToDictionary(latestMessageDict[@"message_body"])];
    }
    conversationItem.latestMessage = latestMessage;


    // `from_user` is not the latest message's user
    // instead of, is the creater of this conversation
    if (PPIsNull(conversationItem.conversationIcon)) {
        NSMutableArray *array = dictionary[@"conversation_users"];

        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *user = (NSDictionary*)obj;
            if ([[user objectForKey:@"uuid"] isEqualToString:[PPSDK sharedSDK].user.userUuid]) {
            } else {
                if (conversationItem.conversationIcon == nil) {
                    conversationItem.conversationIcon = PPFileURL([user objectForKey:@"user_icon"]);
                }
            }
        }];
    }
    

    
    return conversationItem;
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"<%p, %@, %@>",
            self,
            self.class,
            @{@"conversation_uuid": self.uuid,
              @"conversation_name": PPSafeString(self.conversationName),
              @"conversation_icon": PPSafeString(self.conversationIcon),
              @"conversation_type": PPSafeString(self.conversationType),
              @"latest_message": self.latestMessage ? self.latestMessage : @"<null>",
              @"s2s_user_uuid": PPSafeString(self.conversationS2SUserUUID),
              @"update_timestamp": [NSNumber numberWithDouble:self.updateTimestamp]}];
}

#pragma mark - override

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[PPConversationItem class]]) return NO;
    
    PPConversationItem *other = object;
    BOOL equal = [other.uuid isEqualToString:self.uuid];
    
    return equal;
    
}

- (NSUInteger)hash {
    return [self.uuid hash];
}

- (NSComparisonResult)compare:(PPConversationItem *)other {
    if (self.updateTimestamp > other.updateTimestamp) {
        return NSOrderedAscending;
    } else if (self.updateTimestamp < other.updateTimestamp) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end
