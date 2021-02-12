//
//  LMZAudioPlayer.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LMZAudioPlayer;
@protocol AudioDelegate<NSObject>

- (void)playerCurrentTime:(NSTimeInterval)time;
- (void)playerDidFinishPlaying:(LMZAudioPlayer *)player successfully:(BOOL)flag;
@end


@interface LMZAudioPlayer : NSObject


@property (nonatomic,assign) NSTimeInterval currentTime;
@property (nonatomic,weak)id <AudioDelegate>delegate;


- (void)playerAudioWithUrl:(NSURL *)url;        //播放本地视频
- (void)playerAudioWithData:(NSData *)data;     //播放网络/本地视频


- (NSTimeInterval)playerDuration;
- (NSTimeInterval)playerCurrentTime;
- (void)seekTo:(NSTimeInterval)time;

- (void)play;
- (void)pause;
- (void)stop;


- (void)setVolume:(float)value;
- (float)volume;

- (void)uninit;
@end

NS_ASSUME_NONNULL_END
