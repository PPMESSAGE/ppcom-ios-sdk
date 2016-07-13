//
//  PPVoiceRecord.m
//  PPMessage
//
//  Created by PPMessage on 2/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPVoiceRecord.h"

#import "PPSDKUtils.h"
#import "UIImage+PPSDK.h"

@interface PPVoiceRecord ()

@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIImageView *microPhoneImageView;
@property (nonatomic, weak) UIImageView *cancelRecordImageView;
@property (nonatomic, weak) UIImageView *recordingHUDImageView;

@end

@implementation PPVoiceRecord

- (void)startRecordingHUDAtView:(UIView *)view {
    CGPoint center = CGPointMake(CGRectGetWidth(view.frame) / 2.0, CGRectGetHeight(view.frame) / 2.0);
    self.center = center;
    [view addSubview:self];
    [self configRecoding:YES];
}

- (void)pauseRecord {
    [self configRecoding:YES];
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.remindLabel.text = PPLocalizedString(@"SlideToCancel");
}

- (void)resaueRecord {
    [self configRecoding:NO];
    self.remindLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.630];
    self.remindLabel.text = PPLocalizedString(@"ReleaseToCancel");
}

- (void)stopRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled];
}

- (void)cancelRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled];
}

- (void)dismissCompled:(void(^)(BOOL fnished))compled {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        compled(finished);
    }];
}

- (void)configRecoding:(BOOL)recording {
    self.microPhoneImageView.hidden = !recording;
    self.recordingHUDImageView.hidden = !recording;
    self.cancelRecordImageView.hidden = recording;
}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
    NSString *imageName = @"RecordingSignal00";
    if (peakPower >= 0 && peakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (peakPower > 0.1 && peakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (peakPower > 0.3 && peakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.4 && peakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.5 && peakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (peakPower > 0.7 && peakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"6"];
    } else if (peakPower > 0.8 && peakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"7"];
    } else if (peakPower > 0.9 && peakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"8"];
    }
    self.recordingHUDImageView.image = [UIImage pp_imageForName:imageName];
}

- (void)setPeakPower:(CGFloat)peakPower {
    _peakPower = peakPower;
    [self configRecordingHUDImageWithPeakPower:peakPower];
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    if (!_remindLabel) {
        UILabel *remindLabel= [[UILabel alloc] initWithFrame:CGRectMake(9.0, 114.0, 120.0, 21.0)];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:13];
        remindLabel.layer.masksToBounds = YES;
        remindLabel.layer.cornerRadius = 4;
        remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.text = PPLocalizedString(@"SlideToCancel");
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLabel];
        _remindLabel = remindLabel;
    }
    
    if (!_microPhoneImageView) {
        UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.0, 8.0, 50.0, 99.0)];
        microPhoneImageView.image = [UIImage pp_imageForName:@"RecordingBkg"];
        microPhoneImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:microPhoneImageView];
        _microPhoneImageView = microPhoneImageView;
    }
    
    if (!_recordingHUDImageView) {
        UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82.0, 34.0, 18.0, 61.0)];
        recordHUDImageView.image = [UIImage pp_imageForName:@"RecordingSignal001"];
        recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:recordHUDImageView];
        _recordingHUDImageView = recordHUDImageView;
    }
    
    if (!_cancelRecordImageView) {
        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.0, 7.0, 100.0, 100.0)];
        cancelRecordImageView.image = [UIImage pp_imageForName:@"RecordCancel"];
        cancelRecordImageView.hidden = YES;
        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:cancelRecordImageView];
        _cancelRecordImageView = cancelRecordImageView;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

@end
