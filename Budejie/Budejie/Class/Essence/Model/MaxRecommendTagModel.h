//
//  MaxRecommendTagModel.h
//  My百思不得姐
//
//  Created by Max on 16/2/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaxRecommendTagModel : NSObject

/** 标签图片*/
@property (nonatomic, copy) NSString *image_list;

/** 标签名*/
@property (nonatomic, copy) NSString *theme_name;

/** 订阅数*/
@property (nonatomic, assign) NSInteger sub_number;

@end
