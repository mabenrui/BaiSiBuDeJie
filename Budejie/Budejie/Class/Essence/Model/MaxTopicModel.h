//
//  MaxTopicModel.h
//  My百思不得姐
//
//  Created by Max on 16/2/22.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MaxTopicModel : NSObject

/** 名称*/
@property (nonatomic, copy) NSString *name;
/** 头像*/
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间*/
@property (nonatomic, copy) NSString *passtime;
/** 文字内容*/
@property (nonatomic, copy) NSString *text;
/** 顶的数量*/
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量*/
@property (nonatomic, assign) NSInteger cai;
/** 转发数量*/
@property (nonatomic, assign) NSInteger repost;
/** 评论数量*/
@property (nonatomic, assign) NSInteger comment;


/** 宽度*/
@property (nonatomic, assign) CGFloat width;
/** 图片高度*/
@property (nonatomic, assign) CGFloat height;
/** 小图片*/
@property (nonatomic, copy) NSString *image0;
/** 中图片*/
@property (nonatomic, copy) NSString *image2;
/** 大图片*/
@property (nonatomic, copy) NSString *image1;
/** 图片的frame*/
@property (nonatomic, assign) CGRect pictureFrame;

/** cell的高度*/
@property (nonatomic, assign) CGFloat rowHeight;

/** cell内容类型*/
@property (nonatomic, assign) MaxTopicType type;

/** 是否是大图*/
@property (nonatomic, assign, getter=isBigImage) BOOL bigPicture;

/** 图片下载进度*/
@property (nonatomic, assign) CGFloat pictureProgress;


/** 声音,视频公用 **/
/** 播放次数*/
@property (nonatomic, assign) NSInteger playcount;
/** 背景图*/
@property (nonatomic, copy) NSString *bimageuri;
/** 正在播放*/
@property (nonatomic, assign) BOOL isPlaying;
/** 播发器*/
@property (nonatomic, weak) AVPlayer *player;

/**
 * 声音
 */
/** 声音时间长度 **/
@property (nonatomic, assign) NSInteger voicetime;
/** 声音背景图frame **/
@property (nonatomic, assign) CGRect voiceFrame;
/** 声音下载进度*/
@property (nonatomic, assign) CGFloat voiceProgress;
/** 声音资源*/
@property (nonatomic, copy) NSString *voiceuri;

/**
 * 视频
 */
/** 视频时间长度 **/
@property (nonatomic, assign) NSInteger videotime;
/** 视频背景图frame **/
@property (nonatomic, assign) CGRect videoFrame;
/** 视频下载进度*/
@property (nonatomic, assign) CGFloat videoProgress;
/** 视频资源*/
@property (nonatomic, copy) NSString *videouri;

/**
 * 评论
 */
/** 最热评论*/
@property (nonatomic, copy) NSArray *top_cmt;

@end
