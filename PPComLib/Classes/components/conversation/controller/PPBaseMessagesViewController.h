//
//  PPBaseMessagesViewController.h
//  PPMessage
//
//  Created by PPMessage on 3/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPVoiceRecord.h"

@class PPConversationItem, PPMessage, PPBaseMessagesViewControllerDataSource, PPMessageItemBaseView;

@interface PPBaseMessagesViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) NSString *conversationTitle;
@property (nonatomic) NSString *conversationUUID;

@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) PPVoiceRecord *voiceRecordHUD;

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

// Helper
- (NSMutableArray*)messagesInMemory;

// ===============
// Loading
// ===============
- (void)showLoadingView;
- (void)dismissLoadingView;

// send
- (void)sendImage:(UIImage *)image;

@end
