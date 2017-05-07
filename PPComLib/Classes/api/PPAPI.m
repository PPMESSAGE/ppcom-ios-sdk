//
//  PPAPI.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPAPI.h"
#import "PPSDKUtils.h"
#import "NSString+Crypto.h"
#import "AFNetworking.h"
#import "PPLog.h"

#import "PPApp.h"
#import "PPServiceUser.h"

#import "PPSDKConfiguration.h"

#define PPAPI_DEBUG_ENABLE 1

static NSString *const kPPHeaderTypePPKefu = @"PPKEFU";
static NSString *const kPPHeaderTypePPToken = @"PPTOKEN";
static NSString *const kPPHeaderTypePPEmpty = @"PPEMPTY";
static NSString *const kPPHeaderTypePPCom = @"PPCOM";

@interface PPAPI ()

@property (nonatomic) PPSDK *sdk;

//
// @param url: urlSegment
// @param params: url request params
// @param configure: {
//     ignoreApiError: YES/NO, default is NO
//     headerType: @"PPKEFU" / @"PPCOM" / @"EMPTY", default is @"PPKEFU"
// }
// configure can be `nil`
// @param completionHandler: response callback, error callback
//
- (void)baseRequest:(NSString*)url
                with:(NSDictionary*)params
                configuration:(NSDictionary*)configure
                completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler;

- (NSString*)getApiUrl:(NSString*)urlSegment params:(NSDictionary*)params;
- (NSDictionary*)getApiParams:(NSDictionary*)params url:(NSString*)url;
    
- (void)addHeaders:(NSMutableURLRequest *)request type:(NSString *)headerType;
- (NSString*)generateRequestUUID;
- (NSString*)signatureWith:(NSString *)requestUUID appSecret:(NSString *)appSecret;

@end

@implementation PPAPI

#pragma mark - Api request helpers

- (instancetype)initWithSDK:(PPSDK *)sdk {
    self = [super init];
    if (self) {
        self.sdk = sdk;
    }
    return self;
}

- (void)baseRequest:(NSString*)url with:(NSDictionary *)params configuration:(NSDictionary *)configure completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler {
    
    NSString *headerType = kPPHeaderTypePPKefu;
    if (configure) {
        headerType = configure[@"headerType"];
    }
    
    if (!params) {
        params = @{};
    }
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    AFJSONRequestSerializer* requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSString* requestUrl = [self getApiUrl:url params:params];
    NSDictionary* requestParams = [self getApiParams:params url:url];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST"
                                                              URLString:requestUrl
                                                             parameters:requestParams
                                                                  error:nil];
    
    [self addHeaders:request type:headerType];
    
    if (PPAPI_DEBUG_ENABLE) {
        PPFastLog(@"http request: url: %@, params: %@.", requestUrl, requestParams);
    }

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) {
            if (PPAPI_DEBUG_ENABLE) {
                PPFastLog(@"http response: url: %@, params: %@, response: %@.", requestUrl, requestParams, responseObject);
            }

            NSDictionary *result = (NSDictionary *)responseObject;
            if (result && result[@"error_code"] && [result[@"error_code"] integerValue] != 0) {
                PPFastWarn(@"[PPAPI] api request error: %@", result);
            }
            if (completionHandler) completionHandler(result, nil);
            
        } else {
            if (PPAPI_DEBUG_ENABLE) {
                PPFastLog(@"http response: url: %@, params: %@ error: %@.", requestUrl, requestParams, error.description);
            }
            
            if (completionHandler) {
                completionHandler(nil, [self getHttpUnavaliableInfoForError:error]);
            }
        }
        
    }];
    [dataTask resume];
    
}

- (void)basePPComRequest:(NSString*)url with:(NSDictionary *)params completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler {
    
    if (self.accessToken) {
        [self baseRequest:url with:params configuration:@{ @"headerType": kPPHeaderTypePPCom } completionHandler:completionHandler];
    } else {
        // Before make a http request, we make sure ppcom api access token is exist
        [self getPPComApiTokenWithCompletionHandler:^(NSDictionary *response, NSDictionary *error){
            // Store accessToken to memory
            if (!self.accessToken) {
                self.accessToken = response[@"access_token"];
            }
            // The make a http request again after we get the accesstoken
            [self baseRequest:url with:params configuration:@{ @"headerType": kPPHeaderTypePPCom } completionHandler:completionHandler];
        }];
    }
    
}

- (NSDictionary*)getHttpUnavaliableInfoForError:(NSError*)error {
    PPFastLog(@"http unavaliable info error:%@", error);
    return @{@"error_string": PPLocalizedString(@"Network Not Avaliable"), @"error_code": [NSNumber numberWithInteger:PPMessageCustomErrorCodeHttpUnavaliable]};
}


- (NSString*)getApiUrl:(NSString*)urlSegment params:(NSDictionary*)params {
    NSString* url = [NSString stringWithFormat: @"%@/ppquery/PP_QUERY", self.sdk.configuration.hostUrl];
    return url;
}

- (NSDictionary*)getApiParams:(NSDictionary*)params url:(NSString*)url {
    return @{@"api_url":url, @"api_data":params};
}

