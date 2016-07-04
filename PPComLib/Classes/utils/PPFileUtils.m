//
//  PPFileUtils.m
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPFileUtils.h"
#import "PPLog.h"

#import <MobileCoreServices/MobileCoreServices.h>

static NSString *const kPPExceptionFolderName = @"PPExceptions";
NSString *const PPExceptionFileName = @"exceptions.txt";

NSString* PPMakeFolderInDomains(NSSearchPathDirectory directory, NSString *folderName) {
    NSString *domainPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        domainPath = paths[0];
    }
    
    if (domainPath) {
        NSString *folderPath = [domainPath stringByAppendingPathComponent:folderName];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
        
        if (error) {
            PPFastLog(@"Can't create %@ folder, error: %@", folderName, error);
        }
     
        return folderPath;
    }
    
    return nil;
}

void PPSaveTxtToDiskWithContent(NSString* text, NSString *filePath, PPFileWriteToDiskCompletedBlock completed) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createFileAtPath:filePath contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        // Dispatch it
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed) completed(filePath, nil);
        });
    });
}

void PPAppendTxtToDiskWithContent(NSString* text, NSString *filePath) {
    NSString *existContent = PPReadStringFromFileAtURL([NSURL URLWithString:filePath]);
    NSString *newerContent = text;
    if (existContent) {
        newerContent = [NSString stringWithFormat:@"%@\n\n%@", existContent, text];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:filePath contents:[newerContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

NSString* PPGetFileName(NSString* filePath) {
    return [[filePath lastPathComponent] stringByDeletingPathExtension];
}

NSString* PPGetFileMimeType(NSString* filePath) {
    NSString *fileExtension = [filePath pathExtension];
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    
    if (!mimeType) mimeType = @"application/octet-stream";
    return mimeType;
}

NSData* PPReadDataFromFileAtURL(NSURL *url) {
    NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:url error:nil];
    NSData* fileContents = nil;
    
    if (aHandle)
        fileContents = [aHandle readDataToEndOfFile];
    
    return fileContents;
}

NSString* PPReadStringFromFileAtURL(NSURL *url) {
    NSData *data = PPReadDataFromFileAtURL(url);
    if (data) {
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

NSString* PPExceptionFolderPath() {
    return PPMakeFolderInDomains(NSCachesDirectory, kPPExceptionFolderName);
}

NSArray* PPListFiles(NSString* folderPath) {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
}
