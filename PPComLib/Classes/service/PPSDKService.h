//
//  PPSDKService.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

#import "PPSDKService.h"
#import "PPConversationService.h"

#import "PPSDK.h"

@interface PPSDKService : NSObject

@property (nonatomic) PPConversationService* conversationService;

- (instancetype)initWithPPSDK:(PPSDK*)sdk;

@end
