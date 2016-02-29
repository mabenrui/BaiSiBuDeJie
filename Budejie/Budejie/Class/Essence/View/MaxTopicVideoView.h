//
//  MaxTopicVideoView.h
//  Budejie
//
//  Created by Max on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaxTopicModel;

@interface MaxTopicVideoView : UIView

/** model*/
@property (nonatomic, strong) MaxTopicModel *topic;

+ (instancetype)videoView;

@end
