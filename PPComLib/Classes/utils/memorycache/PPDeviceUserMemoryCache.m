//
//  PPDeviceUserMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPDeviceUserMemoryCache.h"

#import "PPUser.h"
#import "PPMemoryCache.h"

static NSString *const kPPDeviceUserMemoryCacheKey = @"memory:device_user:key";

@interface PPDeviceUserMemoryCache ()

@property (nonatomic) PPMemoryCache *memoryCache;

@end

@implementation PPDeviceUserMemoryCache

- (instancetype)initWithMemoryCache:(PPMemoryCache *)cache {
    if (self = [super init]) {
        self.memoryCache = cache;
    }
    return self;
}

#pragma mark -

- (PPUser*)queryWithUUID:(NSString *)userUUID {
    NSInteger index = [self quickIndex:userUUID];
    if (index == -1) {
        return nil;
    }
    
    return [self deviceUsersAutoCreate][index];
}

- (void)updateWithUser:(PPUser *)user {
    NSInteger index = [self quickIndex:user.userUuid];
    if (index == -1) {
        [[self deviceUsersAutoCreate] addObject:user];
    } else {
        [[self deviceUsersAutoCreate] replaceObjectAtIndex:index withObject:user];
    }
}

#pragma mark -

- (NSInteger)quickIndex:(NSString*)userUUID {
    NSMutableArray *users = [self deviceUsersAutoCreate];
    __block NSInteger index = -1;
    [users enumerateObjectsUsingBlock:^(PPUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([user.userUuid isEqualToString:userUUID]) {
            index = (NSInteger)idx;
            *stop = YES;
        }
    }];
    return index;
}

- (NSMutableArray*)deviceUsersAutoCreate {
    id obj = [self.memoryCache objectForKey:kPPDeviceUserMemoryCacheKey];
    if (!obj) {
        obj = [NSMutableArray array];
        [self.memoryCache setObject:obj forKey:kPPDeviceUserMemoryCacheKey];
    }
    return obj;
}

@end
