//
//  PPBaseMessagesViewController.h
//  PPMessage
//
//  Created by PPMessage on 3/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPConversationItem, PPMessage;

@interface PPBaseMessagesViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) NSString *conversationTitle;
@property (nonatomic) NSString *conversationUUID;

/** TRUE: 显示loading动画，标志当前正在加载数据, FALSE: 不显示loading动画，标志当前数据加载完毕 **/
@property (nonatomic) BOOL inRequesting;

- (void)applicationIsActive:(NSNotification *)notification;
- (void)applicationEnteredForeground:(NSNotification *)notification;

- (void)endEditing;

// Page pull to refresh action triggered
- (void)onPagePullToRefreshAction;

@end
