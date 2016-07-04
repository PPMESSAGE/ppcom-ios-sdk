//
//  PPApiMessage.h
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMessage;

@interface PPApiMessage : NSObject

@property (nonatomic) NSString *messageUUID;
@property (nonatomic) NSString *messageBody;
@property (nonatomic) NSString *messageType;
@property (nonatomic) NSString *messageSubType;
@property (nonatomic) NSString *conversationUUID;
@property (nonatomic) NSString *conversationType;
@property (nonatomic) NSString *toUUID;
@property (nonatomic) NSString *toType;
@property (nonatomic) NSString *fromUUID;
@property (nonatomic) NSString *fromType;
@property (nonatomic) NSString *appUUID;
@property (nonatomic) NSString *deviceUUID;

- (instancetype)initWithMessageUUID:(NSString*)messageUUID
                        messageBody:(NSString*)messageBody
                        messageType:(NSString*)messageType
                     messageSubType:(NSString*)messageSubType
                   conversationUUID:(NSString*)conversationUUID
                   conversationType:(NSString*)conversationType
                             toUUID:(NSString*)toUUID
                             toType:(NSString*)toType
                           fromUUID:(NSString*)fromUUID
                           fromType:(NSString*)fromType
                            appUUID:(NSString*)appUUID
                         deviceUUID:(NSString*)deviceUUID;

- (NSDictionary*)toDictionary;

@end
