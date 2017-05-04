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

@property (nonatomic) NSString *apiSecret = "ZThmMTM1ZDM4ZmI2NjE1YWE0NWEwMGM3OGNkMzY5MzVjOTQ2MGU0NQ==";
@property (nonatomic) NSString *apiKey = "M2E2OTRjZTQ5Mzk4ZWUxYzRjM2FlZDM2NmE4MjA4MzkzZjFjYWQyOA==";

/** 
 * Set configuration of PPCOM SDK
 * @author Guijin Ding
 *
 * @param hostUrl, https://ppmessage.cn or https://ppmessage.com, depends on your account which registered in.
 * @param appUUID, your team app uuid, get it from PPMESSAGE backend
 * @param regisgrationId, iOS app push id, if no, can not send push from PPMESSAGE
 * @return void
 */
- (void)setHostUrl:(NSString *)hostUrl appUUID:(NSString*)appUUID registrationId:(NSString*)registrationId;

@end
