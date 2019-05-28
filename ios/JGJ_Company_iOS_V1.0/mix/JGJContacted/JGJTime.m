//
//  JGJTime.m
//  mix
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JGJTime.h"
#import "JGJShareInstance.h"
#import "NSString+Extend.h"
#define numIndex 10
@implementation JGJTime
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}
+(NSString *)DisTenceToNowSTR:(NSString *)timeStam
{
    NSString*str=timeStam;//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
    
    
    
    
}
+(NSString *)dayFromfromNowDay:(NSString *)day AndMonth:(NSString *)month
{
    
    
    
    return 0;
}
//获取今天的日期
-(NSString *)GetToday:(NSString *)months  day:(NSString *)days
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    
    
    
    if ([months integerValue] == month&&[days integerValue] == day) {
        return @"今天";
    }
    else if ([months integerValue] == month&& day - [days integerValue] == 1 ){
        
        
        return @"昨天";
    }
    
    return nsDateString;
}
+(NSString *)todayoRYestoday:(NSString *)timeStam
{
    
    NSString*str=timeStam;//时间戳
    
    //        NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *Month = [[NSDateFormatter alloc]init];
    NSDateFormatter *day = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //获取月份
    [Month setDateFormat:@"MM"];
    //获取天
    [day setDateFormat:@"dd"];
    //    NSString *monthStr =[Month stringFromDate:detaildate];
    //    NSString *dayStr      =[day stringFromDate:detaildate];
    //    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    
    return 0;
}

+(NSString *)yearStr
{

    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    
    
    
    return [NSString stringWithFormat:@"%ld",(long)year];


}

+(NSString *)monthStr
{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *nsDateString= [NSString  stringWithFormat:@"%4ld年%2ld月%2ld日",(long)year,(long)month,(long)day];
    
    
    
    return [NSString stringWithFormat:@"%ld",(long)month];
    
}


+(NSString *)DayStr
{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    
    return [NSString stringWithFormat:@"%ld",(long)day];
    
}

+(NSString *)GetTimeFromStamp:(NSString *)stamp
{
    NSString*str=stamp;//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *Month = [[NSDateFormatter alloc]init];
    NSDateFormatter *day = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //获取月份
    [Month setDateFormat:@"MM"];
    //获取天
    [day setDateFormat:@"dd"];
    //    [day setDateFormat:@"yy"];
    
    NSString *monthStr =[Month stringFromDate:detaildate];
    NSString *dayStr      =[day stringFromDate:detaildate];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    
    
    //今天
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger Today=[conponent day];
    
    if ([monthStr integerValue] == month&&[dayStr integerValue] == Today) {
        
        return [NSString stringWithFormat:@"今天 %@",currentDateStr];
    }
    else if ([monthStr integerValue] == month&& Today - [dayStr integerValue] == 1 ){
        return  [NSString stringWithFormat:@"昨天 %@",currentDateStr];;
    }else{
        
        return currentDateStr;
    }
    return 0;
}
-(BOOL)isSevenTotwntyfour
{
    NSDate *date18 = [self getCustomDateWithHour:19];
    NSDate *date24 = [self getCustomDateWithHour:24];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:date18]==NSOrderedDescending && [currentDate compare:date24]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
