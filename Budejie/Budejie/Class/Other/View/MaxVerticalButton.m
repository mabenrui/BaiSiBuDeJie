//
//  MaxVerticalButton.m
//  My百思不得姐
//
//  Created by Max on 16/2/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxVerticalButton.h"

@implementation MaxVerticalButton

- (void)setUp{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

//不管是从代码还是xib生成的按钮都是一样的样式,即setUp
- (void)awakeFromNib{
    [self setUp];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
