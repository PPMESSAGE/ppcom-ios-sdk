//
//  PPMessageItemBaseView+PPOnTappedMessageItemCell.m
//  PPMessage
//
//  Created by PPMessage on 5/24/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemBaseView+PPOnTappedMessageItemCell.h"

#import "PPMessageItemLeftImageView.h"
#import "PPMessageItemRightImageView.h"
#import "PPMessageItemLeftVoiceView.h"
#import "PPMessageItemRightVoiceView.h"

#import "PPBaseMessagesViewController.h"

#import "PPImageView.h"
#import "PPLoadingImageView.h"

#import "PPLog.h"
#import "PPSDKUtils.h"

#import "PPMessageImageMediaPart.h"
#import "PPMessageAudioMediaPart.h"

#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

#import "PPAudioPlayerHelper.h"
#import "PPBaseMessagesViewController+PPVoiceMessage.h"
#import "PPDownloader.h"

@interface PPMessageItemBaseView () <
    JTSImageViewControllerInteractionsDelegate,
    JTSImageViewControllerDownloaderDelegate,
    JTSImageViewControllerDismissalDelegate,
    PPAudioPlayerHelperDelegate
>

@end

@implementation PPMessageItemBaseView (PPOnTappedTableViewCell)

- (void)pp_onTappedMessage:(PPMessage *)message {
    if (self.messagesViewController) {
        [self.messagesViewController endEditing];
    }
    
    switch (message.type) {
        case PPMessageTypeImage:
            switch (message.direction) {
                case PPMessageDirectionIncoming:
                    [self pp_onTappedLeftImageMessage:message forTableViewCell:(PPMessageItemLeftImageView*)self];
                    break;
                    
                case PPMessageDirectionOutgoing:
                    [self pp_onTappedRightImageMessage:message forTableViewCell:(PPMessageItemRightImageView*)self];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case PPMessageTypeAudio:
            switch (message.direction) {
                case PPMessageDirectionIncoming:
                    [self pp_onTappedLeftVoiceMessage:message forTableViewCell:(PPMessageItemLeftVoiceView*)self];
                    break;
                    
                case PPMessageDirectionOutgoing:
                    [self pp_onTappedRightVoiceMessage:message forTableViewCell:(PPMessageItemRightVoiceView*)self];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

// ================================
// Audio Message Click Event
// ================================

- (void)pp_onTappedLeftVoiceMessage:(PPMessage *)message
                   forTableViewCell:(PPMessageItemLeftVoiceView*)leftVoiceViewCell {
    PPMessageAudioMediaPart *audioMediaPart = message.mediaPart;
    if (audioMediaPart.unread) {
        audioMediaPart.unread = NO;
    }
    
    [self pp_onTappedVoiceMessage:message
                forAudioMediaPart:(PPMessageAudioMediaPart*)message.mediaPart];
}

- (void)pp_onTappedRightVoiceMessage:(PPMessage *)message
                    forTableViewCell:(PPMessageItemRightVoiceView*)rightVoiceViewCell {
    [self pp_onTappedVoiceMessage:message
                forAudioMediaPart:(PPMessageAudioMediaPart*)message.mediaPart];
}

- (void)pp_onTappedVoiceMessage:(PPMessage *)message
              forAudioMediaPart:(PPMessageAudioMediaPart *)audioMediaPart {
    
    PPMessage *messageOnPlaying = [self.messagesViewController pp_messageOnPlayingVoice];
    PPMessageAudioMediaPart *audioMediaPartNeedToPlay = nil;
    if (messageOnPlaying) {
        if (message == messageOnPlaying) {
            audioMediaPart.isAudioPlaying = NO;
            [[PPAudioPlayerHelper shareInstance] stopAudio];
        } else {
            PPMessageAudioMediaPart *mediaPartOnPlaying = messageOnPlaying.mediaPart;
            mediaPartOnPlaying.isAudioPlaying = NO;
            [[PPAudioPlayerHelper shareInstance] stopAudio];
            
            audioMediaPartNeedToPlay = audioMediaPart;
            audioMediaPart.isAudioPlaying = YES;
        }
    } else {
        audioMediaPartNeedToPlay = audioMediaPart;
        audioMediaPart.isAudioPlaying = YES;
    }
    
    [self.messagesViewController reloadTableView];
    
    // Playing
    if (audioMediaPartNeedToPlay) {
        __weak typeof(self) wself = self;
        [PPAudioPlayerHelper shareInstance].delegate = wself;
        // Local play
        if (audioMediaPartNeedToPlay.localFilePath) {
            [[PPAudioPlayerHelper shareInstance] managerAudioWithFileName:audioMediaPartNeedToPlay.localFilePath toPlay:YES];
        } else {
            PPDownloader *downloader = [PPDownloader new];
            [downloader queryDiskCacheForFileUUID:audioMediaPartNeedToPlay.fileUUID done:^(id obj, NSString *fileUUID, NSString *fileDiskPath) {
                
                if (!wself) return;
                
                if (obj) {
                    [[PPAudioPlayerHelper shareInstance] managerAudioWithFileName:fileDiskPath toPlay:YES];
                } else {
                    
                    // Begin to download
                    [downloader downloadWithFileUUID:audioMediaPartNeedToPlay.fileUUID withBlock:^(id obj, NSString *fileUUID, NSString *fileDiskPath) {
                        if (!wself || !wself.messagesViewController) {
                            [downloader cancel];
                            return;
                        }
                        
                        // Is there another voice playing ...
                        PPMessage *anotherMessageIsAnimating = [wself.messagesViewController pp_messageOnPlayingVoice];
                        if (anotherMessageIsAnimating != nil &&
                            anotherMessageIsAnimating.mediaPart != audioMediaPartNeedToPlay) {
                            return;
                        }
                        
                        if (obj) {
                            [[PPAudioPlayerHelper shareInstance] managerAudioWithFileName:fileDiskPath toPlay:YES];
                        } else {
                            audioMediaPartNeedToPlay.isAudioPlaying = NO;
                            [wself.messagesViewController reloadTableView];
                        }
                        
                    }];
                    
                }
                
            }];
        }
    }
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer {
    [self.messagesViewController pp_stopOnPlayingVoice];
    [self.messagesViewController reloadTableView];
}

// ================================
// Image Message Click Event
// ================================

- (void)pp_onTappedLeftImageMessage:(PPMessage *)message
                   forTableViewCell:(PPMessageItemLeftImageView*)leftImageViewCell {
    PPImageView *imageView = leftImageViewCell.leftImageView;
    [self pp_showImageForMessage:message withOriginImageView:imageView];
}

- (void)pp_onTappedRightImageMessage:(PPMessage *)message
                    forTableViewCell:(PPMessageItemRightImageView*)rightImageViewCell {
    PPImageView *imageView = rightImageViewCell.rightImageView;
    [self pp_showImageForMessage:message withOriginImageView:imageView];
}

- (void)pp_showImageForMessage:(PPMessage *)message
           withOriginImageView:(PPImageView *)imageView {
    PPMessageImageMediaPart *imageMediaPart = message.mediaPart;
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];

    if (imageMediaPart.imageLocalPath) {
        imageInfo.image = imageView.image;
    } else {
        imageInfo.image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageMediaPart.imageUrl.absoluteString];
        imageInfo.imageURL = imageMediaPart.imageUrl;
    }

    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled
                                           downloaderDelegate:self];
    imageViewer.interactionsDelegate = self;
    imageViewer.dismissalDelegate = self;
    
    // Present the view controller.
    if (self.messagesViewController) {
        [imageViewer showFromViewController:self.messagesViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }

}

#pragma mark - JTSImageViewControllerInteractionsDelegate

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    PPFastLog(@"imageViewerDidLongPress");
    
    if (!imageViewer.image) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Save") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(imageViewer.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(imageViewer));
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    if (imageViewer) {
        [imageViewer presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        JTSImageViewController *imageViewer = (__bridge JTSImageViewController *)(contextInfo);
        
        UIAlertController *notifyAlertController = [UIAlertController alertControllerWithTitle:nil message:PPLocalizedString(@"Saved to Album") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"OK") style:UIAlertActionStyleCancel handler:nil];
        [notifyAlertController addAction:okAction];
        
        [imageViewer presentViewController:notifyAlertController animated:YES completion:nil];
    }
}

//--------------------------------------------------------------------------------
// JTSImageViewControllerDismissalDelegate
//--------------------------------------------------------------------------------

- (void)imageViewerDidDismiss:(JTSImageViewController *)imageViewer {
    PPMessageImageMediaPart *imageMediaPart = self.message.mediaPart;
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageMediaPart.imageUrl.absoluteString];
    if (image && imageMediaPart.showThumb) {
        imageMediaPart.showThumb = NO;
        [self.messagesViewController reloadTableView];
    }
}

//--------------------------------------------------------------------------------
//JTSImageViewControllerDownloadDelegate
//--------------------------------------------------------------------------------

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id <JTSImageViewControllerDownloader>)downloaderForImageInfo:(JTSImageInfo *)imageInfo {
    return [[PPJTSImageViewDownloader alloc] initWithJTSImageInfo:imageInfo];
}
#pragma clang diagnostic pop

@end

//--------------------------------------------------------------------------------
//ImageDownloader JTSImageViewController
//--------------------------------------------------------------------------------

@interface PPJTSImageViewDownloader ()

@property id<SDWebImageOperation> imageOperation;
@property (nonatomic) JTSImageInfo *imageInfo;
@property int64_t bytesReceived;
@property int64_t bytesExpectedToReceive;

@end

@implementation PPJTSImageViewDownloader

- (instancetype)initWithJTSImageInfo:(JTSImageInfo *)imageInfo {
    if (self = [super init]) {
        self.imageInfo = imageInfo;
    }
    return self;
}

- (void)downloadImage:(void (^)(UIImage *))completion {
    if (self.imageInfo.image) {
        completion(self.imageInfo.image);
        return;
    }
    
    _imageOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:self.imageInfo.imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        _bytesReceived = receivedSize;
        _bytesExpectedToReceive = expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (image) {
            completion(image);
        } else {
            completion(nil);
        }
        
    }];

}

- (void)cancel {
    if (_imageOperation) {
        [_imageOperation cancel];
    }
}

- (int64_t)countOfBytesReceived {
    return _bytesReceived;
}

- (int64_t)countOfBytesExpectedToReceive {
    return _bytesExpectedToReceive;
}

@end
