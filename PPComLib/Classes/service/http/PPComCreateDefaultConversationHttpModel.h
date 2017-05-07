//
//  PPComCreateDefaultConversationHttpModel.h
//  Pods
//
//  Created by Guijin Ding on 07/05/2017.
//
//

#import <Foundation/Foundation.h>

@class PPSDK;

@interface PPComCreateDefaultConversationHttpModel : NSObject

+ (instancetype)modelWithSdk:(PPSDK*)sdk;

//+ (instancetype)modelWithClient:(PPSDK*)client;

- (void) request;

@end
