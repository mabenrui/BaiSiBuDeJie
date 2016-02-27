//
//  MaxTextField.m
//  My百思不得姐
//
//  Created by Max on 16/2/19.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTextField.h"
#import <objc/runtime.h>

#define PlaceHolderLabelColor @"_placeholderLabel.textColor"

@implementation MaxTextField

//+ (void)initialize{
//    
//    //所有成员变量列表,返回时一个数组的指针
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        //取出成员变量
//        //        Ivar ivar = *(ivars + i);
//        Ivar ivar = ivars[i];
//        
//        //打印成员变量名字
//        LLog(@"%s", ivar_getName(ivar));
//    }
//    
//    //释放
//    free(ivars);
//}

- (void)awakeFromNib{
    //self.textColor是在XIB里面设置的白色
    //self.tintColor是光标的颜色
    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
}

//_placeholderLabel这个隐藏属性是用runtime发现的
//其实UITextField还有attributedPlaceholder属性,结合代理也可以实现需求
//也有setHighlighted,但是却没有不高亮的判断

/** 修改UITextField的placeholder文字颜色(三种方法)
 *1. 使用attributedPlaceholder属性,结合代理
 *2. 使用drawPlaceholderInRect重绘
 *3. 使用KVC修改_placeholderLabel.textColor(这个属性是隐藏属性,用runtime发现的)
 *4. 也可以在placeholder的文字位置使用一个label,不过这样太非主流...
 */

- (BOOL)becomeFirstResponder{
    [self setValue:self.textColor forKeyPath:PlaceHolderLabelColor];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    
    [self setValue:[UIColor grayColor] forKeyPath:PlaceHolderLabelColor];
    
    return [super resignFirstResponder];
}

@end
