//
//  PPComMessagesViewController.m
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import "PPComMessagesViewController.h"
#import "PPGroupMembersViewController.h"

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

@end
