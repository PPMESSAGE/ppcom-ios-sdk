//
//  PPSDKStartUpHelper.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "PPSDKStartUpHelper.h"

#import "PPSDK.h"

@interface PPSDKStartUpHelper ()

@property (nonatomic) PPSDK *sdk;

@end

@implementation PPSDKStartUpHelper

- (instancetype)initWithSDK:(PPSDK *)sdk {
    if (self = [super init]) {
        self.sdk = sdk;
    }
    return self;
}

- (void)start {
    
}

- (BOOL)starting {
    return NO;
}

- (BOOL)started {
    return NO;
}

// ========================
// Private
// ========================

- (BOOL)isEmailUser {
    return self.sdk.configuration.email != nil;
}

@end
