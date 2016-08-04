//
//  PPTableHeaderWarningView.h
//  PPMessage
//
//  Created by PPMessage on 4/18/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTableHeaderWarningView : UIView

/**
 * default is `Error-50` image
 */
@property (nonatomic) UIImage *warningImage;

/**
 * text used for warning, default is `Warning`
 */
@property (nonatomic) NSString *warningText;

@end
