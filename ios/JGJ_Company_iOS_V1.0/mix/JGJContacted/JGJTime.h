//
//  JGJTime.h
//  mix
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJTime : NSObject

+ (NSString *)getNowWeekday;
//返回星期几
+ (NSString*)weekDayStr:(NSString *)format;

//返回今天的星期
+ (NSString *)currentDateWithFormatter:(NSString *)formatter;

//详细的时间
+(NSString *)DisTenceToNowSTR:(NSString *)timeStam;
//今天昨天
+(NSString *)todayoRYestoday:(NSString *)timeStam;

+(NSString *)dayFromfromNowDay:(NSString *)day AndMonth:(NSString *)month;

+(NSString *)GetTimeFromStamp:(NSString *)stamp;
//根据时间格式获取是哪天
+(NSInteger)GetDayFromStamp:(NSDate *)stamp;
//根据时间格式获取是哪月
+(NSInteger)GetMonthFromStamp:(NSDate *)stamp;
+ (NSInteger)GetyearFromStamp:(NSDate *)stamp;
+(NSString *)acordingTimeStrRetrunNo_todayText:(NSString *)timeStr;

//年
+(NSString *)yearStr;
//月
+(NSString *)monthStr;
//日
+(NSString *)DayStr;
//检测是不是再下午七点到24点
-(BOOL)isSevenTotwntyfour;
+(NSString *)acordingTimeStrRetrunTime:(NSString *)timeStr;
+(NSString *)acordingTimeStrRetrunMyTime:(NSString *)timeStr;
+(void)Savenum;
+(BOOL)isHad;
+(NSString *)retrunSTRfromArray:(NSArray *)array;
+(NSString *)yearAppendMonthanddayfromstamp:(NSDate *)date;
+(NSString *)yearAppendMonthfromstamp:(NSDate *)date;
+(NSString *)retrunYearAndMonthAndDay:(NSArray *)arr;
//判断是否为今天之后
+ (BOOL)isTodayLaterTime:(NSDate *)date;
//根据nsdate获取农历
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
+(NSString*)getChineseCalendarWithDateAndWeek:(NSDate *)date;
+(NSString *)acordingTimeStrRetrunNew_time:(NSString *)timeStr;
//比较两个时间的大小
+ (NSInteger)compareDate:(NSString*)preDate laterDate:(NSString *)laterDate;

//iponeX尺寸纠正
+ (CGFloat)iphoneXModifynav;

+ (CGFloat)iphoneXModifybar;

+ (CGFloat)iphoneXModifyscreen;
@end
