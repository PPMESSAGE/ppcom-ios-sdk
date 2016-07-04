//
//  PPBaseMessagesViewControllerDataSource.m
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPBaseMessagesViewControllerDataSource.h"

#import "PPMessage.h"

#import "PPMessageItemBaseView.h"
#import "PPMessageItemLeftTextView.h"
#import "PPMessageItemLeftImageView.h"
#import "PPMessageItemLeftFileView.h"
#import "PPMessageItemRightFileView.h"
#import "PPMessageItemRightTextView.h"
#import "PPMessageItemRightImageView.h"
#import "PPMessageImageMediaPart.h"
#import "PPMessageFileMediaPart.h"
#import "PPMessageItemLeftLargeTxtView.h"
#import "PPMessageItemRightLargeTxtView.h"
#import "PPMessageItemLeftUnknownView.h"
#import "PPMessageItemRightUnknownView.h"

#import "PPBaseMessagesViewController.h"

@interface PPBaseMessagesViewControllerDataSource ()

@property (nonatomic) NSMutableArray *messageList;

@end

@implementation PPBaseMessagesViewControllerDataSource

#pragma mark - init
- (instancetype)initWithController:(PPBaseMessagesViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPMessage *message = self.messageList[indexPath.row];
    NSString *cellIdentifier = nil;
    PPMessageItemBaseView *cell = nil;
    
    switch (message.direction) {
        case PPMessageDirectionIncoming:
            switch (message.type) {
                case PPMessageTypeImage:
                    cellIdentifier = PPMessageItemLeftImageViewIdentifier;
                    break;
                    
                case PPMessageTypeText:
                    cellIdentifier = PPMessageItemLeftTextViewIdentifier;
                    break;
                    
                case PPMessageTypeTxt:
                    cellIdentifier = PPMessageItemLeftLargeTxtViewIdentifier;
                    break;
                    
                case PPMessageTypeFile:
                    cellIdentifier = PPMessageItemLeftFileViewIdentifier;
                    break;
                    
                case PPMessageTypeUnknown:
                    cellIdentifier = PPMessageItemLeftUnknownViewIdentifier;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case PPMessageDirectionOutgoing:
            switch (message.type) {
                case PPMessageTypeImage:
                    cellIdentifier = PPMessageItemRightImageViewIdentifier;
                    break;
                    
                case PPMessageTypeText:
                    cellIdentifier = PPMessageItemRightTextViewIdentifier;
                    break;
                    
                case PPMessageTypeTxt:
                    cellIdentifier = PPMessageItemRightLargeTxtViewIdentifier;
                    break;
                    
                case PPMessageTypeFile:
                    cellIdentifier = PPMessageItemRightFileViewIdentifier;
                    break;
                    
                case PPMessageTypeUnknown:
                    cellIdentifier = PPMessageItemRightUnknownViewIdentifier;
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    if (cellIdentifier) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.messagesViewController = self.viewController;
        [cell presentMessage:message];
    }
    
    return cell;
}

#pragma mark - data source delegate

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.messageList[indexPath.row];
}

- (void)updateWithMessages:(NSMutableArray *)messages {
    self.messageList = messages;
}

- (NSMutableArray*)messages {
    return self.messageList;
}

@end
