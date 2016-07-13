//
//  UIImageView+PPMessage.h
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import <UIKit/UIKit.h>

#import "PPMessage.h"

@interface UIImageView (PPMessage)

+ (UIImageView *)pp_messageVoiceAnimationImageViewForOutgoingMessage;
+ (UIImageView *)pp_messageVoiceAnimationImageViewForIncomingMessage;

@end
