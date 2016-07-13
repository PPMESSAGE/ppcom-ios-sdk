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
        self.duration = [audioDictionary[@"dura"] floatValue];
        self.fileUUID = [audioDictionary[@"fid"] string];
    }
    return self;
}

- (NSString*)toJSONString {
    return @{ @"fid": PPSafeString(self.fileUUID),
              @"mime": @"audio/mp4a-latm",
              @"dura": @(self.duration) };
}

// Helper
- (NSString*)fileURL {
    if (_fileURL) {
        _fileURL = PPFileURL(self.fileUUID);;
    }
    return _fileURL;
}

@end
