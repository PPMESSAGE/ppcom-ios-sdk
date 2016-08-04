//
//  PPConversationsViewController.h
//  Pods
//
//  Created by Jin He on 7/7/16.
//
//

#import <Foundation/Foundation.h>
#import "PPConversationViewController.h"
#import "PPConversationViewControllerDataSource.h"
#import "PPGetMessageHistoryHttpModel.h"
#import "PPSDKUtils.h"
#import "PPMessage.h"
#import "PPSDK.h"

typedef void (^loadMessageHistoryBlock)(NSMutableArray *messages);

@interface PPConversationViewController (PPMessageHistory)

- (void)pp_loadMessageHistory:(PPNoArgBlock)block;

@end
