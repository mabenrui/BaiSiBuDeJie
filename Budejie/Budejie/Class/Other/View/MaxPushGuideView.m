//
//  MaxPushGuideView.m
//  My百思不得姐
//
//  Created by Max on 16/2/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxPushGuideView.h"

@implementation MaxPushGuideView

+ (void)show{
    NSString *key = @"CFBundleShortVersionString";
    
    //获取当前verision
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    //获取沙盒存储的version
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    if (![sanboxVersion isEqualToString:currentVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        MaxPushGuideView *pushView = [MaxPushGuideView pushGuide];
        [window addSubview:pushView];
        pushView.frame = window.bounds;
        
        //存储version
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
}

+ (instancetype)pushGuide{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (IBAction)close {
    [self removeFromSuperview];
}

@end
