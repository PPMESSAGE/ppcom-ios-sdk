//
//  PPDownloader.m
//  Pods
//
//  Created by PPMessage on 7/14/16.
//
//

#import "PPDownloader.h"

#import "NSString+Crypto.h"
#import "PPSDKUtils.h"
#import "PPLog.h"
#import "PPFileUtils.h"

#import "AFNetworking.h"

static NSString *const PPDownloaderDiskCacheFolder = @"PPFileCache";

@interface PPDownloader ()

@property (nonatomic) NSCache *fileMemoryCache;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@end

@implementation PPDownloader

- (instancetype)init {
    if (self = [super init]) {
        self.fileMemoryCache = [NSCache new];
    }
    return self;
}

- (void)downloadWithFileUUID:(NSString *)fileUUID
                   withBlock:(PPDownloadFileCompletedBlock)aBlock {
    if (!aBlock) return;
    
    // NSString *fileURLPath = [self fileURLPathWithUUID:fileUUID];
    // NSString *md5Key = [self MD5KeyForFileUUID:fileUUID];
    
    // Look at cache and disk
    __weak typeof(self) wself = self;
    [self queryDiskCacheForFileUUID:fileUUID done:^(id obj, NSString *fileUUID, NSString *fileLocalPath) {
        if (obj) {
            aBlock(obj, fileUUID, fileLocalPath);
        } else {
            
            NSString *fileURLString = [wself fileURLPathWithUUID:fileUUID];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSURL *URL = [NSURL URLWithString:fileURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    PPFastLog(@"[PPDownloader] Error: %@", error);
                    aBlock(nil, fileUUID, fileURLString);
                } else {
                    [wself storeFile:responseObject forFileUUID:fileUUID done:^{
                        aBlock(responseObject, fileUUID, fileURLString);
                    }];
                }
            }];
            [dataTask resume];
            wself.dataTask = dataTask;
            
        }
    }];
}

- (void)cancel {
    if (self.dataTask) {
        [self.dataTask cancel];
    }
}

#pragma mark - find

- (id)fileInMemoryWithMD5Key:(NSString*)md5Key {
    return [self.fileMemoryCache objectForKey:md5Key];
}

- (void)cacheInMemoryWithMD5Key:(NSString*)md5Key
                       withFile:(id)file {
    [self.fileMemoryCache setObject:file forKey:md5Key];
}

- (void)queryDiskCacheForFileUUID:(NSString*)fileUUID
                             done:(PPDownloadFileQueryDiskBlock)aBlock {
    if (!aBlock) {
        return;
    }
    
    NSString *md5Key = [self MD5KeyForFileUUID:fileUUID];
    NSString *fileLocalPath = [self fileURLPathWithUUID:fileUUID];
    
    // First check the in-memory cache...
    id file = [self fileInMemoryWithMD5Key:md5Key];
    if (file) {
        PPFastLog(@"[PPDownloader] find from memory with file uuid: %@", fileUUID);
        aBlock(file, fileUUID, fileLocalPath);
        return;
    }
    
    if ([self isFileExistOnDiskWithMD5Key:md5Key]) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            @autoreleasepool {
                NSData *data = PPReadDataFromFileAtURL([NSURL URLWithString:[self fileDiskPathWithMD5Key:md5Key]]);
                if (data) {
                    PPFastLog(@"[PPDownloader] find file from disk with file uuid: %@", fileUUID);
                    [self.fileMemoryCache setObject:data forKey:md5Key];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    aBlock(data, fileUUID, fileLocalPath);
                });
            }
        });
        
    } else {
        if (aBlock) {
            aBlock(nil, fileUUID, fileLocalPath);
        }
    }
}

- (void)storeFile:(id)file forFileUUID:(NSString *)fileUUID done:(void(^)())aBlock {
    if (!file || !fileUUID) return;
    
    NSString *md5Key = [self MD5KeyForFileUUID:fileUUID];
    [self cacheInMemoryWithMD5Key:md5Key withFile:file];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self storeFileToDisk:file forFileUUID:fileUUID];
        if (aBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                aBlock();
            });
        }
    });
}

- (void)storeFileToDisk:(id)obj forFileUUID:(NSString*)fileUUID {
    NSString *md5Key = [self MD5KeyForFileUUID:fileUUID];
    NSString *filePath = [self fileDiskPathWithMD5Key:md5Key];
    // transform to NSUrl
    // NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:obj attributes:nil];
}

#pragma mark - helper

- (NSString*)fileURLPathWithUUID:(NSString*)fileUUID {
    return PPFileURL(fileUUID);
}

- (NSString*)MD5KeyForFileUUID:(NSString*)fileUUID {
    return [fileUUID pp_MD5String];
}

- (NSString*)fileDiskPathWithMD5Key:(NSString*)md5Key {
    NSString *fileFolder = PPMakeFolderInDomains(NSCachesDirectory, PPDownloaderDiskCacheFolder);
    return [fileFolder stringByAppendingPathComponent:md5Key];
}

- (BOOL)isFileExistOnDiskWithMD5Key:(NSString*)md5Key {
    return [[NSFileManager defaultManager]fileExistsAtPath:[self fileDiskPathWithMD5Key:md5Key]];
}

@end
