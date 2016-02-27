//
//  MaxNewViewController.m
//  My百思不得姐
//
//  Created by Max on 16/2/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxNewViewController.h"

@interface MaxNewViewController ()

@end

@implementation MaxNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GlobalBg;
    
    //设置导航栏内容
    //initWithImage会使imageView的尺寸和image一样
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //左边的按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)tagClick{
    LLog(@"%s", __func__);
}
@end
