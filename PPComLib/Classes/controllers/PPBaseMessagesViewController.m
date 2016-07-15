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
#import "PPMessageItemLeftVoiceView.h"
#import "PPMessageItemRightVoiceView.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPLog.h"
#import "UIImage+PPSDK.h"
#import "UIViewController+PPAnimating.h"
#import "PPBaseMessagesViewController+PPVoiceMessage.h"

#import "PPMessage.h"
#import "PPConversationItem.h"
#import "PPUser.h"
#import "PPMessageSendProtocol.h"

#import "PPSDK.h"

#import "PPMessageSendManager.h"
#import "PPMessageControllerKeyboardDelegate.h"

#import "PPBaseMessagesViewControllerDataSource.h"

#import "PPStoreManager.h"
#import "PPMessagesStore.h"

#import "PPVoiceRecordHelper.h"
#import "PPAudioPlayerHelper.h"

#import "PPTestData.h"

@interface PPBaseMessagesViewController ()<UITextViewDelegate, PPMessageInputToolbarDelegate>

@property (nonatomic) PPChattingView *chattingView;
@property (nonatomic) UIImage *imagePlaceholder;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *testMessages;

@property (nonatomic) PPMessageControllerKeyboardDelegate *keyboardDelegate;

@property (nonatomic) PPBaseMessagesViewControllerDataSource *messagesDataSource;
@property (nonatomic) PPMessagesStore *messagesStore;

// Manage record tools
@property (nonatomic) PPVoiceRecordHelper *voiceRecordHelper;
// Is exceeded
@property (nonatomic) BOOL isMaxTimeStop;

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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(onPagePullToRefreshAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.delegate = self;
    self.chattingView.inputToolbar.inputToolbarDelegate = self;
    self.chattingView.inputToolbar.textInputView.delegate = self;
    
    // 键盘回车键用来发送
    self.chattingView.inputToolbar.textInputView.returnKeyType = UIReturnKeySend;
    self.chattingView.inputToolbar.textInputView.enablesReturnKeyAutomatically = YES;
    
    [self registerCellClass];
    [self setupTableView];
    
    if (self.conversationUUID) {
        [self.messagesDataSource updateWithMessages:[self messagesInMemory]];
        [self.keyboardDelegate keepTableViewContentAtBottomQuickly];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addApplicationObserver];
    [self addPPSDKObserver];
    [self addKeyboardObserver];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removePPSDKObserver];
    [self removeApplicationObserver];
    [self removeKeyboardObserver];
    
    // Audio
    [PPAudioPlayerHelper shareInstance].delegate = nil;
    [[PPAudioPlayerHelper shareInstance] stopAudio];
    [self pp_stopOnPlayingVoice];
    
}

- (void)setupTableView {
    self.messagesDataSource = [[PPBaseMessagesViewControllerDataSource alloc] initWithController:self];
    self.tableView.dataSource = self.messagesDataSource;
}

#pragma mark - Init Methods

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.chattingView.inputToolbar.inputToolbarDelegate = nil;
    self.chattingView.inputToolbar.textInputView.delegate = nil;
    self.keyboardDelegate = nil;
    [PPAudioPlayerHelper shareInstance].delegate = nil;
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

- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    PPFastLog(@"prepareRecordingWithCompletion");
    [self prepareRecordWithCompletion:completion];
}

- (void)didStartRecordingVoiceAction {
    PPFastLog(@"didStartRecordingVoice");
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    PPFastLog(@"didCancelRecordingVoice");
    [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction {
    PPFastLog(@"didFinishRecoingVoice");
    if (self.isMaxTimeStop == NO) {
        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}

- (void)didDragOutsideAction {
    PPFastLog(@"didDragOutsideAction");
    [self resumeRecord];
}

- (void)didDragInsideAction {
    PPFastLog(@"didDragInsideAction");
    [self pauseRecord];
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendText:textView.text];
        textView.text = @"";
        return NO;
    }
    return YES;
}

// =========================
// Send Message
// =========================

- (void)sendText:(NSString*)text {
    __weak typeof(self) wself = self;
    [[PPMessageSendManager getInstance] sendText:text
                                withConversation:self.conversationUUID
                                      completion:^(PPMessage *message, id obj, PPMessageSendState state) {
        [wself handleMessage:message sendState:state extraObj:obj];
    }];
}

- (void)sendAudioWithFilePath:(NSString*)audioFilePath withAudioDuration:(NSTimeInterval)duration {
    __weak typeof(self) wself = self;
    [[PPMessageSendManager getInstance] sendAudio:audioFilePath
                                    audioDuration:duration
                                     conversation:self.conversationUUID
                                       completion:^(PPMessage *message, id obj, PPMessageSendState state) {
        [wself handleMessage:message sendState:state extraObj:obj];
    }];
}

- (void)handleMessage:(PPMessage*)message sendState:(PPMessageSendState)state extraObj:(id)obj {
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

- (PPVoiceRecordHelper*)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        typeof(self) __weak weakSelf = self;
        _voiceRecordHelper = [PPVoiceRecordHelper new];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            PPFastLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
            UIButton *holdDown = weakSelf.chattingView.inputToolbar.holdToTalkButton;
            holdDown.selected = NO;
            holdDown.highlighted = NO;
            weakSelf.isMaxTimeStop = YES;
            
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
    }
    return _voiceRecordHelper;
}

- (PPVoiceRecord*)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[PPVoiceRecord alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
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
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftVoiceView class] forCellReuseIdentifier:PPMessageItemLeftVoiceViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemLeftUnknownView class] forCellReuseIdentifier:PPMessageItemLeftUnknownViewIdentifier];
    
    // (outgoing)
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightTextView class] forCellReuseIdentifier:PPMessageItemRightTextViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightImageView class] forCellReuseIdentifier:PPMessageItemRightImageViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightFileView class] forCellReuseIdentifier:PPMessageItemRightFileViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightLargeTxtView class] forCellReuseIdentifier:PPMessageItemRightLargeTxtViewIdentifier];
    [chattingMessagesCollectionView registerClass:[PPMessageItemRightVoiceView class] forCellReuseIdentifier:PPMessageItemRightVoiceViewIdentifier];
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
    NSMutableArray *messages = [self messagesInMemory];
    [self reloadTableViewWithMessages:messages scrollToBottom:YES];
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

- (NSMutableArray*)messagesInMemory {
//    return [self.messagesStore messagesInCovnersation:self.conversationUUID autoCreate:YES];
    if (!_testMessages) {
        _testMessages = [[PPTestData sharedInstance] getMessages];
        [self.messagesStore setMessageList:_testMessages forConversation:self.conversationUUID];
    }
    return _testMessages;
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

// =================
// Record
// =================
- (void)prepareRecordWithCompletion:(PPPrepareRecorderCompletion)completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}

- (void)startRecord {
    [self.voiceRecordHUD removeFromSuperview];
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    typeof(self) __weak weakSelf = self;
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        PPFastLog(@"Send voice message: %@, voice duration: %@",
                  weakSelf.voiceRecordHelper.recordPath,
                  weakSelf.voiceRecordHelper.recordDuration);
        [weakSelf sendAudioWithFilePath:weakSelf.voiceRecordHelper.recordPath
                      withAudioDuration:[weakSelf.voiceRecordHelper.recordDuration doubleValue]];
    }];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    typeof(self) __weak weakSelf = self;
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"/PPVoice-%@.m4a", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

@end

