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

@property (nonatomic, readwrite) NSString *apiUrl;
@property (nonatomic, readwrite) NSString *webSockeUrl;
@property (nonatomic, readwrite) NSString *downloadUrl;
@property (nonatomic, readwrite) NSString *uploadUrl;
@property (nonatomic, readwrite) NSString *authUrl;

@end

@implementation PPSDKConfiguration

- (void)setHostUrl:(NSString *)hostUrl {
    _hostUrl = hostUrl;
    
    NSString *wsHost = [self.hostUrl stringByReplacingCharactersInRange:NSMakeRange(0,4) withString:@"ws"];
    
    self.webSockeUrl = [wsHost stringByAppendingString:@"/pcsocket/WS"];
    self.downloadUrl = [self.hostUrl stringByAppendingString:@"/download/download/"];
    self.uploadUrl = [self.hostUrl stringByAppendingString:@"/upload/"];
    self.authUrl = [self.hostUrl stringByAppendingString:@"/ppauth"];
    self.apiUrl = [self.hostUrl stringByAppendingString:@"/api"];
    
    PPFileHost = self.downloadUrl;
    PPTxtUploadHost = self.uploadUrl;
}

@end
