//
//  UIBarButtonItem+Extension.h
//  My百思不得姐
//
//  Created by Max on 16/2/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
