//
//  PPConversationsViewControllerDataSource.h
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class PPConversationItem;

/**
 * 为`PPConversationsViewController`提供`DataSource`
 */
@interface PPConversationsViewControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSOrderedSet *conversations;

- (PPConversationItem *)objectAtIndex:(NSIndexPath*)indexPath;

@end
