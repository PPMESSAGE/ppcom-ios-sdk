//
//  PPChattingMessagesCollectionView.m
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPChattingMessagesCollectionView.h"
#import "PPLog.h"

@implementation PPChattingMessagesCollectionView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self pp_init];
    }
    return self;
}

- (void)pp_init {
    self.backgroundColor = [UIColor whiteColor];
    self.separatorColor = [UIColor clearColor];
}

@end
