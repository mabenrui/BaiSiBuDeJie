//
//  NSDate+MaxRelativeTime.h
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MaxRelativeTime)

/**
 * 和当前时间的差距,包括所有元素,年月日时分秒
 */
- (NSDateComponents *)relativeTimeFrom:(NSDate *)fromDate;

- (BOOL)isThisYear;

- (BOOL)isToday;

- (BOOL)isYesterday;

//返回格式化的相对时间
/* 规则如下:
 *  今年
        今天
            1分钟内 - 刚刚
            1小时内 - xx分钟前
            其他  - xx小时前
        昨天
            昨天 HH:mm:ss
        其他
            MM-dd HH:mm:ss
    非今年
        yyyy-MM-dd HH:mm:ss
 *
 *
 */

- (NSString *)FormatRelativeTime;

@end
