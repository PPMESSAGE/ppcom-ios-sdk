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

#import "PPGroupMembersCollectionViewLayout.h"
#import "PPGroupMembersDataSource.h"
#import "PPGroupMemberViewCell.h"

@interface PPGroupMembersViewController ()

@property (nonatomic) PPSDK *sdk;

@property (nonatomic) NSString *conversationUUID;
@property (nonatomic) PPGroupMembersDataSource *groupMemberDataSource;

@property (nonatomic) BOOL animating;
@property (nonatomic) UIBarButtonItem *animatingButton;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

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
    self.navigationItem.rightBarButtonItem = self.animatingButton;
    
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

    // TODO reload data
//    self.animating = YES;
//    [self.groupMembersStore groupMembersInConversation:self.conversationUUID findCompleted:^(NSMutableArray *members, BOOL success) {
//        if (success) {
//            [self updateTitleWithGroupMembersCount:members.count];
//            [self.groupMemberDataSource updateGroupMembers:members];
//            [self.collectionView reloadData];
//        }
//        self.animating = NO;
//    }];
    
}

//- (NSMutableArray*)mockGroupMembers {
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i=0; i < 14; ++i) {
//        PPUser *user = [[PPUser alloc] initWithClient:self.client uuid:@"xxx" fullName:@"PPMessage" avatarId:nil];
//        [array addObject:user];
//    }
//    return array;
//}

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

    // TODO try find P2S conversation uuid
    
//    self.animating = YES;
//    [self.conversationsStore findConversationAssociatedWithUserUUID:user.uuid findCompleted:^(PPConversationItem *conversationItem, BOOL success) {
//        
//        if (success) {
//            [self moveToMessagesViewControllerWithConversation:conversationItem];
//        } else {
//            PPMakeWarningAlert(@"Can not find conversation");
//        }
//        
//        self.animating = NO;
//        
//    }];
    
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

- (void)updateTitleWithGroupMembersCount:(NSInteger)count {
    if (count > 0) {
        self.title = [NSString stringWithFormat:@"Group(%@)", [NSNumber numberWithInteger:count]];
    } else {
        self.title = @"Group";
    }
}

- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    if (_animating) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (UIBarButtonItem*)animatingButton {
    if (!_animatingButton) {
        _animatingButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    }
    return _animatingButton;
}

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}

#pragma mark - Group members datasource

- (NSMutableArray*)groupMembersInConversationUUID:(NSString *)conversationUUID {
    return nil;
}

@end
