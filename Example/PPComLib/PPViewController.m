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
    sdkConfiguration.hostUrl = @"https://ppmessage.com";
    sdkConfiguration.apiKey = @"M2ZiZmZiMGI0MjUzZmM1MTRmMjk5ZDY0MThhNTFlZDdjMTJlMDVkOQ==";
    sdkConfiguration.apiSecret = @"NTAwMzEzYjVmZGMzOGU5MmY3YWRjNmE2M2FjOTU3NTdkOWQ1ZGY0Ng==";
    sdkConfiguration.appUUID = @"77933ab0-f17c-11e5-8957-02287b8c0ebf";
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
