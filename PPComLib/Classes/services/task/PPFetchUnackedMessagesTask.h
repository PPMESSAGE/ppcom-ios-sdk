//
//  PPFetchUnackedMessagesJob.h
//  PPMessage
//
//  Created by PPMessage on 3/10/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPSDK;

/**
 *
 * API: GET_UNACKED_MESSAGE ---> [msg1, msg2, ...] ---> NSTimer: idx = 0 [Delay Parse]
 *                                                               idx = 1
 *                                                               idx = 2
 *                                                               ...
 *                                                               [The End]
 */
@interface PPFetchUnackedMessagesTask : NSObject

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)run;
- (void)cancel;

@end
