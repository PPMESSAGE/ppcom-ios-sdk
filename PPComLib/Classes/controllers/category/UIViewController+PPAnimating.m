//
//  UIViewController+PPAnimating.m
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import "UIViewController+PPAnimating.h"

@implementation UIViewController (PPAnimating)

- (BOOL)pp_isAnimating {
    UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
    if ([self pp_isActivityIndicatorViewAttached]) {
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem.customView;
        if (!activityIndicatorView) return NO;
        return [activityIndicatorView isAnimating];
    }
    return NO;
}

- (void)pp_startAnimating {
    UIActivityIndicatorView *activityIndicatorView;
    if (![self pp_isActivityIndicatorViewAttached]) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        self.navigationItem.rightBarButtonItem = barButton;
    } else {
        activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem.customView;
    }
    
    [activityIndicatorView startAnimating];
}

- (void)pp_stopAnimating {
    if (![self pp_isActivityIndicatorViewAttached]) return;
    
    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem.customView;
    [activityIndicatorView stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - helper

- (BOOL)pp_isActivityIndicatorViewAttached {
    UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
    if (!buttonItem) return NO;
    if (![buttonItem.customView isKindOfClass:[UIActivityIndicatorView class]]) return NO;
    
    return YES;
}

@end
