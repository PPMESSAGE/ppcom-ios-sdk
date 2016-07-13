//
//  PPMessageItemLeftView.h
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemBaseView.h"
#import "PPSquareImageView.h"

extern CGFloat const PPMessageItemLeftViewDefaultBubbleCornerRadius;

@interface PPMessageItemLeftView : PPMessageItemBaseView

@property (nonatomic) PPSquareImageView *avatarImageView;
@property (nonatomic) UILabel *nameLabel;

@property (nonatomic) UIColor *bubbleColor;
@property (nonatomic) CGFloat bubbleCornerRadius;

//
// [icon view][right column view][right view]
//
// Override it's getter method to provide your own rightView
// Default is nil
@property (nonatomic) UIView *rightView;

@end
