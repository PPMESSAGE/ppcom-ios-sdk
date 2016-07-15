//
//  PPDownloader.h
//  Pods
//
//  Created by PPMessage on 7/14/16.
//
//

#import <Foundation/Foundation.h>

typedef void(^PPDownloadFileCompletedBlock)(id obj, NSString *fileUUID, NSString *fileDiskPath);
typedef void(^PPDownloadFileQueryDiskBlock)(id obj, NSString *fileUUID, NSString *fileDiskPath);

@interface PPDownloader : NSObject

- (void)downloadWithFileUUID:(NSString*)fileUUID
                   withBlock:(PPDownloadFileCompletedBlock)aBlock;

- (void)queryDiskCacheForFileUUID:(NSString*)fileUUID
                             done:(PPDownloadFileQueryDiskBlock)aBlock;

- (void)storeFile:(id)file forFileUUID:(NSString *)fileUUID done:(void(^)())aBlock;

- (void)cancel;

@end
