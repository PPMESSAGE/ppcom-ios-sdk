//
//  PPAckMessageHttpModel.m
//  Pods
//
//  Created by PPMessage on 7/7/16.
//
//

#import "PPAckMessageHttpModel.h"

#import "PPSDK.h"
#import "PPAPI.h"

@interface PPAckMessageHttpModel ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPAckMessageHttpModel

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)ackMessageWithMessagePushUUID:(NSString *)pushUUID
                            withBlock:(PPHttpModelCompletedBlock)aBlock {
    [self ackMessageWithMessagePushUUIDArray:@[ pushUUID ] withBlock:aBlock];
}

- (void)ackMessageWithMessagePushUUIDArray:(NSMutableArray *)pushUUIDArray
                                 withBlock:(PPHttpModelCompletedBlock)aBlock {
    NSDictionary *params = @{ @"list": pushUUIDArray };
    [self.sdk.api ackMessage:params completionHandler:^(NSDictionary *response, NSDictionary *error) {
        if (aBlock) {
            aBlock(response, response, error);
        }
    }];
    
}

@end
