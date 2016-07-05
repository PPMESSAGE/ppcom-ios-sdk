//
//  UIImage+PPSDK.m
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import "UIImage+PPSDK.h"
#import "PPSDK.h"

@implementation UIImage (PPSDK)

+ (UIImage*)pp_imageForName:(NSString*)imageName {
    NSString *bundleResourcePath = [NSBundle bundleForClass:[PPSDK class]].resourcePath;
    NSString *assetsPath = [bundleResourcePath stringByAppendingPathComponent:@"PPComLibAssets.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:assetsPath];
    return [self imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (UIImage*)pp_defaultAvatarImage {
    return [self pp_imageForName:@"User-Icon-Default"];
}

+ (UIImage*)pp_defaultGroupImage {
    return [self pp_imageForName:@"user_group_man_man"];
}

+ (UIImage*)pp_defaultMessageErrorImage {
    return [self pp_imageForName:@"Error-50"];
}

+ (UIImage*)pp_defaultMessgaeFileImage {
    return [self pp_imageForName:@"File-50"];
}

@end
