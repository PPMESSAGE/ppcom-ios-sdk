//
//  PPMessage.h
//  PPMessage
//
//  Created by PPMessage on 2/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMessageMediaPart.h"

@class PPUser, PPApiMessage, PPConversationItem;

typedef NS_ENUM(NSInteger, PPMessageType) {
    PPMessageTypeUnknown,
    PPMessageTypeFile,
    PPMessageTypeImage,
    PPMessageTypeText,
    PPMessageTypeTxt,
    PPMessageTypeAudio
};

typedef NS_ENUM(NSInteger, PPMessageDirection) {
    PPMessageDirectionUnknown, // 0
    PPMessageDirectionOutgoing, // 1
    PPMessageDirectionIncoming // 2
};

typedef NS_ENUM(NSInteger, PPMessageStatus) {
    PPMessageStatusOk,
    PPMessageStatusError,
    PPMessageStatusLoading
};

extern NSString *const PPMessageSubTypeText;
extern NSString *const PPMessageSubTypeTxt;
extern NSString *const PPMessageSubTypeFile;
extern NSString *const PPMessageSubTypeImage;
extern NSString *const PPMessageSubTypeAudio;

@interface PPMessage : NSObject

@property (nonatomic) PPUser *fromUser;
@property (nonatomic) PPUser *toUser;
@property (nonatomic) PPMessageStatus status;
@property (nonatomic) NSString *conversationType;
@property (nonatomic) NSString *conversationUUID;
@property (nonatomic) PPMessageDirection direction;
@property (nonatomic) PPMessageType type;
@property (nonatomic) NSString *apiType;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *pushID;
@property (nonatomic) NSString *body;
@property (nonatomic) double timestamp;
@property (nonatomic) BOOL showTimestamp;
@property (nonatomic) id<PPMessageMediaPart> mediaPart;

+ (PPMessage*)messageWithDictionary:(NSDictionary*)messageDict;

+ (PPMessage*)messageForSend:(NSString*)messageUUID
                        text:(NSString*)text
            conversationUUID:(NSString*)conversationUUID
            conversationType:(NSString*)conversationType;

+ (PPMessage*)messageForSend:(NSString *)messageUUID
                        text:(NSString *)text
                conversation:(PPConversationItem *)conversation;

+ (PPMessage*)messageForSend:(NSString *)messageUUID
                        text:(NSString *)text
                conversation:(PPConversationItem *)conversation
                   mediaPart:(id<PPMessageMediaPart>)mediaPart;

+ (NSString*)summaryInMessage:(PPMessage*)message;

- (instancetype)initMessageWithUUID:(NSString*)messageUUID
                        messageBody:(NSString*)messageBody
                     messageSubType:(NSString*)messageSubType
                           fromUser:(PPUser*)fromUser
                             toUser:(PPUser*)toUser
                   conversationItem:(PPConversationItem*)conversationItem
                          timestamp:(double)timestamp;

- (instancetype)initMessageWithUUID:(NSString*)messageUUID
                        messageBody:(NSString*)messageBody
                     messageSubType:(NSString*)messageSubType
                         fromUserID:(NSString*)fromUserID
                       fromUserType:(NSString*)fromUserType
                           toUserID:(NSString*)toUserID
                         toUserType:(NSString*)toUserType
                     conversationID:(NSString*)conversationID
                   conversationType:(NSString*)conversationType
                          timestamp:(double)timestamp;

- (PPApiMessage*)toApiMessage;

@end
