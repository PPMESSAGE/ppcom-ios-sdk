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

@interface PPMessagesStore ()

@property (nonatomic) NSMutableSet *messageUUIDArray;

@end

@implementation PPMessagesStore

+ (instancetype)storeWithClient:(PPSDK*)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.messageUUIDArray = [NSMutableSet set];
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
    [self.messageUUIDArray addObject:message.identifier];
    [[PPStoreManager instanceWithClient:self.sdk].conversationStore updateConversationsWithMessage:message];
    return YES;
}

- (void)updateMessageStatus:(PPMessageStatus)status messageIndentifier:(NSString *)identifier conversationUUID:(NSString *)conversationUUID {
    PPMessage *message = [self findMessageWithIndentifier:identifier conversationUUID:conversationUUID];
    if (message) {
        message.status = status;
    }
}

- (void)insertAtHeadWithMessages:(NSMutableArray*)messages {
    if (!messages || messages.count == 0) return;
    
    //Remove duplicate messages
    NSMutableArray *filterMessageArray = [[NSMutableArray alloc] init];
    for (PPMessage *message in messages) {
        if (![self isExistForMessage:message]) {
            [self.messageUUIDArray addObject:message.identifier];
            [filterMessageArray addObject:message];
        }
    }
    
    //Add messages at head
    NSString *conversationUUID = ((PPMessage*)messages[0]).conversationUUID;
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, filterMessageArray.count)];
    NSMutableArray *localMessages = [self messagesInCovnersation:conversationUUID autoCreate:YES];
    [localMessages insertObjects:filterMessageArray atIndexes:indexes];
    
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

- (BOOL)isExistForMessage:(PPMessage*)message {
    NSString *messageUUID = message.identifier;
    return [self.messageUUIDArray containsObject:messageUUID];
}

@end
