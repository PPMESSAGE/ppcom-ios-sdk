//
//  NSBundle+PPSDK.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "NSBundle+PPSDK.h"
#import "PPSDK.h"

@implementation NSBundle (PPSDK)

+ (NSBundle*)pp_assetsBundle {
    NSString *bundleResourcePath = [self bundleForClass:[PPSDK class]].resourcePath;
    NSString *assetsPath = [bundleResourcePath stringByAppendingPathComponent:@"PPComLibAssets.bundle"];
    return [self bundleWithPath:assetsPath];
}

@end
