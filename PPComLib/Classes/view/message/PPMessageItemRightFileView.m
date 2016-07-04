//
//  PPMessageItemRightFileView.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightFileView.h"
#import "PPMessageFileMediaPart.h"
#import "PPLayoutConstraintsUtils.h"
#import "PPSquareImageView.h"
#import "PPLog.h"
#import "PPImageUtils.h"
#import "PPMessageUtils.h"

@interface PPMessageItemRightFileView ()

@property UIView *leftFileContainerView;
@property UIView *innerView;
@property PPSquareImageView *leftFileViewImageView;
@property UILabel *leftFileNameLabel;
@property UILabel *leftFileSizeLabel;

@end

@implementation PPMessageItemRightFileView

NSString *const PPMessageItemRightFileViewIdentifier = @"PPMessageItemRightFileViewIdentifier";

CGFloat const PPRightFileIconWidth = 64;
static CGFloat const kPPMessageItemRightFileViewPadding = 10;

#pragma mark - Cell Size

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    CGSize cellSize = [self cellBodySizeInCache:message];
    if (CGSizeEqualToSize(cellSize, CGSizeZero)) {
        PPMessageFileMediaPart *fileMediaPart = message.mediaPart;
        CGSize fileNameSize = PPTextPlainSize(fileMediaPart.fileName, [UIFont systemFontOfSize:17]);
        CGFloat leftContentSize = (PPRightFileIconWidth + 5.0 * 5);
        CGFloat height = PPRightFileIconWidth + kPPMessageItemRightFileViewPadding * 2;
        CGFloat width = MIN(PPMaxCellWidth(), fileNameSize.width += leftContentSize);
        cellSize = CGSizeMake(width, height);
        
        [self setCellBodySize:cellSize forMessage:message];
    }
    
    return cellSize;
}

- (UIView*)messageContentView {
    if (!self.leftFileContainerView) {
        self.leftFileContainerView = [UIView new];
        
        _innerView = [UIView new];
        _innerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.leftFileContainerView addSubview:_innerView];
        
        _leftFileViewImageView = [PPSquareImageView new];
        _leftFileViewImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftFileViewImageView.image = [UIImage imageNamed:@"File-50"];
        [_innerView addSubview:_leftFileViewImageView];
        
        _leftFileNameLabel = [UILabel new];
        _leftFileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _leftFileNameLabel.numberOfLines = 2;
        _leftFileNameLabel.textColor = [UIColor whiteColor];
        _leftFileNameLabel.font = [UIFont systemFontOfSize:17];
        [_innerView addSubview:_leftFileNameLabel];
        
        _leftFileSizeLabel = [UILabel new];
        _leftFileSizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _leftFileSizeLabel.textColor = [UIColor whiteColor];
        [_innerView addSubview:_leftFileSizeLabel];
        
//        PPPaddingAll(_innerView, self.leftFileContainerView, kPPMessageItemRightFileViewPadding);
        PPPadding(_innerView, self.leftFileContainerView, kPPMessageItemRightFileViewPadding, PPPaddingMaskLeading | PPPaddingMaskTop | PPPaddingMaskTrailing);
        
        [self configureFileImageIconLayoutConstraints];
        [self configureFileNameLabelLayoutConstraints];
        [self configureFileSizeLabelLayoutConstraints];
        
    }
    return self.leftFileContainerView;
}

- (void)presentMessage:(PPMessage *)message {
    [super presentMessage:message];
    
    PPMessageFileMediaPart *fileMediaPart = message.mediaPart;
    self.leftFileNameLabel.text = fileMediaPart.fileName;
    self.leftFileSizeLabel.text = fileMediaPart.readableFileSize;
//    [self.leftFileViewImageView loadWithUrl:fileMediaPart.fileIconUrl placeHolderImage:PPImageWithColor([UIColor grayColor]) completionHandler:nil];
    
    self.messageContentViewSize = [PPMessageItemRightFileView cellBodySizeForMessage:message];
    
}

- (void)configureFileImageIconLayoutConstraints {
    [_leftFileViewImageView squareTo:_innerView width:PPRightFileIconWidth];
    
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

