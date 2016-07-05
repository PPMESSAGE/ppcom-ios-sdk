//
//  PPConversationListViewController.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationsViewController.h"

#import "PPConversationItemViewCell.h"
#import "PPComMessagesViewController.h"
#import "PPBadgeSquareImageView.h"

#import "PPConversationItem.h"

#import "PPLog.h"
#import "PPSDKUtils.h"
#import "PPReceiver.h"
#import "PPMessageUtils.h"

#import "PPSDK.h"
#import "PPServiceUser.h"
#import "PPMessage.h"
#import "PPWebSocketPool.h"

#import "PPMemoryCache.h"
#import "PPBooleanDictionaryMemoryCache.h"

#import "PPConversationsViewControllerDataSource.h"
#import "PPConversationItemViewCell+PPConfigureForConversationItem.h"

#import "PPTestData.h"

@interface PPConversationsViewController ()

@property (nonatomic) BOOL inRequesting;

@property (nonatomic) PPConversationsViewControllerDataSource *conversationsDataSource;

@end

@implementation PPConversationsViewController

- (void)loadView {
    [super loadView];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PPConversationItemViewCell class] forCellReuseIdentifier:PPConversationItemViewCellIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    PPConversationsTableViewConfigureBlock configureCell = ^(PPConversationItemViewCell *cell, PPConversationItem *conversationItem) {
        [cell configureForConversationItem:conversationItem];
    };
    self.conversationsDataSource = [[PPConversationsViewControllerDataSource alloc] initWithCellIdentifier:PPConversationItemViewCellIdentifier configureBlock:configureCell];
    self.tableView.dataSource = self.conversationsDataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [self onPageVisible];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

#pragma mark -

- (void)applicationIsActive:(NSNotification *)notification {
    [self onPageVisible:YES];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
}

- (void)onMessageArrived:(NSNotification *)notification {
    PPMessage *message = notification.object[@"msg"];
    [self pp_onMessageArrived:message];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onPageVisible {
    [self onPageVisible:NO];
}

- (void)onPageVisible:(BOOL)forceRefresh {
    [self.conversationsDataSource updateItemsWithConversations:[[PPTestData sharedInstance] getConversations]];
}

#pragma mark - UITableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PPConversationItemViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PPComMessagesViewController *controller = [[PPComMessagesViewController alloc] init];
    PPConversationItem *item = [self.conversationsDataSource objectAtIndex:indexPath];
    controller.conversationItem = item;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:PPClientNotificationMsgArrived object:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - PPSocketRocketDelegate

- (void)pp_onMessageArrived:(PPMessage *)message {
    PPFastLog(@"==conversations view controller==");
//    [self asyncUpdateMessage:message withBlock:^(BOOL success, id obj, NSDictionary *jobInfo) {
//        self.totalUnreadCount++;
//        [self asyncFetchConversations];
//        ccccccxxxxxxx
//    }];
    // on message arrived: update view
}

#pragma mark - getter setter

- (void)setInRequesting:(BOOL)inRequesting {
    _inRequesting = inRequesting;
    
//    PPTabBarController *tabBarController = (PPTabBarController*)self.parentViewController;
//    
//    if (!tabBarController.selectedViewController ||
//        tabBarController.selectedViewController == self) {
//
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = inRequesting;
//        if (inRequesting) {
//            self.parentViewController.navigationItem.title = PPLocalizedString(@"Loading");
//        } else {
//            self.parentViewController.navigationItem.title = PPLocalizedString(@"Conversations");
//        }
//    }
    // TODO mark we are requesting ...
}

#pragma mark - reload data

- (void)reloadTableViewWithArray:(NSOrderedSet*)conversations {
    [self.conversationsDataSource updateItemsWithConversations:conversations];
    [self.tableView reloadData];
}

@end
