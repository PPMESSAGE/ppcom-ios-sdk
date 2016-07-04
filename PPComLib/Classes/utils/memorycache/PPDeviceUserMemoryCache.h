//
//  PPDeviceUserMemoryCache.h
//  PPMessage
//
//  Created by PPMessage on 3/9/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPMemoryCache;
@class PPUser;

@interface PPDeviceUserMemoryCache : NSObject

- (instancetype)initWithMemoryCache:(PPMemoryCache*)cache;

#pragma mark -

- (PPUser*)queryWithUUID:(NSString*)userUUID;
- (void)updateWithUser:(PPUser*)user;

@end
