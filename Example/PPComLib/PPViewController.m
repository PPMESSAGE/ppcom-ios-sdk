//
//  PPViewController.m
//  PPComLib
//
//  Created by PPMessage on 07/04/2016.
//  Copyright (c) 2016 PPMessage. All rights reserved.
//

#import "PPViewController.h"
#import <PPComLib/PPComLib.h>

@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Configure PPSDK
    PPSDKConfiguration *sdkConfiguration = [[PPSDKConfiguration alloc] init];
    [sdkConfiguration setHostUrl:@"https://ppmessage.cn" appUUID:@"XXXX-XXXXX-XXXXXXX" registrationId:@"xxxxxxxxxxxxxxxxxxxxxxxxxx"];
    
    [[PPSDK sharedSDK] configure:sdkConfiguration];
    
    // Start PPSDK
    [[PPSDK sharedSDK] start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
