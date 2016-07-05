//
//  PPConversationsViewControllerDataSource.m
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationsViewControllerDataSource.h"

#import "PPMemoryCache.h"
#import "PPConversationMemoryCache.h"
#import "PPBooleanDictionaryMemoryCache.h"

static NSString *const kPPHasFetchedFromServerCacheKey = @"pp_has_conversations_fetched_from_server";

@interface PPConversationsViewControllerDataSource ()

@property (nonatomic, copy) PPConversationsTableViewConfigureBlock configureBlock;
@property (nonatomic) NSString *cellIdentifier;
@property (nonatomic) NSOrderedSet *conversationList;

@end

@implementation PPConversationsViewControllerDataSource

- (instancetype)initWithCellIdentifier:(NSString *)cellIdentifier
                        configureBlock:(PPConversationsTableViewConfigureBlock)block {
    if (self = [super init]) {
        self.cellIdentifier = cellIdentifier;
        self.configureBlock = [block copy];
        self.conversationList = [[PPMemoryCache sharedInstance].conversationCache conversations]; // sort it
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    self.configureBlock(cell, [self objectAtIndex:indexPath]);
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
