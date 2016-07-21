//
//  PPMessageImageMediaPart.h
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageMediaPart.h"
#import <UIKit/UIKit.h>
#import "PPMessageBaseMediaPart.h"

typedef NS_ENUM(NSInteger, PPImageState) {
    PPImageStateUnknown
};

typedef NS_ENUM(NSInteger, PPImageType) {
    PPImageTypeJPEG,
    PPImageTypePNG,
    PPImageTypeGIF
};

@interface PPMessageImageMediaPart : PPMessageBaseMediaPart

@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGSize thumbImageSize;
@property (nonatomic) PPImageState imageState;
@property (nonatomic) PPImageType imageType;
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSURL *thumbUrl;

@property (nonatomic) NSString *imageFileId;
@property (nonatomic) NSString *imageLocalPath;
@property (nonatomic) NSString *imageMimeType;

+ (PPMessageImageMediaPart *)mediaPartWithUIImage:(UIImage *)image;
@end
