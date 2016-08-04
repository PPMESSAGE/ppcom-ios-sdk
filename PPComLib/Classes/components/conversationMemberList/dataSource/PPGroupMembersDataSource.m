//
//  PPGroupMembersDataSource.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGroupMembersDataSource.h"

#import "PPUser.h"

#import "PPGroupMemberViewCell.h"

@interface PPGroupMembersDataSource ()

@property (nonatomic) NSMutableArray *groupMembers;
@property (nonatomic) PPSDK *client;
@property (nonatomic) NSString *cellIdentifier;
@property (nonatomic, copy) PPGroupMemberItemCellConfigurationBlock configureCellBlock;

@end

@implementation PPGroupMembersDataSource

- (instancetype)initWithGroupMembers:(NSMutableArray *)groupMembers
                      cellIdentifier:(NSString *)cellIdentifier
                          withClient:(PPSDK *)client
                  configurationBlock:(PPGroupMemberItemCellConfigurationBlock)configureCellBlock {
    if (self = [super init]) {
        self.groupMembers = groupMembers;
        self.cellIdentifier = cellIdentifier;
        self.client = client;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.groupMembers objectAtIndex:indexPath.row];
}

- (void)updateGroupMembers:(NSMutableArray *)groupMembers {
    self.groupMembers = groupMembers;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupMembers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPGroupMemberViewCell *memberViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(memberViewCell, item);
    return memberViewCell;
}

@end
