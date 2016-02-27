//
//  MaxRecommendTypeModel.h
//  My百思不得姐
//
//  Created by Max on 16/2/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaxRecommendTypeModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;

/** 每个类别里面保存对应请求的数据,解决重复请求的问题*/
@property (nonatomic, copy) NSMutableArray *users;

/** 对应类别的用户数据总数*/
@property (nonatomic, assign) NSInteger total;

/** 当前页码*/
@property (nonatomic, assign) NSInteger currentPage;

@end
