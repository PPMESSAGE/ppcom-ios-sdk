//
//  PPMessageInputToolbar.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageInputToolbar.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPLog.h"
#import "UIImage+PPSDK.h"
#import "UIView+PPBorder.h"
#import "PPSDKUtils.h"

CGFloat const PPChattingViewTextViewBaseLineHeight = 42;
CGFloat const PPTextInputViewPadding = 5.0f;
CGFloat const PPTextInputViewBorderWidth = .5f;

CGFloat const PPAudioButtonDefaultWidth = 32;
CGFloat const PPAudioButtonDefaultHeight = 32;

CGFloat const PPKeyboardButtonDefaultWidth = 32;
CGFloat const PPKeyboardButtonDefaultHeight = 32;

@interface PPMessageInputToolbar ()<PPComposeTextViewLineNumberDelegate>

@property (nonatomic) CGFloat textViewHeight;
@property (nonatomic) BOOL isKeyboardButtonShow;

// Is cancelled record
@property (nonatomic) BOOL isCancelled;
// Is recording
@property (nonatomic) BOOL isRecording;

// input text
@property (nonatomic) NSString *inputedText;

@end

@implementation PPMessageInputToolbar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    _maxLineNumber = 3;
    
    _textInputView = [[PPComposeTextView alloc] init];
    _textInputView.frame = CGRectZero;
    _textInputView.layer.borderColor = [UIColor grayColor].CGColor;
    _textInputView.layer.borderWidth = PPTextInputViewBorderWidth;
    _textInputView.layer.cornerRadius = 5.0f;
    _textInputView.lineNumberDelegate = self;
    [self addSubview:self.textInputView];
    
    // test more button
    _moreButton = [PPButton buttonWithImage:[UIImage pp_defaultMoreImage] withHighlightImage:[UIImage pp_defaultMoreHighlightImage]];
    [self addSubview:_moreButton];
    [_moreButton addTarget:self action:@selector(didMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _audioButton = [PPButton buttonWithImage:[UIImage pp_defaultAudioImage]
                          withHighlightImage:[UIImage pp_defaultAudioHighlightImage]];
    [self addSubview:_audioButton];
    [_audioButton addTarget:self action:@selector(didAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _keyboardButton = [PPButton buttonWithImage:[UIImage pp_defaultKeyboardImage]
                             withHighlightImage:[UIImage pp_defaultKeyboardHighlightImage]];
    [self addSubview:_keyboardButton];
    [_keyboardButton addTarget:self action:@selector(didKeyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _holdToTalkButton = [PPButton new];
    [_holdToTalkButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_holdToTalkButton setTitle:PPLocalizedString(@"HoldToTalk") forState:UIControlStateNormal];
    [_holdToTalkButton setTitle:PPLocalizedString(@"ReleaseToSend") forState:UIControlStateHighlighted];
    [_holdToTalkButton PPMakeBorderWithColor:[UIColor grayColor]];
    _holdToTalkButton.layer.cornerRadius = 5;
    [_holdToTalkButton setBgColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_holdToTalkButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_holdToTalkButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_holdToTalkButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_holdToTalkButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [_holdToTalkButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
    [self addSubview:_holdToTalkButton];
    
    self.isKeyboardButtonShow = NO;
    self.textViewHeight = PPChattingViewTextViewBaseLineHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // more Position
    self.moreButton.frame = [self positionForMoreButton];
    
    // Audio Position
    self.audioButton.frame = [self positionForAudioButton];
    
    // Keyboard Position
    self.keyboardButton.frame = [self positionForKeyboardButton];
    
    // Input tool Bar Position
    self.textInputView.frame = [self positionForTextInputView];
    
    // Hold to talk button position
    self.holdToTalkButton.frame = [self positionForHoldToTalkButton];

}

#pragma mark - line number change delegate

- (void)didLineNumberChangedWith:(NSUInteger)lineNumber
                        textView:(PPComposeTextView *)composeTextView {
    PPFastLog(@"didLineNumberChangeWith:textView:lineNumber:%lu", lineNumber);
    
    if (lineNumber <= self.maxLineNumber) {
        
        [self setTextInputViewBottomInset:.0f];
        
        CGFloat textViewLineHeight = PPChattingViewTextViewBaseLineHeight + (lineNumber - 1) * composeTextView.font.lineHeight;
        CGFloat heightDiff = textViewLineHeight - self.textViewHeight;

        [self.textInputView sizeToFit];
        [self.textInputView scrollRangeToVisible:NSMakeRange(self.textInputView.text.length - 2, 1)];

        CGRect frame = self.frame;
        frame.size.height = textViewLineHeight + PPTextInputViewBorderWidth * 2;
        self.frame = frame;
        
        self.textViewHeight = textViewLineHeight;
        
        if (self.inputToolbarDelegate) {
            if ([self.inputToolbarDelegate respondsToSelector:@selector(didHeightChanged:height:heightDiff:)]) {
                [self.inputToolbarDelegate didHeightChanged:self height:textViewLineHeight heightDiff:heightDiff];
            }
        }
        
    } else {
        
        [self setTextInputViewBottomInset:4.0f];
        
    }
}

- (void)setTextInputViewBottomInset:(CGFloat)bottom {
    UIEdgeInsets insets = self.textInputView.contentInset;
    insets.bottom = bottom;
    self.textInputView.contentInset = insets;
}

// =============================
// Calculate View Positions
// =============================
- (CGRect)positionForLeftButton {
    CGRect toolbarFrame = self.frame;
    CGPoint point = CGPointMake(PPTextInputViewPadding,
                                     (toolbarFrame.size.height - PPAudioButtonDefaultHeight - PPTextInputViewPadding));
    CGSize size = CGSizeMake(PPAudioButtonDefaultWidth, PPAudioButtonDefaultHeight);
    return CGRectMake(point.x, point.y, size.width, size.height);
}

- (CGRect)positionForMoreButton {
    CGRect toolbarFrame = self.frame;
    CGPoint point = CGPointMake(toolbarFrame.size.width - PPTextInputViewPadding - PPAudioButtonDefaultWidth,
                                (toolbarFrame.size.height - PPAudioButtonDefaultHeight - PPTextInputViewPadding));
    CGSize size = CGSizeMake(PPAudioButtonDefaultWidth, PPAudioButtonDefaultHeight);
    return CGRectMake(point.x, point.y, size.width, size.height);
}

- (CGRect)positionForAudioButton {
    return [self positionForLeftButton];
}

- (CGRect)positionForKeyboardButton {
    return [self positionForLeftButton];
}

- (CGRect)positionForHoldToTalkButton {
    CGFloat width = self.frame.size.width - PPTextInputViewPadding * 4 - PPTextInputViewBorderWidth * 2 - self.audioButton.frame.size.width - self.moreButton.frame.size.width;
    CGFloat height = PPChattingViewTextViewBaseLineHeight - PPTextInputViewPadding * 2;
    CGFloat x = PPTextInputViewPadding + self.audioButton.frame.origin.x + self.audioButton.frame.size.width;
    CGFloat y = PPTextInputViewPadding;
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)positionForTextInputView {
    if (!self.holdToTalkButton.hidden) {
        return [self positionForHoldToTalkButton];
    }
    
    CGRect frame = self.textInputView.frame;
    frame.size.width = self.frame.size.width - PPTextInputViewPadding * 4 - PPTextInputViewBorderWidth * 2 - self.audioButton.frame.size.width - self.moreButton.frame.size.width;
    frame.size.height = self.frame.size.height - PPTextInputViewPadding * 2 - PPTextInputViewBorderWidth * 2;
    frame.origin.x = PPTextInputViewPadding + self.audioButton.frame.origin.x + self.audioButton.frame.size.width;
    frame.origin.y = PPTextInputViewPadding;
    return frame;
}


// =============================
// More Button Click Event
// =============================

// more button pressed
- (void)didMoreButtonPressed:(UIButton *)sender {

    [self.textInputView endEditing:YES];
    
    if (self.inputToolbarDelegate && [self.inputToolbarDelegate respondsToSelector:@selector(openActionSheet)]) {
        [self.inputToolbarDelegate openActionSheet];
    }
}


// =============================
// Audio Button Click Event
// =============================

// audio button pressed
- (void)didAudioButtonPressed:(UIButton *)sender {
    self.isKeyboardButtonShow = YES;
    
    [self.textInputView endEditing:YES];
}

- (void)didKeyboardButtonPressed:(UIButton *)sender {
    self.isKeyboardButtonShow = NO;
    
    [self.textInputView becomeFirstResponder];
}

// ============================================
// Hold to Talk Button Click Event
// ============================================
- (void)holdDownButtonTouchDown {
    self.isCancelled = NO;
    self.isRecording = NO;
    if ([self.inputToolbarDelegate respondsToSelector:@selector(prepareRecordingVoiceActionWithCompletion:)]) {
        typeof(self) __weak weakSelf = self;
        
        //這邊回調 return 的 YES, 或 NO, 可以讓底層知道該次錄音是否成功, 進而處理無用的 record 對象
        [self.inputToolbarDelegate prepareRecordingVoiceActionWithCompletion:^BOOL{
            typeof(weakSelf) __strong strongSelf = weakSelf;
            
            //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
            if (strongSelf && !strongSelf.isCancelled) {
                strongSelf.isRecording = YES;
                [strongSelf.inputToolbarDelegate didStartRecordingVoiceAction];
                return YES;
            } else {
                return NO;
            }
        }];
    }
}

- (void)holdDownButtonTouchUpOutside {
    
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.inputToolbarDelegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
            [self.inputToolbarDelegate didCancelRecordingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.inputToolbarDelegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
            [self.inputToolbarDelegate didFinishRecoingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragOutside {
    
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.inputToolbarDelegate respondsToSelector:@selector(didDragOutsideAction)]) {
            [self.inputToolbarDelegate didDragOutsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragInside {
    
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.inputToolbarDelegate respondsToSelector:@selector(didDragInsideAction)]) {
            [self.inputToolbarDelegate didDragInsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

// =============================
// Getter Setter
// =============================
- (void)setIsKeyboardButtonShow:(BOOL)isKeyboardButtonShow {
    _isKeyboardButtonShow = isKeyboardButtonShow;
    
    self.keyboardButton.hidden = !isKeyboardButtonShow;
    self.audioButton.hidden = isKeyboardButtonShow;
    self.textInputView.hidden = isKeyboardButtonShow;
    self.holdToTalkButton.hidden = !isKeyboardButtonShow;
    
    if (self.isKeyboardButtonShow) {
        self.inputedText = self.textInputView.text;
        self.textInputView.text = @"";
    } else {
        self.textInputView.text = self.inputedText;
        self.inputedText = nil;
        self.textInputView.frame = [self positionForTextInputView];
    }
    
}

@end
