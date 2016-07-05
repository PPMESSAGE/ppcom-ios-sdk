//
//  PPConversationItemViewCell+PPConfigureForConversationItem.h
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPConversationItemViewCell.h"

@class PPConversationItem;

@interface PPConversationItemViewCell (PPConfigureForConversationItem)

- (void)configureForConversationItem:(PPConversationItem*)conversationItem;

@end
