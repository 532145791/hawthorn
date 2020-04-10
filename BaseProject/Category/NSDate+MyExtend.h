//
//  NSDate+MyExtend.h
//  BaseProject
//
//  Created by super on 2018/12/15.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MyExtend)

/**
 获取时间字符串

 @param serviceDateString 服务器的时间字符串
 @return yyyy-MM-dd HH:mm
 */
+(NSString *)getFormatDateStringWithServiceDateString:(NSString *)serviceDateString;

/**
 获取年月时间字符串

 @param serviceDateString 服务器的时间字符串
 @return yyyy-MM
 */
+(NSString *)getYYYYMMWithServiceString:(NSString *)serviceDateString;
//根据日期字符串获取日期
+(NSDate *)getDateFromDateString:(NSString *)dateString;

+(NSString *)getFormatterTime:(NSString *)serviceDateString;

//获取MM/DD格式的时间字符串
+(NSString *)getMMDD:(NSString *)serviceDateString;

//根据时间戳获取时间字符串
+ (NSString *)time_timestampToString:(NSInteger)timestamp;
//根据日期获取时间戳
+(NSInteger)getTimestampWithDate:(NSDate *)date;

//根据date获取YYYY/MM/DD
+(NSString *)getDateStringWithDate:(NSDate *)date;

//根据date获取YYYY-MM-DD
+(NSString *)getDateString2WithDate:(NSDate *)date;

//根据date获取MM-DD
+(NSString *)getMMDDWithDateStr:(NSString *)datestr;

//根据date获取YYYY-MM-DD HH:mm
+(NSString *)getYYYYMMDDHHMMWithDate:(NSDate *)date;

//根据date获取MM
+(NSString *)getMMWithDateStr:(NSString *)datestr;

//根据date获取YYYY
+(NSString *)getYYYYWithDateStr:(NSString *)datestr;

//根据时间字符串YYYYMMDD获取日期
+(NSDate *)getDateWithYYYYMMDD:(NSString *)datestr;

//获取date前一天的日期
+(NSDate *)getPreDateWithDate:(NSDate *)date;
//获取某个月有多少天
+(NSInteger)getDayCountOfMonthWithDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
