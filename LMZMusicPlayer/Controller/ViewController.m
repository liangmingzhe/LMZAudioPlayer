//
//  ViewController.m
//  LMZMusicPlayer
//
//  Created by 梁明哲 on 2021/2/11.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>
#import "LMZAudioPlayer.h"
#import "LMZPlaySlider.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AudioDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *musicCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet LMZPlaySlider *sliderView;

@property (strong, nonatomic) LMZAudioPlayer *musicPlayer;
@property (strong, nonatomic) AVURLAsset     *avURLAsset;


@property (strong, nonatomic) NSArray <NSString *> *musicListArray;
@property (assign, nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [ViewController createImageWithColor:[UIColor darkGrayColor] frame:self.backgroundImageView.bounds];
    [self requestmusicList];
    self.index = 0;
//    self.sliderView = [[[NSBundle mainBundle] loadNibNamed:@"LMZPlaySlider"
//                                                     owner:self
//                                                   options:nil] lastObject];
    [self.sliderView setFrame:CGRectMake(20, self.playBtn.frame.origin.y - 160, [UIScreen mainScreen].bounds.size.width - 40, 60)];
//    [self.view addSubview:self.sliderView];
    [self.sliderView.slider addTarget:self action:@selector(sliderHandUpHandle:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}


//快速定位
- (void)sliderHandUpHandle:(UISlider *)sender {
    [self.musicPlayer seekTo:self.musicPlayer.playerDuration * self.sliderView.slider.value];
}
- (void)requestmusicList {
    NSString *bigBang = [[NSBundle mainBundle] pathForResource:@"BIGBANG - Bigbang" ofType:@"mp3"];
    NSString *bigBang2 = [[NSBundle mainBundle] pathForResource:@"BIGBANG - 뱅뱅뱅 (BANG BANG BANG) (Live)" ofType:@"mp3"];
    NSString *yunyuhai = [[NSBundle mainBundle] pathForResource:@"仰思琪 - 云与海（翻自 辛远）" ofType:@"mp3"];
    
    self.musicListArray = @[bigBang2,
                            @"https://mp32.9ku.com/upload/128/2020/04/17/1003659.mp3",
                            yunyuhai,
                            @"https://mp32.9ku.com/upload/128/2020/04/17/1003666.mp3",
                            @"https://mp32.9ku.com/upload/128/2020/04/17/1003670.mp3",
                            bigBang];

}
- (void)setupPlayerWithIndex:(NSInteger)index {
    self.musicPlayer = [[LMZAudioPlayer alloc] init];
    self.musicPlayer.delegate = self;
    
    NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.musicListArray[index]]];
    if (audioData != nil) {
        //网络歌曲
        [self.musicPlayer playerAudioWithData:audioData];
        [self.playBtn setSelected:YES];
        
        _avURLAsset =
        [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.musicListArray[index]] options:nil];
        NSArray<AVMetadataFormat> * formatArr = [self.avURLAsset availableMetadataFormats];
        if (formatArr.count <= 0) {
            self.songLabel.text = [NSString stringWithFormat:@"歌曲:未知"];
            self.singerLabel.text = [NSString stringWithFormat:@"歌手:未知"];
            self.musicCoverImageView.image = [UIImage imageNamed:@"default"];
            return;
        }
        for (NSString *fmt in formatArr) {
            for (AVMetadataItem *metadataItem in [self.avURLAsset metadataForFormat:fmt]) {
                if ([metadataItem.commonKey isEqualToString:@"title"]) {
                    NSLog(@"title---%@",metadataItem.value);
                    self.songLabel.text = [NSString stringWithFormat:@"歌曲:%@",metadataItem.value];
                }else if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                    NSLog(@"artist---%@",metadataItem.value);
                    self.singerLabel.text = [NSString stringWithFormat:@"歌手:%@",metadataItem.value];
                }else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
                    NSLog(@"artwork---%@",metadataItem.value);
                    
                }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                    NSLog(@"Item value %@",metadataItem.value);
                    NSMutableData *dict = (NSMutableData *)[metadataItem value];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.musicCoverImageView.image = [UIImage imageWithData:dict];
                    });
                }
            }
        }
    }else {
        //本地歌曲
        [self.musicPlayer playerAudioWithUrl:[NSURL fileURLWithPath:_musicListArray[index]]];
        [self.playBtn setSelected:YES];
        _avURLAsset =
        [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.musicListArray[index]] options:nil];
        
        NSArray<AVMetadataFormat> * formatArr = [self.avURLAsset availableMetadataFormats];
        if (formatArr.count <= 0) {
            self.songLabel.text = [NSString stringWithFormat:@"歌曲:未知"];
            self.singerLabel.text = [NSString stringWithFormat:@"歌手:未知"];
            self.musicCoverImageView.image = [UIImage imageNamed:@"default"];
            return;
        }
        for (NSString *fmt in formatArr) {
            for (AVMetadataItem *metadataItem in [self.avURLAsset metadataForFormat:fmt]) {
                if ([metadataItem.commonKey isEqualToString:@"title"]) {
                    NSLog(@"title---%@",metadataItem.value);
                    self.songLabel.text = [NSString stringWithFormat:@"歌曲:%@",metadataItem.value];
                }else if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                    NSLog(@"artist---%@",metadataItem.value);
                    self.singerLabel.text = [NSString stringWithFormat:@"歌手:%@",metadataItem.value];
                }else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
                    NSLog(@"artwork---%@",metadataItem.value);
                    
                }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                    NSLog(@"Item value %@",metadataItem.value);
                    NSMutableData *dict = (NSMutableData *)[metadataItem value];
                    dispatch_async(dispatch_get_main_queue(), ^{

                        self.musicCoverImageView.image = [UIImage imageWithData:dict];
                    });
                }
            }
        }
    }
}


//正常来说需要封装封装成单独的UI
// 播放、暂停
- (IBAction)playMusic:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self.musicPlayer play];
    }else {
        [self.musicPlayer pause];
    }
}

// 播放下一首
- (IBAction)playNext:(UIButton *)sender {
    if (self.index < self.musicListArray.count - 1) {
        self.index++;
    }else {
        self.index = 0;
    }
}

// 播放上一首
- (IBAction)playLast:(UIButton *)sender {
    if (self.index > 0) {
        self.index--;
    }else {
        self.index = self.musicListArray.count - 1;
    }
}

/**
 * @abstract 播放列表中第index首歌曲
 * @param index 歌曲在列表中的位置
 */
- (void)setIndex:(NSInteger)index {
    _index = index;
    [self setupPlayerWithIndex:_index];
}

#pragma mark AudioDelegate
- (void)playerCurrentTime:(NSTimeInterval)time {
    if (time == 0) {
        return;
    }
    self.sliderView.duration = self.musicPlayer.playerDuration;
    [self.sliderView moveTo:time/self.musicPlayer.playerDuration];    
}

- (void)playerDidFinishPlaying:(LMZAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        if (self.index < self.musicListArray.count - 1) {
            self.index++;
        }else {
            self.index = 0;
        }
    }
}

+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
