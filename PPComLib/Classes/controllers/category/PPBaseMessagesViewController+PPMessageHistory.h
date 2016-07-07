//
//  PPConversationsViewController.h
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import <Foundation/Foundation.h>
#import "PPBaseMessagesViewController.h"
#import "PPBaseMessagesViewControllerDataSource.h"
#import "PPGetMessageHistoryHttpModel.h"
#import "PPSDKUtils.h"
#import "PPMessage.h"
#import "PPSDK.h"

typedef void (^loadMessageHistoryBlock)(NSMutableArray *messages);

@interface PPBaseMessagesViewController (PPMessageHistory)

- (void)loadMessageHistory:(PPNoArgBlock)block;

@end
