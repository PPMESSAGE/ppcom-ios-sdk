//
//  PPMessageControllerKeyboardDelegate.h
//  PPMessage
//
//  Created by PPMessage on 3/29/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PPMessageInputToolbar;

/**
 * `PPBaseMessagesViewController`的几乎所有 view 交互操作都由此类完成
 */
@interface PPMessageControllerKeyboardDelegate : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView
                     inputToolbar:(PPMessageInputToolbar*)inputToolbar;

/** 键盘弹出 **/
- (void)keyboardWillShow:(NSNotification *)notification;
/** 键盘落下 **/
- (void)keyboardWillHide:(NSNotification *)notification;
/** 输入框高度变化事件 **/
- (void)didHeightChanged:(PPMessageInputToolbar *)inputToolbar
                  height:(CGFloat)height
              heightDiff:(CGFloat)heightDiff;
/** 将tableView的内容滑动到底部 **/
- (void)scrollToBottomAnimated:(BOOL)animate;
/** 将tableView向上移动一点，以确保内容可见，该方法最终操作的是 `tableView`的`origin.y`属性 **/
- (void)moveUpTableView;
/** 重新刷新当前tableView，但是保持此刻`tableView`的位置 **/
- (void)reloadTableViewAndKeepScrollPosition:(void(^)())doReloadWork
                                      offset:(CGFloat)offset;
/** 当tableView显示的时候，如果内存有数据，希望它立马就是在最下端的，使用此函数可以更快，使用`scrollToBottomAnimated`会有明显的延迟感 **/
- (void)keepTableViewContentAtBottomQuickly;
/** 当前tableview的数据信息是否填满了用户所能看到的tableView的窗口 **/
- (BOOL)contentFillUpTableView;

@end
