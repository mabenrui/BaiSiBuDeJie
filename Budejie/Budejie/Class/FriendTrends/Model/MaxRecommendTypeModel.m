//
//  MaxRecommendTypeModel.m
//  My百思不得姐
//
//  Created by Max on 16/2/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendTypeModel.h"

@implementation MaxRecommendTypeModel

- (NSMutableArray *)users{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    
    return _users;
}

@end
