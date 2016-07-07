//
//  PPBaseMessagesViewController.m
//  PPMessage
//
//  Created by PPMessage on 3/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPBaseMessagesViewController.h"
#import "PPChattingView.h"

#import "PPMessageItemBaseView.h"
#import "PPMessageItemLeftTextView.h"
#import "PPMessageItemLeftImageView.h"
#import "PPMessageItemLeftFileView.h"
#import "PPMessageItemRightFileView.h"
#import "PPMessageItemRightTextView.h"
#import "PPMessageItemRightImageView.h"
#import "PPMessageImageMediaPart.h"
#import "PPMessageFileMediaPart.h"
#import "PPMessageItemLeftLargeTxtView.h"
#import "PPMessageItemRightLargeTxtView.h"
#import "PPMessageItemLeftUnknownView.h"
#import "PPMessageItemRightUnknownView.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPLog.h"
#import "UIImage+PPSDK.h"
#import "UIViewController+PPAnimating.h"

#import "PPMessage.h"
#import "PPConversationItem.h"
#import "PPUser.h"
#import "PPMessageWebSocketSender.h"
#import "PPMessageSendProtocol.h"

#import "PPSDK.h"

#import "PPMessageSendManager.h"
#import "PPMessageControllerKeyboardDelegate.h"

#import "PPBaseMessagesViewControllerDataSource.h"
#import "PPBaseMessagesViewController+PPMessageHistory.h"

#import "PPStoreManager.h"
#import "PPMessagesStore.h"

#import "PPTestData.h"

// scroll Y值小于这个之后，触发下拉刷新操作
static CGFloat const kPPChattingViewControllerPullToRefreshY = -75;

@interface PPBaseMessagesViewController ()<UITextViewDelegate, PPMessageInputToolbarDelegate>

@property (nonatomic) PPChattingView *chattingView;
@property (nonatomic) UIImage *imagePlaceholder;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) PPMessageControllerKeyboardDelegate *keyboardDelegate;

@property (nonatomic) PPMessagesStore *messagesStore;

@end

@implementation PPBaseMessagesViewController

- (void)loadView {
    [super loadView];

    self.chattingView = [PPChattingView new];
    self.chattingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.chattingView];
    PPPaddingAll(self.chattingView, self.view, 0);
    
    self.tableView = self.chattingView.chattingMessagesCollectionView;
    self.tableView.contentOffset = CGPointZero;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.delegate = self;
    // 键盘回车键用来发送
    self.chattingView.inputToolbar.textInputView.returnKeyType = UIReturnKeySend;
    self.chattingView.inputToolbar.textInputView.enablesReturnKeyAutomatically = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellClass];
    [self setupTableView];
    
    if (self.conversationUUID) {
        [self.messagesDataSource updateWithMessages:[self.messagesStore messagesInCovnersation:self.conversationUUID autoCreate:YES]];
        [self.keyboardDelegate keepTableViewContentAtBottomQuickly];
    }
    
    // Show test data
    [self.keyboardDelegate keepTableViewContentAtBottomQuickly];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.chattingView.inputToolbar.inputToolbarDelegate = self;
    [self addApplicationObserver];
    [self addPPSDKObserver];
    [self addKeyboardObserver];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.chattingView.inputToolbar.inputToolbarDelegate = nil;
    self.keyboardDelegate = nil;
    [self removePPSDKObserver];
    [self removeApplicationObserver];
    [self removeKeyboardObserver];
}

- (void)setupTableView {
    self.messagesDataSource = [[PPBaseMessagesViewControllerDataSource alloc] initWithController:self];
    self.tableView.dataSource = self.messagesDataSource;
}

#pragma mark - Init Methods

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.chattingView.inputToolbar.textInputView.delegate = nil;
    self.chattingView.inputToolbar.delegate = nil;
    self.keyboardDelegate = nil;
}

#pragma mark -

