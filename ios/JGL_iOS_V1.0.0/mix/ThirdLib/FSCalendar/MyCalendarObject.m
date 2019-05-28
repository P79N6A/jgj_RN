//
//  MyCalendarObject.m
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "MyCalendarObject.h"

#define kCurrentCalendar [NSCalendar currentCalendar]
#define kCalendar(calendarIdentifier) [NSCalendar calendarWithIdentifier:calendarIdentifier]
// 公历
#define kGregorianCalendar kCalendar(NSCalendarIdentifierGregorian)
// 农历
#define kChineseCalendar kCalendar(NSCalendarIdentifierChinese)
@implementation MyCalendarObject

static NSDictionary *_holidays = nil;

+(NSDictionary*)getChineseCalendarWith:(NSDateComponents*)components
{
    NSString *month = [MyCalendarObject getChineseCalendarMonthStringWith:components.month];
    NSString *day = [MyCalendarObject getChineseCalendarDayStringWith:components.day];
    NSString *holiday = [MyCalendarObject getChineseHolidayWith:components.month day:components.day];
    return @{@"month":month,@"day":day,@"holiday":holiday};
}

#pragma mark - 农历 天
+(NSString*)getChineseCalendarDayStringWith:(NSInteger)day
{
    NSArray *days = [MyCalendarObject getChineseCalendarDays];
    
    if (day < 1) {
        return @"初一";
    }else if (day > 30){
        return @"三十";
    }
    if (day <= [days count]) {
        return days[day-1];
    }
    return @"初一";
}

#pragma mark - 农历 月

+(NSString*)getChineseCalendarMonthStringWith:(NSInteger)month
{
    NSArray *months = [MyCalendarObject getChineseCalendarMonths];
    if (month < 1) {
        return @"正月";
    }else if (month > 12){
        return @"腊月";
    }
    if (month <= [months count]) {
        return months[month-1];
    }
    return @"正月";
}

+(NSArray*)getChineseCalendarDays
{
    return @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
}



+(NSArray*)getChineseCalendarMonths
{
    return @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
}

+(NSString *)getWeekDayByDayIndex:(NSInteger )dayIndex{
    NSArray *weekDays = [self getWeekDays];
    return weekDays[dayIndex];
}

