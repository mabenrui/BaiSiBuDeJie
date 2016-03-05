//
//  MaxTopicVideoView.m
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicVideoView.h"
#import "MaxTopicModel.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>


@interface MaxTopicVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation MaxTopicVideoView

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showVideo)];
    [self addGestureRecognizer:tap];
}
- (void)showVideo
{
    
}


+ (instancetype)videoView
{
    //类方法里面 self代表当前类 不需要self class
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (void)createLayer:(AVPlayer *)player
{
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    NSLog(@"%@", NSStringFromCGRect(self.imageView.frame));
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
    layer.frame = self.imageView.bounds;
    
    
    [self.imageView.layer addSublayer:layer];
}

- (void)setTopic:(MaxTopicModel *)topic{
    _topic = topic;
    
    //播发器没有使用懒加载,因为在cell复用时,会出现同样的播放内容
    self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:topic.videouri]];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld播放", topic.playcount];
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", topic.videotime/60, topic.videotime%60];
    
    //立马显示最新的进度值
    //cell重用时,网络卡,cell可能一直显示的是上次的进度
    [self.progressView setProgress:topic.voiceProgress];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        [self bringSubviewToFront:self.progressView];
        
        topic.videoProgress = 1.0 * receivedSize / expectedSize;
        if (topic.videoProgress <= 0) {
            topic.videoProgress = 0;
        }
        
        [self.progressView setProgress:topic.videoProgress];
        
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", topic.videoProgress * 100];
        
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}


- (IBAction)playButtonClick:(UIButton *)sender {
//    UIImage *pause = [UIImage imageNamed:@"playButtonPause"];
//    UIImage *play = [UIImage imageNamed:@"playButtonPlay"];
    
    if (! self.topic.isActive) {
        [self createLayer:self.player];
//        if ([_delegate respondsToSelector:@selector(topicVoiceViewDidActive:)]) {
//            [_delegate topicVoiceViewDidActive:self.topic];
//        }
        
//        [sender setImage:pause forState:UIControlStateNormal];
        
        //播放button滑动到左边
        if (sender.x > MaxMargin) {
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat delta = kWidth / 2 - self.playButton.width / 2 - MaxMargin;
                self.playButton.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
            } completion:^(BOOL finished) {
//                [self playAction];
            }];
        }
        
//        __weak AVPlayerItem *weakPlayerItem = self.playerItem;
//        __weak MaxTopicVideoView *weakSelf = self;
//        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//            CGFloat currenTime = weakPlayerItem.currentTime.value / weakPlayerItem.currentTime.timescale;
//            CGFloat duration = weakPlayerItem.duration.value / weakPlayerItem.duration.timescale;
//            weakSelf.currentProgressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)currenTime/60, (NSInteger)currenTime%60];
//            weakSelf.playProgress.value = currenTime/duration;
//        }];
        
        self.topic.isVideoPlaying = YES;
        self.topic.isActive = YES;
        
        [self.player play];
    }
}

@end
