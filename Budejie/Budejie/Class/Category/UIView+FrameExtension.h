//
//  UIView+FrameExtension.h
//  分类
//
//  Created by qianfeng on 15/12/23.
//  Copyright (c) 2015年 MBR. All rights reserved.
//

#import <UIKit/UIKit.h>

//分类中使用@property,只有方法的声明部分,没有实现部分,也没有实例变量

@interface UIView (FrameExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

//@property (nonatomic, assign) CGFloat maxX;
//@property (nonatomic, assign) CGFloat maxY;

@end
