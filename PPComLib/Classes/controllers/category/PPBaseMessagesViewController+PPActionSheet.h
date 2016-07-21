//
//  PPBaseMessagesViewController+PPCamera.h
//  Pods
//
//  Created by Jin He on 7/20/16.
//
//

#import <Foundation/Foundation.h>
#import "PPBaseMessagesViewController.h"

@interface PPBaseMessagesViewController (PPCamera) <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void) pp_openActionSheet;

@end
