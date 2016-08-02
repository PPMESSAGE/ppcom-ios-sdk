//
//  PPConversationListViewController.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationsViewController.h"
#import "PPComMessagesViewController.h"

#import "PPConversationItemViewCell.h"
#import "PPComLoadingView.h"

#import "PPConversationItem.h"

#import "PPLog.h"
#import "PPSDKUtils.h"
#import "PPMessageUtils.h"
#import "PPPolling.h"

#import "PPSDK.h"
#import "PPServiceUser.h"
#import "PPMessage.h"

#import "PPStoreManager.h"
#import "PPConversationsStore.h"

#import "PPConversationsViewControllerDataSource.h"
#import "PPConversationItemViewCell+PPConfigureForConversationItem.h"

#import "PPGetConversationInfoHttpModel.h"
#import "PPGetWaitingQueueLengthHttpModel.h"

#import "NSString+PPSDK.h"
#import "UIViewController+PPAnimating.h"

#import "PPTestData.h"
#import "PPVoiceRecord.h"

@interface PPConversationsViewController () <PPSDKDelegate>

@property (nonatomic) PPConversationsStore *conversationsStore;
@property (nonatomic) PPConversationsViewControllerDataSource *conversationsDataSource;

@property (nonatomic) PPComLoadingView *loadingView;
@property (nonatomic) PPPolling *pollingConversation;

@end

@implementation PPConversationsViewController

- (void)loadView {
    [super loadView];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PPConversationItemViewCell class] forCellReuseIdentifier:PPConversationItemViewCellIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString pp_LocaliziedStringForKey:@"Conversations Controller Title"];
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
    [PPSDK sharedSDK].sdkDelegate = self;
    
    [self addPPSDKObservers];
    [self addApplicationObservers];
    
    if ([[PPSDK sharedSDK] isStarted]) {
        [self.conversationsDataSource updateItemsWithConversations:[NSOrderedSet orderedSetWithArray:[self.conversationsStore sortedConversations]]];
        [self.tableView reloadData];
    } else {
        [self showActivityIndicatorViewLoading];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed
        [self onBackButtonPressed];
    }
    [super viewWillDisappear:animated];
    [self removeAllObservers];
    [self dismissLoadingView];
    [self cancelPolling];
}

#pragma mark - UITableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PPConversationItemViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PPConversationItem *item = [self.conversationsDataSource objectAtIndex:indexPath];
    
    [self openConversationWithConversationItem:item];
}

#pragma mark - reload data

- (void)reloadTableViewWithArray:(NSOrderedSet*)conversations {
    [self.conversationsDataSource updateItemsWithConversations:conversations];
    [self.tableView reloadData];
}

// ===================
// Notification
// ===================

- (void)addPPSDKObservers {
    // add message arrived observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageArrived:) name:PPSDKMessageArrived object:nil];
}

- (void)removePPSDKObservers {
    // remove message arrived observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PPSDKMessageArrived object:nil];
}

- (void)addApplicationObservers {
    // add application become active observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // add application enter foreground observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeApplicationObservers {
    // remove application become active observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    // remove application enter foreground observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeAllObservers {
    [self removePPSDKObservers];
    [self removeApplicationObservers];
}

- (void)applicationIsActive:(NSNotification *)notification {
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
}

- (void)onMessageArrived:(NSNotification *)notification {
    [self.tableView reloadData];
}

// ===========================
// Back Button Pressed
// ===========================
- (void)onBackButtonPressed {
    [[PPSDK sharedSDK] reset];
}

// ===========================
// PPSDK Delegate
// ===========================
- (void)didPPSDKStartUpSucceded:(PPSDK*)sdk {
    [self getDefaultConversation];
}

- (void)didPPSDKStartUpFailed:(PPSDK*)sdk errorInfo:(id)errorInfo {
    PPFastLog(@"StartUpError:%@", errorInfo);
}

#pragma mark - conversation helpers

// ================================================================================================
// PPConversation - Get default conversation | Waiting | Show/Hide Loading View
// ================================================================================================

