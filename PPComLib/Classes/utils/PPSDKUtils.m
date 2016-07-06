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

// ==================
// PPFileHost - get from PPSDK.configuration.downloadHost
// ==================

#define ANONYMOUS_USER_TRACE_UUID @"anonymous_trace_UUid"

NSString * PPFileHost = @"";
NSString * PPTxtUploadHost = @"";

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

BOOL PPIsApiResponseEmpty(NSDictionary* apiResponse) {
    if (!apiResponse) return YES;
    if ([apiResponse[@"error_code"] integerValue] != 0) return NO;
    
    NSMutableDictionary *copied = [NSMutableDictionary dictionaryWithDictionary:[apiResponse copy]];
    [copied removeObjectForKey:@"error_code"];
    [copied removeObjectForKey:@"error_string"];
    [copied removeObjectForKey:@"uri"];
    
    return copied.count == 0;
}

BOOL PPIsApiResponseError(NSDictionary* apiResponse) {
    if (!apiResponse) return YES;
    return [apiResponse[@"error_code"] integerValue] != 0;
}

UIAlertView* PPMakeWarningAlert(NSString *message) {
    UIAlertView *warnAlertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    return warnAlertView;
}

NSString* PPTraceUUID() {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *traceUUID = [preferences stringForKey:ANONYMOUS_USER_TRACE_UUID];
    if (!traceUUID) {
        traceUUID = PPRandomUUID();
        [preferences setValue:traceUUID forKey:ANONYMOUS_USER_TRACE_UUID];
        [preferences synchronize];
    }
    return traceUUID;
}
