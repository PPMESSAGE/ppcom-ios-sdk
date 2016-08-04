//
//  PPBaseMessagesViewController+PPVoiceMessage.h
//  Pods
//
//  Created by PPMessage on 7/14/16.
//
//
#import <Foundation/Foundation.h>

#import "PPConversationViewController.h"

@class PPMessage;

@interface PPConversationViewController (PPVoiceMessage)

- (PPMessage*)pp_messageOnPlayingVoice;
- (PPMessage*)pp_stopOnPlayingVoice;

@end
