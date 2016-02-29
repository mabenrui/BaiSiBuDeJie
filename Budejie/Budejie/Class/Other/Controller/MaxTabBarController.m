//
//  MaxTabBarController.m
//  My百思不得姐
//
//  Created by Max on 16/1/31.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTabBarController.h"
#import "MaxEssenceViewController.h"
#import "MaxNewViewController.h"
#import "MaxFriendTrendsViewController.h"
#import "MaxMeViewController.h"
#import "MaxTabBar.h"
#import "MaxNavigationController.h"

@interface MaxTabBarController ()

@end

@implementation MaxTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dic[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedDic = [NSMutableDictionary dictionary];
    selectedDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedDic[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    //同样的外观样式可以通过appearance设置
    //后面必须带有 UI_APPEARANCE_SELECTOR的方法, 才可以使用此法
//    //可以点进去查看是否带有此标志
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    
    [self setChildController:[MaxEssenceViewController new] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setChildController:[MaxNewViewController new] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setChildController:[MaxFriendTrendsViewController new] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setChildController:[MaxMeViewController new] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    //使用自定义的tabBar, 但是self.tabBar是readonly,所以使用KVC赋值
//    self.tabBar = [MaxTabBar new];
    [self setValue:[MaxTabBar new] forKey:@"tabBar"];
}

//子控制器设置
- (void)setChildController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    viewController.tabBarItem.title = title;
    viewController.navigationItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    //这里不要调用vc的view, 不然4个控制器会一起被创建, 不太合理
    //应该只创建一个控制器, 后面的控制器点击之后再创建
//    viewController.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    
    MaxNavigationController *nav = [[MaxNavigationController alloc]initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

@end
