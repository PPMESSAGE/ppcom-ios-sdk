//
//  PPContactMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPContactMemoryCache.h"

#import "PPMemoryCache.h"

static NSString * const kContactsCacheKey = @"contacts";

@interface PPContactMemoryCache ()

@property (nonatomic) PPMemoryCache *cache;

@end

@implementation PPContactMemoryCache

- (instancetype)initWithMemoryCache:(PPMemoryCache *)cache {
    if (self = [super init]) {
        _cache = cache;
    }
    return self;
}

#pragma mark -

- (void)updateWithContacts:(NSMutableArray *)contacts {
    [self.cache setObject:contacts forKey:kContactsCacheKey];
}

- (NSMutableArray*)contacts {
    return [self.cache objectForKey:kContactsCacheKey];
}

@end
