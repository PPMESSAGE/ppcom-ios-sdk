//
//  PPBaseMessagesViewController+PPVoiceMessage.m
//  Pods
//
//  Created by PPMessage on 7/14/16.
//
//

#import "PPBaseMessagesViewController+PPVoiceMessage.h"

#import "PPMessage.h"
#import "PPMessageAudioMediaPart.h"

@implementation PPBaseMessagesViewController (PPVoiceMessage)

- (PPMessage*)pp_messageOnPlayingVoice {
    NSMutableArray *messages = [self messagesInMemory];
    if (!messages) {
        return nil;
    }
    
    __block PPMessage *find = nil;
    [messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PPMessage *item = obj;
    
        if (item.type == PPMessageTypeAudio) {
            PPMessageAudioMediaPart *audioMediaPart = item.mediaPart;
            if (audioMediaPart && audioMediaPart.isAudioPlaying) {
                find = item;
                *stop = YES;
            }
        }
        
    }];
    return find;
}

- (PPMessage*)pp_stopOnPlayingVoice {
    PPMessage *message = [self pp_messageOnPlayingVoice];
    if (message) {
        PPMessageAudioMediaPart *audioMediaPart = message.mediaPart;
        audioMediaPart.isAudioPlaying = NO;
    }
    return message;
}

@end
