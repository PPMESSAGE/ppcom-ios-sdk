//
//  PPGroupMembersDataSource.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPSDK;

typedef void (^PPGroupMemberItemCellConfigurationBlock)(id cell, id item);

@interface PPGroupMembersDataSource : NSObject<UICollectionViewDataSource>

- (instancetype)initWithGroupMembers:(NSMutableArray *)groupMembers
                      cellIdentifier:(NSString *)cellIdentifier
                          withClient:(PPSDK *)client
                  configurationBlock:(PPGroupMemberItemCellConfigurationBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (void)updateGroupMembers:(NSMutableArray*)groupMembers;

@end