- (void)endEditing {
    [self.chattingView endEditing:YES];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPMessage *message = [self.messagesDataSource itemAtIndexPath:indexPath];
    return [PPMessageItemBaseView cellHeightForMessage:message inView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self endEditing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.chattingView.inputToolbar.textInputView resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    
    if (currentOffset < kPPChattingViewControllerPullToRefreshY) {
        [self onPagePullToRefreshAction];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    [self.keyboardDelegate scrollToBottomAnimated:animated];
}

#pragma mark -

- (void)reloadTableView {
    [self reloadTableViewWithMessages:[self.messagesDataSource messages]];
}

- (void)reloadTableViewWithMessages:(NSMutableArray *)messages {
    [self reloadTableViewWithMessages:messages scrollToBottom:NO];
}

- (void)reloadTableViewWithMessages:(NSMutableArray *)messages
                     scrollToBottom:(BOOL)scrollToBottom {
    [self.messagesDataSource updateWithMessages:messages];
    [self.tableView reloadData];
    if (scrollToBottom) {
        [self scrollToBottomAnimated:YES];
    }
}

#pragma mark - on page pull to refresh

- (void)onPagePullToRefreshAction {
}

#pragma mark - InputToolbar Delegate

- (void)didHeightChanged:(PPMessageInputToolbar *)inputToolbar
                  height:(CGFloat)height
              heightDiff:(CGFloat)heightDiff {
    PPFastLog(@"**didHeightChanged:%f**", heightDiff);
    [self.keyboardDelegate didHeightChanged:inputToolbar height:height heightDiff:heightDiff];
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // 发送文本信息
        [[PPMessageSendManager getInstance] sendText:textView.text withConversation:self.conversationUUID completion:^(PPMessage *message, id obj, PPMessageSendState state) {
            switch (state) {
                case PPMessageSendStateErrorNoConversationId:
                    break;
                    
                case PPMessageSendStateBeforeSend:
                    PPAddTimestampIfNeedToMessage([self.messagesDataSource messages], message); // add timestamp if need
                    break;
                    
                case PPMessageSendStateSendOut:
                    [self reloadTableViewWithMessages:obj scrollToBottom:YES];
                    [self.keyboardDelegate moveUpTableView];
                    break;
                    
                case PPMessageSendStateError:
                    [self reloadTableView];
                    break;
            }
        }];
        textView.text = @"";
        return NO;
    }
    return YES;
}

// ===========================
// Getter - Setter
// ===========================

- (void)setConversationTitle:(NSString *)conversationTitle {
    _conversationTitle = conversationTitle;
    self.navigationItem.title = conversationTitle;
}

- (UIImage*)imagePlaceholder {
    if (!_imagePlaceholder) {
        _imagePlaceholder = [UIImage pp_defaultAvatarImage];
    }
    return _imagePlaceholder;
}

- (PPMessageControllerKeyboardDelegate*)keyboardDelegate {
    if (!_keyboardDelegate) {
        _keyboardDelegate = [[PPMessageControllerKeyboardDelegate alloc] initWithTableView:self.tableView inputToolbar:self.chattingView.inputToolbar];
    }
    return _keyboardDelegate;
}

- (PPMessagesStore*)messagesStore {
    if (!_messagesStore) {
        _messagesStore = [PPStoreManager instanceWithClient:[PPSDK sharedSDK]].messagesStore;
    }
    return _messagesStore;
}

// =========================================
// UITableView - Register Cell Class
// =========================================
- (void)registerCellClass {
    PPChattingMessagesCollectionView *chattingMessagesCollectionView = self.chattingView.chattingMessagesCollectionView;
    // Register classes
    // (incoming)
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftTextView class] forCellReuseIdentifier:PPMessageItemLeftTextViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftImageView class] forCellReuseIdentifier:PPMessageItemLeftImageViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftFileView class] forCellReuseIdentifier:PPMessageItemLeftFileViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftLargeTxtView class] forCellReuseIdentifier:PPMessageItemLeftLargeTxtViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftUnknownView class] forCellReuseIdentifier:PPMessageItemLeftUnknownViewIdentifier];
    
    // (outgoing)
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightTextView class] forCellReuseIdentifier:PPMessageItemRightTextViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightImageView class] forCellReuseIdentifier:PPMessageItemRightImageViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightFileView class] forCellReuseIdentifier:PPMessageItemRightFileViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightLargeTxtView class] forCellReuseIdentifier:PPMessageItemRightLargeTxtViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightUnknownView class] forCellReuseIdentifier:PPMessageItemRightUnknownViewIdentifier];
}

// ==========================
// Notification
// ==========================

- (void)addPPSDKObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageArrived:) name:PPSDKMessageArrived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSendFailed:) name:PPSDKMessageSendFailed object:nil];
}

- (void)removePPSDKObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PPSDKMessageArrived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PPSDKMessageSendFailed object:nil];
}

- (void)addApplicationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeApplicationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)notification {
    PPFastLog(@"**keyboardWillShow**");
    [self.keyboardDelegate keyboardWillShow:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    PPFastLog(@"**keyboardWillHide**");
    [self.keyboardDelegate keyboardWillHide:notification];
}

- (void)applicationIsActive:(NSNotification *)notification {
    PPFastLog(@"Application Did Become Active");
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    PPFastLog(@"Application Entered Foreground");
}

- (void)messageArrived:(NSNotification *)notification {
    [self scrollToBottomAnimated:YES];
}

- (void)messageSendFailed:(NSNotification *)notification {
    NSDictionary *notifyObj = notification.object;
    NSString *conversationUUID = notifyObj[@"converstion_uuid"];
    if ([self isActiveForConversationUUID:conversationUUID]) {
        [self reloadTableView];
    }
}

// =================
// Helper
// =================

// Whether or not we are chatting with `conversationUUID`
- (BOOL)isActiveForConversationUUID:(NSString*)conversationUUID {
    return self.conversationUUID != nil &&
    conversationUUID != nil &&
    [self.conversationUUID isEqualToString:conversationUUID];
}

// =================
// Loading
// =================
- (void)showLoadingView {
    [self pp_startAnimating];
}

- (void)dismissLoadingView {
    [self pp_stopAnimating];
}

@end

