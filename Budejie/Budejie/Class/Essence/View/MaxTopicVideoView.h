//
//  MaxTopicVideoView.h
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class MaxTopicModel;

@interface MaxTopicVideoView : UIView

/** model*/
@property (nonatomic, weak) MaxTopicModel *topic;
/** 播发器*/
@property (nonatomic, strong) AVPlayer *player;

+ (instancetype)videoView;

@end
