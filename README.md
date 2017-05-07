# PPComLib

[![CI Status](http://img.shields.io/travis/PPMessage/PPComLib.svg?style=flat)](https://travis-ci.org/PPMessage/PPComLib)
[![Version](https://img.shields.io/cocoapods/v/PPComLib.svg?style=flat)](http://cocoapods.org/pods/PPComLib)
[![License](https://img.shields.io/cocoapods/l/PPComLib.svg?style=flat)](http://cocoapods.org/pods/PPComLib)
[![Platform](https://img.shields.io/cocoapods/p/PPComLib.svg?style=flat)](http://cocoapods.org/pods/PPComLib)

## Try Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

> You may need refresh your existed cocoapods repos before running `pod install`.

```
cd ~/.cocoapods/repos/master; git pull;
```


## Pod

> current version: 0.2.0

## Installation

PPComLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PPComLib"
```


## Init

> Init with anonymous user

```objective-c

    PPSDKConfiguration *sdkConfiguration = [[PPSDKConfiguration alloc] init];
    [sdkConfiguration setHostUrl:@"https://ppmessage.cn" appUUID:@"XXXX-XXXXX-XXXXXXX" registrationId:@"xxxxxxxxxxxxxxxxxxxxxxxxxx"];
    [[PPSDK sharedSDK] configure:sdkConfiguration];
    [[PPSDK sharedSDK] start];
    
```

> Init with named user


```objective-c

    PPSDKConfiguration *sdkConfiguration = [[PPSDKConfiguration alloc] init];
    [sdkConfiguration setHostUrl:@"https://ppmessage.cn" appUUID:@"XXXX-XXXXX-XXXXXXX" registrationId:@"xxxxxxxxxxxxxxxxxxxxxxxxxx" entUser:@{@"ent_user_id": @"the_user_id", @"ent_user_name": @"the_user_name", @"ent_user_icon": @"the_user_icon", @"ent_user_create_time": @"the_user_create_time", 123456}];
    [[PPSDK sharedSDK] configure:sdkConfiguration];
    [[PPSDK sharedSDK] start];
    
```



## Author

kun.zhao@ppmessage.com, jin.he@ppmessage.com, guijin.ding@ppmessage.com

## License

PPComLib is available under the MIT license. See the LICENSE file for more info.
