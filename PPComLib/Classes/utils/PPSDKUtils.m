//
//  PPSDKUtils.c
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#include "PPSDKUtils.h"
#import "PPLog.h"
#import <UIKit/UIKit.h>

#ifdef PP_LOCAL_DEBUG

NSString *const PPApiHost = @"http://192.168.0.204:8080/api";
NSString *const PPFileHost = @"http://192.168.0.204:8080/download/";
NSString *const PPWebSocketHost = @"ws://192.168.0.204:8080/pcsocket/WS";
NSString *const PPFileUploadHost = @"http://192.168.0.204:8080/upload";
NSString *const PPTxtUploadHost = @"http://192.168.0.204:8080/upload";
NSString *const PPAuthHost = @"http://192.168.0.204:8080/ppauth";

NSString *const PPApiKey = @"MTJkZDBmNDc0Yjg5NDIwY2RjM2M5ZjUyNGNiOTc3NGFhY2JlODllNA==";

#elif defined(PP_LOCAL_NGROK_DEBUG)

NSString *const PPApiHost = @"http://5aed1483.ngrok.io/api";
NSString *const PPFileHost = @"http://5aed1483.ngrok.io/download/";
NSString *const PPWebSocketHost = @"ws://5aed1483.ngrok.io/pcsocket/WS";
NSString *const PPFileUploadHost = @"http://5aed1483.ngrok.io/upload";
NSString *const PPTxtUploadHost = @"http://5aed1483.ngrok.io/upload";
NSString *const PPAuthHost = @"http://5aed1483.ngrok.io/ppauth";

NSString *const PPApiKey = @"ZmE1YTJhOTYzYjNhMDUyYTY0ZjdhNjJiMWI3NGZhMGZiMTlkNmI0Zg==";

#else

NSString *const PPApiHost = @"https://ppmessage.com/api";
NSString *const PPFileHost = @"https://ppmessage.com/download/";
NSString *const PPWebSocketHost = @"wss://ppmessage.com/pcsocket/WS";
NSString *const PPFileUploadHost = @"https://ppmessage.com/upload";
NSString *const PPTxtUploadHost = @"https://ppmessage.com/upload";
NSString *const PPAuthHost = @"https://ppmessage.com/ppauth";

NSString *const PPApiKey = @"MWJkZWI3NDZhZmRiN2NjNDYzZDVmZGI3YTk2YjI5NzhhOWJhNzIyZA==";

#endif

#pragma mark - Private

NSTimeZone* pp_timeZone() {
    static dispatch_once_t onceToken;
    static NSTimeZone *timeZone;
    dispatch_once(&onceToken, ^{
        timeZone = [NSTimeZone localTimeZone];
    });
    return timeZone;
}

NSDateFormatter* pp_dateFormatter(NSString *formatStyle) {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
    });
    dateFormatter.timeZone = pp_timeZone();
    dateFormatter.dateFormat = formatStyle;
    return dateFormatter;
}

NSCalendar* pp_calendar() {
    static dispatch_once_t onceToken;
    static NSCalendar *calendar;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    calendar.timeZone = pp_timeZone();
    return calendar;
}

BOOL pp_isCurrentYear(NSCalendar *calendar, NSDate *date) {
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger otherYear = [calendar component:NSCalendarUnitYear fromDate:date];
    return otherYear == currentYear;
}