- (NSString*)getApiTokenUrl {
    return [NSString stringWithFormat:@"%@/token", self.sdk.configuration.authUrl];
}


- (void)addHeaders:(NSMutableURLRequest *)request type:(NSString *)headerType {
    if ([headerType isEqualToString:kPPHeaderTypePPEmpty]) {
        
        return;
        
    } else if ([headerType isEqualToString:kPPHeaderTypePPToken]) {
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        return;
        
    }

    NSString *accessToken = self.accessToken;
    
    if (!accessToken) {
        PPFastWarn(@"PPAPI addHeaders accessToken is nil");
        return;
    }
    
    // PPKefu or PPCom need access_token oauth in header
    if ([headerType isEqualToString:kPPHeaderTypePPKefu] ||
        [headerType isEqualToString:kPPHeaderTypePPCom]) {
        
        [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"OAuth %@", accessToken] forHTTPHeaderField:@"Authorization"];
        
    }
}

- (NSString*)generateRequestUUID {
    return PPRandomUUID();
}

- (NSString*)signatureWith:(NSString *)requestUUID appSecret:(NSString *)appSecret {
    NSString *sig = [appSecret stringByAppendingString:requestUUID];
    return [sig pp_SHA1String];
}

#pragma mark - API


- (void)getConversationList:(NSDictionary *)params completionHandler:(void (^)(NSDictionary *, NSDictionary *))completionHandler {
    [self baseRequest:@"/PP_PAGE_USER_CONVERSATION" with:params configuration:nil completionHandler:completionHandler];
}

- (void)getServiceUserList:(NSDictionary*)params completionHandler:(void (^)(NSDictionary *response, NSDictionary *error))completionHandler {
    [self baseRequest:@"/PP_GET_APP_SERVICE_USER_LIST" with:params configuration:nil completionHandler:completionHandler];
}

- (void)getMessageHistory:(NSDictionary *)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_PAGE_HISTORY_MESSAGE" with:params configuration:nil completionHandler:completionHandler];
}

- (void)ackMessage:(NSDictionary *)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/ACK_MESSAGE" with:params configuration:nil completionHandler:completionHandler];
}

- (void)getConversation:(NSDictionary *)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_GET_CONVERSATION_INFO" with:params configuration:nil completionHandler:completionHandler];
}

- (void)createConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_CREATE_CONVERSATION" with:params configuration:nil completionHandler:completionHandler];
}

- (void)closeConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_CLOSE_CONVERSATION" with:params configuration:nil completionHandler:completionHandler];
}

- (void)getDeviceUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_GET_USER_INFO" with:params configuration:nil completionHandler:completionHandler];
}

- (void)updateUser:(NSDictionary *)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self baseRequest:@"/PP_UPDATE_USER" with:params configuration:nil completionHandler:completionHandler];
}

// ======================
// PPCom API
// ======================

- (void)getPPComConversationList:(NSDictionary *)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PP_GET_USER_CONVERSATION_LIST" with:params completionHandler:completionHandler];
}

- (void)getPPComDefaultConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_GET_DEFAULT_CONVERSATION" with:params completionHandler:completionHandler];
}

- (void)createPPComDefaultConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_CREATE_DEFAULT_CONVERSATION" with:params completionHandler:completionHandler];
}

- (void)createPPComConversation:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_CREATE_CONVERSATION" with:params completionHandler:completionHandler];
}

- (void)getConversationUserList:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PP_GET_CONVERSATION_USER_LIST" with:params completionHandler:completionHandler];
}

- (void)getConversationInfo:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PP_GET_CONVERSATION_INFO" with:params completionHandler:completionHandler];
}

- (void)getAppInfo:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PP_GET_APP_INFO" with:params completionHandler:completionHandler];
}

- (void)createAnonymousUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_CREATE_ANONYMOUS" with:params completionHandler:completionHandler];
}

- (void)getUserUuid:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_GET_USER_UUID" with:params completionHandler:completionHandler];
}

- (void)getPPComDeviceUser:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PP_GET_USER_INFO" with:params completionHandler:completionHandler];
}

- (void)createDevice:(NSDictionary*)params completionHandler:(PPAPICompletedBlock)completionHandler {
    [self basePPComRequest:@"/PPCOM_CREATE_DEVICE" with:params completionHandler:completionHandler];
}

// =========================
// Get access token
// =========================

- (void)baseApiTokenRequest:(NSString*)tokenData completionHandler:(PPAPICompletedBlock)completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self getApiTokenUrl] parameters:nil error:nil];
    request.HTTPBody = [tokenData dataUsingEncoding:NSUTF8StringEncoding];
    [self addHeaders:request type:kPPHeaderTypePPToken];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if (completionHandler) completionHandler(responseObject, nil);
        } else {
            if (completionHandler) completionHandler(nil, [self getHttpUnavaliableInfoForError:error]);
        }
    }];
    [dataTask resume];
}


- (void)getPPComApiTokenWithCompletionHandler:(PPAPICompletedBlock)completionHandler {
    NSString *tokenData = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=client_credentials", self.sdk.configuration.apiKey, self.sdk.configuration.apiSecret];
    [self baseApiTokenRequest:tokenData completionHandler:completionHandler];
}

@end
