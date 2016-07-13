//
//  PPMessageItemLeftVoiceView.m
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageItemLeftVoiceView.h"

#import "PPLayoutConstraintsUtils.h"
#import "UIImageView+PPMessage.h"
#import "PPLog.h"
#import "UIView+PPBorder.h"
#import "PPMessageUtils.h"

#import "PPMessageAudioMediaPart.h"

#import <QuartzCore/QuartzCore.h>

NSString *const PPMessageItemLeftVoiceViewIdentifier = @"PPMessageItemLeftVoiceViewIdentifier";

CGFloat const PPMessageItemLeftVoiceViewLeading = 8;
CGFloat const PPMessageItemVoiceUnreadDotSize = 8;

@interface PPMessageItemLeftVoiceView ()

@property (nonatomic) UIView *voiceContainerView;
@property (nonatomic) UIView *voiceDescriptionView;

@end

@implementation PPMessageItemLeftVoiceView

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellBodySize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellBodySize, CGSizeZero)) {
        
        PPMessageAudioMediaPart *audioMediaPart = message.mediaPart;
        cellBodySize = PPVoiceMessageCellWidth(audioMediaPart.duration);
        
        [self setCellBodySize:cellBodySize forMessage:message];
    }
    return cellBodySize;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    PPMessageAudioMediaPart *audioMediaPart = message.mediaPart;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.1f\"", audioMediaPart.duration];
    
    self.messageContentViewSize = [PPMessageItemLeftVoiceView cellBodySizeForMessage:message];
}

- (UIView*)messageContentView {
    if (!_voiceContainerView) {
        _voiceContainerView = [UIView new];
        
        _animationVoiceImageView = [UIImageView pp_messageVoiceAnimationImageViewForIncomingMessage];
        _animationVoiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_voiceContainerView addSubview:_animationVoiceImageView];
        
        [self configureAnimationVoiceImageViewLayoutConstraints];
    }
    return _voiceContainerView;
}

- (UIView*)rightView {
    if (!_voiceDescriptionView) {
        _voiceDescriptionView = [UIView new];
        
        _durationLabel = [UILabel new];
        _durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_voiceDescriptionView addSubview:_durationLabel];
        
        _unreadDot = [UIView new];
        _unreadDot.backgroundColor = [UIColor redColor];
        _unreadDot.layer.cornerRadius = PPMessageItemVoiceUnreadDotSize / 2;
        _unreadDot.clipsToBounds = YES;
        _unreadDot.translatesAutoresizingMaskIntoConstraints = NO;
        [_voiceDescriptionView addSubview:_unreadDot];
        
        [self configureDurationLabelLayoutConstraints];
        [self configureUnreadDotLayoutConstraints];
    }
    return _voiceDescriptionView;
}

#pragma mark - helper

- (void)configureAnimationVoiceImageViewLayoutConstraints {
    PPPadding(_animationVoiceImageView, _voiceContainerView, PPMessageItemLeftVoiceViewLeading, PPPaddingMaskLeading);
    PPPadding(_animationVoiceImageView, _voiceContainerView, 0, PPPaddingMaskCenterY);
}

- (void)configureDurationLabelLayoutConstraints {
    PPPadding(_durationLabel, _voiceDescriptionView, 0, PPPaddingMaskLeading);
    PPPadding(_durationLabel, _voiceDescriptionView, 0, PPPaddingMaskCenterY);
}

- (void)configureUnreadDotLayoutConstraints {
    [_voiceDescriptionView addConstraint:[NSLayoutConstraint constraintWithItem:_unreadDot attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_durationLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0]];
    
    PPPadding(_unreadDot, _voiceDescriptionView, PPMessageItemVoiceUnreadDotSize, PPPaddingMaskWidth | PPPaddingMaskHeight);
    PPPadding(_unreadDot, _voiceDescriptionView, 0, PPPaddingMaskCenterY);
}

@end
