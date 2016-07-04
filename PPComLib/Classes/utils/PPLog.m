//
//  PPLog.m
//  PPMessage
//
//  Created by PPMessage on 2/4/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPLog.h"

#define PP_ENABLE_LOG
#define PP_ENABLE_WARN

void PPFastLog(NSString *format, ...)  {
#ifdef PP_ENABLE_LOG
    __block va_list arg_list;
    va_start (arg_list, format);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    
    va_end(arg_list);
    
    NSLog(@"[PP] %@", formattedString);
#endif
}

void PPFastWarn(NSString *format, ...)  {
#ifdef PP_ENABLE_WARN
    __block va_list arg_list;
    va_start (arg_list, format);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    
    va_end(arg_list);
    
    NSLog(@"[PP] %@", formattedString);
#endif
}