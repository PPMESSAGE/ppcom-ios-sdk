//
//  PPMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPConversationMemoryCache;
@class PPMessageMemoryCache;
@class PPContactMemoryCache;
@class PPDeviceUserMemoryCache;
@class PPBooleanDictionaryMemoryCache;

@interface PPMemoryCache : NSObject

#pragma mark -

+ (PPMemoryCache*)sharedInstance;

#pragma mark -

@property (nonatomic) PPConversationMemoryCache *conversationCache;
@property (nonatomic) PPMessageMemoryCache *messageCache;
@property (nonatomic) PPContactMemoryCache *contactCache;
@property (nonatomic) PPDeviceUserMemoryCache *deviceUserCache;
@property (nonatomic) PPBooleanDictionaryMemoryCache *boolCache;

#pragma mark -

- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)obj forKey:(NSString*)key;
- (void)removeAllObjects;

@end
