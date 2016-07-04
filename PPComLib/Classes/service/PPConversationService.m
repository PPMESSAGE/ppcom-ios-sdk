//
//  PPConversationService.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPConversationService.h"
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
        if (aBlock) {
            aBlock(self.conversations);
        }
        return;
    }
    
    PPGetConversationsFromHTTP *getConverationsFromHttp = [[PPGetConversationsFromHTTP alloc] initWithPPSDK:self.sdk];

    [getConverationsFromHttp getConversationsWithBlock:^(NSMutableArray* conversationArray){
        self.conversations = conversationArray;
        if (aBlock) {
            aBlock(conversationArray);
        }
    }];
}

- (NSMutableArray*)sortedConversations {
    if (self.conversations) {
        //[self.conversations sortUsingComparator:{}];
    }
    return nil;
}


@end
