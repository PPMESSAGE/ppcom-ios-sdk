//
//  PPMessageItemLeftUnknownView.m
//  PPMessage
//
//  Created by PPMessage on 3/10/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftUnknownView.h"
#import "PPSDKUtils.h"

NSString *const PPMessageItemLeftUnknownViewIdentifier = @"PPMessageItemLeftUnknownViewIdentifier";

@implementation PPMessageItemLeftUnknownView

+ (NSString*)textContentInMessage:(PPMessage *)message {
    return PPLocalizedString(@"Unknown Msg");
}

- (NSString*)textContentInMessage:(PPMessage *)message {
    return [[self class] textContentInMessage:message];
}

@end
