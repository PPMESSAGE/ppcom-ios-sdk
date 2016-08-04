//
//  PPMessage.m
//  PPMessage
//
//  Created by PPMessage on 2/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessage.h"

#import "PPUser.h"
#import "PPSDK.h"
#import "PPServiceUser.h"
#import "PPApiMessage.h"

#import "PPSDKUtils.h"
#import "PPLog.h"
#import "PPMessageUtils.h"

#import "PPMessageTxtMediaPart.h"
#import "PPMessageFileMediaPart.h"
#import "PPMessageImageMediaPart.h"
#import "PPMessageAudioMediaPart.h"

#import "PPConversationItem.h"

NSString *const PPMessageSubTypeText = @"TEXT";
NSString *const PPMessageSubTypeTxt = @"TXT";
NSString *const PPMessageSubTypeFile = @"FILE";
NSString *const PPMessageSubTypeImage = @"IMAGE";
NSString *const PPMessageSubTypeAudio = @"AUDIO";

@interface PPMessage ()

- (PPMessageDirection)pp_messageDirectionWithFromUserUUID:(NSString*)userUUID;

@end

@implementation PPMessage

+ (PPMessage*)messageWithDictionary:(NSDictionary*)messageDict {
    NSString *uuid = [messageDict objectForKey:@"id"];
    NSString *body = [messageDict objectForKey:@"bo"];
    NSString *fromUserUUID = [messageDict objectForKey:@"fi"];
    NSString *fromUserType = [messageDict objectForKey:@"ft"];
    NSString *toUserUUID = [messageDict objectForKey:@"ti"];
    NSString *toUserType = [messageDict objectForKey:@"tt"];
    NSString *pushId = [messageDict objectForKey:@"pid"];
    double timestamp = [[messageDict objectForKey:@"ts" ] doubleValue];
    timestamp = PPFixTimestamp(timestamp);
    NSString *apiType = [messageDict objectForKey:@"ms"];
    NSString *conversationUUID = [messageDict objectForKey:@"ci"];
    NSString *conversationType = [messageDict objectForKey:@"ct"];
    PPUser *fromUser = nil;
    if ([messageDict objectForKey:@"from_user"]) {
        fromUser = [PPUser userWithDictionary:messageDict[@"from_user"]];
    }
    
    PPMessage *message = [[PPMessage alloc] initMessageWithUUID:uuid messageBody:body messageSubType:apiType fromUserID:fromUserUUID fromUserType:fromUserType toUserID:toUserUUID toUserType:toUserType conversationID:conversationUUID conversationType:conversationType timestamp:timestamp];
    message.pushID = pushId;
    if (fromUser) {
        message.fromUser = fromUser;
    }
    
    return message;
}

+ (PPMessage*)messageForSend:(NSString *)messageUUID
                        text:(NSString *)text
            conversationUUID:(NSString *)conversationUUID
            conversationType:(NSString *)conversationType {
    
    PPConversationItem *conversation = [PPConversationItem new];
    conversation.uuid = conversationUUID;
    conversation.conversationType = conversationType;
    
    return [PPMessage messageForSend:messageUUID text:text conversation:conversation];
}

+ (PPMessage*)messageForSend:(NSString *)messageUUID
                        text:(NSString *)text
                conversation:(PPConversationItem *)conversation {
    id<PPMessageMediaPart> mediaPart = nil;
    if (PPIsLargeTxtMessage(text)) {
        mediaPart = [PPMessageTxtMediaPart new];
        PPMessageTxtMediaPart *txtMediaPart = (PPMessageTxtMediaPart*)mediaPart;
        txtMediaPart.txtContent = text;
    }
    return [PPMessage messageForSend:messageUUID text:text conversation:conversation mediaPart:mediaPart];
}

