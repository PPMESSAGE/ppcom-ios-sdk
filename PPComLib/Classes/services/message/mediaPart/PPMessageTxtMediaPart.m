//
//  PPMessageTxtMediaPart.m
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageTxtMediaPart.h"
#import "PPMessageUtils.h"
#import "PPSDKUtils.h"

@implementation PPMessageTxtMediaPart

+ (instancetype)mediaPartWithJSONString:(NSString *)jsonString {
    PPMessageTxtMediaPart *txtMediaPart = [PPMessageTxtMediaPart new];
    NSDictionary *dataDictionary = PPJSONStringToDictionary(jsonString);
    txtMediaPart.txtFid = dataDictionary[@"fid"];
    return txtMediaPart;
}

- (void)setTxtFid:(NSString *)txtFid {
    _txtFid = txtFid;
    _txtURL = [NSURL URLWithString:PPFileURL(_txtFid)];
}

- (NSString*)toJSONString {
    return PPDictionaryToJsonString(@{@"fid": self.txtFid});
}

@end
