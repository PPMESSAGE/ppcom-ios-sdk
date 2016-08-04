//
//  PPBaseMessagesViewControllerDataSource.h
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPBaseMessagesViewController;

@interface PPBaseMessagesViewControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) PPBaseMessagesViewController *viewController;

- (instancetype)initWithController:(PPBaseMessagesViewController*)viewController;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

- (void)updateWithMessages:(NSMutableArray*)messages;
- (NSMutableArray*)messages;

@end
