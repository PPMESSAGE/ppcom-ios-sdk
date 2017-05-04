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

- (void)setHostUrl:(NSString *)hostUrl appUUID:(NSString*)appUUID registraionId:(NSString*)registrationId {
    
    NSString *wsHost = [self.hostUrl stringByReplacingCharactersInRange:NSMakeRange(0,4) withString:@"ws"];

    self.hostUrl = hostUrl;
    self.appUUID = appUUID;
    self.registrationId = registrationId;

    self.webSockeUrl = [wsHost stringByAppendingString:@"/pcsocket/WS"];
    self.downloadUrl = [self.hostUrl stringByAppendingString:@"/ppdownload/ppdownload/"];
    self.uploadUrl = [self.hostUrl stringByAppendingString:@"/ppupload/ppupload/"];
    self.authUrl = [self.hostUrl stringByAppendingString:@"/ppauth"];
    self.apiUrl = [self.hostUrl stringByAppendingString:@"/ppapi"];

    // extend to utils
    PPFileHost = self.downloadUrl;
    PPTxtUploadHost = self.uploadUrl;
}

@end