+(NSArray*)getWeekDays
{
    return @[[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
}

#pragma mark - 按阳历节日算的节日


+(NSDictionary*)getHolidaysDictionaryWith:(NSString*)key
{
    if (!_holidays) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Holidays" ofType:@"plist"];
        _holidays = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _holidays[key];
}

+(NSString*)getGregorianHolidayWith:(NSDateComponents*)components
{
    NSDictionary *holiday = [MyCalendarObject getHolidaysDictionaryWith:@"GregorianHolidays"];
    NSString *key = [NSString stringWithFormat:@"%.2ld%.2ld",components.month,components.day];
    NSString *holidayText = holiday[key];

    if (holidayText) {
        return holidayText;
    }
    return @"";//otherHoliday;

}

+(NSString*)getChineseHolidayWith:(NSInteger)month day:(NSInteger)day
{
    NSDictionary *holiday = [MyCalendarObject getHolidaysDictionaryWith:@"ChineseHolidays"];
    NSString *key = [NSString stringWithFormat:@"%.2ld%.2ld",month,day];
    NSString *holidayText = holiday[key];
    if (holidayText) {
        return holidayText;
    }
    return @"";
}

#pragma mark otherGregorianHoliday

+(NSString*)getOtherGregorianHolidayWith:(NSDateComponents *)components
{
    if (components.month == 5 && components.weekOfMonth == 2 && components.weekday == 1) {
        return @"母亲节";
    }else if (components.month == 5 && components.weekOfMonth == 3 && components.weekday == 1){
        return @"全国助残日";
    }else if (components.month == 6 && components.weekOfMonth == 3 && components.weekday == 1){
        return @"父亲节";
    }else if (components.month == 9 && components.weekOfMonth == 3 && components.weekday == 3){
        return @"国际和平日";
    }else if (components.month == 9 && components.weekOfMonth == 3 && components.weekday == 7){
        return @"全国国防教育日";
    }else if (components.month == 9 && components.weekOfMonth == 4 && components.weekday == 1){
        return @"国际聋人节";
    }else if (components.month == 10 && components.weekOfMonth == 1 && components.weekday == 2){
        return @"国际住房日";
    }else if (components.month == 10 && components.weekOfMonth == 2 && components.weekday == 2){
        return @"加拿大感恩节";
    }else if (components.month == 10 && components.weekOfMonth == 2 && components.weekday == 4){
        return @"国际减轻自然灾害日";
    }else if (components.month == 10 && components.weekOfMonth == 2 && components.weekday == 5){
        return @"世界爱眼日";
    }
    return [MyCalendarObject getRemainderGregorianHolidayWith:components];
}

+(NSString*)getRemainderGregorianHolidayWith:(NSDateComponents *)components
{
    if (components.month == 11 && components.weekday == 5) {
        NSInteger weekOfMonth = [MyCalendarObject getWeeksInMonthWiht:components weekDay:5 head:NO];
        if (components.weekOfMonth == weekOfMonth) {
            // 感恩节
            return @"感恩节";
        }
    }else if (components.month == 1 && components.weekday == 1){
        NSInteger weekOfMonth = [MyCalendarObject getWeeksInMonthWiht:components weekDay:1 head:NO];
        if (components.weekOfMonth == weekOfMonth) {
            // 国际麻风节
            return @"国际麻风节";
        }
    }else if (components.month == 3 && components.weekday == 1){
        
        NSInteger days = [MyCalendarObject getDaysWith:components];
        NSInteger weeks = [MyCalendarObject getWeeksWith:components];
        // 最后一天周几
        NSInteger weekDayLastDay =  [MyCalendarObject getLastDayWeekDayWith:components days:days];
        NSInteger weekOfMonth = 1;
        if (weekDayLastDay == 7) {
            weekOfMonth = weeks;
        }else{
            weekOfMonth = weeks -1;
        }
        if (components.weekOfMonth == weekOfMonth) {
            // 中小学生安全教育日
            return @"中小学生安全教育日";
        }
        
    }
    
    return@"";
}

+(NSInteger)getWeeksInMonthWiht:(NSDateComponents*)components weekDay:(NSInteger)weekDay head:(BOOL)head
{
    //NSCalendar *calendar = [MyCalendarObject getCalendarWith:NSCalendarIdentifierGregorian];
    NSInteger days = [MyCalendarObject getDaysWith:components];
    NSInteger weeks = [MyCalendarObject getWeeksWith:components];
    // 最后一天周几
    NSInteger weekDayLastDay =  [MyCalendarObject getLastDayWeekDayWith:components days:days];
    
    NSInteger weekDayFirstDay =  [MyCalendarObject getFirstDayWeekDayWith:components];
    return head? (weekDayFirstDay <= weekDay)?1:2 :(weekDayLastDay >= weekDay)?weeks:weeks-1;
}

// 获取 月份 天数
+(NSInteger)getDaysWith:(NSDateComponents*)components
{
    NSDate *date = [kGregorianCalendar dateFromComponents:components];
    return [MyCalendarObject getNumberOfDaysInCurrentMonthWith:date];
}

// 获取 月份 周数
+(NSInteger)getWeeksWith:(NSDateComponents*)components
{
    NSDate *date = [kGregorianCalendar dateFromComponents:components];
    return [kGregorianCalendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
}
// 获取 月份 最后一天 是周几
+(NSInteger)getLastDayWeekDayWith:(NSDateComponents*)components days:(NSInteger)days
{
    components.day = days;
    NSDate *date = [kGregorianCalendar dateFromComponents:components];
    return  [kGregorianCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}
// 获取 月份 第一天 是周几
+(NSInteger)getFirstDayWeekDayWith:(NSDateComponents*)components
{
    components.day = 1;
    NSDate *date = [kGregorianCalendar dateFromComponents:components];
   return  [kGregorianCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}




/*
 * 根据NSCalendarIdentifier 获取日历
 */

+(NSCalendar*)getCalendarWith:(NSString*)calendarIndentifier
{
    return [NSCalendar calendarWithIdentifier:calendarIndentifier];
}

// 年 月 日
+(NSCalendarUnit)getYMDCalendarUnit
{
    return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
}

/*
 * 计算 date 所在 月份 的天数
 */

+(NSUInteger)getNumberOfDaysInCurrentMonthWith:(NSDate*)date
{
    return  [kGregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

@end
