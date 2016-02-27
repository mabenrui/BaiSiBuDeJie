//
//  MaxTopicCell.h
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaxTopicModel;

@interface MaxTopicCell : UITableViewCell

/** 帖子model*/
@property (nonatomic, strong) MaxTopicModel *topic;

@end
