//
//  PPMessageItemLeftImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftImageView.h"
#import "PPLoadingImageView.h"
#import "PPMessageImageMediaPart.h"
#import "PPLayoutConstraintsUtils.h"
#import "PPImageUtils.h"
#import "PPLog.h"
#import "PPMessageUtils.h"

@interface PPMessageItemLeftImageView ()

@property UIView *leftImageContainerView;

@end

@implementation PPMessageItemLeftImageView

NSString *const PPMessageItemLeftImageViewIdentifier = @"PPMessageItemLeftImageViewIdentifier";

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

+ (BOOL)usingThumbImageURLForMessage:(PPMessage*)message {
    return YES;
}

- (UIView*)messageContentView {
    if (!_leftImageContainerView) {
        _leftImageContainerView = [UIView new];
        
        _leftImageView = [PPLoadingImageView new];
        _leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftImageContainerView addSubview:_leftImageView];
        
        PPPaddingAll(_leftImageView, _leftImageContainerView, .0);
    }
    return _leftImageContainerView;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    PPMessageImageMediaPart *imageMediaPart = message.mediaPart;
    NSURL *imageURL = [self.class usingThumbImageURLForMessage:message] ? imageMediaPart.thumbUrl : imageMediaPart.imageUrl;
    _leftImageView.loading = YES;
    [self.leftImageView loadWithUrl:imageURL placeHolderImage: PPImageWithColor([UIColor grayColor]) completionHandler:^(UIImage *image) {
        if (image) _leftImageView.loading = NO;
    }];
    
    CGSize imageSize = [PPMessageItemLeftImageView cellBodySizeForMessage:message];
    self.messageContentViewSize = imageSize;
    
    CGFloat maxAvaliableCornerRadius = PPMessageItemLeftViewDefaultBubbleCornerRadius * 3;
    if (imageSize.width <= maxAvaliableCornerRadius ||
        imageSize.height <= maxAvaliableCornerRadius) {
        self.bubbleCornerRadius = MIN(imageSize.width, imageSize.height) / 5;
    }
    
}

- (BOOL)addTapGestureRecognizer {
    return YES;
}

@end
