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

#import "PPBaseMessagesViewController.h"

#import "PPImageView.h"
#import "PPLoadingImageView.h"

#import "PPLog.h"
#import "PPSDKUtils.h"

#import "PPMessageImageMediaPart.h"

#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@interface PPMessageItemBaseView () <
    JTSImageViewControllerInteractionsDelegate,
    JTSImageViewControllerDownloaderDelegate
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
            
        default:
            break;
    }
}

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
    imageInfo.image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageMediaPart.imageUrl.absoluteString];
    imageInfo.imageURL = imageMediaPart.imageUrl;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled
                                           downloaderDelegate:self];
    imageViewer.interactionsDelegate = self;
    
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
        if (completion) {
            completion(self.imageInfo.image);
        }
        return;
    }
    
    _imageOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:self.imageInfo.imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        _bytesReceived = receivedSize;
        _bytesExpectedToReceive = expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (image) {
            
            if (completion) {
                completion(image);
            }
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
