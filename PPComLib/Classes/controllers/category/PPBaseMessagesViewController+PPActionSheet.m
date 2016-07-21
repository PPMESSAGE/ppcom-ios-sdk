//
//  PPBaseMessagesViewController+PPCamera.m
//  Pods
//
//  Created by Jin He on 7/20/16.
//
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "PPBaseMessagesViewController+PPActionSheet.h"
#import "PPSDKUtils.h"

@implementation PPBaseMessagesViewController (PPCamera)

- (void) pp_openActionSheet {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Take Photo")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self pp_takePhoto];
                                                            }];
    
    UIAlertAction *choosePictureAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"Choose Picture")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [self pp_choosePicture];
                                                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:PPLocalizedString(@"cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:choosePictureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) pp_takePhoto {
    [self pp_startMediaControllerFromViewController:self
                                      usingDelegate:self
                                     withSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void) pp_choosePicture {
    [self pp_startMediaControllerFromViewController:self
                                      usingDelegate:self
                                     withSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL) pp_startMediaControllerFromViewController: (UIViewController *)controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
                                 withSourceType: (UIImagePickerControllerSourceType) sourceType {

    if (([UIImagePickerController isSourceTypeAvailable:sourceType] == NO)
        || delegate == nil || controller == nil) {
        return NO;
    }

    UIImagePickerController *mediaUI = [UIImagePickerController new];
    mediaUI.sourceType = sourceType;
    // mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

// camera & media delegate

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
        
        [self sendImage:imageToUse];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end




















