//
//  PPMessageInputToolbar.h
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPComposeTextView.h"

extern CGFloat const PPChattingViewTextViewBaseLineHeight;

@class PPMessageInputToolbar;

@protocol PPMessageInputToolbarDelegate <NSObject>

@optional
- (void)didHeightChanged:(PPMessageInputToolbar*)inputToolbar
                  height:(CGFloat)height
              heightDiff:(CGFloat)heightDiff;
@end

@interface PPMessageInputToolbar : UIToolbar

/**
 * @abstract An automatically resizing message composition field.
 */
@property (nonatomic) PPComposeTextView *textInputView;

/**
 * @default 3
 */
@property (nonatomic) NSUInteger maxLineNumber;

/** inputtoolbar delegate **/
@property (nonatomic, weak) id<PPMessageInputToolbarDelegate> inputToolbarDelegate;

@end
