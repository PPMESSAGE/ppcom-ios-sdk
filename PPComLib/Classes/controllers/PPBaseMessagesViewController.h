//
//  PPBaseMessagesViewController.h
//  PPMessage
//
//  Created by PPMessage on 3/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPConversationItem, PPMessage, PPBaseMessagesViewControllerDataSource;

@interface PPBaseMessagesViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) NSString *conversationTitle;
@property (nonatomic) NSString *conversationUUID;

- (void)applicationIsActive:(NSNotification *)notification;
- (void)applicationEnteredForeground:(NSNotification *)notification;

- (void)endEditing;

// Reload table view
- (void)reloadTableView;
- (void)reloadTableViewWithMessages:(NSMutableArray *)messages;
- (void)reloadTableViewWithMessages:(NSMutableArray *)messages
                     scrollToBottom:(BOOL)scrollToBottom;

// Page pull to refresh action triggered
- (void)onPagePullToRefreshAction;

// ===============
// Loading
// ===============
- (void)showLoadingView;
- (void)dismissLoadingView;

@end
