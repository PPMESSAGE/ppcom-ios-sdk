//
//  PPSDKConfiguration.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

@interface PPSDKConfiguration : NSObject

@property (nonatomic) NSString *appUUID;
@property (nonatomic) NSString *apiSecret;
@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *hostUrl;
@property (nonatomic) NSString *email;

@property (nonatomic, readonly) NSString *apiUrl;
@property (nonatomic, readonly) NSString *webSockeUrl;
@property (nonatomic, readonly) NSString *downloadUrl;
@property (nonatomic, readonly) NSString *uploadUrl;
@property (nonatomic, readonly) NSString *authUrl;

@end
