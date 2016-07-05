//
//  PPGroupMembersCollectionViewLayout.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGroupMembersCollectionViewLayout.h"

#import "PPGroupMemberViewCell.h"

@implementation PPGroupMembersCollectionViewLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 3.f;
        self.minimumLineSpacing = 3.f;
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(PPGroupMemberViewCellWidth, PPGroupMemberViewCellHeight);
}

@end
