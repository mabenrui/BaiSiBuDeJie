//
//  MaxConst.h
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MaxTopicType)
{
    MaxTopicTypeAll = 1,
    MaxTopicTypePicture = 10,
    MaxTopicTypeWord = 29,
    MaxTopicTypeVoice = 31,
    MaxTopicTypeVideo = 41
};

/** 精华顶部title高度*/
UIKIT_EXTERN CGFloat const MaxTitleViewH;
/** 精华顶部title的y值*/
UIKIT_EXTERN CGFloat const MaxTitleViewY;

/** 精华cell的基本间距*/
UIKIT_EXTERN CGFloat const MaxMargin;
/** 精华底部一组按钮的高度*/
UIKIT_EXTERN CGFloat const MaxButtonGroupHeight;
/** 精华cell 文字内容的y值*/
UIKIT_EXTERN CGFloat const MaxTopicCellHeaderHeight;
/** 精华cell 图片的最大高度*/
UIKIT_EXTERN CGFloat const MaxTopicPictureMaxH;
/** 精华cell 图片超过最大高度后的自动显示的高度*/
UIKIT_EXTERN CGFloat const MaxTopicPictureDefaultH;