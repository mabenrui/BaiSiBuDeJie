//
//  MaxTopicVoiceView.m
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicVoiceView.h"
#import "MaxTopicModel.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>

@interface MaxTopicVoiceView ()

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *playProgress;
@property (weak, nonatomic) IBOutlet UILabel *currentProgressLabel;
@property (weak, nonatomic) IBOutlet UIView *playVoiceBg;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation MaxTopicVoiceView

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 2;
    
    [self.playProgress setThumbImage:[UIImage imageNamed:@"voice-play-progress-icon"] forState:UIControlStateNormal];
    [self.playProgress setMinimumTrackImage:[UIImage imageNamed:@"voice-play-progress"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showVoice)];
    [self addGestureRecognizer:tap];
    
    //音乐播放完毕的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)showVoice
{
    
}

+ (instancetype)voiceView
{
    //类方法里面 self代表当前类 不需要self class
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (void)setTopic:(MaxTopicModel *)topic{
    _topic = topic;
    
    //播发器没有使用懒加载,因为在cell复用时,会出现同样的播放内容
    self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:topic.voiceuri]];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld播放", topic.playcount];
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", topic.voicetime/60, topic.voicetime%60];
    
    //立马显示最新的进度值
    //cell重用时,网络卡,cell可能一直显示的是上次的进度
    [self.progressView setProgress:topic.voiceProgress];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        [self bringSubviewToFront:self.progressView];
        
        topic.voiceProgress = 1.0 * receivedSize / expectedSize;
        if (topic.voiceProgress <= 0) {
            topic.voiceProgress = 0;
        }
        
        [self.progressView setProgress:topic.voiceProgress];
        
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", topic.voiceProgress * 100];

        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;

    }];
}

- (IBAction)playButtonClick:(UIButton *)sender {
    UIImage *pause = [UIImage imageNamed:@"playButtonPause"];
    UIImage *play = [UIImage imageNamed:@"playButtonPlay"];
    
    if (! self.topic.isActive) {
        
        if ([_delegate respondsToSelector:@selector(topicVoiceViewDidActive:)]) {
            [_delegate topicVoiceViewDidActive:self.topic];
        }

        [sender setImage:pause forState:UIControlStateNormal];
        
        //播放button滑动到左边
        if (sender.x > MaxMargin) {
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat delta = kWidth / 2 - self.playButton.width / 2 - MaxMargin;
                self.playButton.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
            } completion:^(BOOL finished) {
                [self playAction];
            }];
        }
        
        __weak AVPlayerItem *weakPlayerItem = self.playerItem;
        __weak MaxTopicVoiceView *weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat currenTime = weakPlayerItem.currentTime.value / weakPlayerItem.currentTime.timescale;
            CGFloat duration = weakPlayerItem.duration.value / weakPlayerItem.duration.timescale;
            weakSelf.currentProgressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)currenTime/60, (NSInteger)currenTime%60];
            weakSelf.playProgress.value = currenTime/duration;
        }];
        
        self.topic.isVoicePlaying = YES;
        self.topic.isActive = YES;
        
        [self.player play];
    }else if (self.topic.isVoicePlaying){
        //暂停音乐
        [self.player pause];
        self.topic.isVoicePlaying = NO;
        
        [self.playButton setImage:play forState:UIControlStateNormal];
    }else if (! self.topic.isVoicePlaying){
        //play音乐
        [self.player play];
        self.topic.isVoicePlaying = YES;
        
        [self.playButton setImage:pause forState:UIControlStateNormal];
    }
}
- (IBAction)beforeChangeProgress {
    [self.player pause];
}

- (IBAction)changePlayProgress:(UISlider *)sender {
    CGFloat duration = self.playerItem.duration.value / self.playerItem.duration.timescale;
    [self.player seekToTime:CMTimeMake(duration * sender.value, 1)];
}
- (IBAction)afterChangeProgress {
    [self.player play];
}

//播放开始时,视图处理
- (void)playAction
{
    self.playCountLabel.hidden = YES;
    self.playVoiceBg.hidden = NO;
    
    CGFloat delta = kWidth / 2 - self.playButton.width / 2 - MaxMargin;
    self.playButton.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
    
}
//播放完毕后视图处理
- (void)playEnd
{
    self.playCountLabel.hidden = NO;
    self.playVoiceBg.hidden = YES;
    
    self.playButton.transform = CGAffineTransformIdentity;
}

//播放完毕
- (void)playerDidEnd
{
    [self playEnd];
    
    //button的图标
    [self.playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    //播放进度初始化
    self.playProgress.value = 0;
    //音乐初始化
    [self.player seekToTime:CMTimeMake(0, 1)];
    
    self.topic.isVoicePlaying = NO;
    self.topic.isActive = NO;
}

@end
