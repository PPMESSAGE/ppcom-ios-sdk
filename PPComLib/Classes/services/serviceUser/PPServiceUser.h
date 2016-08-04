//
//  PPServiceUser.h
//  PPMessage
//
//  Created by PPMessage on 2/19/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPUser.h"

@interface PPServiceUser : PPUser

+ (instancetype)userWithDictionary:(NSDictionary*)userDictionary;

@property (nonatomic) NSString *accessToken;
@property (nonatomic) BOOL login;
@property (nonatomic) BOOL active;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *signature;

@end
