//
//  PPTableHeaderWarningView.m
//  PPMessage
//
//  Created by PPMessage on 4/18/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTableHeaderWarningView.h"

#import "PPImageView.h"

#import "PPLayoutConstraintsUtils.h"

static NSString *const kPPTableHeaderWarningViewWarningText = @"Warning";
static NSString *const kPPTableHeaderWarningViewWarningImageName = @"Error-50";

static CGFloat const kPPTableHeaderWarningViewHeight = 48;
static CGFloat const kPPTableHeaderWarningViewLeftMargin = 16;
static CGFloat const kPPTableHeaderWarningViewTextLabelLeftMargin = 8;

@interface PPTableHeaderWarningView ()

@property (nonatomic) PPImageView *warningImageView;
@property (nonatomic) UILabel *warningLabel;

@end

@implementation PPTableHeaderWarningView

- (instancetype)init {
    if (self = [super init]) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self pp_init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pp_init];
    }
    return self;
}

#pragma mark -

- (void)pp_init {
    self.frame = CGRectMake(0, 0, 0, kPPTableHeaderWarningViewHeight);
    self.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:223.0f/255.0f blue:224.0f/255.0f alpha:1.0];
    
    _warningImageView = [PPImageView new];
    _warningImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.warningImage = [UIImage imageNamed:kPPTableHeaderWarningViewWarningImageName];
    [self addSubview:_warningImageView];
    
    _warningLabel = [UILabel new];
    _warningLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _warningLabel.backgroundColor = [UIColor clearColor];
    self.warningText = kPPTableHeaderWarningViewWarningText;
    _warningLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_warningLabel];
    
    [self configureLayoutConstraints];
}

- (void)configureLayoutConstraints {
    // _warningImageView
    PPPadding(_warningImageView, self, kPPTableHeaderWarningViewLeftMargin, PPPaddingMaskLeading);
    PPPadding(_warningImageView, self, 0, PPPaddingMaskCenterY);
    
    // _warningLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_warningLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_warningImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:kPPTableHeaderWarningViewTextLabelLeftMargin]];
    PPPadding(_warningLabel, self, 0, PPPaddingMaskCenterY);
}

#pragma mark - setter

- (void)setWarningImage:(UIImage *)warningImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        _warningImage = warningImage;
        _warningImageView.image = _warningImage;
    });
}

- (void)setWarningText:(NSString *)warningText {
    dispatch_async(dispatch_get_main_queue(), ^{
        _warningText = warningText;
        _warningLabel.text = _warningText;
    });
}

@end
