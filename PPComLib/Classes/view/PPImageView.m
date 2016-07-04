//
//  PPImageView.m
//  PPMessage
//
//  Created by PPMessage on 2/5/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PPLog.h"

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

@end
