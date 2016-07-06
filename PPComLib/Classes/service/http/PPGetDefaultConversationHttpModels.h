//
//  PPGetDefaultConversationHttpModels.h
//  PPComLib
//
//  Created by PPMessage on 3/31/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPHttpModel.h"

@class PPSDK;
@class PPConversationItem;

/**
 * 请求服务器获取默认`conversation`，然后返回`PPConversationItem`。
 *
 * 成功获取，`PPConversationItem`不为`nil`，否则为`nil`
 *
 */
@interface PPGetDefaultConversationHttpModels : NSObject

+ (instancetype)modelWithClient:(PPSDK*)client;

- (void)requestWithBlock:(PPHttpModelCompletedBlock)completed;

@end
