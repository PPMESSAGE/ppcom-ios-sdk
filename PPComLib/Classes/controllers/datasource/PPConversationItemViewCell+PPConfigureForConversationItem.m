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
    NSString *messageSummary = [self determineSummaryForConveresation:conversationItem];
    NSString *messageTimestamp = PPFormatTimestampToHumanReadableStyle(conversation.updateTimestamp, NO);
    NSString *avatarUrl = PPIsNotNull(conversation.conversationIcon) ? conversation.conversationIcon : @"";
    
    if (messageSummary) {
        self.msgSummaryLabel.text = [self fixSummary:messageSummary];
    } else {
        if (latestMessage && latestMessage.type == PPMessageTypeTxt) {
            PPMessageTxtMediaPart *txtMediaPart = latestMessage.mediaPart;
            if (txtMediaPart.txtURL) {
                self.msgSummaryLabel.text = messageSummary;
                [[PPTxtLoader sharedLoader] loadTxtWithURL:txtMediaPart.txtURL completed:^(NSString *text, NSError *error, NSURL *txtURL) {
                    self.msgSummaryLabel.text = text != nil ? text : messageSummary;
                }];
            } else {
                self.msgSummaryLabel.text = [self fixSummary:latestMessage.body];
            }
        } else {
            self.msgSummaryLabel.text = [self fixSummary:messageSummary];
        }
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

- (NSString*)determineSummaryForConveresation:(PPConversationItem*)conversation {
    // First check `conversationSummary`
    NSString *messageSummary = conversation.conversationSummary;
    if (messageSummary) {
        return messageSummary;
    }
    
    // Then, check `latestMessage`
    if (conversation.latestMessage) {
        PPMessage *message = conversation.latestMessage;
        messageSummary = [PPMessage summaryInMessage:message];
    }
    
    return messageSummary;
}

- (NSString*)fixSummary:(NSString*)messageSummary {
    if (!messageSummary) return @" ";
    if ([messageSummary length] == 0) return @" ";
    return messageSummary;
}

@end
