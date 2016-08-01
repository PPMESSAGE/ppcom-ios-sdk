//
//  PPNetworkHelper.h
//  Pods
//
//  Created by Jin He on 7/29/16.
//
//

#import <Foundation/Foundation.h>

#import "PPReachability.h"

@class PPSDK;

@protocol PPNetworkHelperDelegate <NSObject>

@optional

- (void) didNetworkReachable:(NetworkStatus)netStaus;

- (void) didNetworkUnreachable;

@end


@interface PPNetworkHelper : NSObject

@property (nonatomic) NetworkStatus netStatus;
@property (nonatomic, weak) id<PPNetworkHelperDelegate> networkHelperDelegate;

-(instancetype)initWithSDK:(PPSDK *)sdk;

- (void)startNotifier;

- (void)stopNotifier;

@end
