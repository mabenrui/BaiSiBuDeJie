//
//  MaxShowPrictureController.m
//  My百思不得姐
//
//  Created by Max on 16/2/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxShowPrictureController.h"
#import "MaxTopicModel.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <DALabeledCircularProgressView.h>

@interface MaxShowPrictureController ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end

@implementation MaxShowPrictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [imageView addGestureRecognizer:tap];

    //图片尺寸
    CGFloat pictureW = kWidth;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;

    if (pictureH >= kHeight) {
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = kHeight / 2;
    }
    
    //立马显示最新的进度值
    //cell重用时,网络卡,cell可能一直显示的是上次的进度
    [self.progressView setProgress:self.topic.pictureProgress];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress];
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        self.topic.pictureProgress = progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveImage:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//这个方法的参数是固定的
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}
- (IBAction)transmit:(UIButton *)sender {
}
- (IBAction)Toback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
