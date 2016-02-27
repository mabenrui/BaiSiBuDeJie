//
//  MaxNavigationController.m
//  My百思不得姐
//
//  Created by Max on 16/2/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxNavigationController.h"

@interface MaxNavigationController ()

@end

@implementation MaxNavigationController

//当第一次使用这个类的时候会调用一次
+ (void)initialize{
    
    //1. appearanceWhenContainedInInstancesOfClasses 是给所有MaxNavigationController定制统一外观,而不是所有的UINavigationBar
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    //2. 在initialize方法里面定义外观,而不是在viewDidLoad, 因为这个方法只会执行一次
    
    //3. 也可以直接使用
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        //调整button的尺寸和位置(第1种方法,就是使用固定的大小)
        button.size = CGSizeMake(70, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//不常用的属性,让button的title和image左对齐
        
        //第2种方法,使用sizeToFit
//        [button sizeToFit];
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);//内边距
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    
    //super的push放最后, 让viewController里面设置的leftBarButton可以最后覆盖
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
