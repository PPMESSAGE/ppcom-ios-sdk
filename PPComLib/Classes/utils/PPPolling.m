//
//  PPPolling.m
//  PPComLib
//
//  Created by PPMessage on 5/4/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPPolling.h"

#import "PPSDK.h"

#import "PPLog.h"

static NSTimeInterval const kDefaultTimeInterval = 5;

@interface PPPolling ()

@property (nonatomic) PPSDK *client;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, copy) PPPollingExecutingBlock executingBlock;

@end

@implementation PPPolling

- (instancetype)initWithClient:(PPSDK *)client {
    return [self initWithClient:client withTimeInterval:kDefaultTimeInterval];
}

- (instancetype)initWithClient:(PPSDK *)client
              withTimeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        self.client = client;
        self.timeInterval = timeInterval;
    }
    return self;
}

- (void)runWithExecutingCode:(PPPollingExecutingBlock)block {
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
    self.executingBlock = [block copy];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)cancel {
    [self.timer invalidate];
}

#pragma mark - helper

- (void)timeFired:(NSTimer *)timer {
    self.executingBlock();
}

@end
