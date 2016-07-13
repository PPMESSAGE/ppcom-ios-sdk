//
//  PPMessageItemLeftVoiceView.h
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageItemLeftView.h"

extern NSString *const PPMessageItemLeftVoiceViewIdentifier;

@interface PPMessageItemLeftVoiceView : PPMessageItemLeftView

@property (nonatomic) UIImageView *animationVoiceImageView;
@property (nonatomic) UILabel *durationLabel;
@property (nonatomic) UIView *unreadDot;

@end
