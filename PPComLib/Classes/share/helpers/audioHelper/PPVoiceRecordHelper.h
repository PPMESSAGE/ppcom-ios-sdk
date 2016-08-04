//
//  PPMessageUtils.h
//  PPMessage
//
//  Created by PPMessage on 7/13/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^PPPrepareRecorderCompletion)();
typedef void(^PPStartRecorderCompletion)();
typedef void(^PPStopRecorderCompletion)();
typedef void(^PPPauseRecorderCompletion)();
typedef void(^PPResumeRecorderCompletion)();
typedef void(^PPCancellRecorderDeleteFileCompletion)();
typedef void(^PPRecordProgress)(float progress);
typedef void(^PPPeakPowerForChannel)(float peakPowerForChannel);

//Default max audio total time
extern CGFloat const PPVoiceRecorderTotalTime;

@interface PPVoiceRecordHelper : NSObject

@property (nonatomic, copy) PPStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) PPRecordProgress recordProgress;
@property (nonatomic, copy) PPPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(PPPrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(PPStartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(PPPauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(PPResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(PPStopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(PPCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
