//
//  NSDate+MyExtend.m
//  BaseProject
//
//  Created by super on 2018/12/15.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import "NSDate+MyExtend.h"

@implementation NSDate (MyExtend)
+(NSString *)getFormatDateStringWithServiceDateString:(NSString *)serviceDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:serviceDateString];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [formatter2 stringFromDate:date];
    return strDate;
}

+(NSString *)getYYYYMMWithServiceString:(NSString *)serviceDateString{
    NSString *yyyy = [serviceDateString substringWithRange:NSMakeRange(0, 7)];
    return yyyy;
}

+(NSDate *)getDateFromDateString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+(NSString *)getFormatterTime:(NSString *)serviceDateString{
    long timestamp = [[NSDate getDateFromDateString:serviceDateString] timeIntervalSince1970];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = timestamp;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    if (time <= 10*60) {
        return @"刚刚";
    }
    if (time > 10*60) {
        NSString *currentDateStr = [NSDate getYYYYMMDDHHMMWithDate:[NSDate date]];
        if ([[currentDateStr substringToIndex:10] isEqualToString:[serviceDateString substringToIndex:10]]) {
            return [serviceDateString substringWithRange:NSMakeRange(11, 5)];
        }else{
            if ([[currentDateStr substringToIndex:3] isEqualToString:[serviceDateString substringToIndex:3]]) {
                return [serviceDateString substringWithRange:NSMakeRange(5,11)];
            }
        }
    }
    return [NSDate getFormatDateStringWithServiceDateString:serviceDateString];
}

//获取MM/DD格式的时间字符串
+(NSString *)getMMDD:(NSString *)serviceDateString{
    NSString *mm = [serviceDateString substringWithRange:NSMakeRange(5, 2)];
    NSString *dd = [serviceDateString substringWithRange:NSMakeRange(8, 2)];
    return [NSString stringWithFormat:@"%@/%@",mm,dd];
}

//根据date获取MM-DD
+(NSString *)getMMDDWithDateStr:(NSString *)datestr{
    NSString *mm = [datestr substringWithRange:NSMakeRange(5, 2)];
    NSString *dd = [datestr substringWithRange:NSMakeRange(8, 2)];
    return [NSString stringWithFormat:@"%@-%@",mm,dd];
}

//根据date获取MM
+(NSString *)getMMWithDateStr:(NSString *)datestr{
    NSString *mm = [datestr substringWithRange:NSMakeRange(5, 2)];
    return mm;
}

//根据date获取YYYY
+(NSString *)getYYYYWithDateStr:(NSString *)datestr{
    NSString *yyyy = [datestr substringWithRange:NSMakeRange(0, 4)];
    return yyyy;
}

+ (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = timestamp/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转小时
    NSInteger hours = time/3600;
    
    if (hours <= 23) {
        if (hours == 0) {
            hours = 1;
        }
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    
    if (hours <= 48 && hours >=24) {
        return @"昨天";
    }
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

//根据日期获取时间戳
+(NSInteger)getTimestampWithDate:(NSDate *)date{
    return [date timeIntervalSince1970]*1000;
}

//根据date获取yyyy/MM/dd
+(NSString *)getDateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd"];
    NSString *strDate = [formatter2 stringFromDate:date];
    return strDate;
}

//根据date获取YYYY-MM-DD
+(NSString *)getDateString2WithDate:(NSDate *)date{
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter2 stringFromDate:date];
    return strDate;
}

//根据date获取YYYY-MM-DD HH:mm
+(NSString *)getYYYYMMDDHHMMWithDate:(NSDate *)date{
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [formatter2 stringFromDate:date];
    return strDate;
}

//根据时间字符串YYYYMMDD获取日期
+(NSDate *)getDateWithYYYYMMDD:(NSString *)datestr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:datestr];
    return date;
}

//获取date前一天的日期
+(NSDate *)getPreDateWithDate:(NSDate *)date{
    return [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
}

//获取某个月有多少天
+(NSInteger)getDayCountOfMonthWithDate:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
@end
