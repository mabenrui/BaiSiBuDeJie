//
//  MaxFriendTrendsViewController.m
//  My百思不得姐
//
//  Created by Max on 16/2/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxFriendTrendsViewController.h"
#import "MaxRecommendViewController.h"
#import "MaxLoginRegisterController.h"

@interface MaxFriendTrendsViewController ()

@end

@implementation MaxFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GlobalBg;
    
    //设置导航栏内容
    //initWithImage会使imageView的尺寸和image一样
    self.navigationItem.title = @"我的关注";
    
    //左边的按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)friendsClick{
    MaxRecommendViewController *recommend = [MaxRecommendViewController new];
    
    [self.navigationController pushViewController:recommend animated:YES];
}
- (IBAction)loginRegister:(UIButton *)sender {
    MaxLoginRegisterController *loginRegister = [MaxLoginRegisterController new];
    [self presentViewController:loginRegister animated:YES completion:nil];
}

@end
