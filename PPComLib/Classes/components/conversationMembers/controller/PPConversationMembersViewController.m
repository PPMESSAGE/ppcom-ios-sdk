//
//  PPConversationMembersViewController.m
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import "PPConversationMembersViewController.h"
#import "PPComConversationViewController.h"

#import "PPServiceUser.h"
#import "PPSDK.h"
#import "PPUser.h"

#import "PPSDKUtils.h"
#import "UIViewController+PPAnimating.h"

#import "PPConversationMembersCollectionViewLayout.h"
#import "PPConversationMembersDataSource.h"
#import "PPConversationMemberViewCell.h"

#import "PPStoreManager.h"
#import "PPConversationMembersStore.h"
#import "PPConversationsStore.h"

#import "PPTestData.h"

typedef void(^findConversationBlock)(PPConversationItem *conversation, BOOL success);

@interface PPConversationMembersViewController ()

@property (nonatomic) PPSDK *sdk;

@property (nonatomic) PPConversationMembersStore *conversationMembersStore;
@property (nonatomic) PPConversationsStore *conversationsStore;

@property (nonatomic) NSString *conversationUUID;
@property (nonatomic) PPConversationMembersDataSource *conversationMemberDataSource;

@end

@implementation PPConversationMembersViewController

#pragma mark - Constructor

- (instancetype)initWithConversationUUID:(NSString *)conversationUUID {
    if (self = [super initWithCollectionViewLayout:[PPConversationMembersCollectionViewLayout new]]) {
        self.conversationUUID = conversationUUID;
    }
    return self;
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PPConversationMemberViewCell class] forCellWithReuseIdentifier:PPConversationMemberViewCellIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
    
    [self updateTitleWithMemberCount:0];
    
    [self setUpCollectionView];
}

#pragma mark - private

- (void)setUpCollectionView {
    
    NSMutableArray *cachedMembers = [self membersInConversationUUID:self.conversationUUID];
    self.conversationMemberDataSource = [[PPConversationMembersDataSource alloc] initWithMembers:cachedMembers
                                                                                  cellIdentifier:PPConversationMemberViewCellIdentifier
                                                                                      withClient:self.sdk
                                                                              configurationBlock:^(id cell, id item) {
            ((PPConversationMemberViewCell*)cell).member = item;
        }];
    
    [self updateTitleWithMemberCount:(cachedMembers ? cachedMembers.count : 0)];
    
    self.collectionView.dataSource = self.conversationMemberDataSource;
    
    [self pp_startAnimating];
    [self.conversationMembersStore membersInConversation:self.conversationUUID findCompleted:^(NSMutableArray *members, BOOL success) {
            if (success) {
                [self updateTitleWithMemberCount:members.count];
                [self.conversationMemberDataSource updateMembers:members];
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
    return CGSizeMake(PPConversationMemberViewCellWidth, PPConversationMemberViewCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PPUser *user = [self.conversationMemberDataSource itemAtIndexPath:indexPath];
    
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
    NSMutableArray *members = [self.conversationMembersStore membersInConversation:self.conversationUUID];
    if (members.count == 2) {
        PPConversationItem *conversation = [self.conversationsStore findConversationWithConversationUUID:self.conversationUUID];
        block(conversation, conversation != nil);
        return;
    }
    [self.conversationsStore findConversationAssociatedWithUserUUID:user.userUuid findCompleted:block];
    
}

#pragma mark - helpers

- (void)moveToMessagesViewControllerWithConversation:(PPConversationItem*)conversationItem {
    
    PPComConversationViewController *messagesViewController = [self messagesViewControllerFromHistoryStack];
    if (messagesViewController) {
        
        messagesViewController.conversationTitle = conversationItem.conversationName;
        messagesViewController.conversationUUID = conversationItem.uuid;
        
        [self.navigationController popToViewController:messagesViewController animated:YES];
    }
}

- (PPComConversationViewController*)messagesViewControllerFromHistoryStack {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    __block PPComConversationViewController *messagesViewControllerFromHistory = nil;
    [navigationArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PPComConversationViewController class]]) {
            messagesViewControllerFromHistory = obj;
            *stop = YES;
        }
    }];
    return messagesViewControllerFromHistory;
}

#pragma mark - getter setter

- (PPConversationMembersStore*)conversationMembersStore {
    if (!_conversationMembersStore) {
        self.conversationMembersStore = [PPStoreManager instanceWithClient:self.sdk].conversationMembersStore;
    }
    return _conversationMembersStore;
}

- (PPConversationsStore*)conversationsStore {
    if (!_conversationsStore) {
        _conversationsStore = [PPStoreManager instanceWithClient:self.sdk].conversationStore;
    }
    return _conversationsStore;
}

- (void)updateTitleWithMemberCount:(NSInteger)count {
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

#pragma mark - conversation members datasource

- (NSMutableArray*)membersInConversationUUID:(NSString *)conversationUUID {
    return [self.conversationMembersStore membersInConversation:conversationUUID];
}

@end
