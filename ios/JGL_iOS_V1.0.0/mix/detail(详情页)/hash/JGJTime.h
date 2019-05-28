//
//  JGJTime.h
//  mix
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface JGJTime : NSObject
+ (NSString *)retrunMoneyNumWithNum:(NSString *)moneyStr;

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

//月
+(NSString *)monthStr;
//日
+(NSString *)DayStr;

+(NSString *)DayStrFromDate:(NSDate *)date;

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

+(NSString*)getChineseCalendarWithDateAndWeek:(NSDate *)date;

+(NSString*)getChineseCalendarWithDate:(NSDate *)date;

+(NSString *)acordingTimeStrRetrunNew_time:(NSString *)timeStr;
//年
+(NSString *)yearStr;
#pragma mark - 根据nsdate 返回时间

+ (NSString *)NowTimeAcoordingNsdate:(NSDate *)date;
+ (NSString *)NowTimeYearAcoordingNsdate:(NSDate *)date;
/*
 *根据汉语时间 返回农历时间
 */
+ (NSString *)AccordingtoChineseTimeReturnTotheLunarCalendartime;


+(NSString *)ChineseyearAppendMonthanddayfromstamp:(NSDate *)date;
/*
 *2019-2-2
 */
+(NSString *)yearAppend_Monthand_dayfromstamp:(NSDate *)date;

/*
 *2019/2/2
 */
+(NSString *)newYearAppend_Monthand_dayfromstamp:(NSDate *)date;

/*
 *字符串转成其他的格式
 */
+(NSString *)yearStrchangeType:(NSString *)dateStr;
 //iponeX尺寸纠正
+ (CGFloat)iphoneXModifynav;

+ (CGFloat)iphoneXModifybar;

+ (CGFloat)iphoneXModifyscreen;

+ (CGFloat)iphoneXStatusNav;

@end
