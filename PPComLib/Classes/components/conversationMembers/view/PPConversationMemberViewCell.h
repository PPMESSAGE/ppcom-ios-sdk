//
//  PPConversationMemberViewCell.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPUser;

FOUNDATION_EXPORT CGFloat const PPConversationMemberViewCellWidth;
FOUNDATION_EXPORT CGFloat const PPConversationMemberViewCellHeight;

FOUNDATION_EXPORT NSString *const PPConversationMemberViewCellIdentifier;

@interface PPConversationMemberViewCell : UICollectionViewCell

@property (nonatomic) PPUser *member;

@end
