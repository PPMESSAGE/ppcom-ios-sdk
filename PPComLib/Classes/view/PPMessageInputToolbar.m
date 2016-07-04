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

CGFloat const PPChattingViewTextViewBaseLineHeight = 42;
CGFloat const PPTextInputViewPadding = 5.0f;
CGFloat const PPTextInputViewBorderWidth = .5f;

@interface PPMessageInputToolbar ()<PPComposeTextViewLineNumberDelegate>

@property (nonatomic) CGFloat textViewHeight;

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
    
    self.textViewHeight = PPChattingViewTextViewBaseLineHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.textInputView.frame;
    frame.size.width = self.frame.size.width - PPTextInputViewPadding * 2 - PPTextInputViewBorderWidth * 2;
    frame.size.height = self.frame.size.height - PPTextInputViewPadding * 2 - PPTextInputViewBorderWidth * 2;
    frame.origin.x = PPTextInputViewPadding;
    frame.origin.y = PPTextInputViewPadding;
    self.textInputView.frame = frame;
    
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

@end
