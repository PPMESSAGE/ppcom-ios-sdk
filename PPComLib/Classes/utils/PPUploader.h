//
//  PPUploader.h
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUploader : NSObject

- (void)uploadWithFilePath:(NSString *)filePath
              withFileName:(NSString *)fileName
          withFileMimeType:(NSString *)fileMimeType
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *response, NSError *error))completedHandler;

- (void)uploadWithFilePath:(NSString *)filePath
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *response, NSError *error))completedHandler;

- (void)uploadWithFileData:(NSData *)fileData
              withFileName:(NSString *)fileName
          withFileMimeType:(NSString *)fileMimeType
               toURLString:(NSString *)serverURLString
                 completed:(void (^)(NSDictionary *response, NSError *error))completedHandler;

@end
