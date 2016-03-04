//
//  MaxUser.h
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaxUser : NSObject

/** 用户名*/
@property (nonatomic, copy) NSString *username;
/** 性别*/
@property (nonatomic, copy) NSString *sex;
/** 头像*/
@property (nonatomic, copy) NSString *profile_image;

@end
