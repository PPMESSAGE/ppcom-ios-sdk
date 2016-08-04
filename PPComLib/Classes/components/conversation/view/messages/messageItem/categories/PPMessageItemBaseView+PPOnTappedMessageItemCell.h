//
//  PPMessageItemBaseView+PPOnTappedMessageItemCell.h
//  PPMessage
//
//  Created by PPMessage on 5/24/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemBaseView.h"
#import <PPJTSImageViewController/JTSImageInfo.h>
#import <PPJTSImageViewController/JTSImageViewController.h>

@interface PPMessageItemBaseView (PPOnTappedMessageItemCell)

- (void)pp_onTappedMessage:(PPMessage*)message;

@end

//--------------------------------------------------------------------------------
//ImageDownloader JTSImageViewController
//--------------------------------------------------------------------------------

@interface PPJTSImageViewDownloader : NSObject <JTSImageViewControllerDownloader>

- (instancetype)initWithJTSImageInfo:(JTSImageInfo*)imageInfo;

@end