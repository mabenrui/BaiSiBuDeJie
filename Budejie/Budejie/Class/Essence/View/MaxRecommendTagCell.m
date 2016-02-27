//
//  MaxRecommendTagCell.m
//  My百思不得姐
//
//  Created by Max on 16/2/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendTagCell.h"
#import "MaxRecommendTagModel.h"
#import <UIImageView+WebCache.h>

@interface MaxRecommendTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *TagImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagName;
@property (weak, nonatomic) IBOutlet UILabel *subCount;


@end

@implementation MaxRecommendTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecommendTag:(MaxRecommendTagModel *)recommendTag{
    _recommendTag = recommendTag;
    
    self.tagName.text = recommendTag.theme_name;
    [self.TagImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    NSString *subNumber;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%ld人订阅", recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万订阅", recommendTag.sub_number / 10000.0];
    }
    
    self.subCount.text = subNumber;
}

- (void)setFrame:(CGRect)frame{
    
    //重写setFrame方法,产生分割线和左右边距
    //如果在tableView的返回cell的方法里设置cell.x = 5 是无效的
    //因为tableView是重新布局
    frame.origin.x = 5;
    frame.size.width -= 2*frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

@end
