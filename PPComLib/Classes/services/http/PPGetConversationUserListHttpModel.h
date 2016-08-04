//
//  PPGetConversationUserListHttpModel.h
//  PPComLib
//
//  Created by PPMessage on 4/14/16.
//  Copyright © 2016 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPHttpModel.h"

@class PPSDK;

@interface PPGetConversationUserListHttpModel : NSObject

+ (instancetype)modelWithClient:(PPSDK*)client;

- (void)usersWithConversationUUID:(NSString*)conversationUUID
                   completedBlock:(PPHttpModelCompletedBlock)completedBlock;

@end
