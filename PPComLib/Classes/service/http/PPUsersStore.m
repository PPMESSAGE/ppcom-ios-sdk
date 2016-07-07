//
//  PPUsersStore.m
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import "PPUsersStore.h"

#import "PPUser.h"
#import "PPSDK.h"

#import "PPGetUserDetailInfoHttpModel.h"

@interface PPUsersStore ()

@property (nonatomic) NSMutableDictionary *users;

@end

@implementation PPUsersStore

+ (instancetype)storeWithClient:(PPSDK*)client {
    return [[self alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.sdk = client;
        self.users = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)updateWithUser:(PPUser *)user {
    [self.users setObject:user forKey:user.userUuid];
}

- (void)findWithUserUUID:(NSString *)userUUID
               withBlock:(PPUsersStoreFindUserCompletedBlock)aBlock {
    PPUser *userInMemory = [self findFromMemoryWithUserUUID:userUUID];
    if (userInMemory) {
        if (aBlock) {
            aBlock(userInMemory);
        }
        return;
    }
    
    PPGetUserDetailInfoHttpModel *findUserTask = [[PPGetUserDetailInfoHttpModel alloc] initWithSDK:self.sdk];
    [findUserTask getUserDetailInfoWithUUID:userUUID withBlock:^(id obj, NSDictionary *response, NSError *error) {
        if (obj) {
            [self updateWithUser:obj];
        }
        if (aBlock) {
            aBlock(obj);
        }
    }];
}

// ===================
// Helpers
// ===================

- (PPUser*)findFromMemoryWithUserUUID:(NSString*)userUUID {
    return [self.users objectForKey:userUUID];
}

@end
