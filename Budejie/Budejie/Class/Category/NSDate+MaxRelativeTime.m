//
//  NSDate+MaxRelativeTime.m
//  My百思不得姐
//
//  Created by Max on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "NSDate+MaxRelativeTime.h"

@implementation NSDate (MaxRelativeTime)

- (NSDateComponents *)relativeTimeFrom:(NSDate *)fromDate{
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    return [calendar components:unit fromDate:fromDate toDate:self options:0];
}

- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    //年数相等才是今年,不能计算时间差是 3600*24*365
    return selfYear == nowYear;
}

- (BOOL)isToday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *nowDate = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfDate = [calendar components:unit fromDate:self];
    
    //年月日 这3个数值相同才能算今天
    return nowDate.year == selfDate.year && nowDate.month == selfDate.month && nowDate.day == selfDate.day;
}

- (BOOL)isYesterday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter *fm = [NSDateFormatter new];
    fm.dateFormat = @"yyyy-MM-dd";
    
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDate *nowDate = [fm dateFromString:[fm stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fm dateFromString:[fm stringFromDate:self]];

    NSDateComponents *delta = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return delta.year == 0 && delta.month == 0 && delta.day == 1;
}

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

- (NSString *)FormatRelativeTime{
    NSString *formatString = nil;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //今年
    if ([self isThisYear]) {
        if ([self isToday]) {//今天
            
            NSDateComponents *delta = [[NSDate date] relativeTimeFrom:self];
            if (delta.hour >=1) {
                formatString = [NSString stringWithFormat:@"%ld小时前", delta.hour];
            }else if(delta.minute >=1){
                formatString = [NSString stringWithFormat:@"%ld分钟前", delta.minute];
            }else{
                formatString = @"刚刚";
            }
        }else if([self isYesterday]){//昨天
            formatter.dateFormat = @"昨天 HH:mm:ss";
            formatString = [formatter stringFromDate:self];
        }else{
            formatter.dateFormat = @"MM-dd HH:mm:ss";
            formatString = [formatter stringFromDate:self];
        }
    }else{
       formatString = [formatter stringFromDate:self];
    }
    
    return formatString;
}

- (NSDate *)localTime
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:[NSDate date]];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:[NSDate date]];
    
    return destinationDateNow;
}


@end
