//
//  PPGroupMembersViewController.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPGroupMembersViewController.h"
#import "PPComMessagesViewController.h"

#import "PPServiceUser.h"
#import "PPSDK.h"
#import "PPUser.h"

#import "PPSDKUtils.h"
#import "UIViewController+PPAnimating.h"

#import "PPGroupMembersCollectionViewLayout.h"
#import "PPGroupMembersDataSource.h"
#import "PPGroupMemberViewCell.h"

#import "PPStoreManager.h"
#import "PPGroupMembersStore.h"
#import "PPConversationsStore.h"

#import "PPTestData.h"

typedef void(^findConversationBlock)(PPConversationItem *conversation, BOOL success);

@interface PPGroupMembersViewController ()

@property (nonatomic) PPSDK *sdk;

@property (nonatomic) PPGroupMembersStore *groupMembersStore;
@property (nonatomic) PPConversationsStore *conversationsStore;

@property (nonatomic) NSString *conversationUUID;
@property (nonatomic) PPGroupMembersDataSource *groupMemberDataSource;

@end

@implementation PPGroupMembersViewController

#pragma mark - Constructor

- (instancetype)initWithConversationUUID:(NSString *)conversationUUID {
    if (self = [super initWithCollectionViewLayout:[PPGroupMembersCollectionViewLayout new]]) {
        self.conversationUUID = conversationUUID;
    }
    return self;
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PPGroupMemberViewCell class] forCellWithReuseIdentifier:PPGroupMemberViewCellIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
    
    [self updateTitleWithGroupMembersCount:0];
    
    [self setUpCollectionView];
}

#pragma mark - private

- (void)setUpCollectionView {
    
    NSMutableArray *cachedGroupMembers = [self groupMembersInConversationUUID:self.conversationUUID];
    self.groupMemberDataSource = [[PPGroupMembersDataSource alloc] initWithGroupMembers:cachedGroupMembers cellIdentifier:PPGroupMemberViewCellIdentifier withClient:self.sdk configurationBlock:^(id cell, id item) {
        ((PPGroupMemberViewCell*)cell).groupMember = item;
    }];
    [self updateTitleWithGroupMembersCount:(cachedGroupMembers ? cachedGroupMembers.count : 0)];
    
    self.collectionView.dataSource = self.groupMemberDataSource;
    
    [self pp_startAnimating];
    [self.groupMembersStore groupMembersInConversation:self.conversationUUID findCompleted:^(NSMutableArray *members, BOOL success) {
        if (success) {
            [self updateTitleWithGroupMembersCount:members.count];
            [self.groupMemberDataSource updateGroupMembers:members];
            [self.conversationsStore setMembers:members withConversationUUID:self.conversationUUID];
            [self.collectionView reloadData];
        }
        [self pp_stopAnimating];
    }];
    
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(PPGroupMemberViewCellWidth, PPGroupMemberViewCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PPUser *user = [self.groupMemberDataSource itemAtIndexPath:indexPath];
    
    if (!user.userUuid) return; // user.uuid not exist
    if ([user.userUuid isEqualToString:self.sdk.user.userUuid]) return; // self
    
    findConversationBlock block = ^(PPConversationItem *conversationItem, BOOL success) {
        if (success) {
            [self moveToMessagesViewControllerWithConversation:conversationItem];
        } else {
            PPMakeWarningAlert(PPLocalizedString(@"Create Conversation Error"));
        }
        [self pp_stopAnimating];
    };

    [self pp_startAnimating];
    NSMutableArray *members = [self.groupMembersStore groupMembersInConversation:self.conversationUUID];
    if (members.count == 2) {
        PPConversationItem *conversation = [self.conversationsStore findConversationWithConversationUUID:self.conversationUUID];
        block(conversation, conversation != nil);
        return;
    }
    [self.conversationsStore findConversationAssociatedWithUserUUID:user.userUuid findCompleted:block];
    
}

#pragma mark - helpers

- (void)moveToMessagesViewControllerWithConversation:(PPConversationItem*)conversationItem {
    
    PPComMessagesViewController *messagesViewController = [self messagesViewControllerFromHistoryStack];
    if (messagesViewController) {
        
        messagesViewController.conversationTitle = conversationItem.conversationName;
        messagesViewController.conversationUUID = conversationItem.uuid;
        
        [self.navigationController popToViewController:messagesViewController animated:YES];
    }
}

- (PPComMessagesViewController*)messagesViewControllerFromHistoryStack {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    __block PPComMessagesViewController *messagesViewControllerFromHistory = nil;
    [navigationArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PPComMessagesViewController class]]) {
            messagesViewControllerFromHistory = obj;
            *stop = YES;
        }
    }];
    return messagesViewControllerFromHistory;
}

#pragma mark - getter setter

- (PPGroupMembersStore*)groupMembersStore {
    if (!_groupMembersStore) {
        _groupMembersStore = [PPStoreManager instanceWithClient:self.sdk].groupMembersStore;
    }
    return _groupMembersStore;
}

- (PPConversationsStore*)conversationsStore {
    if (!_conversationsStore) {
        _conversationsStore = [PPStoreManager instanceWithClient:self.sdk].conversationStore;
    }
    return _conversationsStore;
}

- (void)updateTitleWithGroupMembersCount:(NSInteger)count {
    if (count > 0) {
        self.title = [NSString stringWithFormat:PPLocalizedString(@"Group Member Controller Title With Number"), [NSNumber numberWithInteger:count]];
    } else {
        self.title = PPLocalizedString(@"Group Member Controller Title");
    }
}

- (PPSDK*)sdk {
    if (!_sdk) {
        _sdk = [PPSDK sharedSDK];
    }
    return _sdk;
}

#pragma mark - Group members datasource

- (NSMutableArray*)groupMembersInConversationUUID:(NSString *)conversationUUID {
    return [self.groupMembersStore groupMembersInConversation:conversationUUID];
}

@end
