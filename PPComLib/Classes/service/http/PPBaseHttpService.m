//
//  PPBaseHttpService.m
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import "PPBaseHttpService.h"

@implementation PPBaseHttpService

- (instancetype)initWithPPSDK:(PPSDK*)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
        self.api = self.sdk.api;
        self.app = self.sdk.app;
        self.user = self.sdk.user;
    }
    return self;
}

@end
