//
//  PPConversationsViewController.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationsViewController.h"
#import "PPConversationsViewControllerDataSource.h"

#import "PPConversationsStore.h"

#import "PPConversationItem.h"
#import "PPConversationItemViewCell.h"

#import "PPComConversationViewController.h"

#import "PPGetConversationInfoHttpModel.h"
#import "PPGetWaitingQueueLengthHttpModel.h"

#import "PPSDK.h"
#import "PPLog.h"
#import "PPPolling.h"
#import "PPSDKUtils.h"
#import "PPMessage.h"
#import "PPMessageUtils.h"
#import "PPVoiceRecord.h"
#import "PPServiceUser.h"
#import "PPComLoadingView.h"

#import "NSString+PPSDK.h"
#import "UIViewController+PPAnimating.h"

// #import "PPTestData.h"

@interface PPConversationsViewController () <PPSDKDelegate>

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) PPConversationsStore *store;
@property (nonatomic) PPConversationsViewControllerDataSource *dataSource;

@property (nonatomic) PPComLoadingView *loadingView;
@property (nonatomic) PPPolling *pollingConversation;

@end

@implementation PPConversationsViewController

- (instancetype) init {
    if (self = [super init]) {
        self.sdk = [PPSDK sharedSDK];
        self.sdk.sdkDelegate = self;
        self.store = [PPConversationsStore storeWithClient:self.sdk];
        self.dataSource = [[PPConversationsViewControllerDataSource alloc] initWithCellIdentifier:PPConversationItemViewCellIdentifier];
    }
    return self;
}


#pragma mark - UITableView events

- (void)loadView {
    [super loadView];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PPConversationItemViewCell class] forCellReuseIdentifier:PPConversationItemViewCellIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.dataSource;
    self.title = [NSString pp_LocaliziedStringForKey:@"Conversations Controller Title"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addPPSDKObservers];
    [self addApplicationObservers];
    
    if ([self.sdk isStarted]) {
        [self reloadTableView];
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
    
    PPConversationItem *item = [self.dataSource objectAtIndex:indexPath];
    
    [self openConversationWithConversationItem:item];
}


#pragma mark - UITableView helpers

- (void)reloadTableView {

    NSArray *sortedConversations = [self.store sortedConversations];
    NSOrderedSet *orderedConversations = [NSOrderedSet orderedSetWithArray:sortedConversations];

    [self.dataSource updateItemsWithConversations:orderedConversations];
    [self.tableView reloadData];
}


#pragma mark - Observers

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
    [self.sdk reset];
}


#pragma mark - SDK Delegates

// ===========================
// PPSDK Delegate
// ===========================

- (void)didPPSDKStartUpSucceded:(PPSDK*)sdk {
    [self getDefaultConversation];
}

- (void)didPPSDKStartUpFailed:(PPSDK*)sdk errorInfo:(id)errorInfo {
    PPFastLog(@"StartUpError:%@", errorInfo);
}


#pragma mark - Conversation Helpers

// ================================================================================================
// PPConversation - Get default conversation | Waiting | Show/Hide Loading View
// ================================================================================================

- (void)openConversationWithConversationItem:(PPConversationItem *)item {
    
    PPComConversationViewController *controller = [PPComConversationViewController new];
    
    controller.conversationUUID = item.uuid;
    controller.conversationTitle = item.conversationName;

    [self removeAllObservers];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getDefaultConversation {

    __weak PPConversationsViewController *wself = self;

    [self.store asyncGetDefaultConversationWithCompletedBlock:^(PPConversationItem *conversation) {

        if (conversation) {
            [self getAllConversations];
        } else {
            [self onFailedGetDefaultConversation];
        }
    }];
}

- (void) setDefaultConversationByUUID:(NSString *)conversationUUID {

    PPGetConversationInfoHttpModel *model = [[PPGetConversationInfoHttpModel alloc] initWithClient:self.sdk];
    
    [model getWithConversationUUID:conversationUUID completedBlock:^(PPConversationItem *conversation, NSDictionary *response, NSError *error) {

        if (!conversation) {
            // Should not be here ... if goes here, just keep current loading state ...
            return;
        }

        if (![self.store isDefaultConversationAvaliable]) {
            [self.store addDefaultConversation:conversation];
        }

        [self getAllConversations];
    }];
}

- (void)onFailedGetDefaultConversation {

    [self showLoadingView];

    self.pollingConversation = [[PPPolling alloc] initWithClient:self.sdk];
    
    [self.pollingConversation runWithExecutingCode:^{

        __weak PPConversationsViewController *wself = self;

        PPGetWaitingQueueLengthHttpModel *getWaitingQueueLengthTask = [PPGetWaitingQueueLengthHttpModel modelWithClient:self.sdk];

        [getWaitingQueueLengthTask getWaitingQueueLengthWithCompletedBlock:^(NSNumber *waitingQueueLength, NSDictionary *response, NSError *error) {

            NSString *conversationUUID = response[@"conversation_uuid"];

            if (PPIsNotNull(conversationUUID)) {
                [wself setDefaultConversationByUUID:conversationUUID];
                [wself cancelPolling];
                [wself dismissLoadingView];
            }
        }];
    }];
}

- (void)getAllConversations {

    __weak PPConversationsViewController *wself = self;
    
    [wself.store sortedConversationsWithBlock:^(NSArray *conversations, NSError *error) {

        [wself reloadTableView];
        [wself endLoading];

        // open latest conversation immediately
        [wself openConversationWithConversationItem:conversations[0]];
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

#pragma mark - loading

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

@end
