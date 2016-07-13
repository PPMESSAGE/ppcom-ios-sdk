//
//  PPMessageUtils.h
//  PPMessage
//
//  Created by PPMessage on 7/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPVoiceRecordHelper.h"
#import "PPLog.h"

#import <AVFoundation/AVFoundation.h>

CGFloat const PPVoiceRecorderTotalTime = 60.0;

@interface PPVoiceRecordHelper () <AVAudioRecorderDelegate> {
    NSTimer *_timer;
    
    BOOL _isPause;
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	UIBackgroundTaskIdentifier _backgroundIdentifier;
#endif
}

@property (nonatomic, copy, readwrite) NSString *recordPath;
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation PPVoiceRecordHelper

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = PPVoiceRecorderTotalTime;
        self.recordDuration = @"0";
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
		_backgroundIdentifier = UIBackgroundTaskInvalid;
#endif
    }
    return self;
}

- (void)dealloc {
    [self stopRecord];
    self.recordPath = nil;
    [self stopBackgroundTask];
}

- (void)startBackgroundTask {
	[self stopBackgroundTask];
	
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	_backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		[self stopBackgroundTask];
	}];
#endif
}

- (void)stopBackgroundTask {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	if (_backgroundIdentifier != UIBackgroundTaskInvalid) {
		[[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
		_backgroundIdentifier = UIBackgroundTaskInvalid;
	}
#endif
}

- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)cancelRecording {
    if (!_recorder)
        return;
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)stopRecord {
    [self cancelRecording];
    [self resetTimer];
}

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(PPPrepareRecorderCompletion)prepareRecorderCompletion {
    typeof(self) __weak weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _isPause = NO;
        
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
        if(error) {
            PPFastLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        error = nil;
        [audioSession setActive:YES error:&error];
        if(error) {
            PPFastLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        if (weakSelf) {
            typeof(weakSelf) __strong strongSelf = weakSelf;
            strongSelf.recordPath = path;
            error = nil;
            
            if (strongSelf.recorder) {
                [strongSelf cancelRecording];
            } else {
                strongSelf.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:strongSelf.recordPath] settings:recordSetting error:&error];
                strongSelf.recorder.delegate = strongSelf;
                [strongSelf.recorder prepareToRecord];
                strongSelf.recorder.meteringEnabled = YES;
                [strongSelf.recorder recordForDuration:(NSTimeInterval) 160];
                [strongSelf startBackgroundTask];
            }
            
            if(error) {
                PPFastLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //上層如果傳會來說已經取消了, 那這邊就做原先取消的動作
                if (!prepareRecorderCompletion()) {
                    [strongSelf cancelledDeleteWithCompletion:^{
                    }];
                }
            });
        }
    });
}

- (void)startRecordingWithStartRecorderCompletion:(PPStartRecorderCompletion)startRecorderCompletion {
    if ([_recorder record]) {
        [self resetTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
        if (startRecorderCompletion)
            dispatch_async(dispatch_get_main_queue(), ^{
                startRecorderCompletion();
            });
    }
}

- (void)resumeRecordingWithResumeRecorderCompletion:(PPResumeRecorderCompletion)resumeRecorderCompletion {
    _isPause = NO;
    if (_recorder) {
        if ([_recorder record]) {
            dispatch_async(dispatch_get_main_queue(), resumeRecorderCompletion);
        }
    }
}

- (void)pauseRecordingWithPauseRecorderCompletion:(PPPauseRecorderCompletion)pauseRecorderCompletion {
    _isPause = YES;
    if (_recorder) {
        [_recorder pause];
    }
    if (!_recorder.isRecording)
        dispatch_async(dispatch_get_main_queue(), pauseRecorderCompletion);
}

- (void)stopRecordingWithStopRecorderCompletion:(PPStopRecorderCompletion)stopRecorderCompletion {
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    [self getVoiceDuration:_recordPath];
    dispatch_async(dispatch_get_main_queue(), stopRecorderCompletion);
}

- (void)cancelledDeleteWithCompletion:(PPCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion {
    
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    
    if (self.recordPath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.recordPath]) {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.recordPath error:&error];
            if (error) {
                PPFastLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(nil);
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion(nil);
        });
    }
}

- (void)updateMeters {
    if (!_recorder)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recorder updateMeters];
        
        self.currentTimeInterval = _recorder.currentTime;
        
        if (!_isPause) {
            float progress = self.currentTimeInterval / self.maxRecordTime * 1.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_recordProgress) {
                    _recordProgress(progress);
                }
            });
        }
        
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.015;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新扬声器
            if (_peakPowerForChannel) {
                _peakPowerForChannel(peakPowerForChannel);
            }
        });
        
        if (self.currentTimeInterval > self.maxRecordTime) {
            [self stopRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
                _maxTimeStopRecorderCompletion();
            });
        }
    });
}

- (void)getVoiceDuration:(NSString*)recordPath {
    NSError *error = nil;
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
    if (error) {
        PPFastLog(@"recordPath：%@ error：%@", recordPath, error);
        self.recordDuration = @"";
    } else {
        PPFastLog(@"时长:%f", play.duration);
        self.recordDuration = [NSString stringWithFormat:@"%.1f", play.duration];
    }
}

@end
