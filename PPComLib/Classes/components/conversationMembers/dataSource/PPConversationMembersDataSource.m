//
//  PPConversationMembersDataSource.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPConversationMembersDataSource.h"

#import "PPUser.h"

#import "PPConversationMemberViewCell.h"

@interface PPConversationMembersDataSource ()

@property (nonatomic) NSMutableArray *members;
@property (nonatomic) PPSDK *client;
@property (nonatomic) NSString *cellIdentifier;
@property (nonatomic, copy) PPConversationMemberItemCellConfigurationBlock configureCellBlock;

@end

@implementation PPConversationMembersDataSource

- (instancetype)initWithMembers:(NSMutableArray *)members
                 cellIdentifier:(NSString *)cellIdentifier
                     withClient:(PPSDK *)client
             configurationBlock:(PPConversationMemberItemCellConfigurationBlock)configureCellBlock {
    if (self = [super init]) {
        self.members = members;
        self.cellIdentifier = cellIdentifier;
        self.client = client;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.members objectAtIndex:indexPath.row];
}

- (void)updateMembers:(NSMutableArray *)members {
    self.members = members;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.members.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPConversationMemberViewCell *memberViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(memberViewCell, item);
    return memberViewCell;
}

@end
