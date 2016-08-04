//
//  PPGetWaitingQueueLengthHttpModel.m
//  PPComLib
//
//  Created by PPMessage on 5/4/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGetWaitingQueueLengthHttpModel.h"

#import "PPAPI.h"
#import "PPSDK.h"
#import "PPApp.h"

#import "PPServiceUser.h"

@interface PPGetWaitingQueueLengthHttpModel ()

@property (nonatomic) PPSDK *client;

@end

@implementation PPGetWaitingQueueLengthHttpModel

+ (instancetype)modelWithClient:(PPSDK *)client {
    return [[PPGetWaitingQueueLengthHttpModel alloc] initWithClient:client];
}

- (instancetype)initWithClient:(PPSDK*)client {
    if (self = [super init]) {
        self.client = client;
    }
    return self;
}

- (void)getWaitingQueueLengthWithCompletedBlock:(PPHttpModelCompletedBlock)completedBlock {
    if (!self.client.app || !self.client.app.appUuid) return;
    
    NSDictionary *requestParams = @{ @"app_uuid": self.client.app.appUuid,
                                     @"user_uuid": self.client.user.userUuid };
    [self.client.api getWaitingQueueLength:requestParams completionHandler:^(NSDictionary *response, NSDictionary *error) {
        NSInteger waitingQueueLength = 0;
        if (response && [response[@"error_code"] integerValue] == 0) {
            waitingQueueLength = [response[@"length"] integerValue];
        }
        if (completedBlock) {
            completedBlock([NSNumber numberWithInteger:waitingQueueLength], response, [NSError errorWithDomain:PPErrorDomain
                                                                                                          code:PPErrorCodeAPIError
                                                                                                      userInfo:error]);
        }
    }];
}

@end
