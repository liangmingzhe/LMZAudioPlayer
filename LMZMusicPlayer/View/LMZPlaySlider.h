//
//  LMZPlaySlider.h
//  LMZMusicPlayer
//
//  Created by 梁明哲 on 2021/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMZPlaySlider : UIView
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (assign, nonatomic) NSTimeInterval duration;  //总时长
- (void)moveTo:(float)percent;
@end

NS_ASSUME_NONNULL_END
