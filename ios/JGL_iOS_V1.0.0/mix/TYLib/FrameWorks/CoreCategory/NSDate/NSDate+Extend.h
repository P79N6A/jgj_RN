//
//  NSDate+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)


/*
 *  时间戳
 */
@property (nonatomic,copy,readonly) NSString *timestamp;


/*
 *  时间成分
 */
@property (nonatomic,strong,readonly) NSDateComponents *components;


/*
 *  是否是今年
 */
@property (nonatomic,assign,readonly) BOOL isThisYear;


/*
 *  是否是今天
 */
@property (nonatomic,assign,readonly) BOOL isToday;


/*
 *  是否是昨天
 */
@property (nonatomic,assign,readonly) BOOL isYesToday;


/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;


/*
 *  将formatStr格式时间(timeStr)转换成时间戳
 */
+(long)dateStringToTimesTamp:(NSString *)timeStr format:(NSString *)formatStr;


/*
 *  将formatStr格式时间戳(timeStr)转换成时间
 */
+ (NSString *)dateTimesTampToString:(NSString *)timesTamp format:(NSString *)formatStr;

/**
 *  将时间戳转换为NSDate
 *
 *  @param timeSpString 时间戳
 *
 *  @return 对应的NSDate
 */
+ (NSDate *)timeSpStringToNSDate:(NSString *)timeSpString;


/**
 *  当前时间和上次保存的时间，是否超过了timeSeconds(单位:秒),超过了返回YES,没有超过返回NO
 *
 *  @param timeSeconds 时间戳
 *
 *  @return 是否超过了时间
 */
+ (BOOL )isOverTimeInterVal:(NSInteger)timeSeconds key:(NSString *)key;

/**
 * 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 * nowMinutes:现在的时间加上 nowMinutes(分钟)的时间是否在 fromHour 和 toHour 之间
 */
+ (BOOL)dateIsBetweenFromNow:(NSInteger )nowMinutes FromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

/**
 *  获取时间戳的差值
 *
 *  @param timesTamp 传入的时间差
 *
 *  @return 传入时间戳和当前时间戳的差值
 */
+ (NSUInteger )dateTimesTampDValue:(NSString *)timesTamp;


/**
 *  获取2个NSDate的天数差
 *
 *  @param serverDate 开始的NSDate
 *  @param endDate    结束的NSDate
 *
 *  @return 天数差
 */
+(NSInteger )getDaysFrom:(NSDate *)startDate withToDate:(NSDate *)endDate;


/**
 *  获取2个NSDate的月数差
 *
 *  @param serverDate 开始的NSDate
 *  @param endDate    结束的NSDate
 *
 *  @return 月数差
 */
+(NSInteger )getMonthsFrom:(NSDate *)startDate withToDate:(NSDate *)endDate;

/**
 *  判断本月相差多少天
 *
 *  @param fromDate 起点的时间
 *  @param toDate   终止的时间
 *
 *  @return 相差的天数
 */
+(NSInteger )getDaysThisMothFrom:(NSDate *)fromDate withToDate:(NSDate *)toDate;

#pragma mark - 项目特定的
/**
 *  项目耗时
 *
 *  @param timeString 传入的时间戳
 *
 *  @return 返回多久之前
 */
+ (NSString *)timeConsume:(NSString *)timeString;

/**
 *  获取stime和createTime的时间差
 *
 *  @param stime      系统时间
 *  @param createTime 项目创建时间
 *
 *  @return 系统时间和项目创建时间的时间差
 */
+ (NSString *)timeConsumeByStime:(NSString *)stime createTime:(NSString *)createTime;

+ (NSString *)getJLGTimeStrMdhm:(NSString *)timesTamp;
+ (NSString *)getJLGTimeStrYMdhm:(NSString *)timesTamp;
+ (NSString *)getJLGTimeStrYMd:(NSString *)timesTamp;

/**
 *  判断startTime 和 endTime 之间的时间
 *
 *  @param start_TimesTamp 开始时间
 *  @param end_TimesTamp   结束实际
 *
 *  @return 时间的字符串
 */
+ (NSString *)getJLGTimeDValueStartTime:(NSString *)start_TimesTamp endTime:(NSString *)end_TimesTamp;

/**
 *  获取本月的最后一天
 *
 *  @return 最后一天的NSDate
 */
+(NSDate *)getLastDayOfThisMonth;

/**
 *  获取本月的最后一周
 *
 *  @return 最后一周的NSDate
 */
+(NSDate *)getLastWeekOfThisMonth;

/**
 *  将NSDate 转换成对应的日期格式
 *
 *  @param date   需要的日期
 *  @param format 需要转换的格式
 *
 *  @return 转换完的格式
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  将NSString转化为NSDate
 *
 *  @param string   传入的字符串
 *  @param format 需要转换的格式
 *
 *  @return 转换完的日期
 */
+ (NSDate *)dateFromString:(NSString *)string withDateFormat:(NSString *)dateFormat;

/**
 *  判断是星期几
 *
 *  @param inputDate 输入的日期
 *
 *  @return 返回星期几,1是星期天，2是星期一，以此类推
 */
+ (NSInteger )weekdayStringFromDate:(NSDate*)inputDate;

/**
 *  比较date是否在哪个时间之间
 *
 *  @param date      需要比较的时间
 *  @param beginDate 开始的时间
 *  @param endDate   结束的时间
 *
 *  @return 返回是否正确的时间
 */
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
@end
