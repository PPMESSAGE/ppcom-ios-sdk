//
//  PPUploader.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPUploader.h"

#import "PPLog.h"
#import "PPSDKUtils.h"
#import "PPMessageUtils.h"
#import "PPFileUtils.h"

#import "PPSDK.h"
#import "PPServiceUser.h"

#import "AFNetworking.h"

@interface PPUploader ()

- (void)uploadWithRequest:(NSMutableURLRequest*)request
                completed:(void (^)(NSDictionary *, NSError *))completedHandler;

@end

@implementation PPUploader

- (void)uploadWithRequest:(NSMutableURLRequest*)request
                completed:(void (^)(NSDictionary *, NSError *))completedHandler {
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          PPFastLog(@"progress:%f", uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          PPFastLog(@"Error: %@", error);
                      } else {
                          PPFastLog(@"%@ %@", response, responseObject);
                      }
                      
                      if (completedHandler) {
                          if (error) {
                              completedHandler(nil, error);
                          } else {
                              completedHandler(PPJSONStringToDictionary(PPDataToString(responseObject)), nil);
                          }
                      }
                      
                  }];
    
    [uploadTask resume];
}

- (void)uploadWithFilePath:(NSString *)filePath
              withFileName:(NSString *)fileName
          withFileMimeType:(NSString *)fileMimeType
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *, NSError *))completedHandler {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:serverURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:fileMimeType error:nil];
        
    } error:nil];
    
    [self uploadWithRequest:request completed:completedHandler];
    
}

- (void)uploadWithFilePath:(NSString *)filePath
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *, NSError *))completedHandler {
    
    NSString *fileName = PPGetFileName(filePath);
    NSString *mimeType = PPGetFileMimeType(filePath);
    
    [self uploadWithFilePath:filePath withFileName:fileName withFileMimeType:mimeType toURLString:serverURLString completed:completedHandler];
}

- (void)uploadWithFileData:(NSData *)fileData
              withFileName:(NSString *)fileName
          withFileMimeType:(NSString *)fileMimeType
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *, NSError *))completedHandler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:serverURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:fileMimeType];
        
    } error:nil];
    
    [self uploadWithRequest:request completed:completedHandler];
}

@end
