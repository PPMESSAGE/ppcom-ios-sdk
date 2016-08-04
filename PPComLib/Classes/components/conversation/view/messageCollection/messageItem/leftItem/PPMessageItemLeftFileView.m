//
//  PPMessageItemLeftFileView.m
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftFileView.h"
#import "PPMessageFileMediaPart.h"
#import "PPLayoutConstraintsUtils.h"
#import "PPSquareImageView.h"
#import "PPLog.h"
#import "UIImage+PPSDK.h"
#import "PPMessageUtils.h"

@interface PPMessageItemLeftFileView ()

@property UIView *leftFileContainerView;
@property UIView *innerView;
@property PPSquareImageView *leftFileViewImageView;
@property UILabel *leftFileNameLabel;
@property UILabel *leftFileSizeLabel;

@end

@implementation PPMessageItemLeftFileView

NSString *const PPMessageItemLeftFileViewIdentifier = @"PPMessageItemLeftFileViewIdentifier";

CGFloat const PPLeftFileIconWidth = 64;
static CGFloat const kPPMessageItemLeftFileViewInnerPadding = 10;

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellBodySize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellBodySize, CGSizeZero)) {
        PPMessageFileMediaPart *mediaPart = message.mediaPart;
        UIFont *font = [UIFont systemFontOfSize:17.0];
        CGFloat width = PPLeftFileIconWidth + kPPMessageItemLeftFileViewInnerPadding * 2 + 5.0 + MAX(PPTextPlainSize(mediaPart.fileName, font).width, PPTextPlainSize(mediaPart.readableFileSize, font).width);
        width = MIN(width, PPMaxCellWidth());
        CGFloat height = PPLeftFileIconWidth + kPPMessageItemLeftFileViewInnerPadding * 2;
        cellBodySize = CGSizeMake(width, height);
        
        [self setCellBodySize:cellBodySize forMessage:message];
    }
    return cellBodySize;
}

#pragma mark - Init

- (UIView*)messageContentView {
    if (!_leftFileContainerView) {
        _leftFileContainerView = [UIView new];
        _leftFileContainerView.backgroundColor = [UIColor blueColor];
        
        _innerView = [UIView new];
        _innerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftFileContainerView addSubview:_innerView];
        
        _leftFileViewImageView = [PPSquareImageView new];
        _leftFileViewImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftFileViewImageView.image = [UIImage pp_defaultMessgaeFileImage];
        [_innerView addSubview:_leftFileViewImageView];
        
        _leftFileNameLabel = [UILabel new];
        _leftFileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _leftFileNameLabel.numberOfLines = 2;
        [_innerView addSubview:_leftFileNameLabel];
        
        _leftFileSizeLabel = [UILabel new];
        _leftFileSizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_innerView addSubview:_leftFileSizeLabel];
        
        PPPadding(_innerView, _leftFileContainerView, kPPMessageItemLeftFileViewInnerPadding, PPPaddingMaskLeading | PPPaddingMaskTop | PPPaddingMaskTrailing);
        
        [self configureFileImageIconLayoutConstraints];
        [self configureFileNameLabelLayoutConstraints];
        [self configureFileSizeLabelLayoutConstraints];
        
    }
    return _leftFileContainerView;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    PPMessageFileMediaPart *fileMediaPart = message.mediaPart;
    self.leftFileNameLabel.text = fileMediaPart.fileName;
    self.leftFileSizeLabel.text = fileMediaPart.readableFileSize;
//    [self.leftFileViewImageView loadWithUrl:fileMediaPart.fileIconUrl placeHolderImage:PPImageWithColor([UIColor grayColor]) completionHandler:nil];
    
    self.messageContentViewSize = [PPMessageItemLeftFileView cellBodySizeForMessage:message];

}

- (void)configureFileImageIconLayoutConstraints {
    [_leftFileViewImageView squareTo:_innerView width:PPLeftFileIconWidth];

    PPPadding(_leftFileViewImageView, _innerView, 0, PPPaddingMaskLeading | PPPaddingMaskTop);
}

- (void)configureFileNameLabelLayoutConstraints {
    PPPadding(_leftFileNameLabel, _innerView, 0, PPPaddingMaskTrailing | PPPaddingMaskTop);
    
    [_innerView addConstraint:[NSLayoutConstraint constraintWithItem:_leftFileNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_leftFileViewImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0]];

}

- (void)configureFileSizeLabelLayoutConstraints {
    [_innerView addConstraint:[NSLayoutConstraint constraintWithItem:_leftFileSizeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_leftFileNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    
    [_innerView addConstraint:[NSLayoutConstraint constraintWithItem:_leftFileSizeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_leftFileViewImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0]];
}

@end
