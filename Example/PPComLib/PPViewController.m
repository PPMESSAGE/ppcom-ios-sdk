//
//  PPViewController.m
//  PPComLib
//
//  Created by PPMessage on 07/04/2016.
//  Copyright (c) 2016 PPMessage. All rights reserved.
//

#import <PPComLib/PPComLib.h>
#import "PPViewController.h"

@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Configure PPSDK
    PPSDK *sdk = [PPSDK sharedSDK];
    PPSDKConfiguration *sdkConfiguration = [PPSDKConfiguration new];

    sdkConfiguration.hostUrl = @"http://192.168.0.52:8945";
    sdkConfiguration.apiKey = @"YmIyMGM4ZThhNTZhMDVmOTZiOGMwYWY1YzQyOWNkZTViZDI1MjNlMg==";
    sdkConfiguration.apiSecret = @"NzBkMWNiMmQ1OWFmMzYzYjJkNjVlMWRjMDNmNTg4ODNmYjk0OTUwZg==";
    sdkConfiguration.appUUID = @"568bd914-53d1-11e6-b4f5-ac87a30c6610";
    sdkConfiguration.email = @"ThreeKingdoms@gamil.com";

    [sdk configure:sdkConfiguration];

    // Start PPSDK
    [sdk start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
