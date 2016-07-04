//
//  PPBooleanDictionaryMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMemoryCache.h"

@interface PPBooleanDictionaryMemoryCache : NSObject

- (instancetype)initWithMemoryCache:(PPMemoryCache*)memoryCache;

- (BOOL)queryWithKey:(NSString*)key;
- (void)updateWithKey:(NSString*)key
                value:(BOOL)value;

@end
