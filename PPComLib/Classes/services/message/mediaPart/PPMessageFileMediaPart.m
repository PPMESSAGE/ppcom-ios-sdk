//
//  PPMessageFileMediaPart.m
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageFileMediaPart.h"

#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPFileUtils.h"

@implementation PPMessageFileMediaPart

// {"mime": "application/x-pkcs12", "name": "dis.p12", "fid": "1b2bdc0c-dc65-11e5-9251-acbc327f19e9", "size": 3249}
+ (instancetype)mediaPartWithJSONString:(NSString *)jsonString {
    
    PPMessageFileMediaPart *fileMediaPart = [PPMessageFileMediaPart new];
    NSDictionary *dictionary = PPJSONStringToDictionary(jsonString);
    
    fileMediaPart.fileMimeType = PPMessageFileMimeTypeUnknown;
    fileMediaPart.fileName = dictionary[@"name"];
    fileMediaPart.fileSize = [dictionary[@"size"] unsignedIntegerValue];
    fileMediaPart.fileId = dictionary[@"fid"];
    
    return fileMediaPart;
}

#pragma mark - setter

- (void)setFileId:(NSString *)fileId {
    _fileId = fileId;
    _fileUrl = PPFileURL(_fileId);
}

- (void)setFileSize:(NSUInteger)fileSize {
    _fileSize = fileSize;
    _readableFileSize = PPFormatFileSize(fileSize);
}

#pragma mark - helper

- (NSString*)toJSONString {
    return PPDictionaryToJsonString(@{@"fid": self.fileId,
                                      @"mime": PPGetFileMimeType(self.fileLocalPath)});
}

@end
