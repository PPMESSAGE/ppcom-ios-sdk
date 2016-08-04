//
//  PPMessageTxtMediaPart.h
//  PPMessage
//
//  Created by PPMessage on 2/22/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMessageBaseMediaPart.h"

@interface PPMessageTxtMediaPart : PPMessageBaseMediaPart

@property (nonatomic) NSURL *txtURL;
@property (nonatomic) NSString *txtContent;
@property (nonatomic) NSString *txtFid;

@end
