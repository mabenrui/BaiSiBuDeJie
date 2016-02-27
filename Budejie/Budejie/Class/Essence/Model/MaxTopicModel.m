//
//  MaxTopicModel.m
//  My百思不得姐
//
//  Created by Max on 16/2/22.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicModel.h"
#import <MJExtension.h>

@interface MaxTopicModel()
{
    CGFloat _rowHeight;
    CGRect _pictureFrame;
}

@end

@implementation MaxTopicModel

- (CGFloat)rowHeight{
    
    if (_rowHeight == 0) {
        _rowHeight = MaxTopicCellHeaderHeight;
        
        //文字最大高度
        CGSize maxSize = CGSizeMake(kWidth - 2 * MaxMargin, MAXFLOAT);
        //计算文字高度
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
        
        _rowHeight += textH + MaxMargin;
        
        if (self.type == MaxTopicTypePicture) {
            CGFloat pictureX = MaxMargin;
            CGFloat pictureY = _rowHeight;
            CGFloat pictureW = maxSize.width;
            CGFloat pictureH = self.height / self.width * pictureW;
            
            if (pictureH >= MaxTopicPictureMaxH) {
                pictureH = MaxTopicPictureDefaultH;
                self.bigPicture = YES;
            }
            
            //计算图片frame
            _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _rowHeight += pictureH + MaxMargin;
        }
        
        _rowHeight += MaxButtonGroupHeight + MaxMargin;
    }
    
    return _rowHeight;
}

@end
