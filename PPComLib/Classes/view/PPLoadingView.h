//
//  PPLoadingView.h
//  PPMessage
//
//  Created by PPMessage on 2/14/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * -------------
 * |           |
 * |           |
 * |     *     |
 * |           |
 * |           |
 * |  loading  |
 * |           |
 * -------------
 *
 */
@interface PPLoadingView : UIView

/**
 * 当为`YES`的时候,self.hidden = NO;
 * 当为`NO`的时候,self.hidden = YES;
 * 默认为`YES`
 */
@property (nonatomic) BOOL loading;

/**
 * loading的时候显示的文字
 * 默认为`Please Wait`
 */
@property NSString *loadingText;

@end
