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

@property (nonatomic) NSString *cellIdentifier;
@property (nonatomic) NSOrderedSet *conversationList;

@end

@implementation PPConversationsViewControllerDataSource

- (instancetype)initWithCellIdentifier:(NSString *)cellIdentifier {
    if (self = [super init]) {
        self.cellIdentifier = cellIdentifier;
        self.conversationList = [NSOrderedSet orderedSet];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversationList count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPConversationItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    PPConversationItem *item = [self objectAtIndex:indexPath];

    [cell configureForConversationItem:item];

    return cell;
}

- (id)objectAtIndex:(NSIndexPath *)indexPath {
    return self.conversationList[indexPath.row];
}

- (NSOrderedSet*)conversations {
    return self.conversationList;
}

- (void)updateItemsWithConversations:(NSOrderedSet *)conversations {
    self.conversationList = conversations;
}

@end
