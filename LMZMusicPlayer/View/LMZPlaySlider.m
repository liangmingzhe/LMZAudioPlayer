//
//  LMZPlaySlider.m
//  LMZMusicPlayer
//
//  Created by 梁明哲 on 2021/2/11.
//

#import "LMZPlaySlider.h"
@interface LMZPlaySlider()
@end
@implementation LMZPlaySlider

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.slider setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10)];
    [self addSubview:self.slider];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateHighlighted];
    
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)moveTo:(float)percent {
    if (self.slider.isHighlighted == NO) { //防止拖动时错乱
        self.slider.value = percent;
    
        //当前播放时间
        NSInteger playMinute = (int)(self.duration * percent)/60;
        NSInteger playSecond = (int)(_duration * percent)%60;
        self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)playMinute,(long)playSecond];

        //音频总时长
        NSInteger durationMinute = (int)self.duration/60;
        NSInteger durationSecond = (int)self.duration%60;
        self.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)durationMinute,(long)durationSecond];
    }
}

- (void)sliderValueChanged:(UISlider *)sender {
    //当前播放时间
    NSInteger playMinute = (int)(self.duration * sender.value)/60;
    NSInteger playSecond = (int)(_duration * sender.value)%60;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)playMinute,(long)playSecond];

    //音频总时长
    NSInteger durationMinute = (int)self.duration/60;
    NSInteger durationSecond = (int)self.duration%60;
    self.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)durationMinute,(long)durationSecond];
}

@end
