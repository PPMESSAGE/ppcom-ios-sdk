//
//  NSString+PPSDK.m
//  Pods
//
//  Created by PPMessage on 7/6/16.
//
//

#import "NSString+PPSDK.h"
#import "NSBundle+PPSDK.h"

@implementation NSString (PPSDK)

+ (NSString*)pp_LocaliziedStringForKey:(NSString*)key {
    NSBundle *assetsBundle = [NSBundle pp_assetsBundle];
    return NSLocalizedStringFromTableInBundle(key, @"PPLocalizable", assetsBundle, nil);
}

@end
