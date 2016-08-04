//
//  PPWebSocket.m
//  Pods
//
//  Created by Jin He on 8/2/16.
//
//

#import <SocketRocket/SRWebSocket.h>

#import "PPWebSocket.h"

#import "PPSDK.h"
#import "PPApp.h"
#import "PPLog.h"
#import "PPServiceUser.h"
#import "PPMessageUtils.h"

static const NSInteger kReconnectDelay = 10;
static const NSInteger kMaxReconnectTimes = 10;


@interface PPWebSocket () <SRWebSocketDelegate>

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) SRWebSocket *webSocket;
@property (nonatomic) NSInteger reconnectTimes;

@property (nonatomic) BOOL isReconnecting;
@property (nonatomic) BOOL shouldReconnect;
@property (nonatomic) BOOL isDispatchingReconnectTask;

@end

@implementation PPWebSocket

- (instancetype) initWithPPSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
        self.webSocket = nil;
        self.reconnectTimes = 0;
        self.isReconnecting = NO;
        self.shouldReconnect = YES;
        self.isDispatchingReconnectTask = NO;
    }
    return self;
}

#pragma mark - interface

- (BOOL) send:(NSString *)messages {
    if (![self isOpen]) return NO;
    [self.webSocket send:messages];
    return YES;
}

- (void) open {
    self.shouldReconnect = YES;

    // if not ready, absort opening
    if (![self isReadyToOpenSocket]) {
        PPFastWarn(@"--open-- not ready to open socket !");
        return;
    }
    
    [self openWebSocket];
}

- (void) close {
    self.shouldReconnect = NO;
    [self closeWebSocket];
}

- (void) reconnect {
    
    // if not ready, absort reconnecting
    if (![self isReadyToOpenSocket]) {
        PPFastWarn(@"--reconnect-- not ready to open socket");
        self.isReconnecting = NO;
        return;
    }
    
    // if shouldRecoonect is NO, cancel reconnecting
    if (!self.shouldReconnect) {
        self.isReconnecting = NO;
        return;
    }
    
    // if reconnectTimes exceed maxReconnectTimes, abort reconnecting
    if (self.reconnectTimes >= kMaxReconnectTimes) {
        self.isReconnecting = NO;
        return;
    }
    
    // if isReconnecting is NO, begin reconnecting,
    if (!self.isReconnecting) {
        self.isReconnecting = YES;
        self.reconnectTimes = 0;
    }
    
    // first reconnection should be launched immediately
    if (self.reconnectTimes == 0) {
        [self openWebSocket];
        self.reconnectTimes += 1;
        return;
    }
    
    // later reconnection should be dispatched after a delay, two tasks can't be dispatched at the same time
    if (!self.isDispatchingReconnectTask) {
        [self openWebSocketWithDelay];
        self.reconnectTimes += 1;
    }
}

- (BOOL) isOpen {
    return self.webSocket && self.webSocket.readyState == SR_OPEN;
}

#pragma mark - interface helpers

-(void) openWebSocket {
    
    NSURL *url = [NSURL URLWithString:self.sdk.configuration.webSockeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.webSocket.delegate = self;

    [self onSocketConnecting];
    [self.webSocket open];
}

-(void) closeWebSocket {
    
    if (self.webSocket && self.webSocket.readyState == SR_OPEN) {
        [self.webSocket close];
    }
    self.webSocket = nil;
}

- (void) openWebSocketWithDelay {
    
    self.isDispatchingReconnectTask = YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, kReconnectDelay * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    
        [self openWebSocket];
        self.isDispatchingReconnectTask = NO;
    });
}

#pragma mark - webSocket delegate

- (void) webSocketDidOpen:(SRWebSocket *)webSocket {
    PPFastLog(@"webSocketDidOpen");
    
    [self onSocketOpen];
}

- (void) webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    PPFastLog(@"webSocket didCloseWithCode:%@ reason:%@ wasClean:%@", @(code), reason, @(wasClean));
    
    [self onSocketClose];
}

