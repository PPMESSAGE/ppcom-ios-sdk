//
//  PPWebSocketPool.m
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPWebSocketPool.h"

#import "SRWebSocket.h"
#import "PPSDK.h"
#import "PPServiceUser.h"
#import "PPApp.h"

#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPLog.h"

static NSInteger const kPPSocketRocketMaxmiumTryReconnectLimit = 3;
static NSInteger const kPPSocketRocketDelayBetweenEachReconnect = 10; // after 10 seconds, we begin the next auto-reconnect task

/**
 *
 *
 */
@interface PPWebSocketPool () <SRWebSocketDelegate>

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) NSMutableArray *socketPool;
@property (nonatomic) SRWebSocket *activeWebSocket;
@property (nonatomic) BOOL closed;

@property (nonatomic) BOOL inReconnecting;
@property (nonatomic) NSInteger currentTryReconnectCount;
@property (nonatomic) BOOL autoReconnectTaskInDispatching;

@end

@implementation PPWebSocketPool

- (instancetype)initWithPPSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
        self.socketPool = [NSMutableArray array];
        self.closed = NO;
        self.currentTryReconnectCount = 0;
        self.autoReconnectWhenLostConnect = YES;
        self.inReconnecting = NO;
        self.maxTryReconnectLimit = kPPSocketRocketMaxmiumTryReconnectLimit;
    }
    return self;
}

#pragma mark - behaviour

- (BOOL)send:(NSString *)messages {
    if (![self isOpen]) return NO;
    [self.activeWebSocket send:messages];
    return YES;
}

- (void)open {
    self.closed = NO;
    NSURL *url = [NSURL URLWithString:self.sdk.configuration.webSockeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    webSocket.delegate = self;
    self.activeWebSocket = webSocket;
    [self.socketPool addObject:webSocket];
    [webSocket open];
    [self onSocketConnecting:webSocket];
    [self snapshot];
}

- (void)close {
    self.closed = YES;
    if (self.activeWebSocket) {
        if (self.activeWebSocket.readyState == SR_OPEN) {
            [self.activeWebSocket close];
        }
        [self.socketPool removeObject:self.activeWebSocket];
        self.activeWebSocket = nil;
    }
    [self snapshot];
}

- (BOOL)isOpen {
    return !self.closed && self.activeWebSocket && self.activeWebSocket.readyState == SR_OPEN;
}

#pragma mark - reconnect

- (void)reconnect {
    if (self.inReconnecting) return;
    [self resetAutoReconnectContext];
    [self tryReconnectWhenLossConnection];
}

- (void)tryReconnectWhenLossConnection {
    if (self.autoReconnectTaskInDispatching) {
        PPFastLog(@"Auto reconnect task in dispatching, cancel reconnect task");
        return;
    }
    
    if (![self canStartAutoReconnectTask]) {
        return;
    }
    
    self.autoReconnectTaskInDispatching = YES;
    
    [self onSocketConnecting:nil];
    
    // after `kPPSocketRocketDelayBetweenEachReconnect` we startup the auto reconnect task
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, kPPSocketRocketDelayBetweenEachReconnect * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        self.autoReconnectTaskInDispatching = NO;
        [self autoReconnectTask];
        
    });
    
}

- (void)autoReconnectTask {
    
    if ([self canStartAutoReconnectTask]) {
        self.currentTryReconnectCount += 1;
        PPFastLog(@"try %ldth reconnect", self.currentTryReconnectCount);
        [self open];
    }
    
}

- (BOOL)canStartAutoReconnectTask {
    BOOL canStart = NO;
    
    if (!self.autoReconnectWhenLostConnect) {
        PPFastLog(@"Not allowed auto reconnect when lost connection, cancel reconnect task");
    } else if (self.closed) {
        PPFastLog(@"Self closed, cancel reconnect task");
    } else if ([self isOpen]) {
        PPFastLog(@"Self has opened, cancel reconnect task");
    } else if (self.currentTryReconnectCount >= self.maxTryReconnectLimit) {
        PPFastLog(@"try reconnect count has limited to %ld, cancel reconnect task", self.maxTryReconnectLimit);
    } else {
        canStart = YES;
    }
    
    self.inReconnecting = canStart;
    if (!self.inReconnecting) {
        [self resetAutoReconnectContext];
    }
    
    return canStart;
}

