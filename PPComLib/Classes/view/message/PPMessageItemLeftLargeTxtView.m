//
//  PPMessageItemLeftLargeTxtView.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemLeftLargeTxtView.h"

#import "PPMessageTxtMediaPart.h"

#import "PPLog.h"

NSString *const PPMessageItemLeftLargeTxtViewIdentifier = @"PPMessageItemLeftLargeTxtViewIdentifier";

@implementation PPMessageItemLeftLargeTxtView

+ (NSString*)textContentInMessage:(PPMessage *)message {
    PPMessageTxtMediaPart *txtMediaPart = (PPMessageTxtMediaPart*)message.mediaPart;
    return txtMediaPart.txtContent;
}

- (NSString*)textContentInMessage:(PPMessage *)message {
    NSString *textContent = [PPMessageItemLeftLargeTxtView textContentInMessage:message];
    return textContent;
}

@end
