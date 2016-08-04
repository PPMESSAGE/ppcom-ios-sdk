//
//  PPMessageBaseMediaPart.h
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMessageMediaPart.h"

@interface PPMessageBaseMediaPart : NSObject<PPMessageMediaPart>

+ (instancetype)mediaPartWithJSONString:(NSString*)jsonString;

@end
