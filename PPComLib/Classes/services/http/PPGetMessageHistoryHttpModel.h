//
//  PPGetMessageHistoryHttpModel.h
//  PPComLib
//
//  Created by PPMessage on 4/11/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetMessageHistoryHttpModel : NSObject

+ (instancetype)modelWithClient:(PPSDK*)client;

- (void)requestWithConversationUUID:(NSString*)conversationUUID
                         pageOffset:(NSInteger)pageOffset
                           pageSize:(NSInteger)pageSize
                          completed:(PPHttpModelCompletedBlock)completedBlock;

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                         pageOffset:(NSInteger)pageOffset
                          completed:(PPHttpModelCompletedBlock)completedBlock;

- (void)requestWithConversationUUID:(NSString *)conversationUUID
                            maxUUID:(NSString *)maxUUID
                          completed:(PPHttpModelCompletedBlock)completedBlock;
@end