BOOL pp_validateUrl(NSString *candidate) {
    NSString *urlRegEx =
    @"^(http|https)://.*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

#pragma mark - Public

NSString* PPFileURL(NSString *fileId) {
    if (PPIsNull(fileId)) return nil;
    if (pp_validateUrl(fileId)) return fileId;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", PPFileHost, fileId];
    return url;
}

NSString* PPRandomUUID() {
    return [[NSUUID UUID] UUIDString];
}

NSString* PPSafeString(NSString *str) {
    if (PPIsNull(str)) {
        return @"";
    }
    return str;
}

BOOL PPIsObjectNull(id obj) {
    return !obj || obj == (id)[NSNull null];
}

BOOL PPIsNull(NSString* str) {
    return PPIsObjectNull(str) || ([str isKindOfClass:[NSString class]] && (
                                                [str isEqualToString:@""] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"]));
}

BOOL PPIsNotNull(NSString *str) {
    return !PPIsNull(str);
}

NSString* PPDeviceUUID() {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendorKey = @"pp_identifier";
    NSString *uniqueIdentifier = nil;
    // Find from disk
    if ([preferences objectForKey:identifierForVendorKey] == nil) {
        
        uniqueIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString;
        PPFastLog(@"===New unique identifier:%@===", uniqueIdentifier);
        
        // Write to disk
        [preferences setObject:uniqueIdentifier forKey:identifierForVendorKey];
        [preferences synchronize];
        
    } else {
        uniqueIdentifier = [preferences objectForKey:identifierForVendorKey];
        PPFastLog(@"===Use cached unique identifier:%@===", uniqueIdentifier);
    }
    return uniqueIdentifier;
}

double PPRetrieveTimestampFromString(NSString *string) {
    NSDateFormatter *dateFormatter = pp_dateFormatter(@"yyyy-MM-dd HH:mm:ss");
    
    NSString *removeLast7CharsString = [string substringToIndex:19];
    NSDate *date = [dateFormatter dateFromString:removeLast7CharsString];
    
    long timestamp = (long)(date.timeIntervalSince1970);
    return timestamp;
}

NSString* PPFormatTimestampToHumanReadableStyle(double timestamp, BOOL withHHMMSS) {
    NSDate *otherDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timestamp];
    
    NSDateFormatter *dateFormatter = pp_dateFormatter(@"HH:mm:ss");
    
    NSCalendar *calendar = pp_calendar();
    if ([calendar isDateInToday:otherDate]) {
        return [dateFormatter stringFromDate:otherDate];
    }
    
    if ([calendar isDateInYesterday:otherDate]) {
        dateFormatter = pp_dateFormatter(@"HH:mm");
        return withHHMMSS ? [NSString stringWithFormat:@"%@ %@", PPLocalizedString(@"Yesterday"), [dateFormatter stringFromDate:otherDate]] : PPLocalizedString(@"Yesterday");
    }
    
    BOOL isSameYear = pp_isCurrentYear(calendar, otherDate);
    
    if (!withHHMMSS) {
        dateFormatter = pp_dateFormatter(isSameYear ? @"MM-dd" : @"yyyy-MM-dd");
    } else {
        dateFormatter = pp_dateFormatter(isSameYear ? @"MM-dd HH:mm" : @"yyyy-MM-dd HH:mm");
    }
    
    return [dateFormatter stringFromDate:otherDate];
}

double PPFixTimestamp(double originTimestampInSeconds) {
    return originTimestampInSeconds;
}

double PPCurrentTimestamp() {
    return [NSDate date].timeIntervalSince1970;
}

NSString* PPDataToString(NSData *data) {
    return [NSString stringWithUTF8String:[[NSData dataWithData:data] bytes]];
}

NSString* PPLocalizedString(NSString* key) {
    return [NSString stringWithFormat:NSLocalizedString(key, nil)];
}

NSString* PPFormatFileSize(NSUInteger fileSizeInBytes) {
    NSArray *tokens = @[@"B",@"KB",@"MB",@"GB",@"TB"];
    double convertedValue = (double)fileSizeInBytes;
    int multiplyFactor = 0;
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f%@", convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

UIImage* PPImageFromAssets(NSString* imagePathWithOutSuffix) {
    return [UIImage imageNamed:[NSString stringWithFormat:@"PPComLib.bundle/%@", imagePathWithOutSuffix]];
}

UIImage* PPDefaultAvatarImage() {
    return PPImageFromAssets(@"pp_icon_avatar");
}

UIImage* PPImageFromBundle(NSString* imagePathWithOutSuffix) {
    NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"PPComLib" withExtension:@"bundle"]];
    NSString *imagePath = [bundle pathForResource:imagePathWithOutSuffix ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
}
