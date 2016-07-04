//
//  PPFileUtils.h
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const PPExceptionFileName;

typedef void(^PPFileWriteToDiskCompletedBlock)(NSString *filePath, NSError *error);

NSString* PPMakeFolderInDomains(NSSearchPathDirectory directory, NSString *folderName);
void PPSaveTxtToDiskWithContent(NSString* text, NSString *filePath, PPFileWriteToDiskCompletedBlock completed);
void PPAppendTxtToDiskWithContent(NSString* text, NSString *filePath);

NSString* PPGetFileName(NSString* filePath);
NSString* PPGetFileMimeType(NSString* filePath);

NSData* PPReadDataFromFileAtURL(NSURL *url);
NSString* PPReadStringFromFileAtURL(NSURL *url);

NSString* PPExceptionFolderPath();
NSArray* PPListFiles(NSString* folderPath);