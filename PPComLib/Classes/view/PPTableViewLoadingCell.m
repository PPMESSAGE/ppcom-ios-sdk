//
//  PPTableViewLoadingCell.m
//  PPMessage
//
//  Created by PPMessage on 2/27/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTableViewLoadingCell.h"

#import "PPLayoutConstraintsUtils.h"

NSString *const PPTableViewLoadingCellIdentifier = @"PPTableViewLoadingCellIdentifier";

@interface PPTableViewLoadingCell ()

@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic) UIView *centerView;

@end

@implementation PPTableViewLoadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    _centerView = [UIView new];
    _centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_centerView];
    
    _indicatorView = [UIActivityIndicatorView new];
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_centerView addSubview:_indicatorView];
    
    _loadingLabel = [UILabel new];
    _loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingLabel.text = @"Loading";
    [_centerView addSubview:_loadingLabel];
    
    [self pp_configureIndicatorViewLayoutConstraint];
    [self pp_configureLoadingLabelLayoutConstraint];
    [self pp_configureCenterViewLayoutConstraint];
    
}

- (void)pp_configureIndicatorViewLayoutConstraint {
    
}

- (void)pp_configureLoadingLabelLayoutConstraint {
}

- (void)pp_configureCenterViewLayoutConstraint {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_loadingLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_indicatorView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0]];
    
    PPPadding(_centerView, self.contentView, .0, PPPaddingMaskCenterX | PPPaddingMaskCenterY);
}

@end
