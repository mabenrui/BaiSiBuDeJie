//
//  MaxComment.h
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaxUser;

@interface MaxComment : NSObject

/** 音频时长*/
@property (nonatomic, assign) NSInteger voicetime;

/** 评论内容*/
@property (nonatomic, copy) NSString *content;

/** 被点赞数量*/
@property (nonatomic, assign) NSInteger like_count;

/** 用户*/
@property (nonatomic, strong) MaxUser *user;

@end
