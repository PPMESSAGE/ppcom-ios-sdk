//
//  PPUser.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPUser.h"

#import "PPSDKUtils.h"

@implementation PPUser

+ (instancetype)userWithDictionary:(NSDictionary*)userDictionary {
    NSString *userUUID = userDictionary[@"uuid"];
    if (!userUUID) {
        userUUID = userDictionary[@"user_uuid"];
    }
    NSString *userIcon = userDictionary[@"user_icon"];
    NSString *userName = userDictionary[@"user_fullname"];
    NSString *userEmail = userDictionary[@"user_email"];
    
    PPUser *user = [[self alloc]initWithUuid:userUUID];
    user.userName = userName;
    user.userIcon = PPSafeString(PPFileURL(userIcon));
    user.userEmail = userEmail;
    
    return user;
}

- (instancetype)initWithUuid:(NSString*)uuid {
    self = [super init];
    if (self) {
        _userUuid = uuid;
    }
    return self;
}

- (BOOL)isEmpty {
    return PPIsNotNull(self.userUuid) &&
    (PPIsNull(self.userName) || [self.userName isEqualToString:@""]) &&
    (PPIsNull(self.userIcon) || [self.userIcon isEqualToString:@""]);
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"<%p, %@, %@>",
            self,
            self.class,
            @{@"uuid": PPSafeString(self.userUuid),
              @"userIcon": PPSafeString(self.userIcon),
              @"userName": PPSafeString(self.userName),
              @"userEmail": PPSafeString(self.userEmail)}];
}

@end