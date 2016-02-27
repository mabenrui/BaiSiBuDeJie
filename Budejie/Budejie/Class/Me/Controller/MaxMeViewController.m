//
//  MaxMeViewController.m
//  My百思不得姐
//
//  Created by Max on 16/2/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxMeViewController.h"

@interface MaxMeViewController ()

@end

@implementation MaxMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GlobalBg;
    
    //设置导航栏内容
    //initWithImage会使imageView的尺寸和image一样
    self.navigationItem.title = @"我的";
    
    //右边的按钮    
    UIBarButtonItem *night = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightClick)];
    UIBarButtonItem *setting = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    self.navigationItem.rightBarButtonItems = @[setting, night];
}

- (void)settingClick{
    LLog(@"%s", __func__);
}
- (void)nightClick{
    LLog(@"%s", __func__);
}


@end
