//
//  PPTxtLoader.m
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPTxtLoader.h"

#import "AFNetworking.h"

#import "PPFileUtils.h"
#import "NSString+Crypto.h"
#import "PPLog.h"

static NSString *const kPPTxtLoaderCacheKeyPrefix = @"TxtCache:";
static NSString *const kPPTxtLoaderDiskCacheFolder = @"LargeTxt";

static NSString *const kPPTxtLoaderErrorDomain = @"PPMessage";

typedef NS_ENUM(NSUInteger, PPTxtLoaderErrorCode) {
    PPTxtLoaderErrorCodeFileNotExist
};

@interface PPTxtLoader ()

@property (nonatomic) NSCache *memCache;

@end

@implementation PPTxtLoader

+ (instancetype)sharedLoader {
    static PPTxtLoader *txtLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        txtLoader = [PPTxtLoader new];
    });
    return txtLoader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _memCache = [NSCache new];
    }
    return self;
}

- (void)loadTxtWithURL:(NSURL*)txtURL
             completed:(void (^)(NSString *text, NSError *error, NSURL *txtURL))completedHandler {
    [self loadTxtWithURL:txtURL httpTimeout:0 completed:completedHandler];
}

- (void)loadTxtWithURL:(NSURL *)txtURL
           httpTimeout:(NSUInteger)httpTimeoutInMilliSeconds
             completed:(void (^)(NSString *, NSError *, NSURL *))completedHandler {
    if (!txtURL) {
        PPFastLog(@"txtURL can not be nil");
        if (completedHandler) completedHandler(nil, nil, txtURL);
        return;
    }
    
    NSString *md5URLString = [txtURL.absoluteString pp_MD5String];
    NSString *txtCacheKey = [self pp_txtCacheKeyWithMD5URLString:md5URLString];
    NSString *txt = [self pp_findInMemCache:txtCacheKey];
    
    if (!txt) {
        // Check disk
        [self pp_loadTxtFromDickCache:md5URLString completed:^(NSString *text, NSError *error) {
            if (!error) {
                PPFastLog(@"Disk cache hit %@", txtURL.absoluteString);
                [self pp_saveTxtToMemoryWithContent:text cacheKey:txtCacheKey];
                if (completedHandler) completedHandler(text, nil, txtURL);
                
            } else {
                // Download from server
                [self pp_downloadTxtWithURLString:txtURL.absoluteString completed:^(NSString *text, NSError *error) {
                    
                    if (!error) {
                        [self pp_saveTxtToDiskWithContent:text fileName:md5URLString completed:nil];
                        [self pp_saveTxtToMemoryWithContent:text cacheKey:txtCacheKey];
                        if (completedHandler) completedHandler(text, nil, txtURL);
                    } else {
                        if (completedHandler) completedHandler(nil, error, txtURL);
                    }
                    
                }];
            }
        }];
    } else {
        PPFastLog(@"Memory cache hit %@", txtURL);
        if (completedHandler) completedHandler(txt, nil, txtURL);
    }
}

#pragma mark - Memory cache methods

- (NSString*)pp_txtCacheKeyWithMD5URLString:(NSString*)md5UrlString {
    return [NSString stringWithFormat:@"%@%@", kPPTxtLoaderCacheKeyPrefix, md5UrlString];
}

- (void)pp_saveTxtToMemoryWithContent:(NSString*)text
                             cacheKey:(NSString*)cacheKey {
    [self.memCache setObject:text forKey:cacheKey];
}

- (NSString*)pp_findInMemCache:(NSString*)txtCacheKey {
    id obj = [self.memCache objectForKey:txtCacheKey];
    if (obj) {
        return (NSString*)obj;
    }
    return nil;
}

#pragma mark - disk folder operate

- (void)pp_loadTxtFromDickCache:(NSString*)md5UrlString
                      completed:(void (^)(NSString *text, NSError *error))completedHandler {
    if ([self pp_txtExistOnDisk:md5UrlString]) {
        NSString *txtPath = [self pp_txtDiskUrlPath:md5UrlString];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSData *data = [self pp_readDataFromFileAtURL:[NSURL URLWithString:txtPath]];
            NSString *txtString = @"";
            if (data) {
                txtString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completedHandler) completedHandler(txtString, nil);
            });
        });
        
    } else {
        NSError *error = [NSError errorWithDomain:kPPTxtLoaderErrorDomain code:PPTxtLoaderErrorCodeFileNotExist userInfo:@{ @"error_desc": @"File not exist on path" }];
        if (completedHandler) completedHandler(nil, error);
    }
}

- (void)pp_saveTxtToDiskWithContent:(NSString*)text
                           fileName:(NSString*)fileName
                          completed:(void(^)(NSString *fileName, NSError *error))completedHandler {
    
    if ([self pp_txtExistOnDisk:fileName]) {
        if (completedHandler) completedHandler(fileName, nil);
        return;
    }
    
    NSString *txtPath = [self pp_txtDiskUrlPath:fileName];
    PPSaveTxtToDiskWithContent(text, txtPath, ^(NSString *filePath, NSError *error) {
        if (completedHandler) completedHandler(fileName, nil);
    });
    
}

- (NSData*)pp_readDataFromFileAtURL:(NSURL*)anURL {
    return PPReadDataFromFileAtURL(anURL);
}

- (NSString*)pp_txtDiskUrlPath:(NSString*)md5UrlString {
    NSString *txtFolder = PPMakeFolderInDomains(NSCachesDirectory, kPPTxtLoaderDiskCacheFolder);
    return [txtFolder stringByAppendingPathComponent:md5UrlString];
}

- (BOOL)pp_txtExistOnDisk:(NSString*)md5UrlString {
    return [[NSFileManager defaultManager]fileExistsAtPath:[self pp_txtDiskUrlPath:md5UrlString]];
}

#pragma mark - read from server

- (void)pp_downloadTxtWithURLString:(NSString*)txtURLString
                          completed:(void (^)(NSString *text, NSError *error))completedHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL *URL = [NSURL URLWithString:txtURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            PPFastLog(@"Error: %@", error);
            if (completedHandler) completedHandler(nil, error);
        } else {
            NSString *txtContent = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (completedHandler) completedHandler(txtContent, nil);
        }
    }];
    [dataTask resume];
}

@end
