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

@property (nonatomic) PPBaseMessagesViewControllerDataSource *messagesDataSource;

- (void)applicationIsActive:(NSNotification *)notification;
- (void)applicationEnteredForeground:(NSNotification *)notification;

- (void)endEditing;

// Page pull to refresh action triggered
- (void)onPagePullToRefreshAction;

// ===============
// Loading
// ===============
- (void)showLoadingView;
- (void)dismissLoadingView;

@end
