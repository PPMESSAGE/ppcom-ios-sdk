//
//  PPMessageStore.h
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import <Foundation/Foundation.h>
#import "PPMessage.h"

@class PPSDK, PPMessage;

@interface PPMessagesStore : NSObject

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) NSMutableDictionary *messages;

+ (instancetype)storeWithClient:(PPSDK*)client;

- (NSMutableArray*)messagesInCovnersation:(NSString*)conversationUUID;

- (NSMutableArray*)messagesInCovnersation:(NSString *)conversationUUID autoCreate:(BOOL)autoCreate;

- (void)setMessageList:(NSMutableArray*)messageList forConversation:(NSString*)conversationUUID;

- (BOOL)updateWithNewMessage:(PPMessage*)message;

- (void)updateMessageStatus:(PPMessageStatus)status messageIndentifier:(NSString *)identifier conversationUUID:(NSString *)conversationUUID;

- (void)insertAtHeadWithMessages:(NSMutableArray*)messages;

@end
