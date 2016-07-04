//
//  PPContactMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMemoryCache;

@interface PPContactMemoryCache : NSObject

- (instancetype)initWithMemoryCache:(PPMemoryCache*)cache;

#pragma mark -

- (void)updateWithContacts:(NSMutableArray*)contacts;
- (NSMutableArray*)contacts;

@end
