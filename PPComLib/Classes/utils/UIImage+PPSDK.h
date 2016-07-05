//
//  UIImage+PPSDK.h
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (PPSDK)

+ (UIImage*)pp_imageForName:(NSString*)imageName;

+ (UIImage*)pp_defaultAvatarImage;

+ (UIImage*)pp_defaultGroupImage;

+ (UIImage*)pp_defaultMessageErrorImage;

+ (UIImage*)pp_defaultMessgaeFileImage;

@end
