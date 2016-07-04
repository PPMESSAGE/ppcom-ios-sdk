//
//  PPMessageItemRightLargeTxtView.m
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemRightLargeTxtView.h"

#import "PPMessageTxtMediaPart.h"

NSString *const PPMessageItemRightLargeTxtViewIdentifier = @"PPMessageItemRightLargeTxtViewIdentifier";

@implementation PPMessageItemRightLargeTxtView

+ (NSString*)textContentInMessage:(PPMessage *)message {
    PPMessageTxtMediaPart *txtMediaPart = message.mediaPart;
    return txtMediaPart.txtContent;
}

- (NSString*)textContentInMessage:(PPMessage *)message {
    return [PPMessageItemRightLargeTxtView textContentInMessage:message];
}

@end
