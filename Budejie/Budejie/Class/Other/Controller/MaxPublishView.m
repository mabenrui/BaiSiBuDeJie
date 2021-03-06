//
//  MaxPublish.m
//  Budejie
//
//  Created by Max on 16/2/27.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxPublishView.h"
#import "MaxVerticalButton.h"
#import "POP.h"

#define MaxRootVC [UIApplication sharedApplication].keyWindow.rootViewController.view

#define buttonTag 50

/** POP 和 CoreAnimation区别
 * CoreAnimation动画只能添加到layer上
 * POP动画可以添加到任何对象上
 * POP的底层并非基于CoreAnimation,是基于CADisplayLink
 * CoreAnimation的动画"效果"只是表面,并么有真实改变frame,size等属性
 * POP动画是实时的真正修改对象的属性
 *
 */

@interface MaxPublishView ()

@end

@implementation MaxPublishView

- (void)awakeFromNib {
    [self customButtons];
}

+ (instancetype)publishView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

static UIWindow *window_;
+ (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MaxPublishView *publish = [MaxPublishView publishView];
    publish.frame = window.bounds;
    
    [window addSubview:publish];    
}

- (void)customButtons{
    //动画开始之前, 禁止所有子控件的点击事件
    self.userInteractionEnabled = NO;
    MaxRootVC.userInteractionEnabled = NO;
    
    //数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    //6个button
    NSInteger maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartX = 20;
    CGFloat buttonStartY = kHeight / 2 - buttonH;
    //buton间距
    CGFloat xMargin = (kWidth - 2*buttonStartX - maxCols*buttonW) / (maxCols - 1);
    
    NSInteger count = images.count;
    for (int i = 0; i < count; i++) {
        MaxVerticalButton *button = [MaxVerticalButton new];
        [self addSubview:button];
        
        //设置button
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + buttonTag;
        
        //设置frame
        NSInteger row = i / maxCols;
        NSInteger col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (buttonW + xMargin);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonStartY = buttonEndY - kHeight;
        
        //设置动画
        POPSpringAnimation *aniForButton = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect fromValue = CGRectMake(buttonX, buttonStartY, buttonW, buttonH);
        CGRect toValue = CGRectMake(buttonX, buttonEndY, buttonW, buttonH);
        aniForButton.fromValue = [NSValue valueWithCGRect:fromValue];
        aniForButton.toValue = [NSValue valueWithCGRect:toValue];
        aniForButton.springBounciness = 10;
        aniForButton.springSpeed = 10;
        aniForButton.beginTime = CACurrentMediaTime() + 0.04*i;
        
        [button pop_addAnimation:aniForButton forKey:@"button"];
    }
    
    //添加标语
    UIImageView *slogan = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:slogan];
    //标语动画
    POPSpringAnimation *aniForSlogan = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    CGFloat centerX = kWidth / 2;
    CGFloat centerEndY = kHeight * 0.2;
    CGFloat centerStartY = centerEndY - kHeight;
    
    aniForSlogan.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerStartY)];
    aniForSlogan.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    aniForSlogan.beginTime = CACurrentMediaTime() + count * 0.04;
    
    //防止循环引用
    __weak MaxPublishView *publishWeak = self;
    
    [aniForSlogan setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
        //所有动画执行完毕, 恢复点击事件
        publishWeak.userInteractionEnabled = YES;
        MaxRootVC.userInteractionEnabled = YES;
    }];
    
    [slogan pop_addAnimation:aniForSlogan forKey:@"slogan"];
}
- (void)buttonClick:(UIButton *)button{
    
    [self cancelWithCompletionBlock:^{
        if (button.tag == buttonTag) {
            LLog(@"发视频");
        }
    }];
}

- (IBAction)cancel {
    
    [self cancelWithCompletionBlock:nil];
}

- (void)cancelWithCompletionBlock:(void(^)())block{
    //动画之前禁止事件
    self.userInteractionEnabled = NO;

    NSInteger count = self.subviews.count;
    NSInteger index = 1;
    for (NSInteger i = index; i < count; i++) {
        UIView *subView = self.subviews[i];
        CGFloat centerY = subView.centerY;
        CGFloat centerEndY = centerY + kHeight;
        
        POPBasicAnimation *bAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        bAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        bAni.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerEndY)];
        bAni.beginTime = CACurrentMediaTime() + 0.04 * (i - index);
        
        if (i == count - 1) {
            //防止循环引用
            __weak MaxPublishView *publishWeak = self;
            
            [bAni setCompletionBlock:^(POPAnimation * anim, BOOL finish) {
                [publishWeak removeFromSuperview];
                MaxRootVC.userInteractionEnabled = YES;

                ! block ? : block();
            }];
        }
        
        [subView pop_addAnimation:bAni forKey:@"subView"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancel];
}
//-(void)dealloc{
//    NSLog(@"dealloc");
//}

@end
