//
//  PPComposeTextView.h
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPComposeTextView;

@protocol PPComposeTextViewLineNumberDelegate <NSObject>

- (void)didLineNumberChangedWith:(NSUInteger)lineNumber
                        textView:(PPComposeTextView*)composeTextView;

@end

@interface PPComposeTextView : UITextView

@property (nonatomic) NSString *placeholder;

@property (nonatomic, weak) id<PPComposeTextViewLineNumberDelegate> lineNumberDelegate;

@end