//我的shijain
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}
-(void)setobjectwithNsstring:(NSString *)day
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    
    
    
}
//别人的shijain
+(NSString *)acordingTimeStrRetrunTime:(NSString *)timeStr
{
    //    NSLog(@"%@",timeStr);
    NSString *years = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *months =[timeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *days   = [timeStr substringWithRange:NSMakeRange(8, 2)];
    NSString *times = [timeStr substringWithRange:NSMakeRange(11, 5)];
    NSString *timeYear = [timeStr substringWithRange:NSMakeRange(0, 16)];
    //今天
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger year = [conponent year];
    NSInteger month=[conponent month];
    NSInteger Today=[conponent day];
    
    if ([months integerValue] == month&&[days integerValue] == Today) {
        
        return [NSString stringWithFormat:@"%@",times];
    }
    else if ([months integerValue] == month&& Today - [days integerValue] == 1 ){
        return  [NSString stringWithFormat:@"昨天 %@",times];;
    }else if([years integerValue]!=year){
        
        return timeYear;
    }else{
        
        return [NSString stringWithFormat:@"%@-%@ %@",months,days,times];
    }
    return 0;
}
+(NSString *)acordingTimeStrRetrunMyTime:(NSString *)timeStr
{
    NSString *years = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *months =[timeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *days   = [timeStr substringWithRange:NSMakeRange(8, 2)];
    NSString *times = [timeStr substringWithRange:NSMakeRange(11, 5)];
    NSString *timeYear = [timeStr substringWithRange:NSMakeRange(0, 16)];
    //今天
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger year = [conponent year];
    NSInteger month=[conponent month];
    NSInteger Today=[conponent day];
    
    if ([months integerValue] == month&&[days integerValue] == Today) {
        
        return [NSString stringWithFormat:@"%@",times];
        
    }
    else if ([months integerValue] == month&& Today - [days integerValue] == 1 ){
        return  [NSString stringWithFormat:@"昨天 %@",times];;
    }else if([years integerValue]!=year){
        
        return timeYear;
    }else{
        return [NSString stringWithFormat:@"%@-%@ %@",months,days,times];
    }
    return 0;
}
+(NSString *)acordingTimeStrRetrunNew_time:(NSString *)timeStr
{
    
    if ([NSString isEmpty:timeStr]) {
        return @"";
    }
    
    if (timeStr.length<8) {
        return @"";
    }
    
    NSString *years = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *months =[timeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *days   = [timeStr substringWithRange:NSMakeRange(8, 2)];
//    NSString *times = [timeStr substringWithRange:NSMakeRange(11, 5)];
//    NSString *timeYear = [timeStr substringWithRange:NSMakeRange(0, 16)];
    //今天
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger year = [conponent year];
    NSInteger month=[conponent month];
    NSInteger Today=[conponent day];
    
//    if ([months integerValue] == month&&[days integerValue] == Today) {
    
    return [NSString stringWithFormat:@"%@-%@-%@",years,months,days];
    
//    }
//    else if ([months integerValue] == month&& Today - [days integerValue] == 1 ){
//        return  [NSString stringWithFormat:@"%@-%@",months,days];;
//    }else if([years integerValue]!=year){
//        
//        return [NSString stringWithFormat:@"%@-%@-%@",years,months,days];
//;
//    }else{
//        return [NSString stringWithFormat:@"%@-%@-%@",years,months,days];
//    }
//    return 0;

}


+(NSString *)acordingTimeStrRetrunNo_todayText:(NSString *)timeStr
{
    NSString *years = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *months =[timeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *days   = [timeStr substringWithRange:NSMakeRange(8, 2)];
    //    NSString *times = [timeStr substringWithRange:NSMakeRange(11, 5)];
    //    NSString *timeYear = [timeStr substringWithRange:NSMakeRange(0, 16)];
    //今天
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger year = [conponent year];
    NSInteger month=[conponent month];
    NSInteger Today=[conponent day];
    
//    if ([months integerValue] == month&&[days integerValue] == Today) {
//        
//        return [NSString stringWithFormat:@" %@-%@",months,days];
//        
//    }
//    else if ([months integerValue] == month&& Today - [days integerValue] == 1 ){
//        return  [NSString stringWithFormat:@" %@-%@",months,days];;
//    }else if([years integerValue]!=year){
//        
//        return [NSString stringWithFormat:@"%@-%@-%@",years,months,days];
//        ;
//    }else{
        return [NSString stringWithFormat:@"%@-%@-%@",years,months,days];
//    }
    return 0;
    
}

+(void)Savenum
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger Today=[conponent day];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)Today] forKey:@"Score_key"];
    
}
+(BOOL)isHad
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger Today=[conponent day];
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Score_key"] integerValue] == Today) {
        return YES;
    }else{
        
        return NO;
        
    }
    
}
+ (NSInteger)GetDayFromStamp:(NSDate *)stamp
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:stamp];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    return day;
}
+(NSInteger)GetyearFromStamp:(NSDate *)stamp
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:stamp];
    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
    return year;
}
+ (NSInteger)GetMonthFromStamp:(NSDate *)stamp
{
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:stamp];
//    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
    
    return month;
}
+(NSString *)yearAppendMonthanddayfromstamp:(NSDate *)date
{
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm"];
    NSString *daystr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString *monthstr = [NSString stringWithFormat:@"%ld",(long)month];
    if (daystr.length) {
        if (daystr.length == 1) {
            daystr = [NSString stringWithFormat:@"%@%@",@"0",daystr];
        }
    }
    if (monthstr.length) {
        if (monthstr.length == 1) {
            monthstr = [NSString stringWithFormat:@"%@%@",@"0",monthstr];
        }
    }
    return [NSString stringWithFormat:@"%ld%@%@",(long)year,monthstr,daystr];
    
}
+ (NSString *)retrunSTRfromArray:(NSArray *)array
{
    
    NSString *str ;
    for (id obj in array) {
        NSString *new_str;
        if (![obj isKindOfClass:[NSString class]]) {
            new_str = [NSString stringWithFormat:@"%@",obj];
            new_str = [new_str substringToIndex:numIndex];
        }else{
            new_str = [obj substringToIndex:numIndex];
        }
        new_str = [new_str stringByReplacingOccurrencesOfString:@"-" withString:@""];;
        if (!str.length) {
            str = new_str;
        }else{
            str =[NSString stringWithFormat:@"%@,%@",str,new_str];
        }
    }
    return str;
    
    
}

