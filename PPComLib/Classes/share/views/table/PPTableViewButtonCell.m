//
//  PPTableViewButtonCell.m
//  PPMessage
//
//  Created by PPMessage on 2/15/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTableViewButtonCell.h"
#import "PPLayoutConstraintsUtils.h"

@implementation PPTableViewButtonCell

NSString *const PPTableViewButtonCellIdentifier = @"PPTableViewButtonCellIdentifier";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
