//
//  UIBarButtonItem+Extension.m
//  My百思不得姐
//
//  Created by Max on 16/2/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.size = button.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
