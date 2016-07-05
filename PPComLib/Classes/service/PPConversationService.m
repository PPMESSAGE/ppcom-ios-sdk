//
//  PPConversationService.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPConversationService.h"
#import "PPGetConversationFromHTTP.h"
#import "PPGetConversationsFromHTTP.h"

@interface PPConversationService ()

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) NSMutableArray *conversations;

@end

@implementation PPConversationService

- (instancetype) initWithPPSDK:(PPSDK*)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)getConversationsWithBlock:(PPConversationServiceGetListBlock)aBlock {
    if (self.conversations) {
        if (aBlock) aBlock([self sortedConversations]);
        return;
    }

    PPGetConversationsFromHTTP *model = [[PPGetConversationsFromHTTP alloc] initWithPPSDK:self.sdk];
    [model getConversationsWithBlock:^(NSMutableArray* conversationArray){
        self.conversations = conversationArray;
        if (aBlock) aBlock([self sortedConversations]);
    }];
}

- (NSMutableArray*)sortedConversations {
    if (self.conversations) {
        [self.conversations sortUsingComparator:^NSComparisonResult(PPConversationItem *obj1, PPConversationItem *obj2) {
            return obj1.updateTimestamp - obj2.updateTimestamp;
        }];
        return self.conversations;
    }
    return nil;
}

- (void)addConversation:(PPConversationItem*)conversation {
    PPConversationItem *oldConversation = [self findConversationWithUUID:conversation.uuid];
    if (oldConversation) {
        // TODO: update this conversation
        NSUInteger index = [self.conversations indexOfObject:oldConversation];
        [self.conversations replaceObjectAtIndex:index withObject:conversation];
        return;
    }
    [self.conversations addObject:conversation];
    
}

- (void)addConversations:(NSMutableArray*)conversations {
    [conversations enumerateObjectsUsingBlock:^(PPConversationItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addConversation:obj];
    }];
}

- (void)findConversationWithUUID:(NSString*)conversationUUID withBlock:(PPConversationServiceFindConversationBlock)aBlock {
    PPConversationItem *conversation = [self findConversationWithUUID:conversationUUID];
    if (conversation) {
        if (aBlock) aBlock(conversation);
        return;
    }
    
    PPGetConversationFromHTTP *model = [[PPGetConversationFromHTTP alloc] initWithPPSDK:self.sdk];
    [model getConversation:conversationUUID withBlock:^(PPConversationItem * conversation){
        if (aBlock) aBlock(conversation);
    }];
}

- (PPConversationItem*) findConversationWithUUID:(NSString *)conversationUUID {
    __block PPConversationItem *target = nil;
    [self.conversations enumerateObjectsUsingBlock:^(PPConversationItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.uuid == conversationUUID) {
            target = obj;
            *stop = YES;
        }
    }];
    return target;
}

@end
