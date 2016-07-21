//
//  PPMessageImageMediaPart.m
//  PPMessage
//
//  Created by PPMessage on 2/12/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageImageMediaPart.h"

#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPFileUtils.h"
#import "PPLog.h"

@implementation PPMessageImageMediaPart

// {"thum": "f4a54ffa-da18-11e5-8049-acbc327f19e9", "mime": "image/jpeg", "orig": "f490a53d-da18-11e5-9045-acbc327f19e9", "orig_width": xxx, "orig_height": xxx, "thum_width": xxx, "thum_height": xxx}
+ (instancetype)mediaPartWithJSONString:(NSString *)jsonString {
    
    NSDictionary *dictionary = PPJSONStringToDictionary(jsonString);
    PPMessageImageMediaPart *mediaPart = [PPMessageImageMediaPart new];
    mediaPart.thumbUrl = [NSURL URLWithString:PPFileURL(dictionary[@"thum"])];
    mediaPart.imageUrl = [NSURL URLWithString:PPFileURL(dictionary[@"orig"])];
    
    NSString *mimeType = [dictionary[@"mime"] lowercaseString];
    if ([mimeType isEqualToString:@"image/jpeg"]) {
        mediaPart.imageType = PPImageTypeJPEG;
    } else if ([mimeType isEqualToString:@"image/gif"]) {
        mediaPart.imageType = PPImageTypeGIF;
    }
    
    // Assume default imageSize is 3:4
    mediaPart.imageSize = CGSizeMake(300, 400);
    if ([dictionary objectForKey:@"orig_width"]) {
        mediaPart.imageSize = CGSizeMake([dictionary[@"orig_width"] integerValue], [dictionary[@"orig_height"] integerValue]);
    }
    // Assume default imageThumbSize is 3:4
    mediaPart.thumbImageSize = CGSizeMake(300, 400);
    if ([dictionary objectForKey:@"thum_width"]) {
        //
        // There is a bug in image/gif image style, `thum_height` was wrong spelled to `_thum_height` :)
        //
        // {"orig_width": 310, "_thum_height": 280, "orig_height": 280, "thum": "55775d6e-1c04-11e6-aec7-acbc327f19e9", "mime": "image/gif", "thum_width": 310, "orig": "55775d6e-1c04-11e6-aec7-acbc327f19e9"}
        NSInteger thumHeight = dictionary[@"thum_height"] ? [dictionary[@"thum_height"] integerValue] : [dictionary[@"_thum_height"] integerValue];
        mediaPart.thumbImageSize = CGSizeMake([dictionary[@"thum_width"] integerValue], thumHeight);
    }
    
    return mediaPart;
}

+ (PPMessageImageMediaPart *) mediaPartWithUIImage:(UIImage *)image {
    PPMessageImageMediaPart *mediaPart = [PPMessageImageMediaPart new];
    mediaPart.imageSize = [image size];
    mediaPart.thumbImageSize = [image size];

    // create path & save image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [PPRandomUUID() stringByAppendingString:@".jpeg"];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [UIImageJPEGRepresentation(image, 100) writeToFile:filePath atomically:YES];

    mediaPart.imageLocalPath = filePath;
    return mediaPart;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageSize = CGSizeZero;
    }
    return self;
}

- (NSString*)toJSONString {
    return PPDictionaryToJsonString(@{@"fid": self.imageFileId,
                                      @"mime": PPGetFileMimeType(self.imageLocalPath)});
}

@end
