//
//  PPSDK.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPWebSocketPool.h"
#import "PPReceiver.h"
#import "PPSDKStartUpHelper.h"

// Notification: A new message arrived
NSString *const PPSDKMessageArrived = @"PPSDKMessageArrived";

// Notification: Message send succeed
NSString *const PPSDKMessageSendSucceed = @"PPSDKMessageSendSucceed";

// Notification: Message send failed
NSString *const PPSDKMessageSendFailed = @"PPSDKMessageSendFailed";

@interface PPSDK () <PPWebSocketPoolDelegate, PPSDKStartUpHelperDelegate>

@property (nonatomic, readwrite) PPSDKConfiguration* configuration;
@property (nonatomic) PPSDKStartUpHelper* startUpHelper;

@end

@implementation PPSDK

+ (instancetype)sharedSDK {
    static PPSDK *sharedSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSDK = [[self alloc] init];
    });
    return sharedSDK;
}

// ==============================
// Developer API
// ==============================

- (void)configure:(PPSDKConfiguration*)configuration {
    self.configuration = configuration;
}

- (void)start {
    [self.startUpHelper start];
}

- (void)reset {
    if (_webSocket) {
        [_webSocket close];
    }
    if (_user) {
        _user = nil;
    }
    if (_app) {
        _app = nil;
    }
}

// ==============================
// Getter
// ==============================

- (PPAPI*)api {
    if (!_api) {
        _api = [[PPAPI alloc] initWithSDK: self];
    }
    return _api;
}

- (PPWebSocketPool*)webSocket {
    if (!_webSocket) {
        _webSocket = [[PPWebSocketPool alloc] initWithPPSDK:self];
    }
    return _webSocket;
}

- (PPSDKStartUpHelper*)startUpHelper {
    if (!_startUpHelper) {
        _startUpHelper = [[PPSDKStartUpHelper alloc] initWithSDK:self];
        _startUpHelper.startUpDelegate = self;
    }
    return _startUpHelper;
}

// ==============================
// Application Lifecycle
// ==============================

- (void)applicationEnterForeground:(UIApplication *)application {
    
}

- (void)applicationEnterBackground:(UIApplication *)application {
    
}

// ==============================
// PPWebSocketPoolDelegate
// ==============================

- (void)didMessageArrived:(PPWebSocketPool *)webSocket message:(id)obj {
    [[PPReceiver sharedReceiver] handle:obj handleCompleted:nil];
}

// ==============================
// PPSDKStartUpHelperDelegate
// ==============================
- (void)didSDKStartUpSucceded:(PPSDKStartUpHelper*)startUpHelper {
    [self notifyStartUpSucceded];
}

- (void)didSDKStartUpFailed:(PPSDKStartUpHelper*)startUpHelper errorInfo:(id)errorInfo {
    [self notifyStartUpFailedWithErrorInfo:errorInfo];
}

// ==============================
// PPSDKDelegate
// ==============================
- (void)notifyStartUpSucceded {
    if (self.sdkDelegate) {
        if ([self.sdkDelegate respondsToSelector:@selector(didPPSDKStartUpSucceded:)]) {
            [self.sdkDelegate didPPSDKStartUpSucceded:self];
        }
    }
}

- (void)notifyStartUpFailedWithErrorInfo:(id)errorInfo {
    if (self.sdkDelegate) {
        if ([self.sdkDelegate respondsToSelector:@selector(didPPSDKStartUpFailed:errorInfo:)]) {
            [self.sdkDelegate didPPSDKStartUpFailed:self errorInfo:errorInfo];
        }
    }
}

// TODO: report websocket state

//- (void)didSocketOpened:(PPWebSocketPool *)webSocket {
//    if (self.webSocketStateChangeDelegate &&
//        [self.webSocketStateChangeDelegate respondsToSelector:@selector(didWebSocketStateChanged:)]) {
//        [self.webSocketStateChangeDelegate didWebSocketStateChanged:PPWebSocketStateOpen];
//    }
//    self.webSocketState = PPWebSocketStateOpen;
//    
//    [self fetchUnackedMessages];
//}
//
//- (void)didSocketMeetError:(PPWebSocketPool *)webSocket error:(NSError *)error {
//    if (self.webSocketStateChangeDelegate &&
//        [self.webSocketStateChangeDelegate respondsToSelector:@selector(didWebSocketStateChanged:)]) {
//        [self.webSocketStateChangeDelegate didWebSocketStateChanged:PPWebSocketStateClosed];
//    }
//    self.webSocketState = PPWebSocketStateClosed;
//}
//
//- (void)didSocketClosed:(PPWebSocketPool *)webSocket {
//    if (self.webSocketStateChangeDelegate &&
//        [self.webSocketStateChangeDelegate respondsToSelector:@selector(didWebSocketStateChanged:)]) {
//        [self.webSocketStateChangeDelegate didWebSocketStateChanged:PPWebSocketStateClosed];
//    }
//    self.webSocketState = PPWebSocketStateClosed;
//}
//
//- (void)didSocketConnecting:(PPWebSocketPool *)webSocket {
//    if (self.webSocketStateChangeDelegate &&
//        [self.webSocketStateChangeDelegate respondsToSelector:@selector(didWebSocketStateChanged:)]) {
//        [self.webSocketStateChangeDelegate didWebSocketStateChanged:PPWebSocketStateConnecting];
//    }
//    self.webSocketState = PPWebSocketStateConnecting;
//}

@end