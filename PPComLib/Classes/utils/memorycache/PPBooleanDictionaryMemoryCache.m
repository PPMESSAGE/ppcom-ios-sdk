//
//  PPBooleanDictionaryMemoryCache.m
//  PPMessage
//
//  Created by PPMessage on 3/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPBooleanDictionaryMemoryCache.h"

static NSString *const kPPBooleanDictionaryCacheKey = @"boolean_dictionary";

@interface PPBooleanDictionaryMemoryCache ()

@property (nonatomic) PPMemoryCache *memoryCache;

@end

@implementation PPBooleanDictionaryMemoryCache

- (instancetype)initWithMemoryCache:(PPMemoryCache*)memoryCache {
    if (self = [super init]) {
        self.memoryCache = memoryCache;
    }
    return self;
}

#pragma mark - API

- (BOOL)queryWithKey:(NSString *)key {
    NSMutableDictionary *dict = [self boolDictionary];
    if (dict[key]) {
        return [dict[key] boolValue];
    }
    return NO;
}

- (void)updateWithKey:(NSString *)key value:(BOOL)value {
    NSMutableDictionary *dict = [self boolDictionary];
    dict[key] = [NSNumber numberWithBool:value];
}

- (NSMutableDictionary*)boolDictionary {
    NSMutableDictionary *dict = [self.memoryCache objectForKey:kPPBooleanDictionaryCacheKey];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        [self.memoryCache setObject:dict forKey:kPPBooleanDictionaryCacheKey];
    }
    return dict;
}

@end
