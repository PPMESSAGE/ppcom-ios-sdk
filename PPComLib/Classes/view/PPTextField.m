//
//  PPTextField.m
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTextField.h"

@implementation PPTextField

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

- (void)addBottomLine {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

- (void)pp_init {
//    CALayer *border = [CALayer layer];
//    CGFloat borderWidth = 2;
//    border.borderColor = [UIColor darkGrayColor].CGColor;
//    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
//    border.borderWidth = borderWidth;
//    [self.layer addSublayer:border];
//    self.layer.masksToBounds = YES;
}

@end
