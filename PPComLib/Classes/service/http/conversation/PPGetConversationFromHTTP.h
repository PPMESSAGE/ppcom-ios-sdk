//
//  PPGetConversationInfoFromHTTP.h
//  Pods
//
//  Created by Jin He on 7/5/16.
//
//

#import <PPComLib/PPComLib.h>
#import "PPBaseHTTPService.h"

@interface PPGetConversationFromHTTP : PPBaseHttpService

- (void) getConversation: (NSString *)conversationUUID withBlock: (PPHttpServiceCompletedBlock) block;

@end
