//
//  PPTestData.h
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import <Foundation/Foundation.h>

@class PPApp, PPServiceUser;

@interface PPTestData : NSObject

+ (instancetype)sharedInstance;

- (NSMutableArray*)getConversations;
- (NSMutableArray*)getMessages;
- (NSMutableArray*)getGroupMembers;

- (PPApp*)getApp;
- (PPServiceUser*)getServiceUser;

@end
