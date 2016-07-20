//
//  PPMessageInputToolbar.h
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPComposeTextView.h"
#import "PPButton.h"

extern CGFloat const PPChattingViewTextViewBaseLineHeight;

@class PPMessageInputToolbar;

@protocol PPMessageInputToolbarDelegate <NSObject>

@optional
- (void)didHeightChanged:(PPMessageInputToolbar*)inputToolbar
                  height:(CGFloat)height
              heightDiff:(CGFloat)heightDiff;

// prepare record
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion;

// Start record
- (void)didStartRecordingVoiceAction;

// Slide up to cancel record
- (void)didCancelRecordingVoiceAction;

// release finger finish record
- (void)didFinishRecoingVoiceAction;

// finger drag out side record button
- (void)didDragOutsideAction;

// finger enter inside record button
- (void)didDragInsideAction;

@end

@interface PPMessageInputToolbar : UIToolbar

// Hold to talk button
@property (nonatomic) PPButton *holdToTalkButton;

// more Button
@property (nonatomic) PPButton *moreButton;

// Audio Button
@property (nonatomic) PPButton *audioButton;

// Keyboard Button
@property (nonatomic) PPButton *keyboardButton;

/**
 * @abstract An automatically resizing message composition field.
 */
@property (nonatomic) PPComposeTextView *textInputView;

/**
 * @default 3
 */
@property (nonatomic) NSUInteger maxLineNumber;

/** inputtoolbar delegate **/
@property (nonatomic, weak) id<PPMessageInputToolbarDelegate> inputToolbarDelegate;

@end
