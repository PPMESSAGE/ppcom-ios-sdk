//
//  PPImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>

#import "PPImageView.h"

#import "PPLog.h"
#import "PPMessageImageMediaPart.h"

@implementation PPImageView

- (void)loadWithUrl:(NSURL *)imageUrl placeHolderImage:(UIImage *)placeHolderImage completionHandler:(void (^)(UIImage *))completionHandler {
    
    [self sd_setImageWithURL:imageUrl placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            PPFastLog(@"error: %@", (error != nil ? error.description : @"no error"));
        }
        
        if (!error && image) {
            if (completionHandler) {
                completionHandler(image);
            }
        }
    }];
}

// 1. load imageLocalPath
// 2. load imageUrl
// 3. load thumbUrl
- (void)loadWithImageMediaPart:(PPMessageImageMediaPart *)imageMediaPart
              placeHolderImage:(UIImage *)placeHolderImage
             completionHandler:(void (^)(UIImage *))completionHandler {
    
    if (imageMediaPart.imageLocalPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:imageMediaPart.imageLocalPath];
        if (image) {
            self.image = image;
            if (completionHandler) completionHandler(image);
            return;
        }
    }
    
    NSString *imageUrl = [imageMediaPart.imageUrl absoluteString];
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:imageUrl done:^(UIImage *image, SDImageCacheType cacheType) {
       
        if (image) {
            self.image = image;
            if (completionHandler) completionHandler(image);
            return;
        }
        
        [self loadWithUrl:imageMediaPart.thumbUrl placeHolderImage:placeHolderImage completionHandler:completionHandler];
    }];
}

- (void)loadWithLocaUrl:(NSString *)url {
    UIImage *image = [UIImage imageWithContentsOfFile:url];
    if (image) {
        self.image = image;
    }
}

@end
