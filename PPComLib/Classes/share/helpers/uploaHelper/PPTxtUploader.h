//
//  PPTxtUploader.h
//  PPMessage
//
//  Created by PPMessage on 2/26/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPUploader.h"

@interface PPTxtUploader : PPUploader

- (void)uploadWithText:(NSString *)text
             completed:(void (^)(NSDictionary *response, NSError *error))completedHandler;

@end
