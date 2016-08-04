//
//  PPBaseMessagesViewController+PPCamera.m
//  Pods
//
//  Created by Jin He on 7/20/16.
//
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "PPImagePicker.h"

#import "PPSDKUtils.h"

@interface PPImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation PPImagePicker

#pragma mark - actionSheet

- (void) openActionSheetFromViewController: (UIViewController *)controller {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Take Photo")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self openCameraFromViewController:controller];
                                                            }];
    
    UIAlertAction *choosePictureAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Choose Picture")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [self openPhotoLibraryFromViewController:controller];
                                                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:choosePictureAction];
    [alertController addAction:cancelAction];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - open UIImagePicker

- (void) openCameraFromViewController: (UIViewController *)controller {

    [self openMediaControllerFromViewController:controller
                                  usingDelegate:self
                                 withSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void) openPhotoLibraryFromViewController: (UIViewController *)controller {

    [self openMediaControllerFromViewController:controller
                                  usingDelegate:self
                                 withSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) openMediaControllerFromViewController: (UIViewController *)controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
                                 withSourceType: (UIImagePickerControllerSourceType) sourceType {

    if (([UIImagePickerController isSourceTypeAvailable:sourceType] == NO)
        || delegate == nil || controller == nil) {
        return NO;
    }

    UIImagePickerController *mediaUI = [UIImagePickerController new];

    mediaUI.allowsEditing = NO;
    mediaUI.delegate = delegate;
    mediaUI.sourceType = sourceType;
    mediaUI.modalPresentationStyle = UIModalPresentationCurrentContext;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];

    [controller presentViewController:mediaUI animated:YES completion:nil];

    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {

        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }

        if ([self.delegate respondsToSelector:@selector(didFinishingPickingImage:)]) {
            [self.delegate didFinishingPickingImage:imageToUse];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end




















