//
//  PPBaseMessagesViewController+PPVoiceMessage.h
//  Pods
//
//  Created by PPMessage on 7/14/16.
//
//
#import <Foundation/Foundation.h>

#import "PPBaseMessagesViewController.h"

@class PPMessage;

@interface PPBaseMessagesViewController (PPVoiceMessage)

- (PPMessage*)pp_messageOnPlayingVoice;
- (PPMessage*)pp_stopOnPlayingVoice;

@end
