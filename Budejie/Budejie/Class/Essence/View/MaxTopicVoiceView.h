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

@interface MaxTopicVoiceView : UIView

/** model*/
@property (nonatomic, strong) MaxTopicModel *topic;
@property (strong, nonatomic) AVPlayer *player;

+ (instancetype)voiceView;

- (void)playAction;
- (void)playEnd;
- (void)playerDidEnd;

@end
