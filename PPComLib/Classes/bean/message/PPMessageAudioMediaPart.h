//
//  PPMessageAudioMediaPart.h
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageBaseMediaPart.h"

@interface PPMessageAudioMediaPart : PPMessageBaseMediaPart

@property (nonatomic) BOOL unread;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSString *fileUUID;
@property (nonatomic) NSString *fileURL;
@property (nonatomic) NSString *localFilePath;

@end