+ (PPMessage*)messageForSend:(NSString *)messageUUID
                        text:(NSString *)text
                conversation:(PPConversationItem *)conversation
                   mediaPart:(id<PPMessageMediaPart>)mediaPart {
    PPMessage *message = [PPMessage new];
    
    message.identifier = messageUUID;
    message.direction = PPMessageDirectionOutgoing;
    message.timestamp = PPCurrentTimestamp();
    message.apiType = [self detectApiTypeForText:text forMediaPart:mediaPart];
    message.type = [self pp_typeFromApiMessageSubType:message.apiType];
    message.body = text;
    message.mediaPart = mediaPart;
    
    message.conversationUUID = conversation.uuid;
    message.conversationType = conversation.conversationType;
    
    PPUser *toUser = [[PPUser alloc] initWithUuid:conversation.uuid];
    toUser.userType = @"DU";
    message.toUser = toUser;
    
    // Make a copy here
    PPUser *currentUser = [PPSDK sharedSDK].user;
    message.fromUser = [[PPUser alloc]initWithUuid:currentUser.userUuid];
    message.fromUser.userType = @"DU";
    message.fromUser.userName = currentUser.userName;
    message.fromUser.userIcon = currentUser.userIcon;
    message.fromUser.userEmail = currentUser.userEmail;
    
    return message;
}

+ (NSString*)summaryInMessage:(PPMessage*)message {
    switch (message.type) {
        case PPMessageTypeText:
            return message.body;
            
        case PPMessageTypeImage:
            return PPLocalizedString(@"Image Msg Summary");
            
        case PPMessageTypeFile:
            return PPLocalizedString(@"File Msg Summary");
            
        case PPMessageTypeUnknown:
            return PPLocalizedString(@"Unknown Msg Summary");
            
        case PPMessageTypeAudio:
            return PPLocalizedString(@"Audio Msg Summary");
            
        default:
            return @" ";
    }
}

- (instancetype)initMessageWithUUID:(NSString *)messageUUID
                        messageBody:(NSString *)messageBody
                     messageSubType:(NSString *)messageSubType
                           fromUser:(PPUser *)fromUser
                             toUser:(PPUser *)toUser
                   conversationItem:(PPConversationItem *)conversationItem
                          timestamp:(double)timestamp {
    if (self = [super init]) {
        _identifier = messageUUID;
        _apiType = messageSubType;
        _type = [PPMessage pp_typeFromApiMessageSubType:messageSubType];
        _timestamp = timestamp;
        _body = messageBody;
        _fromUser = fromUser;
        _toUser = toUser;
        _conversationUUID = conversationItem.uuid;
        _conversationType = conversationItem.conversationType;
        
        if (_fromUser) {
            _direction = [self pp_messageDirectionWithFromUserUUID:_fromUser.userUuid];
        }
        
        id<PPMessageMediaPart> mediaPart = nil;
        
            switch (_type) {
                case PPMessageTypeTxt:
                    mediaPart = [PPMessageTxtMediaPart mediaPartWithJSONString:messageBody];
                    break;
        
                case PPMessageTypeFile:
                    mediaPart = [PPMessageFileMediaPart mediaPartWithJSONString:messageBody];
                    break;
        
                case PPMessageTypeImage:
                    mediaPart = [PPMessageImageMediaPart mediaPartWithJSONString:messageBody];
                    break;
                    
                case PPMessageTypeAudio:
                    mediaPart = [PPMessageAudioMediaPart mediaPartWithJSONString:messageBody];
                    break;
                    
                default:
                    break;
            }
        
        _mediaPart = mediaPart;
        
    }
    return self;
}

- (instancetype)initMessageWithUUID:(NSString *)messageUUID
                        messageBody:(NSString *)messageBody
                     messageSubType:(NSString *)messageSubType
                         fromUserID:(NSString *)fromUserID
                       fromUserType:(NSString *)fromUserType
                           toUserID:(NSString *)toUserID
                         toUserType:(NSString *)toUserType
                     conversationID:(NSString *)conversationID
                   conversationType:(NSString *)conversationType
                          timestamp:(double)timestamp {
    PPUser *fromUser = [[PPUser alloc]initWithUuid:fromUserID];
    fromUser.userType = fromUserType;
    
    PPUser *toUser = [[PPUser alloc]initWithUuid:toUserID];
    toUser.userType = toUserType;
    
    PPConversationItem *conversation = [[PPConversationItem alloc]init];
    conversation.uuid = conversationID;
    conversation.conversationType = conversationType;
    
    return [self initMessageWithUUID:messageUUID messageBody:messageBody messageSubType:messageSubType fromUser:fromUser toUser:toUser conversationItem:conversation timestamp:timestamp];
}

