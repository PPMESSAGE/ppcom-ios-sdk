//
//  PPGetConversationsFromHTTP.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

#import "PPBaseHttpService.h"

typedef void(^PPGetConversationsBlock)(NSMutableArray* conversationArray);

@interface PPGetConversationsFromHTTP : PPBaseHttpService

- (void)getConversationsWithBlock:(PPGetConversationsBlock)block;

@end
