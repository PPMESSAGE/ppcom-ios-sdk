//
//  PPApiMessage.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPApiMessage.h"

@implementation PPApiMessage

- (instancetype)initWithMessageUUID:(NSString *)messageUUID
                        messageBody:(NSString *)messageBody
                        messageType:(NSString *)messageType
                     messageSubType:(NSString *)messageSubType
                   conversationUUID:(NSString *)conversationUUID
                   conversationType:(NSString *)conversationType
                             toUUID:(NSString *)toUUID
                             toType:(NSString *)toType
                           fromUUID:(NSString *)fromUUID
                           fromType:(NSString *)fromType
                            appUUID:(NSString *)appUUID
                         deviceUUID:(NSString *)deviceUUID {
    if (self = [super init]) {
        self.messageUUID = messageUUID;
        self.messageBody = messageBody;
        self.messageType = messageType;
        self.messageSubType = messageSubType;
        self.conversationUUID = conversationUUID;
        self.conversationType = conversationType;
        self.toUUID = toUUID;
        self.toType = toType;
        self.fromUUID = fromUUID;
        self.fromType = fromType;
        self.appUUID = appUUID;
        self.deviceUUID = deviceUUID;
    }
    return self;
}

- (NSDictionary*)toDictionary {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"conversation_uuid"] = self.conversationUUID;
    dictionary[@"conversation_type"] = self.conversationType;
    dictionary[@"to_uuid"] = self.toUUID;
    dictionary[@"to_type"] = self.toType;
    dictionary[@"from_uuid"] = self.fromUUID;
    dictionary[@"from_type"] = self.fromType;
    dictionary[@"uuid"] = self.messageUUID;
    dictionary[@"message_type"] = self.messageType;
    dictionary[@"message_subtype"] = self.messageSubType;
    dictionary[@"message_body"] = self.messageBody;
    dictionary[@"app_uuid"] = self.appUUID;
    dictionary[@"device_uuid"] = self.deviceUUID;

    dictionary[@"is_service_user"] = @NO;
    dictionary[@"is_app_message"] = @YES;
    dictionary[@"is_browser_message"] = @NO;
    
    return dictionary;

}

@end