- (void)resetAutoReconnectContext {
    self.currentTryReconnectCount = 0;
}

#pragma mark - webSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    PPFastLog(@"webSocketDidOpen");
    [self authWithWebSocket:webSocket];
    
    if (self.webSocketPoolDelegate && [self.webSocketPoolDelegate respondsToSelector:@selector(didSocketOpened:)]) {
        [self.webSocketPoolDelegate didSocketOpened:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    PPFastLog(@"webSocket didCloseWithCode:%@ reason:%@ wasClean:%@", @(code), reason, @(wasClean));
    
    if (self.webSocketPoolDelegate && [self.webSocketPoolDelegate respondsToSelector:@selector(didSocketClosed:)]) {
        [self.webSocketPoolDelegate didSocketClosed:self];
    }

    [self onSocketClosed:webSocket];
    [self tryReconnectWhenLossConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    PPFastLog(@"webSocket didReceiveMessage:%@", message);
    
    if ([message isKindOfClass:[NSString class]]) {
        if ([self handleAuthMessage:message]) {
            if (self.webSocketPoolDelegate && [self.webSocketPoolDelegate respondsToSelector:@selector(didSocketAuthed:)]) {
                [self.webSocketPoolDelegate didSocketAuthed:self];
            }
        } else {
            if (self.webSocketPoolDelegate) {
                [self.webSocketPoolDelegate didMessageArrived:self message:message];
            }
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    PPFastLog(@"webSocket didFailWithError:%@", error);
    if (self.webSocketPoolDelegate && [self.webSocketPoolDelegate respondsToSelector:@selector(didSocketClosed:)]) {
        [self.webSocketPoolDelegate didSocketClosed:self];
    }
    [self onSocketClosed:webSocket];

    // if network is down, don't waste time in reconnecting socket.
    if (error.code == 50) {
        PPFastLog(@"Network is down, stop reconnecting socket");
        return;
    }

    [self tryReconnectWhenLossConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    PPFastLog(@"webSocket didReceivePong:%@", pongPayload);
}

#pragma mark - helpers

- (void)authWithWebSocket:(SRWebSocket*)webSocket {
    PPServiceUser *user = self.sdk.user;
    PPApp *app = self.sdk.app;
    if (!user || !user.accessToken || !user.userUuid || !user.mobileDeviceUuid) {
        PPFastLog(@"authWithWebSocket illegal user:%@", user);
        [self onSocketClosed:webSocket];
        return;
    }
    if (!app || !app.appUuid) {
        PPFastLog(@"authWithWebSocket illegal app:%@", app);
        [self onSocketClosed:webSocket];
        return;
    }
    NSDictionary *params = @{ @"type": @"auth",
                              @"api_token": user.accessToken,
                              @"app_uuid": app.appUuid,
                              @"user_uuid": user.userUuid,
                              @"device_uuid": user.mobileDeviceUuid,
                              @"is_service_user": @YES };
    NSString *jsonString = PPDictionaryToJsonString(params);
    [webSocket send:jsonString];
}

- (BOOL)handleAuthMessage:(NSString*)message {
    NSDictionary *messageBody = PPJSONStringToDictionary(message);
    if (messageBody[@"what"] && [messageBody[@"what"] isEqualToString:@"AUTH"]) {
        return YES;
    }
    return NO;
}

- (void)onSocketClosed:(SRWebSocket*)webSocket {
    if (self.activeWebSocket == webSocket) {
        self.activeWebSocket = nil;
    }
    [self.socketPool removeObject:webSocket];
}

- (void)onSocketConnecting:(SRWebSocket*)webSocket {
    if (self.webSocketPoolDelegate && [self.webSocketPoolDelegate respondsToSelector:@selector(didSocketConnecting:)]) {
        [self.webSocketPoolDelegate didSocketConnecting:self];
    }
}

- (void)snapshot {
    PPFastLog(@"");
    PPFastLog(@"==========WEBSOCKET==========");
    PPFastLog(@"websocket counts:%@", @(self.socketPool.count));
    PPFastLog(@"==========WEBSOCKET==========");
    PPFastLog(@"");
}

@end
