//
//  PPSDKStartUpHelper.h
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import <Foundation/Foundation.h>

@class PPSDK, PPUser, PPSDKStartUpHelper;

@protocol PPSDKStartUpHelperDelegate <NSObject>

@optional

// start up succeded
- (void)didSDKStartUpSucceded:(PPSDKStartUpHelper*)startUpHelper;

// start up failed
- (void)didSDKStartUpFailed:(PPSDKStartUpHelper*)startUpHelper errorInfo:(id)errorInfo;

@end

@interface PPSDKStartUpHelper : NSObject

@property (nonatomic) NSString *status;
@property (nonatomic, weak) id<PPSDKStartUpHelperDelegate> startUpDelegate;

- (instancetype)initWithSDK:(PPSDK*)sdk;

- (void)start;

- (BOOL)starting;

- (BOOL)started;

@end
