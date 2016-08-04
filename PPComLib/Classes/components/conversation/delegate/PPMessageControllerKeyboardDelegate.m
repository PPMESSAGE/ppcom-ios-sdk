//
//  PPMessageControllerKeyboardDelegate.m
//  PPMessage
//
//  Created by PPMessage on 3/29/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageControllerKeyboardDelegate.h"

#import "PPMessageInputToolbar.h"

#import "PPLog.h"

@interface PPMessageControllerKeyboardDelegate ()

/** To save the keyboard animation */
@property (nonatomic) NSInteger animationCurve;
/** keyboard height */
@property (nonatomic) CGFloat keyboardHeight;
/** To save keyboard animation duration **/
@property (nonatomic) CGFloat animationDuration;
/** Keyboard is showing **/
@property BOOL keyboardShow;
/** keyboard moveUp distance **/
@property (nonatomic) CGFloat keyboardMoveUpDistance;
/** tableview moveUp diff distance **/
@property (nonatomic) CGFloat tableViewMoveUpDiffDistance;
/** tableview moveUp distance **/
@property (nonatomic) CGFloat tableViewMoveUpDistance;
/** tableview last moveup distance **/
@property (nonatomic) CGFloat lastMoveUpDistance;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) PPMessageInputToolbar *inputToolbar;

@end

@implementation PPMessageControllerKeyboardDelegate

- (instancetype)initWithTableView:(UITableView *)tableView
                     inputToolbar:(PPMessageInputToolbar *)inputToolbar {
    if (self = [super init]) {
        self.tableView = tableView;
        self.inputToolbar = inputToolbar;
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // Get keyboard height
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    PPFastLog(@"**keyboard height:%f", keyboardHeight);
    
    // A输入法==切换==>B输入法，虽然调用`keyboardWillShow`,
    // 但是`keyboardHeight == .0f`，故此处应该首先手动调用一下`keyboardWillHide`
    // 之后系统会立即重新调用`keyboardWillShow`
    if (ABS(keyboardHeight - .0f) < .000001f) {
        [self keyboardWillHide:notification];
        return;
    }
    
    // Get keyboard animation
    self.animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    // Get keyboard animation duration
    self.animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.keyboardMoveUpDistance = keyboardHeight - self.keyboardHeight;
    self.keyboardHeight = keyboardHeight;
    
    self.tableViewMoveUpDistance = [self calcTableViewMoveUpDistance];
    self.lastMoveUpDistance = self.tableViewMoveUpDistance;
    BOOL diffMoveUp = ABS(self.keyboardMoveUpDistance) < self.keyboardHeight;
    self.tableViewMoveUpDiffDistance = diffMoveUp ? self.keyboardMoveUpDistance : self.tableViewMoveUpDistance;
    
    self.keyboardShow = YES;
    
    [self setViewMovedUp:YES scrollToBottom:YES completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setViewMovedUp:NO scrollToBottom:NO completion:nil];
    
    self.keyboardHeight = 0;
    self.keyboardShow = NO;
    self.tableViewMoveUpDistance = 0;
}

- (void)didHeightChanged:(PPMessageInputToolbar *)inputToolbar
                  height:(CGFloat)height
              heightDiff:(CGFloat)heightDiff {
    self.keyboardMoveUpDistance = heightDiff;
    self.tableViewMoveUpDiffDistance = heightDiff;
    [self setViewMovedUp:YES scrollToBottom:NO completion:nil];
}

- (void)scrollToBottom:(BOOL)animate {
    [self scrollToBottomAnimated:animate withKeyboardHeight:.0f];
}

- (void)moveUpTableView {
    CGFloat newMoveUp = [self calcTableViewMoveUpDistance];
    CGFloat diff = newMoveUp;
    if (self.lastMoveUpDistance > .0f) {
        diff = newMoveUp - self.lastMoveUpDistance;
    }
    self.lastMoveUpDistance = newMoveUp;
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:(UIViewAnimationOptionBeginFromCurrentState|self.animationCurve) animations:^{
        
        [self snapshot];
        
        CGFloat distance = diff;
        if (distance > .0f) {
            [self calculateViewTargetRect:YES
                                     view:self.tableView
                           moveUpDistance:distance];
        }
        
        [self scrollToBottomAnimated:YES];
        
        [self snapshot];
        
        
    } completion:nil];
}

- (void)scrollToBottomAnimated:(BOOL)animate {
    [self scrollToBottomAnimated:animate withKeyboardHeight:.0f];
}

