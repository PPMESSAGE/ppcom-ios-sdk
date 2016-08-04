//
//  PPChattingView.m
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPChattingView.h"
#import "PPComposeTextView.h"

#import "PPLayoutConstraintsUtils.h"
#import "PPLog.h"

@interface PPChattingView ()

@property (nonatomic) NSLayoutConstraint *inputToolbarMarginBottomLayoutConstraint;
@property (nonatomic) NSLayoutConstraint *inputToolbarMarginTopLayoutConstraint;

@end

@implementation PPChattingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    _chattingMessagesCollectionView = [PPChattingMessagesCollectionView new];
    _chattingMessagesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_chattingMessagesCollectionView];
    
    _inputToolbar = [PPMessageInputToolbar new];
    _inputToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_inputToolbar];
    
    [self configureChattingMessagesCollectionViewLayoutConstraints];
    [self configureInputtoolbarLayoutConstraints];
    
}

- (void)configureChattingMessagesCollectionViewLayoutConstraints {
    PPPadding(_chattingMessagesCollectionView, self, 0.0, PPPaddingMaskLeading | PPPaddingMaskTop | PPPaddingMaskTrailing);
}

- (void)configureInputtoolbarLayoutConstraints {
    // trailing | leading
    PPPadding(_inputToolbar, self, 0, PPPaddingMaskLeading | PPPaddingMaskTrailing);
    
    // bottom
    self.inputToolbarMarginBottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:_inputToolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:self.inputToolbarMarginBottomLayoutConstraint];

    // top
    self.inputToolbarMarginTopLayoutConstraint = [NSLayoutConstraint constraintWithItem:_inputToolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_chattingMessagesCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0];
    [self addConstraint:self.inputToolbarMarginTopLayoutConstraint];
    
}

- (void)changeInputToolbarBottomMargin:(CGFloat)margin {
    self.inputToolbarMarginBottomLayoutConstraint.constant = -margin;
    [self setNeedsUpdateConstraints];
}

@end
