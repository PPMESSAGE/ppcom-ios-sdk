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
    if (!buttonItem) return NO;
    if (![buttonItem isKindOfClass:[UIActivityIndicatorView class]]) return NO;
    
    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem;
    if (!activityIndicatorView) return NO;
    return [activityIndicatorView isAnimating];
}

- (void)pp_startAnimating {
    UIActivityIndicatorView *activityIndicatorView;
    if (![self isActivityIndicatorViewAttached]) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        self.navigationItem.rightBarButtonItem = barButton;
    } else {
        activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem;
    }
    
    [activityIndicatorView startAnimating];
}

- (void)pp_stopAnimating {
    if (![self isActivityIndicatorViewAttached]) return;
    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*) self.navigationItem.rightBarButtonItem;
    [activityIndicatorView stopAnimating];
}

#pragma mark - helper

- (BOOL)isActivityIndicatorViewAttached {
    UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
    if (!buttonItem) return NO;
    if (![buttonItem isKindOfClass:[UIActivityIndicatorView class]]) return NO;
    
    return YES;
}

@end
