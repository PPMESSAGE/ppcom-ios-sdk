//
//  PPButton.h
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPButton : UIButton

+ (PPButton *)buttonWithImage:(UIImage *)image
           withHighlightImage:(UIImage *)hlImage UI_APPEARANCE_SELECTOR;

- (void)setBgColor:(UIColor *)backgroundColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end
