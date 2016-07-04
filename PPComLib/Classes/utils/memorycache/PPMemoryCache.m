//
//  PPMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMemoryCache.h"

#import "PPConversationMemoryCache.h"
#import "PPMessageMemoryCache.h"
#import "PPContactMemoryCache.h"
#import "PPDeviceUserMemoryCache.h"
#import "PPBooleanDictionaryMemoryCache.h"

@interface PPMemoryCache ()

@property (nonatomic) NSCache *cache;

@end

@implementation PPMemoryCache

#pragma mark - static

+ (PPMemoryCache*)sharedInstance {
    static PPMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [PPMemoryCache new];
    });
    return cache;
}

#pragma mark -

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [NSCache new];
        
        self.conversationCache = [[PPConversationMemoryCache alloc] initWithMemoryCache:self];
        self.messageCache = [[PPMessageMemoryCache alloc] initWithMemoryCache:self];
        self.contactCache = [[PPContactMemoryCache alloc] initWithMemoryCache:self];
        self.deviceUserCache = [[PPDeviceUserMemoryCache alloc] initWithMemoryCache:self];
        self.boolCache = [[PPBooleanDictionaryMemoryCache alloc] initWithMemoryCache:self];
        
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

- (void)setObject:(id)obj forKey:(NSString *)key {
    [self.cache setObject:obj forKey:key];
}

- (void)removeAllObjects {
    [self.cache removeAllObjects];
}

@end
