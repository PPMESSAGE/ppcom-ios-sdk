//
//  PPTxtUploader.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTxtUploader.h"

#import "PPFileUtils.h"
#import "PPSDKUtils.h"
#import "NSString+Crypto.h"
#import "PPLog.h"

static NSString *const kPPTxtUploaderLocalFolderName = @"PPTxtUploadTmp";

@implementation PPTxtUploader

- (void)uploadWithText:(NSString *)text
             completed:(void (^)(NSDictionary *, NSError *))completedHandler {
    NSString *folderName = PPMakeFolderInDomains(NSLibraryDirectory, kPPTxtUploaderLocalFolderName);
    NSString *filePath = [folderName stringByAppendingPathComponent:[PPRandomUUID() pp_MD5String]];
    PPSaveTxtToDiskWithContent(text, filePath, ^(NSString *filePath, NSError *error) {
        NSString *fileName = PPGetFileName(filePath);
        [super uploadWithFilePath:filePath withFileName:fileName withFileMimeType:@"text/plain" toURLString:PPTxtUploadHost completed:completedHandler];
    });
}

@end
