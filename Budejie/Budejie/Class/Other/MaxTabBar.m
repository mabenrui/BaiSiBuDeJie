//
//  MaxTabBar.m
//  My百思不得姐
//
//  Created by Max on 16/2/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTabBar.h"

@interface MaxTabBar ()

@property (nonatomic, weak) UIButton *pulish;

@end

@implementation MaxTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        //中间的发布按钮
        UIButton *pulish = [UIButton buttonWithType:UIButtonTypeCustom];
        [pulish setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [pulish setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        pulish.size = pulish.currentBackgroundImage.size;//没有直接设置frame,是因为在init里面frame可能出错
        
        [self addSubview:pulish];
        
        self.pulish = pulish;

    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    self.pulish.center = CGPointMake(width * 0.5, height * 0.5);
    
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        //这个continue是为了过滤中间的pulish
        //之所以使用NSClassFromString是因为UITabBarButton是私有类,我们不可以直接调用
        //比如调用[UITabBarButton class]
        if (! [button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        
        //index的处理是因为中间有个pulish按钮
        CGFloat buttonX = buttonW * (index > 1 ? index + 1 : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index++;
    }
}


@end
