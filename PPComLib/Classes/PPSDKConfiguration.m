//
//  PPSDKConfiguration.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPSDKConfiguration.h"

#import "PPSDKUtils.h"

@interface PPSDKConfiguration ()

@end

@implementation PPSDKConfiguration

- (void)setHostUrl:(NSString *)hostUrl appUuid:(NSString *)appUuid registrationId:(NSString *)registrationId entUser:(NSDictionary*)entUser {
    

    self.entUser = entUser;
    self.hostUrl = hostUrl;
    self.appUUID = appUuid;
    self.registrationId = registrationId;

    NSString *wsHost = [hostUrl stringByReplacingCharactersInRange:NSMakeRange(0,4) withString:@"ws"];
    self.webSockeUrl = [wsHost stringByAppendingString:@"/pcsocket/WS"];
    self.downloadUrl = [self.hostUrl stringByAppendingString:@"/ppdownload/ppdownload/"];
    self.uploadUrl = [self.hostUrl stringByAppendingString:@"/ppupload/ppupload/"];
    self.authUrl = [self.hostUrl stringByAppendingString:@"/ppauth"];
    self.apiUrl = [self.hostUrl stringByAppendingString:@"/ppapi"];

    self.apiSecret = @"ZThmMTM1ZDM4ZmI2NjE1YWE0NWEwMGM3OGNkMzY5MzVjOTQ2MGU0NQ==";
    self.apiKey = @"M2E2OTRjZTQ5Mzk4ZWUxYzRjM2FlZDM2NmE4MjA4MzkzZjFjYWQyOA==";

    // extend to utils
    PPFileHost = self.downloadUrl;
    PPTxtUploadHost = self.uploadUrl;
}


- (void)setHostUrl:(NSString *)hostUrl appUuid:(NSString *)appUuid registrationId:(NSString *)registrationId {
    [self setHostUrl:hostUrl appUuid:appUuid registrationId:registrationId entUser: nil];
}

@end
