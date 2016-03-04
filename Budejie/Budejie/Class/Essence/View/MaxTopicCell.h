//
//  MaxTopicCell.h
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaxTopicModel;
@class MaxTopicPictureView;
@class MaxTopicVideoView;
@class MaxTopicVoiceView;

@interface MaxTopicCell : UITableViewCell

/** 帖子model*/
@property (nonatomic, strong) MaxTopicModel *topic;

@property (weak, nonatomic) MaxTopicPictureView *pictureView;
@property (weak, nonatomic) MaxTopicVoiceView *voiceView;
@property (weak, nonatomic) MaxTopicVideoView *videoView;

@end
