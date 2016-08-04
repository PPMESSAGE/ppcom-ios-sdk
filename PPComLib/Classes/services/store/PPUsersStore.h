//
//  PPUsersStore.h
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import <Foundation/Foundation.h>

@class PPSDK, PPUser;

typedef void(^PPUsersStoreFindUserCompletedBlock)(PPUser *user);

@interface PPUsersStore : NSObject

@property (nonatomic) PPSDK *sdk;

+ (instancetype)storeWithClient:(PPSDK*)client;

- (void)updateWithUser:(PPUser*)user;
- (void)findWithUserUUID:(NSString*)userUUID
               withBlock:(PPUsersStoreFindUserCompletedBlock)aBlock;

@end
