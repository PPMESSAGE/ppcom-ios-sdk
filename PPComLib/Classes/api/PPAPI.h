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

/**
 * 登陆成功，`sdk.api` 和 `sdk.user` 都将会根据返回结果进行初始化
 */
- (void)login:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

/**
 * @params {
 *     from_uuid
 *     device_uuid
 *     session_uuid
 * }
 */
- (void)logout:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

/**
 * @params {
 *     page_offset: 0 ~ +Infinity,
 *     page_size: 0 ~ +Infinity,
 *     user_uuid: xxx,
 *     app_uuid: xxx
 * }
 */
- (void)getConversationList:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

/**
 * 得到所有客服人员列表
 * @param params: {
 *     app_uuid
 * }
 */
- (void)getServiceUserList:(NSDictionary*)params completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler;

- (void)getMessageHistory:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)ackMessage:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

- (void)getUnackedMessages:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler;

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
