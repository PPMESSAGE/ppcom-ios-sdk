//
//  PPUser.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUser : NSObject

@property (readonly) NSString *userUuid;
@property (nonatomic) NSString *browserDeviceUuid;
@property (nonatomic) NSString *mobileDeviceUuid;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userIcon;
@property (nonatomic) NSString *userType;

+ (instancetype)userWithDictionary:(NSDictionary*)userDictionary;

- (instancetype)initWithUuid:(NSString*)uuid;

/** 判断一个user是否是empty状态：只有user_uuid，其它信息均不存在 **/
- (BOOL)isEmpty;

@end
