//
//  PPGroupMemberViewCell.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPUser;

FOUNDATION_EXPORT CGFloat const PPGroupMemberViewCellWidth;
FOUNDATION_EXPORT CGFloat const PPGroupMemberViewCellHeight;

FOUNDATION_EXPORT NSString *const PPGroupMemberViewCellIdentifier;

@interface PPGroupMemberViewCell : UICollectionViewCell

@property (nonatomic) PPUser *groupMember;

@end
