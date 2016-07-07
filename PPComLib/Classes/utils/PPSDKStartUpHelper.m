//
//  PPSDKStartUpHelper.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPSDKStartUpHelper.h"
#import "PPGetAppInfoHttpModel.h"
#import "PPGetUserUUIDHttpModel.h"
#import "PPGetUserDetailInfoHttpModel.h"
#import "PPCreateDeviceHttpModel.h"
#import "PPUpdateDeviceHttpModel.h"
#import "PPCreateAnonymousUserHttpModel.h"

#import "PPWebSocketPool.h"
#import "PPSDKUtils.h"
#import "PPSDK.h"
#import "PPLog.h"

#import "PPAPI.h"
#import "PPServiceUser.h"

#define START_STATUS_INITIAL    @"initial"
#define START_STATUS_STARTING   @"starting"
#define START_STATUS_STARTED    @"started"

@interface PPSDKStartUpHelper ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPSDKStartUpHelper

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
        self.status = START_STATUS_INITIAL;
    }
    return self;
}

/*
*
* 1. get app info
* 2. for user with email, get user uuid, then get user info
* 3. for annoymous user, get/set track_id (annoymous user),
*    then create annoymous user (annoymous user)
* 4. create device
* 5. update device
* 6. connect websocket
* 7. callback
*
*/
- (void)start {
    [self onStartBegin];
    [self app:^{
        [self user:^{
            [self device:^{
                [self socket];
            }];
        }];
    }];
}

- (BOOL)starting {
    return [self.status isEqualToString:START_STATUS_STARTING];
}

- (BOOL)started {
    return [self.status isEqualToString:START_STATUS_STARTED];
}

// ========================
// Private
// ========================

- (BOOL)isEmailUser {
    return self.sdk.configuration.email != nil;
}

- (void)onStartBegin {
    self.status = START_STATUS_STARTING;
}

- (void)onStartSuccess {
    self.status = START_STATUS_STARTED;
    if (self.startUpDelegate && [self.startUpDelegate respondsToSelector:@selector(didSDKStartUpSucceded:)]) {
        [self.startUpDelegate didSDKStartUpSucceded:self];
    }
}

- (void)onStartFail:(NSError *)error {
    self.status = START_STATUS_STARTING;
    if (self.startUpDelegate && [self.startUpDelegate respondsToSelector:@selector(didSDKStartUpFailed:errorInfo:)]){
        [self.startUpDelegate didSDKStartUpFailed:self errorInfo:error];
    }
}

- (void)app:(PPNoArgBlock)block {
    PPGetAppInfoHttpModel *getAppInfoHttpModel = [[PPGetAppInfoHttpModel alloc] initWithSDK:self.sdk];
    [getAppInfoHttpModel getAppInfoWithBlock:^(id app, NSDictionary *response, NSError *error) {
        if (!app) {
            [self onStartFail:error];
            return;
        }
        self.sdk.app = app;
        if (block) block();
    }];
}


- (void)user:(PPNoArgBlock)block {
    if ([self isEmailUser]) {
        [self emailUser:block];
    } else {
        [self anonymousUser:block];
    }
}

- (void)anonymousUser:(PPNoArgBlock)block {
    PPCreateAnonymousUserHttpModel *createAnonymousUserHttpModel = [[PPCreateAnonymousUserHttpModel alloc] initWithSDK:self.sdk];
    [createAnonymousUserHttpModel createAnonymousUserWithTraceUUID:PPTraceUUID() withBlock:^(id user, NSDictionary *response, NSError *error) {
        if (!user) {
            [self onStartFail:error];
            return;
        }
        self.sdk.user = user;
        if (block) block();
    }];
}

- (void)emailUser:(PPNoArgBlock)block {
    PPGetUserUUIDHttpModel *getUserUUIDHttpModel = [[PPGetUserUUIDHttpModel alloc] initWithSDK:self.sdk];
    [getUserUUIDHttpModel getUserUUIDWithEmail:self.sdk.configuration.email withBlock:^(id userUUID, NSDictionary *response, NSError *error) {
        if (!userUUID) {
            [self onStartFail:error];
            return;
        }
        
        PPGetUserDetailInfoHttpModel *getUserDetailInfoModel = [[PPGetUserDetailInfoHttpModel alloc] initWithSDK:self.sdk];
        [getUserDetailInfoModel getUserDetailInfoWithUUID:userUUID withBlock:^(id user, NSDictionary *response, NSError *error) {
            if (!user) {
                [self onStartFail:error];
                return;
            }
            self.sdk.user = user;
            if (block) block();
        }];
    }];
}

- (void)device:(PPNoArgBlock)block {
    PPCreateDeviceHttpModel *createDeviceHttpModel = [[PPCreateDeviceHttpModel alloc] initWithSDK:self.sdk];
    [createDeviceHttpModel createDeviceWithMobileUniqueID:PPDeviceUUID() withBlock:^(id deviceUUID, NSDictionary *response, NSError *error) {
        if (!deviceUUID) {
            [self onStartFail:error];
            return;
        }
        
        // Update user's deviceUUID
        self.sdk.user.mobileDeviceUuid = deviceUUID;
        
        PPUpdateDeviceHttpModel *updateDeviceHttpModel = [[PPUpdateDeviceHttpModel alloc] initWithSDK:self.sdk];
        [updateDeviceHttpModel updateDeviceWithDeviceUUID:deviceUUID withOnline:YES withBlock:^(id success, NSDictionary *response, NSError *error) {
            if (!success) {
                [self onStartFail:error];
                return;
            }
            if (block) block();
        }];
    }];
}

- (void)socket {
    self.sdk.user.accessToken = self.sdk.api.accessToken;
    [self.sdk.webSocket open];
    [self onStartSuccess];
}

@end
