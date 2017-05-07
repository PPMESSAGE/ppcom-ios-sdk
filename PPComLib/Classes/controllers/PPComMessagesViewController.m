//
//  PPComMessagesViewController.m
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import "PPComMessagesViewController.h"
#import "PPGroupMembersViewController.h"

#import "PPBaseMessagesViewController+PPMessageHistory.h"

#import "UIImage+PPSDK.h"

@interface PPComMessagesViewController ()

// Group members icon in the right corner
@property (nonatomic) UIBarButtonItem *groupButtonItem;

@end

@implementation PPComMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.groupButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self messagesInMemory].count <= 0) {
        [self onPagePullToRefreshAction];
    }
}
// ========================
// Group Member Icon
// ========================

- (UIBarButtonItem*)groupButtonItem {
    if (!_groupButtonItem) {
        _groupButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage pp_defaultGroupImage] style:UIBarButtonItemStylePlain target:self action:@selector(onGroupButtonItemClicked:)];
    }
    return _groupButtonItem;
}

- (void)onGroupButtonItemClicked:(id)sender {
    if (!self.conversationUUID) return;
    [self gotoGroupMembersViewController];
}

- (void)gotoGroupMembersViewController {
    PPGroupMembersViewController *groupMembersViewController = [[PPGroupMembersViewController alloc] initWithConversationUUID:self.conversationUUID];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:groupMembersViewController animated:YES];
}

// ========================
// Loading
// ========================
- (void)showLoadingView {
    [super showLoadingView];
}

- (void)dismissLoadingView {
    [super dismissLoadingView];
    self.navigationItem.rightBarButtonItem = self.groupButtonItem;
}

// ========================
// PullToRefresh
// ========================
- (void)onPagePullToRefreshAction {
    [super onPagePullToRefreshAction];

    if (self.conversationUUID == nil) {
        return;
    }

    __weak PPComMessagesViewController *wself = self;
    [self showLoadingView];
    [self pp_loadMessageHistory:^{
        __strong PPComMessagesViewController *self = wself;
        [self dismissLoadingView];
        [self reloadTableView];
        [self.refreshControl endRefreshing];
    }];
}

@end
