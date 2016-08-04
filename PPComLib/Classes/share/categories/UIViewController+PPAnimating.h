//
//  UIViewController+PPAnimating.h
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (PPAnimating)

- (BOOL)pp_isAnimating;

- (void)pp_startAnimating;

- (void)pp_stopAnimating;

@end
