//
//  PPBadgeImageView.h
//  PPMessage
//
//  Created by PPMessage on 2/21/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
#import "PPSquareImageView.h"

@interface PPBadgeSquareImageView : UIView

@property (nonatomic) PPSquareImageView *imageView;
@property (nonatomic) CustomBadge *badgeView;
@property (nonatomic) NSString *badgeText;

@end
