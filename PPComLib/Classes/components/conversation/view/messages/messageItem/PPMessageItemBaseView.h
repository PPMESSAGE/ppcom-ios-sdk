//
//  PPMessageItemBaseView.h
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMessage.h"

@class PPConversationViewController;

@interface PPMessageItemBaseView : UITableViewCell

extern CGFloat const PPMessageItemViewAvatarWidth;
extern CGFloat const PPMessageItemViewNameLabelHeight;
extern CGFloat const PPMessageItemViewTimestampHeight;

@property (nonatomic) CGSize messageContentViewSize;
@property (nonatomic, weak) PPConversationViewController *conversationViewController;
@property (nonatomic) PPMessage *message;

+ (CGFloat)cellHeightForMessage:(PPMessage *)message inView:(UIView *)view;
+ (CGSize)cellSizeForMessage:(PPMessage *)message inView:(UIView *)view;

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message;
+ (CGSize)cellBodySizeInCache:(PPMessage *)message;
+ (void)setCellBodySize:(CGSize)cellBodySize
             forMessage:(PPMessage *)message;

- (UIView*)messageContentView;
- (UIView*)messageTimestampView;

- (void)presentMessage:(PPMessage *)message;
- (BOOL)addTapGestureRecognizer;
- (void)onMessageItemTapped:(UITapGestureRecognizer*)gr;

@end
