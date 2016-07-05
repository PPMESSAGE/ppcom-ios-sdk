//
//  PPBaseHttpService.h
//  Pods
//
//  Created by PPMessage on 7/4/16.
//
//

#import <Foundation/Foundation.h>

#import "PPSDK.h"
#import "PPAPI.h"
#import "PPServiceUser.h"
#import "PPApp.h"

typedef void (^PPHttpServiceCompletedBlock)(id obj);

@interface PPBaseHttpService : NSObject

@property (nonatomic) PPSDK *sdk;
@property (nonatomic) PPAPI *api;
@property (nonatomic) PPServiceUser *user;
@property (nonatomic) PPApp *app;

- (instancetype)initWithPPSDK:(PPSDK*)sdk;

@end
