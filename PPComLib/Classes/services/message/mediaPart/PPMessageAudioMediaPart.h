//
//  PPMessageAudioMediaPart.h
//  Pods
//
//  Created by PPMessage on 7/13/16.
//
//

#import "PPMessageBaseMediaPart.h"

@interface PPMessageAudioMediaPart : PPMessageBaseMediaPart

@property (nonatomic) BOOL isAudioPlaying;
@property (nonatomic) BOOL unread;

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSString *fileUUID;
@property (nonatomic) NSString *fileURL;
@property (nonatomic) NSString *localFilePath;

@end
