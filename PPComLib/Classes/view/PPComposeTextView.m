//
//  PPComposeTextView.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPComposeTextView.h"

#import "PPSDKUtils.h"
#import "PPMessageUtils.h"
#import "PPLog.h"

@interface PPComposeTextView ()

@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) NSUInteger lineNumber;

@end

@implementation PPComposeTextView

static NSString *const PPPlaceholderText = @"Enter Message";

- (instancetype)init {
    self = [super init];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    self.lineNumber = 1;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],                                 NSForegroundColorAttributeName : [UIColor grayColor]}];
    self.textContainerInset = UIEdgeInsetsMake(6, 4, 4, 4);
    self.font = [UIFont systemFontOfSize:17];
    self.dataDetectorTypes = UIDataDetectorTypeLink;
    self.placeholder = PPPlaceholderText;
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = PPLocalizedString(PPPlaceholderText);
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.placeholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.placeholderLabel.isHidden) {
        // Position the placeholder label over where entered text would be displayed.
        CGRect placeholderFrame = self.placeholderLabel.frame;
        CGFloat textViewHorizontalIndent = 5;
        placeholderFrame.origin.x = self.textContainerInset.left + textViewHorizontalIndent;
        placeholderFrame.origin.y = self.textContainerInset.top;
        CGSize fittedPlaceholderSize = [self.placeholderLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        placeholderFrame.size = fittedPlaceholderSize;
        CGFloat maxPlaceholderWidth = CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right - textViewHorizontalIndent * 2;
        if (fittedPlaceholderSize.width > maxPlaceholderWidth) {
            placeholderFrame.size.width = maxPlaceholderWidth;
        }
        self.placeholderLabel.frame = placeholderFrame;
        
        // We want the placeholder to be overlapped by / underneath the cursor.
        [self sendSubviewToBack:self.placeholderLabel];
    }
}

#pragma mark - Setters

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (PPIsNull(text) ||
        [text isEqualToString:@""]) {
        [self onTextViewTextChanged];
    }
}

#pragma mark - Notification Handlers

- (void)textViewTextDidChange:(NSNotification *)notification {
    [self onTextViewTextChanged];
}

- (void)onTextViewTextChanged {
    [self configurePlaceholderVisibility];
    [self pp_calculateLineNumber];
}

#pragma mark - Helpers

- (void)configurePlaceholderVisibility {
    self.placeholderLabel.hidden = self.attributedText.length > 0;
}

- (void)pp_calculateLineNumber {
    NSUInteger oldLineNumber = self.lineNumber;
    NSUInteger lineNumber = PPTextViewLineNumber(self);
    
    if (oldLineNumber != lineNumber) {
        self.lineNumber = lineNumber;
        
        if (self.lineNumberDelegate) {
            [self.lineNumberDelegate didLineNumberChangedWith:lineNumber textView:self];
        }
    }
}

@end
