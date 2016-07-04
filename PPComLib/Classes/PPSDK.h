//
//  PPSDK.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPApp.h"
#import "PPSDKConfiguration.h"
#import "PPMessageSendProtocol.h"

// Notification: A new message arrived
FOUNDATION_EXPORT NSString *const PPSDKMessageArrived;

// Notification: Message send succeed
FOUNDATION_EXPORT NSString *const PPSDKMessageSendSucceed;

// Notification: Message send failed
FOUNDATION_EXPORT NSString *const PPSDKMessageSendFailed;

@class PPServiceUser;
@class PPAPI;
@class PPApp;
@class PPWebSocketPool;
@class PPSDKConfiguration;
@class PPSDKService;

@interface PPSDK : NSObject

@property (nonatomic) PPApp *app;
@property (nonatomic) PPAPI *api;
@property (nonatomic) PPWebSocketPool *webSocket;
@property (nonatomic) PPServiceUser *user;
@property (nonatomic) PPSDKService *sdkService;
@property (nonatomic) id<PPMessageSendProtocol> messageSender;

@property (nonatomic, readonly) PPSDKConfiguration* configuration;

+ (instancetype)sharedSDK;

- (void)configure:(PPSDKConfiguration*)configuration;
- (void)start;
- (void)reset;

// Call this method when the app enter foreground
- (void)applicationEnterForeground:(UIApplication *)application;

// Call this method when the app enter background
- (void)applicationEnterBackground:(UIApplication *)application;

@end