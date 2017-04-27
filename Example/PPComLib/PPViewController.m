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
//     sdkConfiguration.hostUrl = @"http://192.168.0.204:8945";
//     sdkConfiguration.apiKey = @"YjRlZTYyNWY3ZThjMDJlNDg3YjRkYjNkZDQzNTk0NjdmODk1ZTMzNg==";
//     sdkConfiguration.apiSecret = @"MTU3ZWE3MWQ4MTc0NzgxNjRhNGViMTdhMWUyMDUxZTRlYzAzNjg2YQ==";
//     sdkConfiguration.appUUID = @"9c60acbd-44bb-11e6-94c0-acbc327f19e9";
//     sdkConfiguration.email = @"test_user@gamil.com";
    
    sdkConfiguration.hostUrl = @"https://ppmessage.cn";
    sdkConfiguration.apiKey = @"";
    sdkConfiguration.apiSecret = @"";
    sdkConfiguration.appUUID = @"";
    //sdkConfiguration.email = @"ThreeKingdoms@gamil.com";
    
    [[PPSDK sharedSDK] configure:sdkConfiguration];
    
    // Customer user info
    PPServiceUser *user = [[PPServiceUser alloc] init];
    user.userName = @"JasonLi";
    user.userIcon = @"https://avatars1.githubusercontent.com/u/7382247?v=3&u=dd690117b1933bea61be9eccd6feab806bf52c4d&s=140";
    [PPSDK sharedSDK].user = user;
    
    // Start PPSDK
    [[PPSDK sharedSDK] start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
