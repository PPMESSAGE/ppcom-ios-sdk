//
//  PPSDKConfiguration.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

@interface PPSDKConfiguration : NSObject

@property (nonatomic, readwrite) NSString *hostUrl;
@property (nonatomic, readwrite) NSString *appUUID;
@property (nonatomic, readwrite) NSString *registrationId;

@property (nonatomic, readwrite) NSString *apiUrl;
@property (nonatomic, readwrite) NSString *webSockeUrl;
@property (nonatomic, readwrite) NSString *downloadUrl;
@property (nonatomic, readwrite) NSString *uploadUrl;
@property (nonatomic, readwrite) NSString *authUrl;

@property (nonatomic, readwrite) NSString *apiSecret;
@property (nonatomic, readwrite) NSString *apiKey;

/** 
 * Set configuration of PPCOM SDK
 * @author Guijin Ding
 *
 * @param hostUrl https://ppmessage.cn or https://ppmessage.com, depends on your account which registered in.
 * @param appUuid your team app uuid, get it from PPMESSAGE backend
 * @param registrationId iOS app push id, if no, can not send push from PPMESSAGE 
 */
- (void)setHostUrl:(NSString *)hostUrl appUuid:(NSString*)appUuid registrationId:(NSString*)registrationId;

@end
