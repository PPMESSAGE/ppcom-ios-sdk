//
//  PPConversationItemViewCell+PPConfigureForConversationItem.m
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationItemViewCell+PPConfigureForConversationItem.h"

#import "PPConversationItem.h"
#import "PPMessageTxtMediaPart.h"
#import "PPTxtLoader.h"
#import "PPBadgeSquareImageView.h"

#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "UIImage+PPSDK.h"

#import "MGSwipeTableCell.h"

@implementation PPConversationItemViewCell (PPConfigureForConversationItem)

- (void)configureForConversationItem:(PPConversationItem *)conversationItem {
    
    PPConversationItem *conversation = conversationItem;
    
    PPMessage *latestMessage = conversation.latestMessage;
    
    NSString *displayName = conversation.conversationName;
    NSString *messageSummary = @" ";
    NSString *messageTimestamp = PPFormatTimestampToHumanReadableStyle(conversation.updateTimestamp, NO);
    NSString *avatarUrl = PPIsNotNull(conversation.conversationIcon) ? conversation.conversationIcon : @"";
    
    if (latestMessage) {
        messageSummary = [PPMessage summaryInMessage:latestMessage];
    }
    
    if (latestMessage.type == PPMessageTypeTxt) {
        PPMessageTxtMediaPart *txtMediaPart = latestMessage.mediaPart;
        if (txtMediaPart.txtURL) {
            self.msgSummaryLabel.text = messageSummary;
            [[PPTxtLoader sharedLoader] loadTxtWithURL:txtMediaPart.txtURL completed:^(NSString *text, NSError *error, NSURL *txtURL) {
                self.msgSummaryLabel.text = text != nil ? text : messageSummary;
            }];
        } else {
            self.msgSummaryLabel.text = latestMessage.body;
        }
    } else {
        self.msgSummaryLabel.text = messageSummary;
    }
    
    int unreadMessageCount = conversation.unreadMsgNumber;
    NSString *badgeText = nil;
    if (unreadMessageCount > 0) {
        badgeText = [NSString stringWithFormat:@"%d", unreadMessageCount];
    }
    
    self.avatarView.badgeText = badgeText;
    self.avatarView.imageView.roundRectBorder = YES;
    
    self.displayNameLabel.text = displayName;
    self.msgTimestampLabel.text = messageTimestamp;
    
    [self.avatarView.imageView loadWithUrl:[[NSURL alloc] initWithString:avatarUrl] placeHolderImage:[UIImage pp_defaultAvatarImage] completionHandler:nil];

}

@end