+(NSString *)yearAppendMonthfromstamp:(NSDate *)date
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *monthstr = [NSString stringWithFormat:@"%ld",(long)month];
    
    if (monthstr.length) {
        if (monthstr.length == 1) {
            monthstr = [NSString stringWithFormat:@"%@%@",@"0",monthstr];
        }
    }
    NSString *timeStr = [NSString stringWithFormat:@"%ld%@",(long)year,monthstr];
    return timeStr;
    
}
+(NSString *)retrunYearAndMonthAndDay:(NSArray *)arr
{
    NSString *str = [NSString string];
    for (int i = 0; i<arr.count; i++) {
        NSCalendar  * cal=[NSCalendar  currentCalendar];
        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:arr[i]];
        NSInteger year=[conponent year];
        NSInteger month=[conponent month];
        NSInteger day=[conponent day];
        NSString *daystr = [NSString stringWithFormat:@"%ld",(long)day];
        NSString *monthstr = [NSString stringWithFormat:@"%ld",(long)month];
        if (daystr.length) {
            if (daystr.length == 1) {
                daystr = [NSString stringWithFormat:@"%@%@",@"0",daystr];
            }
        }
        if (monthstr.length) {
            if (monthstr.length == 1) {
                monthstr = [NSString stringWithFormat:@"%@%@",@"0",monthstr];
                
            }
        }
        if (str.length) {
            str = [NSString stringWithFormat:@"%@,%ld%@%@",str,(long)year,monthstr,daystr];
        }else{
            str = [NSString stringWithFormat:@"%ld%@%@",(long)year,monthstr,daystr];
        }
    }
    return str;
}
+(BOOL)isTodayLaterTime:(NSDate *)date
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    
    NSDateComponents * conponents= [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger Tyear = [conponents year];
    NSInteger Tmonth= [conponents month];
    NSInteger Tday  = [conponents day];
    NSString *daystr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString *monthstr = [NSString stringWithFormat:@"%ld",(long)month];
    if (daystr.length) {
        if (daystr.length == 1) {
            daystr = [NSString stringWithFormat:@"%@%@",@"0",daystr];
        }
    }
    if (monthstr.length) {
        if (monthstr.length == 1) {
            monthstr = [NSString stringWithFormat:@"%@%@",@"0",monthstr];
            
        }
    }
    
    
    NSString *daystrs = [NSString stringWithFormat:@"%ld",(long)Tday];
    NSString *monthstrs = [NSString stringWithFormat:@"%ld",(long)Tmonth];
    if (daystrs.length) {
        if (daystrs.length == 1) {
            daystrs = [NSString stringWithFormat:@"%@%@",@"0",daystrs];
        }
    }
    if (monthstrs.length) {
        if (monthstrs.length == 1) {
            monthstrs = [NSString stringWithFormat:@"%@%@",@"0",monthstrs];
            
        }
    }
    
    
    NSString *datestr = [NSString stringWithFormat:@"%ld%@%@",(long)year,monthstr,daystr];
    NSString *Tdatestr = [NSString stringWithFormat:@"%ld%@%@",(long)Tyear,monthstrs,daystrs];
    if ([datestr compare:Tdatestr options:NSNumericSearch ] == NSOrderedDescending) {
        return YES;
    }else{
        
        return NO;
    }
    
}
+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                             @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                             @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                             @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                             @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                             @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"-----------weekday is %d",[comps weekday]);//在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSLog(@"-----------month is %d",[comps month]);
    NSLog(@"-----------day is %d",[comps day]);
    NSLog(@"-----------weekdayOrdinal is %d",[comps weekdayOrdinal]);
    
    return d_str;

