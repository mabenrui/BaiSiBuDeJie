//
//  MaxTopicPictureView.h
//  My百思不得姐
//
//  Created by Max on 16/2/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaxTopicModel;

@interface MaxTopicPictureView : UIView

/** model*/
@property (nonatomic, weak) MaxTopicModel *topic;

+ (instancetype)pictureView;

@end
