//
//  PPPolling.h
//  PPComLib
//
//  Created by PPMessage on 5/4/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSDK;

typedef void (^PPPollingExecutingBlock)();

@interface PPPolling : NSObject

- (instancetype)initWithClient:(PPSDK*)client;
- (instancetype)initWithClient:(PPSDK*)client
              withTimeInterval:(NSTimeInterval)timeInterval;

- (void)runWithExecutingCode:(PPPollingExecutingBlock)block;
- (void)cancel;

@end
