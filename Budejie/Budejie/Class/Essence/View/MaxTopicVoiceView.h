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
@class MaxTopicVoiceView;

@protocol MaxTopicVoiceViewDelegate <NSObject>

- (void)voiceView:(MaxTopicVoiceView *)voiceView clickPlayButton:(UIButton *)button;

- (void)voiceView:(MaxTopicVoiceView *)voiceView beforeChangeProgress:(UISlider *)sender;
- (void)voiceView:(MaxTopicVoiceView *)voiceView changePlayProgress:(UISlider *)sender;
- (void)voiceView:(MaxTopicVoiceView *)voiceView afterChangeProgress:(UISlider *)sender;

@end

@interface MaxTopicVoiceView : UIView

/** model*/
@property (nonatomic, weak) MaxTopicModel *topic;

/** 代理*/
@property (nonatomic, weak) id<MaxTopicVoiceViewDelegate> delegate;

+ (instancetype)voiceView;

- (void)showVoiceInActive:(BOOL)isActive;
- (void)playerDidEnd;

- (void)changeProgressString:(NSString *)str;
- (void)changeProgressValue:(CGFloat)value;

@end
