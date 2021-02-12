//
//  LMZAudioPlayer.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//
/*
 开发笔记:
    1.AVAudioPlayer 播放进度的监听问题
    AVAudioPlayer没有提供播放进度的回调，只提供了 currentTime 和 duration两个参数。这里使用的方式是用NSTimer 定时更新获取进度。
    
 */

#import "LMZAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface LMZAudioPlayer()<AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation LMZAudioPlayer
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
/**
 * @param data  请求到音频数据
 * @discussion  播放网络视频必须转换成NSData，非常不方便
 */
- (void)playerAudioWithData:(NSData *)data {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:data
                                                error:&error];
    if (error != nil) {
        NSLog(@"%@",[error description]);
        return;
    }
    
    self.player.delegate = self;
    [self.player setNumberOfLoops:0];
    [self.player setVolume:1];
    [self.player setDelegate:self];
    [self.player prepareToPlay];
    if (self.player == nil) {
        NSLog(@"LMZ:Audio Error:%@",[error description]);
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                               error:nil];
        [_player play];
        __weak typeof (self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.player != nil) {
                weakSelf.currentTime = weakSelf.player.currentTime;
                if ([weakSelf.delegate respondsToSelector:@selector(playerCurrentTime:)]) {
                    [weakSelf.delegate playerCurrentTime:weakSelf.player.currentTime];
                    NSLog(@"LMZ: Audio Current Time:%f",weakSelf.player.currentTime);
                }
            }
        }];
    
        [[NSRunLoop currentRunLoop] addTimer:self.timer
                                     forMode:NSRunLoopCommonModes];  //防止被UITrakingMode干扰
        [self.timer fire];
    }
}

//播放音频
- (void)playerAudioWithUrl:(NSURL *)url {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                         error:&playerError];
    if (playerError != nil) {
        NSLog(@"%@",[playerError description]);
        return ;
    }
    self.player.delegate = self;
    [self.player setNumberOfLoops:0];
    [self.player setVolume:1];
    [self.player setDelegate:self];
    [self.player prepareToPlay];
    if (self.player == nil) {
        NSLog(@"LMZ:Audio Error:%@",[playerError description]);
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                               error:nil];
        [_player play];
        __weak typeof (self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.player != nil) {
                weakSelf.currentTime = weakSelf.player.currentTime;
                if ([weakSelf.delegate respondsToSelector:@selector(playerCurrentTime:)]) {
                    [weakSelf.delegate playerCurrentTime:weakSelf.player.currentTime];
                    NSLog(@"LMZ: Audio Current Time:%f",weakSelf.player.currentTime);
                }
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer
                                     forMode:NSRunLoopCommonModes];  //防止被UITrakingMode干扰
        [self.timer fire];
    }
}

- (NSTimeInterval)playerDuration {
    return [_player duration];
}
- (NSTimeInterval)playerCurrentTime {
    return [_player currentTime];
}

- (void)seekTo:(NSTimeInterval)time {
    [self.player setCurrentTime:time];
}


- (void)stop {
    [_player stop];
//    if(self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
}

- (void)pause {
    [_player pause];
}

- (void)play {
    [_player play];
}

- (void)uninit {
    self.player.delegate = nil;
    self.player = nil;
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setVolume:(float)value {
    [self.player setVolume:value];
}

- (float)volume {
    return [self.player volume];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"LMZ:Audio Play finish");
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if ([self.delegate respondsToSelector:@selector(playerDidFinishPlaying:successfully:)]) {
        [self.delegate playerDidFinishPlaying:self successfully:flag];
    }
}



- (void)dealloc {
    NSLog(@"");
}

@end
