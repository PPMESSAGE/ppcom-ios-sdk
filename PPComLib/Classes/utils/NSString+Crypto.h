//
//  NSString+Crypto.h
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Crypto)

- (NSString*) pp_SHA1String;

- (NSString*) pp_MD5String;

@end
