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

- (AVPlayer *)player
{
    if (nil == _player) {
        if (nil == _playerItem) {
            NSURL *uri = [NSURL URLWithString:self.topic.voiceuri];
            _playerItem = [[AVPlayerItem alloc]initWithURL:uri];
        }
        
        _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    }
    
    return _player;
}
- (AVPlayerItem *)playerItem
{
    if (nil == _playerItem) {
        NSURL *uri = [NSURL URLWithString:self.topic.voiceuri];
        _playerItem = [[AVPlayerItem alloc]initWithURL:uri];
    }
    return _playerItem;
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
        
        //只有大图才进行绘图操作
        if (! topic.isBigImage) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.voiceFrame.size, YES, 0);
        
        //将下载完的图片image 绘制到上下文
        CGFloat width = topic.voiceFrame.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束上下文
        UIGraphicsEndImageContext();
    }];
}

- (IBAction)playButtonClick:(UIButton *)sender {
    UIImage *pause = [UIImage imageNamed:@"playButtonPause"];
    UIImage *play = [UIImage imageNamed:@"playButtonPlay"];

    if (! self.topic.isPlaying) {

        [sender setImage:pause forState:UIControlStateNormal];
        
        //播放button滑动到左边
        if (sender.x > MaxMargin) {
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat delta = kWidth / 2 - self.playButton.width / 2 - MaxMargin;
                self.playButton.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
            } completion:^(BOOL finished) {
                [self playAction];
            }];
            
            __weak AVPlayerItem *weakPlayerItem = self.playerItem;
            __weak MaxTopicVoiceView *weakSelf = self;
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                CGFloat currenTime = weakPlayerItem.currentTime.value / weakPlayerItem.currentTime.timescale;
                CGFloat duration = weakPlayerItem.duration.value / weakPlayerItem.duration.timescale;
                weakSelf.currentProgressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)currenTime/60, (NSInteger)currenTime%60];
                weakSelf.playProgress.value = currenTime/duration;
            }];
        }
        
        self.topic.isPlaying = YES;
        
        [self.player play];
    }else{
        [sender setImage:play forState:UIControlStateNormal];
        self.topic.isPlaying = NO;
        [self.player pause];
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

- (void)playAction
{
    self.playCountLabel.hidden = YES;
    self.playVoiceBg.hidden = NO;
    
    CGFloat delta = kWidth / 2 - self.playButton.width / 2 - MaxMargin;
    self.playButton.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
    
}
- (void)playEnd
{
    self.playCountLabel.hidden = NO;
    self.playVoiceBg.hidden = YES;
    
    self.playButton.transform = CGAffineTransformIdentity;
}

- (void)playerDidEnd
{
    if (self.playButton.x <= MaxMargin) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playButton.transform = CGAffineTransformIdentity;
        }];
    }
    [self playEnd];
    [self.playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    self.playProgress.value = 0;
    [self.player seekToTime:CMTimeMake(0, 1)];
    
    self.topic.isPlaying = NO;
}

@end
