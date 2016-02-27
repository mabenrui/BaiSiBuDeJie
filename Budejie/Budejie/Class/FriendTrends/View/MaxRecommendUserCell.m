//
//  MaxRecommendUserCell.m
//  My百思不得姐
//
//  Created by Max on 16/2/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendUserCell.h"
#import "MaxRecommendUserModel.h"
#import <UIImageView+WebCache.h>

@interface MaxRecommendUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;


@end

@implementation MaxRecommendUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MaxRecommendUserModel *)model{
    _model = model;
    
    self.nameLabel.text = model.screen_name;    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    NSString *followNum;
    if (model.fans_count < 10000) {
        followNum = [NSString stringWithFormat:@"%ld人关注", model.fans_count];
    }else{
        followNum = [NSString stringWithFormat:@"%.1f万关注", model.fans_count / 10000.0];
    }
    self.followLabel.text = followNum;
}
@end
