//
//  PPFetchUnackedMessagesJob.m
//  PPMessage
//
//  Created by PPMessage on 3/10/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPFetchUnackedMessagesTask.h"

#import "PPSDK.h"
#import "PPServiceUser.h"
#import "PPAPI.h"
#import "PPWebSocketPool.h"

#import "PPSDKUtils.h"
#import "PPLog.h"
#import "PPMessageUtils.h"

#import "PPGetUserDetailInfoHttpModel.h"
#import "PPPageUnackedMessageHttpModel.h"

#import "PPStoreManager.h"
#import "PPUsersStore.h"

static const NSTimeInterval PPGetUnackedMessageDelayTime = 0.5;

@interface PPFetchUnackedMessagesTask ()

@property BOOL cancelled;
@property BOOL noMoreUnackedMessage;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSMutableArray *unackedMessagesArray;

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) PPUsersStore *usersStore;

@end

@implementation PPFetchUnackedMessagesTask

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
        self.cancelled = NO;
        self.noMoreUnackedMessage = NO;
    }
    return self;
}

- (void)run {
    [self receiveUnackedMessages];
}

- (void)cancel {
    self.cancelled = YES;
    self.noMoreUnackedMessage = NO;
    [self stopTimer];
}

#pragma mark - NSTimer Event

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:PPGetUnackedMessageDelayTime
                                                  target:self
                                                selector:@selector(messageArrived:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)stopTimer {
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
    }
}

// ======================================
// Get unacked messages, Parse messages
// ======================================

- (void)receiveUnackedMessages {
    
    PPPageUnackedMessageHttpModel *pageUnackedMessageHttpModel = [[PPPageUnackedMessageHttpModel alloc] initWithSDK:self.sdk];
    [pageUnackedMessageHttpModel pageUnackeMessageWithBlock:^(id obj, NSDictionary *response, NSError *error) {

        self.unackedMessagesArray = obj ? obj : @[];
        PPFastLog(@"[PPFetchUnackedMessagesTask] receive %@ unacked messages", @(self.unackedMessagesArray.count));

        if (self.unackedMessagesArray.count == 0) {
            self.noMoreUnackedMessage = YES;
            return;
        }

        self.noMoreUnackedMessage = NO;
        [self startTimer];
    }];
}

- (void)addFromUserForMessageDictionary:(NSMutableDictionary*)msgContainer
                              completed:(void (^)(NSMutableDictionary *msg))completed {
    
    NSString *userUUID = msgContainer[@"msg"][@"fi"];
    [self.usersStore findWithUserUUID:userUUID withBlock:^(PPUser *user) {
        if (user) {
            // Build a from_user dictionary
            NSMutableDictionary *fromUserDictionary = [NSMutableDictionary dictionary];
            fromUserDictionary[@"user_fullname"] = user.userName;
            fromUserDictionary[@"uuid"] = user.userUuid;
            fromUserDictionary[@"user_email"] = user.userEmail;
            fromUserDictionary[@"user_icon"] = user.userIcon;
            msgContainer[@"msg"][@"from_user"] = fromUserDictionary;
        } else {
            PPFastLog(@"[PPFetchUnackedMessagesTask] Cannot find user %@ in message %@", userUUID, msgContainer[@"msg"]);
        }
        if (completed) completed(msgContainer);
    }];
}

- (void)messageArrived:(id)userInfo {
    if (self.cancelled || !self.unackedMessagesArray || self.unackedMessagesArray.count == 0) {
        [self stopTimer];

        // re-run
        if (!self.cancelled && !self.noMoreUnackedMessage) {
            [self receiveUnackedMessages];
        }
        return;
    }
    
    NSMutableDictionary *msg = [self.unackedMessagesArray firstObject];
    [self.unackedMessagesArray removeObjectAtIndex:0];

    __weak PPFetchUnackedMessagesTask *wself = self;
    [self addFromUserForMessageDictionary:msg completed:^(NSMutableDictionary *msg) {
        [wself simulateArrivedWebSocketMessage:msg];
    }];
}

- (void)simulateArrivedWebSocketMessage:(NSMutableDictionary*)msg {
    PPWebSocketPool *webSocket = [PPSDK sharedSDK].webSocket;
    id<PPWebSocketPoolDelegate> webSocketDelegate = webSocket.webSocketPoolDelegate;
    if (webSocketDelegate) {
        [webSocketDelegate didMessageArrived:webSocket message:[self convertToWebSocketMessageWithMsg:msg]];
    }
}

- (NSString*)convertToWebSocketMessageWithMsg:(NSMutableDictionary*)msg {
    return PPDictionaryToJsonString(msg);
}

// =======================
// Getter
// =======================
- (PPUsersStore*)usersStore {
    if (!_usersStore) {
        _usersStore = [PPStoreManager instanceWithClient:self.sdk].usersStore;
    }
    return _usersStore;
}

// =======================
// TEST DATA
// =======================

#pragma mark - Test Data {

- (NSDictionary*)buildUnackedMessages:(NSUInteger)count {
    
    NSDictionary *singleMessage = @{ @"ci":@"7f86ee70-3069-11e6-811e-02287b8c0ebf",
                                            @"ft":@"DU",
                                            @"tt":@"AP",
                                            @"bo":@"SDF",
                                            @"ts":@(1465714439.74822),
                                            @"mt":@"NOTI",
                                            @"tl":@"",
                                            @"ms":@"TEXT",
                                            @"ti":@"7f86ee70-3069-11e6-811e-02287b8c0ebf",
                                            @"fi":@"7d20ff2c-3069-11e6-8f02-02287b8c0ebf",
                                            @"id":@"24b338e2-6f95-486b-b1c5-28e3547c77d6",
                                            @"ct":@"P2S"
                                            };
    NSString *singleMessageString = PPDictionaryToJsonString(singleMessage);
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i < count; ++i) {
        [listArray addObject:PPRandomUUID()];
    }
    
    NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i=0; i < count; ++i) {
        [messageDictionary setObject:singleMessageString forKey:[listArray objectAtIndex:i]];
    }
    
    return @{
             @"error_code":@(0),
             @"error_string":@"success",
             @"list":listArray,
             @"message":messageDictionary,
             @"size":@(count),
             @"uri":@"/GET_UNACKED_MESSAGES"
             };
}

@end
