//
//  PPMessageItemLeftImageView.h
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftView.h"

@class PPLoadingImageView;

extern NSString *const PPMessageItemLeftImageViewIdentifier;

@interface PPMessageItemLeftImageView : PPMessageItemLeftView

@property PPLoadingImageView *leftImageView;

@end
