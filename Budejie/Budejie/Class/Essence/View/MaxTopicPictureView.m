//
//  MaxTopicPictureView.m
//  My百思不得姐
//
//  Created by Max on 16/2/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicPictureView.h"
#import "MaxTopicModel.h"
#import "MaxShowPrictureController.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>

@interface MaxTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

/** 进度条 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end


@implementation MaxTopicPictureView

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)];
    [self addGestureRecognizer:tap];
}
- (void)showPicture{
    MaxShowPrictureController *show = [MaxShowPrictureController new];
    show.topic = self.topic;
    //当前类是view 没有presentViewController方法
    //所以使用rootVC来弹出
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:show animated:YES completion:nil];
}

+ (instancetype)pictureView
{
    //类方法里面 self代表当前类 不需要self class
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (void)setTopic:(MaxTopicModel *)topic{
    _topic = topic;

    //立马显示最新的进度值
    //cell重用时,网络卡,cell可能一直显示的是上次的进度
    [self.progressView setProgress:topic.pictureProgress];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;

        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        if (topic.pictureProgress <= 0) {
            topic.pictureProgress = 0;
        }
        [self.progressView setProgress:topic.pictureProgress];

        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", topic.pictureProgress * 100];
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //只有大图才进行绘图操作
        if (! topic.isBigImage) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureFrame.size, YES, 0);
        
        //将下载完的图片image 绘制到上下文
        CGFloat width = topic.pictureFrame.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束上下文
        UIGraphicsEndImageContext();
    }];
    
    //判断gif,但是这样判断不准确,因为只判断了文件名的字符串,这个是可以改动的
    //最准确的做法是,取出图片的第一个字节,即可判断,SDWebImage就是这样判断的
    //SDWebImage中NSData+ImageContentType.m文件
    NSString *extension = topic.image1.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    if (topic.isBigImage) {
        //图片超过的部分需要减掉,这个设置是在xib做的,其中的 clip subviews
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.seeBigButton.hidden = NO;
    }else{
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.seeBigButton.hidden = YES;
    }
}

@end
