//
//  PPMessageAudioMediaPart.m
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageAudioMediaPart.h"

#import "PPSDKUtils.h"
#import "PPMessageUtils.h"

@implementation PPMessageAudioMediaPart

+ (instancetype)mediaPartWithJSONString:(NSString*)jsonString {
    return [[self alloc] initWithJSONString:jsonString];
}

- (instancetype)initWithJSONString:(NSString*)jsonString {
    if (self = [super init]) {
        NSDictionary *audioDictionary = PPJSONStringToDictionary(jsonString);
        audioDictionary = audioDictionary[@"m4a"];
        self.fileUUID = audioDictionary[@"fid"];
        self.duration = [audioDictionary[@"dura"] doubleValue];
        self.unread = YES;
        self.isAudioPlaying = NO;
    }
    return self;
}

- (NSString*)toJSONString {
    return PPDictionaryToJsonString(@{ @"fid": PPSafeString(self.fileUUID),
              @"mime": @"audio/m4a",
              @"dura": @(self.duration) });
}

// Helper
- (NSString*)fileURL {
    if (_fileURL) {
        _fileURL = PPFileURL(self.fileUUID);;
    }
    return _fileURL;
}

@end
