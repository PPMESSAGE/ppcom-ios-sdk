//
//  PPConversationsViewControllerDataSource.m
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationsViewControllerDataSource.h"

#import "PPConversationItem.h"
#import "PPConversationItemViewCell.h"
#import "PPConversationItemViewCell+PPConfigureForConversationItem.h"


@interface PPConversationsViewControllerDataSource ()

@end

@implementation PPConversationsViewControllerDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.conversations = [NSOrderedSet orderedSet];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPConversationItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPConversationItemViewCellIdentifier
                                                                       forIndexPath:indexPath];
    PPConversationItem *item = [self objectAtIndex:indexPath];

    [cell configureForConversationItem:item];

    return cell;
}

#pragma mark - helpers

- (PPConversationItem* )objectAtIndex:(NSIndexPath *)indexPath {
    return self.conversations[indexPath.row];
}

@end