//    return chineseCal_str;
}
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}
+(NSString *)getChineseCalendarWithDateAndWeek:(NSDate *)date
{
    NSCalendar  * localeCalendar =[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [localeCalendar components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *monthstr = [NSString stringWithFormat:@"%ld",(long)month];
    NSString *daystr = [NSString stringWithFormat:@"%ld",(long)day];

    if (monthstr.length) {
        if (monthstr.length == 1) {
            monthstr = [NSString stringWithFormat:@"%@%@",@"0",monthstr];
        }
    }
    if (daystr.length) {
        if (daystr.length == 1) {
            daystr = [NSString stringWithFormat:@"%@%@",@"0",daystr];
        }
    }
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthstr,daystr];
    NSString *nowTimeStr = [JGJTime acordingTimeStrRetrunNew_time:timeStr];
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                             @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                             @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                             @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                             @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                             @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    
    NSCalendar *localeCalendars = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];

    NSDateComponents *localeComp = [localeCalendars components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [localeCalendar components:unitFlags fromDate:date];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
//    return [weekdays objectAtIndex:theComponents.weekday];

    return [NSString stringWithFormat:@"%@   %@   %@",nowTimeStr,d_str,[weekdays objectAtIndex:theComponents.weekday]];
}



+ (NSInteger)compareDate:(NSString*)preDate laterDate:(NSString *)laterDate
{
    //
    if ([NSString isEmpty:preDate]) {
//        [TYShowMessage showError:@"选择开始时间"];
        return -1;
    }
    if ([NSString isEmpty:laterDate]) {
//        [TYShowMessage showError:@"选择开始时间"];
        return 0;
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *dateTime=[formatter stringFromDate:preDate];
    NSDate *date = [formatter dateFromString:preDate];
    
    
    NSInteger aa=0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    dta = [dateformater dateFromString:laterDate];
    NSComparisonResult result = [date compare:dta];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //aDate比date大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //aDate比date小
        aa=-1;
        
    }
    
    return aa;
}


+ (NSString*)weekDayStr:(NSString *)format
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSString *str = [self description];
    if (str.length >= 10) {
        NSString *nowString = [str substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        if (array.count == 0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        if (array.count >= 3) {
            int year = [[array objectAtIndex:0] integerValue];
            int month = [[array objectAtIndex:1] integerValue];
            int day = [[array objectAtIndex:2] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int week = [weekdayComponents weekday];
    week ++;
    switch (week) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";  
            break;  
    }  
    return weekDayStr;  
}

+ (NSString *)currentDateWithFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-mm-dd"];
    NSString *weekString = [dateformatter stringFromDate:date];
    return weekString;
}
+(NSString *)getNowWeekday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    NSString  *weekDayStr;
    switch ([comps weekday]) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";
            break;
    }

    return weekDayStr;
}

+ (CGFloat)iphoneXModifybar{
    if (isiPhoneX) {
        return -34;
        
    }else{
        
        
        return 0;
    }
    
}

+ (CGFloat)iphoneXModifynav
{
    if (isiPhoneX) {
        return 44;
        
    }else{
        
        
        return 0;
    }
}
+(CGFloat)iphoneXModifyscreen
{
    if (isiPhoneX) {
        return 58;
        
    }else{
        
        
        return 0;
    }
    
}
@end
