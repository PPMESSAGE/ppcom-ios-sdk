//
//  PPConversationItemView.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPBadgeSquareImageView;

extern CGFloat const PPConversationItemViewHeight;
extern NSString *const PPConversationItemViewCellIdentifier;

@interface PPConversationItemViewCell : UITableViewCell

@property (nonatomic) PPBadgeSquareImageView *avatarView;
@property (nonatomic) UILabel *displayNameLabel;
@property (nonatomic) UILabel *msgSummaryLabel;
@property (nonatomic) UILabel *msgTimestampLabel;

@end