- (void)openConversationWithConversationItem:(PPConversationItem *)item {
    
    PPComMessagesViewController *controller = [[PPComMessagesViewController alloc] init];
    
    controller.conversationUUID = item.uuid;
    controller.conversationTitle = item.conversationName;
    
    [self removeAllObservers];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getDefaultConversation {
    PPStoreManager *storeManager = [PPStoreManager instanceWithClient:[PPSDK sharedSDK]];
    __weak PPConversationsViewController *wself = self;
    [storeManager.conversationStore asyncGetDefaultConversationWithCompletedBlock:^(PPConversationItem *conversation) {
        if (!conversation) {
            [self onFailedGetDefaultConversation:wself];
        } else {
            [self getAllConversations:wself storeManager:storeManager];
        }
    }];
}

- (void) setDefaultConversationByUUID:(__weak PPConversationsViewController *)wself conversationUUID:(NSString *)conversationUUID {
    PPGetConversationInfoHttpModel *model = [[PPGetConversationInfoHttpModel alloc] initWithClient:[PPSDK sharedSDK]];
    [model getWithConversationUUID:conversationUUID completedBlock:^(PPConversationItem *conversation, NSDictionary *response, NSError *error) {
        if (conversation) {
            PPConversationsStore *conversationStore = [PPStoreManager instanceWithClient:[PPSDK sharedSDK]].conversationStore;
            if (![conversationStore isDefaultConversationAvaliable]) {
                [conversationStore addDefaultConversation:conversation];
            }
            
            [self getAllConversations:self storeManager:[PPStoreManager instanceWithClient:[PPSDK sharedSDK]]];
        } else {
            // Should not be here ... if goes here, just keep current loading state ...
        }
    }];
}

- (void)onFailedGetDefaultConversation:(__weak PPConversationsViewController *)wself {
    [self showLoadingView];
    self.pollingConversation = [[PPPolling alloc] initWithClient:[PPSDK sharedSDK]];
    [self.pollingConversation runWithExecutingCode:^{
        PPGetWaitingQueueLengthHttpModel *getWaitingQueueLengthTask = [PPGetWaitingQueueLengthHttpModel modelWithClient:[PPSDK sharedSDK]];
        [getWaitingQueueLengthTask getWaitingQueueLengthWithCompletedBlock:^(NSNumber *waitingQueueLength, NSDictionary *response, NSError *error) {
            NSString *conversationUUID = response[@"conversation_uuid"];
            if (PPIsNotNull(conversationUUID)) {
                [wself setDefaultConversationByUUID:wself conversationUUID:conversationUUID];
                [self cancelPolling];
                [self dismissLoadingView];
                return;
            }
        }];
    }];
}

- (void)getAllConversations:(__weak PPConversationsViewController *)wself storeManager:(PPStoreManager *)storeManager {
    [storeManager.conversationStore sortedConversationsWithBlock:^(NSArray *conversations, NSError *error) {
        
        [wself.conversationsDataSource updateItemsWithConversations:[NSOrderedSet orderedSetWithArray:conversations]];
        [wself.tableView reloadData];
        [wself endLoading];
        
        // open latest conversation immediately
        [self openConversationWithConversationItem:conversations[0]];
    }];
}

- (void)cancelPolling {
    if (_pollingConversation) {
        [_pollingConversation cancel];
        _pollingConversation = nil;
    }
}

// ===========================
// Loading
// ===========================

- (void)showLoadingView {
    [self.view addSubview:self.loadingView];
}

- (void)dismissLoadingView {
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
}

- (void)showActivityIndicatorViewLoading {
    [self pp_startAnimating];
}

- (void)dismissActivityIndicatorViewLoading {
    [self pp_stopAnimating];
}

- (void)endLoading {
    [self dismissLoadingView];
    [self dismissActivityIndicatorViewLoading];
}

// ===========================
// Getter Setter
// ===========================
- (PPComLoadingView*)loadingView {
    if (!_loadingView) {
        _loadingView = [[PPComLoadingView alloc] init];
        _loadingView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    }
    return _loadingView;
}

- (PPConversationsStore*)conversationsStore {
    if (!_conversationsStore) {
        _conversationsStore = [PPStoreManager instanceWithClient:[PPSDK sharedSDK]].conversationStore;
    }
    return _conversationsStore;
}

@end
