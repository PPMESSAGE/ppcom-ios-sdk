//
//  PPApp.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPApp : NSObject

@property (readonly) NSString *appUuid;
@property (readonly) NSString *appKey;
@property (readonly) NSString *appSecret;
@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *userUUID; // Who create this app

+ (instancetype)appWithDictionary:(NSDictionary*)appDictionary;

- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString*)appSecret uuid:(NSString*)uuid;

@end
