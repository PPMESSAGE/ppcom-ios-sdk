//
//  PPConversationMembersDataSource.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPSDK;

typedef void (^PPConversationMemberItemCellConfigurationBlock)(id cell, id item);

@interface PPConversationMembersDataSource : NSObject<UICollectionViewDataSource>

- (instancetype)initWithMembers:(NSMutableArray *)members
cellIdentifier:(NSString *)cellIdentifier
withClient:(PPSDK *)client
configurationBlock:(PPConversationMemberItemCellConfigurationBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

- (void)updateMembers:(NSMutableArray*)members;

@end
