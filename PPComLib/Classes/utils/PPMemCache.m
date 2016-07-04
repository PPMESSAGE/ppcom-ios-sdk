//
//  PPMemCache.m
//  PPMessage
//
//  Created by PPMessage on 2/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMemCache.h"

@implementation PPMemCache

+ (NSCache*)sharedCache {
    static NSCache *memCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        memCache = [[NSCache alloc]init];
    });
    return memCache;
}

@end
