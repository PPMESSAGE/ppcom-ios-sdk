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
    sdkConfiguration.hostUrl = @"http://192.168.0.52:8945";
    sdkConfiguration.apiKey = @"ZGEwYjExYzFkOGI1N2YxYTRiNGI5MGYzMzQwZjQ3NTllZmY2MWMzNw==";
    sdkConfiguration.apiSecret = @"NTEyYmJhOWM3NTZhYWRlNjhhYjA1ODljODU0YjlhODUwZDViZDAyYw==";
    sdkConfiguration.appUUID = @"6892a540-4439-11e6-98b2-ac87a30c6610";
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
