//
//  PPConversationsViewControllerDataSource.h
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PPConversationsTableViewConfigureBlock)(id cell, id item);

/**
 * 为`PPConversationsViewController`提供`DataSource`
 */
@interface PPConversationsViewControllerDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithCellIdentifier:(NSString*)cellIdentifier
configureBlock:(PPConversationsTableViewConfigureBlock)block;

- (id)objectAtIndex:(NSIndexPath*)indexPath;

- (NSOrderedSet*)conversations;
- (void)updateItemsWithConversations:(NSOrderedSet*)conversations;

@end
