//
//  PPMessageItemRightVoiceView.m
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageItemRightVoiceView.h"

#import "PPMessageUtils.h"
#import "UIView+PPBorder.h"
#import "UIImageView+PPMessage.h"
#import "PPLayoutConstraintsUtils.h"

#import "PPMessageAudioMediaPart.h"

NSString *const PPMessageItemRightVoiceViewIdentifier = @"PPMessageItemRightVoiceViewIdentifier";

CGFloat const PPMessageItemLeftVoiceViewTrailing = 8.0;

@interface PPMessageItemRightVoiceView ()

@property (nonatomic) UIView *voiceContainerView;

@end

@implementation PPMessageItemRightVoiceView

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

- (UIView*)messageContentView {
    if (!_voiceContainerView) {
        _voiceContainerView = [UIView new];
        [_voiceContainerView PPMakeBorder];
        
        _animationVoiceImageView = [UIImageView pp_messageVoiceAnimationImageViewForOutgoingMessage];
        _animationVoiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_voiceContainerView addSubview:_animationVoiceImageView];
        
        [self configureAnimationVoiceImageViewLayoutConstraints];
    }
    return _voiceContainerView;
}

- (UIView*)leftView {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
    }
    return _durationLabel;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    PPMessageAudioMediaPart *audioMediaPart = message.mediaPart;
    self.durationLabel.text = [NSString stringWithFormat:@"%.1f\"", audioMediaPart.duration];
    self.messageContentViewSize = [PPMessageItemRightVoiceView cellBodySizeForMessage:message];
}

- (void)configureAnimationVoiceImageViewLayoutConstraints {
    PPPadding(_animationVoiceImageView, _voiceContainerView, PPMessageItemLeftVoiceViewTrailing, PPPaddingMaskTrailing);
    PPPadding(_animationVoiceImageView, _voiceContainerView, 0, PPPaddingMaskCenterY);
}

@end
