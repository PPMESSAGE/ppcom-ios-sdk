//
//  PPNetworkHelper.m
//  Pods
//
//  Created by Jin He on 7/29/16.
//
//

#import "PPNetworkHelper.h"

@interface PPNetworkHelper ()

@property PPReachability *reachability;

@end

@implementation PPNetworkHelper

- (void) startNotifier {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [PPReachability reachabilityForInternetConnection];
    [self.reachability startNotifier];

    self.netStatus = [self.reachability currentReachabilityStatus];
    [self setNetworkStatus:self.netStatus];
}

- (void)reachabilityChanged:(NSNotification *)note {
    PPReachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[PPReachability class]]);
    self.netStatus = [curReach currentReachabilityStatus];
    [self setNetworkStatus:self.netStatus];
}

- (void)setNetworkStatus: (NetworkStatus)netStatus {
    switch (netStatus) {
        case NotReachable:
            NSLog(@"---------network not reachable");
            if ([self.networkHelperDelegate respondsToSelector:@selector(didNetworkUnreachable)]) {
                [self.networkHelperDelegate didNetworkUnreachable];
            }
            break;
        case ReachableViaWiFi:
            NSLog(@"---------network reachable via wifi");
            if ([self.networkHelperDelegate respondsToSelector:@selector(didNetworkReachable)]) {
                [self.networkHelperDelegate didNetworkReachable:netStatus];
            }
            break;
        case ReachableViaWWAN:
            NSLog(@"---------network reachable via wwan");
            if ([self.networkHelperDelegate respondsToSelector:@selector(didNetworkReachable)]) {
                [self.networkHelperDelegate didNetworkReachable:netStatus];
            }
        default:
            break;
    }
}


@end