- (void)reloadTableViewAndKeepScrollPosition:(void (^)())doReloadWork
                                      offset:(CGFloat)offset {
    CGSize beforeContentSize = self.tableView.contentSize;
    
    if (doReloadWork) doReloadWork();
    
    CGSize afterContentSize = self.tableView.contentSize;
    CGPoint afterContentOffset = self.tableView.contentOffset;
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    newContentOffset.y -= offset; // 让它往下稍走一些
    self.tableView.contentOffset = newContentOffset;
}

- (void)keepTableViewContentAtBottomQuickly {
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (BOOL)contentFillUpTableView {
    return self.tableView.contentSize.height >= self.tableView.frame.size.height;
}

- (void)scrollToBottomAnimated:(BOOL)animated
            withKeyboardHeight:(CGFloat)keyboardHeight {
    CGSize contentSize = self.tableView.contentSize;
    CGFloat diffHeight = MAX(0, self.inputToolbar.bounds.size.height - PPChattingViewTextViewBaseLineHeight);
    contentSize.height -= diffHeight;
    contentSize.height += keyboardHeight;
    [self.tableView setContentOffset:[self bottomOffsetForContentSize:contentSize] animated:animated];
}

- (CGPoint)bottomOffsetForContentSize:(CGSize)contentSize {
    UITableView *msgView = self.tableView;
    CGFloat contentSizeHeight = contentSize.height;
    CGFloat collectionViewFrameHeight = msgView.frame.size.height;
    CGFloat collectionViewBottomInset = msgView.contentInset.bottom;
    CGFloat collectionViewTopInset = msgView.contentInset.top;
    CGPoint offset = CGPointMake(0, MAX(-collectionViewTopInset, contentSizeHeight - (collectionViewFrameHeight - collectionViewBottomInset)));
    return offset;
}

#pragma mark - helpers

- (void)calculateViewTargetRect:(BOOL)moveUp
                           view:(UIView*)view
                 moveUpDistance:(CGFloat)moveUpDistance {
    
    UIView *moveView = view;
    CGRect rect = moveView.frame;
    if (moveUp) {
        rect.origin.y -= moveUpDistance;
    } else {
        rect.origin.y += moveUpDistance;
    }
    view.frame = rect;
    
}

- (void)setViewMovedUp:(BOOL)moveUp
        scrollToBottom:(BOOL)scrollToBottom
            completion:(void (^)(BOOL finished))completion {
    
    [self snapshot];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:(UIViewAnimationOptionBeginFromCurrentState|self.animationCurve) animations:^{
        
        CGFloat inputViewMoveUpDistance = moveUp ? self.keyboardMoveUpDistance : self.keyboardHeight;
        [self calculateViewTargetRect:moveUp
                                 view:self.inputToolbar
                       moveUpDistance:inputViewMoveUpDistance];
        
        CGFloat tableViewMoveUpDistance = moveUp ? self.tableViewMoveUpDiffDistance : (ABS(self.tableView.frame.origin.y));
        BOOL moveUpTableView = tableViewMoveUpDistance > .0f || inputViewMoveUpDistance < .0f;
        if (moveUpTableView) {
            [self calculateViewTargetRect:moveUp
                                     view:self.tableView
                           moveUpDistance:tableViewMoveUpDistance];
        }
        
        if (moveUp && scrollToBottom) {
            [self scrollToBottomAnimated:NO];
        }
        
        [self snapshot];
        
    } completion:completion];
    
}

- (CGFloat)calcTableViewMoveUpDistance {
    CGFloat tableViewHeight = self.tableView.frame.size.height;
    CGFloat tableViewVisibleHeight = self.tableView.contentSize.height;
    CGFloat diff = tableViewVisibleHeight + self.keyboardHeight - tableViewHeight;
    return MIN(diff, self.keyboardHeight);
}

#pragma mark - 

- (void)snapshot {
    PPFastLog(@"SNAP_SHOT: keyboard:%f, keyboard_diff:%f, tableview:%f, tableView_diff:%f, origin.y:%f, tableviewSize:%f, tableViewContentHeight:%f, lastMoveUpDistance:%f",
              self.keyboardHeight,
              self.keyboardMoveUpDistance,
              self.tableViewMoveUpDistance,
              self.tableViewMoveUpDiffDistance,
              self.tableView.frame.origin.y,
              self.tableView.frame.size.height,
              self.tableView.contentSize.height,
              self.lastMoveUpDistance);
}

@end
