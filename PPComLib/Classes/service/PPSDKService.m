//
//  PPSDKService.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPSDKService.h"

@implementation PPSDKService

- (instancetype)initWithPPSDK:(PPSDK*)sdk {
    if (self = [super init]) {
        self.conversationService = [[PPConversationService alloc] initWithPPSDK:sdk];
    }
    return self;
}

@end