- (PPApiMessage*)toApiMessage {
    
    NSString *body = self.body;
    if (self.mediaPart) {
        body = [self.mediaPart toJSONString];
    }
    
    PPApiMessage *apiMessage = [[PPApiMessage alloc]initWithMessageUUID:self.identifier messageBody:body messageType:@"NOTI" messageSubType:self.apiType conversationUUID:self.conversationUUID conversationType:self.conversationType toUUID:self.toUser.userUuid toType:self.toUser.userType fromUUID:self.fromUser.userUuid fromType:self.fromUser.userType appUUID:[PPSDK sharedSDK].app.appUuid deviceUUID:self.fromUser.mobileDeviceUuid];
    return apiMessage;
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"<%p, %@, %@>",
            self,
            self.class,
            @{@"body": self.body ? self.body : @"",
              @"uuid": self.identifier ? self.identifier : @"",
              @"type": [NSNumber numberWithInteger:self.type],
              @"timestamp": [NSNumber numberWithDouble:self.timestamp],
              @"direction": [NSNumber numberWithInteger:self.direction],
              @"conversationID": self.conversationUUID ? self.conversationUUID : @"<nil>",
              @"from_user": self.fromUser ? self.fromUser : @"<nil>",
              @"show_timestamp": @(self.showTimestamp)}];
}

#pragma mark -setter getter

- (void)setFromUser:(PPUser *)fromUser {
    _fromUser = fromUser;
    if (_fromUser && _fromUser.userUuid) {
        self.direction = [self pp_messageDirectionWithFromUserUUID:_fromUser.userUuid];
    }
}

#pragma mark - Helpers

+ (PPMessageType)pp_typeFromApiMessageSubType:(NSString *)msgSubType {
    if ([msgSubType isEqualToString:PPMessageSubTypeText]) {
        return PPMessageTypeText;
    }
    
    if ([msgSubType isEqualToString:PPMessageSubTypeTxt]) {
        return PPMessageTypeTxt;
    }
    
    if ([msgSubType isEqualToString:PPMessageSubTypeImage]) {
        return PPMessageTypeImage;
    }
    
    if ([msgSubType isEqualToString:PPMessageSubTypeFile]) {
        return PPMessageTypeFile;
    }
    
    if ([msgSubType isEqualToString:PPMessageSubTypeAudio]) {
        return PPMessageTypeAudio;
    }
    
    return PPMessageTypeUnknown;
}

+ (NSString*)detectApiTypeForText:(NSString*)text
                     forMediaPart:(id<PPMessageMediaPart>)mediaPart {
    if (text) {
        if (PPIsLargeTxtMessage(text)) {
            return PPMessageSubTypeTxt;
        }
        return PPMessageSubTypeText;
    } else {
        if ([mediaPart isKindOfClass:[PPMessageImageMediaPart class]]) {
            return PPMessageSubTypeImage;
        }
        if ([mediaPart isKindOfClass:[PPMessageAudioMediaPart class]]) {
            return PPMessageSubTypeAudio;
        }
        if ([mediaPart isKindOfClass:[PPMessageFileMediaPart class]]) {
            return PPMessageSubTypeFile;
        }
    }
    return PPMessageSubTypeText;
}

- (PPMessageDirection)pp_messageDirectionWithFromUserUUID:(NSString *)userUUID {
    NSString *selfUserUUID = [PPSDK sharedSDK].user.userUuid;
    BOOL equal = [selfUserUUID isEqualToString:userUUID];
    if (equal) {
        return PPMessageDirectionOutgoing;
    } else {
        return PPMessageDirectionIncoming;
    }
}

#pragma mark -

- (NSUInteger)hash {
    return [self.identifier hash];
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[PPMessage class]]) return NO;
    
    PPMessage *other = object;
    return [other.identifier isEqualToString:self.identifier];
}

@end