- (void) webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    PPFastLog(@"webSocket didFailWithError:%@", error);
    
    [self onSocketFailWithError:error];
}

- (void) webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    PPFastLog(@"webSocket didReceiveMessage:%@", message);
    
    [self onSocketReceiveMessage:(id)message];
}

- (void) webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    PPFastLog(@"webSocket didReceivePong:%@", pongPayload);
}

#pragma mark - webSocket event helpers

- (void) onSocketConnecting {
    
    if ([self.delegate respondsToSelector:@selector(didSocketConnecting:)]) {
        [self.delegate didSocketConnecting:self];
    }
}

- (void) onSocketOpen {
    
    if ([self.delegate respondsToSelector:@selector(didSocketOpened:)]) {
        [self.delegate didSocketOpened:self];
    }
    
    if (self.isReconnecting) {
        self.isReconnecting = NO;
    }
    
    [self sendAuthMessage];
}

- (void) onSocketClose {
    
    if ([self.delegate respondsToSelector:@selector(didSocketClosed:)]) {
        [self.delegate didSocketClosed:self];
    }
    
    [self reconnect];
}

- (void) onSocketFailWithError:(NSError*)error {
    
    if ([self.delegate respondsToSelector:@selector(didSocketFail:withError:)]) {
        [self.delegate didSocketFail:self withError:error];
    }
    
    // if network is down, don't waste time in reconnecting socket.
    if (error.code == 50) {
        PPFastLog(@"Network is down, stop reconnecting socket");
        self.isReconnecting = NO;
        return;
    }
    
    [self reconnect];
}

- (void) onSocketReceiveMessage:(id)message {

    if (![message isKindOfClass:[NSString class]]) {
        PPFastLog(@"webSocket receive a invalid message");
        return;
    }
    
    if ([self isAuthMessage:message]) {
        [self handleAuthMessage:message];
        return;
    }
    
    [self handleNornalMessage:message];
}

#pragma mark - webSocket message helpers

- (void) handleAuthMessage:(id)message {
    
    if ([self.delegate respondsToSelector:@selector(didSocketAuthed:)]) {
        [self.delegate didSocketAuthed:self];
    }
}

- (void) handleNornalMessage:(id)message {
    
    if ([self.delegate respondsToSelector:@selector(didMessageArrived:message:)]) {
        [self.delegate didMessageArrived:self message:message];
    }
}

- (void) sendAuthMessage {
    
    if (![self isReadyToSendAuthMessage]) {
        return;
    }
    
    PPApp *app = self.sdk.app;
    PPServiceUser *user = self.sdk.user;
    NSDictionary *params = @{ @"type": @"auth",
                              @"api_token": user.accessToken,
                              @"app_uuid": app.appUuid,
                              @"user_uuid": user.userUuid,
                              @"device_uuid": user.mobileDeviceUuid,
                              @"is_service_user": @YES };
    NSString *jsonString = PPDictionaryToJsonString(params);
    [self.webSocket send:jsonString];
}

- (BOOL) isAuthMessage:(NSString*)message {
    
    NSDictionary *messageBody = PPJSONStringToDictionary(message);
    
    if (messageBody[@"what"] && [messageBody[@"what"] isEqualToString:@"AUTH"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - other helpers

- (BOOL) isReadyToOpenSocket {
    
    return [self isUserAndAppReady];
}

- (BOOL) isReadyToSendAuthMessage {
    
    return [self isUserAndAppReady] && [self isOpen];
}

- (BOOL) isUserAndAppReady {

    PPApp *app = self.sdk.app;
    PPServiceUser *user = self.sdk.user;
    
    if (!user || !user.accessToken || !user.userUuid || !user.mobileDeviceUuid) {
        PPFastLog(@"authWithWebSocket illegal user:%@", user);
        return NO;
    }
    
    if (!app || !app.appUuid) {
        PPFastLog(@"authWithWebSocket illegal app:%@", app);
        return NO;
    }
    
    return YES;
}

@end
