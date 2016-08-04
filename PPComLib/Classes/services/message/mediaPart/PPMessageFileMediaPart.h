//
//  PPMessageFileMediaPart.h
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMessageBaseMediaPart.h"

typedef NS_ENUM(NSInteger, PPMessageFileMimeType) {
    PPMessageFileMimeTypeUnknown,
    PPMessageFileMimeTypeImage,
    PPMessageFileMimeTypeDocument,
    PPMessageFileMimeTypeMedia
};

@interface PPMessageFileMediaPart : PPMessageBaseMediaPart

@property (nonatomic) NSURL *fileIconUrl;
@property (nonatomic) NSString *fileName;
@property (nonatomic) NSUInteger fileSize;
@property (nonatomic) NSString *readableFileSize;
@property (nonatomic) PPMessageFileMimeType fileMimeType;
@property (nonatomic) NSString *fileUrl;
@property (nonatomic) NSString *fileId;
@property (nonatomic) NSString *fileLocalPath;

@end
