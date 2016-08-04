//
//  PPMessageItemRightImageView.h
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightView.h"

@class PPLoadingImageView;

extern NSString *const PPMessageItemRightImageViewIdentifier;

@interface PPMessageItemRightImageView : PPMessageItemRightView

@property PPLoadingImageView *rightImageView;

@end
