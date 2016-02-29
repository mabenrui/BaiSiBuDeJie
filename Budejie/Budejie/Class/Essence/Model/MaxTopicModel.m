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
        
        CGFloat frameX = 0;
        CGFloat frameY = 0;
        CGFloat frameW = 0;
        CGFloat frameH = 0;
        
        if (self.type == MaxTopicTypePicture) {
            frameX = MaxMargin;
            frameY = _rowHeight;
            frameW = maxSize.width;
            frameH = self.height / self.width * frameW;
            
            if (frameH >= MaxTopicPictureMaxH) {
                frameH = MaxTopicPictureDefaultH;
                self.bigPicture = YES;
            }
            
            //计算图片frame
            _pictureFrame = CGRectMake(frameX, frameY, frameW, frameH);
            
            _rowHeight += frameH + MaxMargin;
        }else if (self.type == MaxTopicTypeVoice){
            frameX = MaxMargin;
            frameY = _rowHeight;
            frameW = maxSize.width;
            frameH = self.height / self.width * frameW;
            
            _voiceFrame = CGRectMake(frameX, frameY, frameW, frameH);

            _rowHeight += frameH + MaxMargin;
        }else if (self.type == MaxTopicTypeVideo){
            frameX = MaxMargin;
            frameY = _rowHeight;
            frameW = maxSize.width;
            frameH = self.height / self.width * frameW;
            
            _videoFrame = CGRectMake(frameX, frameY, frameW, frameH);
            
            _rowHeight += frameH + MaxMargin;
        }
        
        _rowHeight += MaxButtonGroupHeight + MaxMargin;
    }
    
    return _rowHeight;
}

@end
