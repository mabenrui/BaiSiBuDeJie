//
//  MaxRecommendTypeCell.m
//  My百思不得姐
//
//  Created by Max on 16/2/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendTypeCell.h"
#import "MaxRecommendTypeModel.h"

@interface MaxRecommendTypeCell ()

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end

@implementation MaxRecommendTypeCell

- (void)awakeFromNib {
    self.backgroundColor = RGBColor(244, 244, 244);
    
    //修为是透明的view,避免遮挡
    UIView *temp = [UIView new];
    temp.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = temp;
}

- (void)setModel:(MaxRecommendTypeModel *)model{
    _model = model;
    
    self.textLabel.text = model.name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;//为了上下都减2,对称
}

//选中cell时,所有的cell都会执行此方法,可以用来监听cell的选中状态
//被选中的cell会传入selected=YES,其他的cell会传入NO
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    //被选中时,selected值是YES
    //注意,在xib中cell的selection设置为None才行,默认是default
    //selection为None时,被选中内部的子控件不会进入高亮状态,所以设置self.textLabel.highlightedTextColor也无效
    
    self.selectedView.hidden = ! selected;
    self.textLabel.textColor = selected ? [UIColor redColor] : RGBColor(78, 78, 78);
    
}

@end
