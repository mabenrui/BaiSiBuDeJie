//
//  MaxTopicVoiceView.h
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class MaxTopicModel;

@protocol MaxTopicVoiceViewDelegate <NSObject>

- (void)topicVoiceViewDidActive:(MaxTopicModel *)topic;

@end

@interface MaxTopicVoiceView : UIView

/** model*/
@property (nonatomic, weak) MaxTopicModel *topic;
@property (nonatomic, strong) AVPlayer *player;
/** 代理*/
@property (nonatomic, weak) id<MaxTopicVoiceViewDelegate> delegate;

+ (instancetype)voiceView;

- (void)playAction;
- (void)playEnd;
- (void)playerDidEnd;

@end
