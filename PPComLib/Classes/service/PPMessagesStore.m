//
//  PPMessageStore.m
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import "PPMessagesStore.h"
#import "PPConversationsStore.h"
#import "PPStoreManager.h"
#import "PPMessage.h"
#import "PPSDK.h"

@implementation PPMessagesStore

+ (instancetype)storeWithClient:(PPSDK*)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.messages = [NSMutableDictionary dictionary];
        self.sdk = client;
    }
    return self;
}


- (NSMutableArray*)messagesInCovnersation:(NSString*)conversationUUID {
    return self.messages[conversationUUID];
}

- (NSMutableArray*)messagesInCovnersation:(NSString *)conversationUUID autoCreate:(BOOL)autoCreate {
    NSMutableArray *messages = self.messages[conversationUUID];
    if (!messages && autoCreate) {
        messages = [NSMutableArray new];
        self.messages[conversationUUID] = messages;
    }
    return messages;
}

- (void)setMessageList:(NSMutableArray*)messageList forConversation:(NSString*)conversationUUID {
    self.messages[conversationUUID] = messageList;
}

- (BOOL)updateWithNewMessage:(PPMessage*)message {
    if (!message || !message.conversationUUID) {
        return NO;
    }
    NSMutableArray *messages = [self messagesInCovnersation:message.conversationUUID autoCreate:YES];
    [messages addObject:message];
    [[PPStoreManager instanceWithClient:self.sdk].conversationStore updateConversationsWithMessage:message];
    return YES;
}

- (void)updateMessageStatus:(PPMessageStatus)status messageIndentifier:(NSString *)identifier conversationUUID:(NSString *)conversationUUID {
    PPMessage *message = [self findMessageWithIndentifier:identifier conversationUUID:conversationUUID];
    if (message) {
        message.status = status;
    }
}

// private

- (PPMessage*)findMessageWithIndentifier:(NSString *)indentifier conversationUUID:(NSString *)conversationUUID {
    NSMutableArray *messages = self.messages[conversationUUID];
    __block PPMessage *target = nil;
    [messages enumerateObjectsUsingBlock:^(PPMessage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:indentifier]) {
            target = obj;
            *stop = YES;
        }
    }];
    return target;
}

@end
