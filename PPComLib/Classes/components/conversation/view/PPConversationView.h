//
//  PPChattingView.h
//  PPMessage
//
//  Created by PPMessage on 2/7/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPConversationViewMessages.h"
#import "PPConversationViewInputToolbar.h"

@interface PPConversationView : UIView

@property (nonatomic) PPConversationViewMessages *conversationViewMessages;
@property (nonatomic) PPMessageInputToolbar *inputToolbar;

/**
 * @param margin 底部距离，默认是0
 * @description 键盘弹起来的时候，将`inputToolbar`距离父view底部的距离变成键盘的高度
 */
- (void)changeInputToolbarBottomMargin:(CGFloat)margin;

@end
