//
//  PPAPI.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSDK.h"

typedef void (^PPAPICompletedBlock)(NSDictionary *response, NSDictionary *error);

typedef NS_ENUM(NSInteger, PPMessageCustomErrorCode) {
    PPMessageCustomErrorCodeHttpUnavaliable = 10000
};

@interface PPAPI : NSObject

@property (nonatomic) NSString *accessToken;

- (instancetype)initWithSDK:(PPSDK*)sdk;

// ------------
// API
// ------------

- (void)login:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)logout:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getConversationList:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getServiceUserList:(NSDictionary*)params completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler;

- (void)getMessageHistory:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)ackMessage:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)pageUnackedMessage:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)createConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)closeConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getDeviceUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)updateUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

// ======================
// PPCom API
// ======================

- (void)getPPComConversationList:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getWaitingQueueLength:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getPPComDefaultConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)createPPComConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getConversationUserList:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getConversationInfo:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getAppInfo:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)createAnonymousUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getUserUuid:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getPPComDeviceUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)createDevice:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)updateDevice:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

// =========================
// Get access token
// =========================

/**
 * @param params {
 *     user_email = ''
 *     user_password = ''
 * }
 */
- (void)getApiToken:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

// Get ppcom api token
- (void)getPPComApiTokenWithCompletionHandler:(PPAPICompletedBlock)completionHandler;

@end
