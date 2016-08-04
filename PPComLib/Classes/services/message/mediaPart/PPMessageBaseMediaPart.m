//
//  PPMessageBaseMediaPart.m
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageBaseMediaPart.h"

@interface PPMessageBaseMediaPart ()

@end

@implementation PPMessageBaseMediaPart

+ (instancetype)mediaPartWithJSONString:(NSString*)jsonString {
    PPMessageBaseMediaPart *baseMediaPart = [[PPMessageBaseMediaPart alloc]init];
    return baseMediaPart;
}

- (NSString*)toJSONString {
    return nil;
}

@end
