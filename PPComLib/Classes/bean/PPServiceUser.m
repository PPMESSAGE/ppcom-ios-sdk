//
//  PPServiceUser.m
//  PPMessage
//
//  Created by PPMessage on 2/19/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPServiceUser.h"
#import "PPSDKUtils.h"

#import "PPLog.h"

@implementation PPServiceUser

+ (instancetype)userWithDictionary:(NSDictionary*)userDictionary {
    PPServiceUser *user = (PPServiceUser*)[super userWithDictionary:userDictionary];
    
    user.browserDeviceUuid = PPSafeString(userDictionary[@"browser_device_uuid"]);
    user.mobileDeviceUuid = PPSafeString(userDictionary[@"mobile_device_uuid"]);
    
    NSString *signature = PPSafeString(userDictionary[@"user_signature"]);
    if (!signature) signature = @"";
    user.signature = signature;
    
    return user;
}

- (NSString*)description {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"userUUID"] = self.userUuid;
    userInfo[@"userName"] = self.userName;
    userInfo[@"userIcon"] = self.userIcon;
    userInfo[@"userPassword"] = self.password;
    userInfo[@"is_active"] = self.active ? @"True": @"False";
    userInfo[@"is_login"] = self.login ? @"True": @"False";
    userInfo[@"access_token"] = PPSafeString(self.accessToken);
    
    return [NSString stringWithFormat:
            @"<%p, %@, %@>",
            self,
            self.class,
            userInfo];
}

@end
