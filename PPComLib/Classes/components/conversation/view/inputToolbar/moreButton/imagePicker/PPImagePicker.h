//
//  PPBaseMessagesViewController+PPCamera.h
//  Pods
//
//  Created by Jin He on 7/20/16.
//
//

#import <Foundation/Foundation.h>

@protocol PPImagePickerDelegate <NSObject>

@optional

- (void) didFinishingPickingImage:(UIImage *)image;

@end

@interface PPImagePicker: NSObject

@property (nonatomic, weak) id<PPImagePickerDelegate> delegate;

- (void) openActionSheetFromViewController:(UIViewController *)controller;

@end
