//
//  PPApp.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPApp.h"

@implementation PPApp

+ (instancetype)appWithDictionary:(NSDictionary *)appDictionary {
    PPApp *app = [[PPApp alloc] initWithAppKey:appDictionary[@"app_key"] appSecret:appDictionary[@"app_secret"] uuid:appDictionary[@"uuid"]];
    app.userUUID = appDictionary[@"user_uuid"];
    app.appName = appDictionary[@"app_name"];
    return app;
}

- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret uuid:(NSString *)uuid {
    self = [super init];
    if (self) {
        _appKey = appKey;
        _appSecret = appSecret;
        _appUuid = uuid;
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[appUUID:%@, appName:%@, appKey:%@, appSecret:%@, userUUID:%@]",
            self.appUuid,
            self.appName,
            self.appKey,
            self.appSecret,
            self.userUUID];
}

@end
