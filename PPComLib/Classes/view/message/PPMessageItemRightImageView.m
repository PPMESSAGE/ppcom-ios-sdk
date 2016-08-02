//
//  PPMessageItemRightImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightImageView.h"
#import "PPLayoutConstraintsUtils.h"
#import "PPLoadingImageView.h"
#import "PPMessageImageMediaPart.h"
#import "PPLog.h"
#import "PPImageUtils.h"
#import "PPMessageUtils.h"

@interface PPMessageItemRightImageView ()

@property UIView *rightImageContainerView;

@end

@implementation PPMessageItemRightImageView

NSString *const PPMessageItemRightImageViewIdentifier = @"PPMessageItemRightImageViewIdentifier";

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellSize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellSize, CGSizeZero)) {
        PPMessageImageMediaPart *imageMediaPart = message.mediaPart;
        CGSize imageSize = [self usingThumbImageURLForMessage:message] ? imageMediaPart.thumbImageSize : imageMediaPart.imageSize;
        cellSize = PPImageCellTargetSize(imageSize);
        
        [self setCellBodySize:cellSize forMessage:message];
    }
    return cellSize;
}

+ (BOOL)usingThumbImageURLForMessage:(PPMessage *)message {
    return YES;
}

- (UIView*)messageContentView {
    if (!_rightImageContainerView) {
        _rightImageContainerView = [UIView new];
        
        _rightImageView = [PPLoadingImageView new];
        _rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightImageContainerView addSubview:_rightImageView];
        
        PPPaddingAll(_rightImageView, _rightImageContainerView, .0);
    }
    return _rightImageContainerView;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    PPMessageImageMediaPart *imageMediaPart = message.mediaPart;
    
    _rightImageView.loading = YES;
    [self.rightImageView loadWithImageMediaPart:imageMediaPart
                               placeHolderImage: PPImageWithColor([UIColor grayColor])
                              completionHandler:^(UIImage *image) {
        if (image) _rightImageView.loading = NO;
    }];

    CGSize imageSize = [PPMessageItemRightImageView cellBodySizeForMessage:message];
    self.messageContentViewSize = imageSize;
    
    CGFloat maxAvaliableCornerRadius = PPMessageItemRightViewDefaultBubbleCornerRadius * 3;
    if (imageSize.width < maxAvaliableCornerRadius ||
        imageSize.height < maxAvaliableCornerRadius) {
        self.bubbleCornerRadius = MIN(imageSize.width, imageSize.height) / 5;
    }
}

- (BOOL)addTapGestureRecognizer {
    return YES;
}

@end
