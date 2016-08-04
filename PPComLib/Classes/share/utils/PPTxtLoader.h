//
//  PPTxtLoader.h
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTxtLoader : NSObject

+ (instancetype)sharedLoader;

- (void)loadTxtWithURL:(NSURL*)txtURL
             completed:(void (^)(NSString *text, NSError *error, NSURL *txtURL))completedHandler;
- (void)loadTxtWithURL:(NSURL *)txtURL
           httpTimeout:(NSUInteger)httpTimeoutInMilliSeconds
             completed:(void (^)(NSString *, NSError *, NSURL *))completedHandler;

@end
