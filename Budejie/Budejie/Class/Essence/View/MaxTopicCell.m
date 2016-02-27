//
//  MaxTopicCell.m
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicCell.h"
#import "MaxTopicModel.h"
#import "MaxTopicPictureView.h"
#import "NSDate+MaxRelativeTime.h"
#import <UIImageView+WebCache.h>

@interface MaxTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (weak, nonatomic) MaxTopicPictureView *pictureView;

@end

@implementation MaxTopicCell

- (void)awakeFromNib {
    //圆形头像
    self.headerView.layer.cornerRadius = 35 / 2;
    self.headerView.layer.masksToBounds = YES;
}

- (MaxTopicPictureView *)pictureView{
    if (! _pictureView) {
        MaxTopicPictureView *pictureView = [MaxTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        
        _pictureView = pictureView;
    }
    
    return _pictureView;
}
- (void)setTopic:(MaxTopicModel *)topic
{
    _topic = topic;
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    self.text_label.text = topic.text;
    
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *create = [format dateFromString:topic.passtime];
    self.createTimeLabel.text = [create FormatRelativeTime];
    
    [self formatButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self formatButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self formatButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self formatButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    if (topic.type == MaxTopicTypePicture) {
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
    }
}

- (void)formatButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    }else{
        placeholder = [NSString stringWithFormat:@"%ld", count];
    }
    
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10.0f;
    
//    frame.origin.x += margin;
//    frame.size.width -= margin * 2;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

@end