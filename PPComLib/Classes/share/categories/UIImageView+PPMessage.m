//
//  UIImageView+PPMessage.m
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "UIImageView+PPMessage.h"

#import "UIImage+PPSDK.h"

@implementation UIImageView (PPMessage)

+ (UIImageView *)pp_messageVoiceAnimationImageViewForIncomingMessage {
    return [self pp_messageVoiceAnimationImageViewWithPPMessage:[self messageWithDirection:PPMessageDirectionIncoming]];
}

+ (UIImageView *)pp_messageVoiceAnimationImageViewForOutgoingMessage {
    return [self pp_messageVoiceAnimationImageViewWithPPMessage:[self messageWithDirection:PPMessageDirectionOutgoing]];
}

// =============
// Helper
// =============

+ (PPMessage*)messageWithDirection:(PPMessageDirection)messageDirection {
    PPMessage *message = [PPMessage new];
    message.direction = messageDirection;
    return message;
}

+ (UIImageView *)pp_messageVoiceAnimationImageViewWithPPMessage:(PPMessage*)message {
    UIImageView *messageVoiceAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 17)];
    NSString *imageSepatorName;
    switch (message.direction) {
        case PPMessageDirectionOutgoing:
            imageSepatorName = @"Sender";
            break;
            
        case PPMessageDirectionIncoming:
            imageSepatorName = @"Receiver";
            break;
            
        default:
            imageSepatorName = @"Receiver";
            break;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        UIImage *image = [UIImage pp_imageForName:[imageSepatorName stringByAppendingFormat:@"VoiceNodePlaying00%ld", (long)i]];
        if (image)
            [images addObject:image];
    }
    
    messageVoiceAniamtionImageView.image = [UIImage pp_imageForName:[imageSepatorName stringByAppendingString:@"VoiceNodePlaying"]];
    messageVoiceAniamtionImageView.animationImages = images;
    messageVoiceAniamtionImageView.animationDuration = 1.0;
    [messageVoiceAniamtionImageView stopAnimating];
    
    return messageVoiceAniamtionImageView;
}

@end
