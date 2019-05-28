//
//  NSDate+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSDate+Extend.h"


@interface NSDate ()

/*
 *  清空时分秒，保留年月日
 */
@property (nonatomic,strong,readonly) NSDate *ymdDate;

@end

@implementation NSDate (Extend)

/*
 *  时间戳
 */
-(NSString *)timestamp{

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}

/*
 *  时间成分
 */
-(NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    return [calendar components:unit fromDate:self];
}

/*
 *  是否是今年
 */
-(BOOL)isThisYear{
    
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}

/*
 *  是否是今天
 */
-(BOOL)isToday{

    //差值为0天
    return [self calWithValue:0];
}

/*
 *  是否是昨天
 */
-(BOOL)isYesToday{
    
    //差值为1天
    return [self calWithValue:1];
}

-(BOOL)calWithValue:(NSInteger)value{
    
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents = self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents = [NSDate date].ymdDate.components;
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}

/*
 *  清空时分秒，保留年月日
 */
-(NSDate *)ymdDate{
    
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    return date;
}

/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    return components;
}


//将formatStr格式时间(timeStr)转换成时间戳
+(long)dateStringToTimesTamp:(NSString *)timeStr format:(NSString *)formatStr{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [format setTimeZone:timeZone];
    
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}

//将formatStr格式时间戳(timeStr)转换成时间
+ (NSString *)dateTimesTampToString:(NSString *)timesTamp format:(NSString *)formatStr
{
    NSDate *getDate = [NSDate dateWithTimeIntervalSince1970:[timesTamp integerValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [format setTimeZone:timeZone];
    
    NSString *dateString = [format stringFromDate:getDate];
    return dateString;
    
}

//将时间戳转换为NSDate
+ (NSDate *)timeSpStringToNSDate:(NSString *)timeSpString{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[timeSpString integerValue]];
    return currentTime;
}


//当前时间和上次保存的时间，是否超过了timeSeconds(单位:秒),超过了返回YES,没有超过返回NO
+ (BOOL )isOverTimeInterVal:(NSInteger)timeSeconds key:(NSString *)key{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSUInteger newTimeInterVal = [date timeIntervalSince1970];
    NSUInteger oldTimeInterVal = [[UserDefaults objectForKey:key] integerValue];
    
    [UserDefaults setObject:[NSString stringWithFormat:@"%@",@(newTimeInterVal)] forKey:key];
    [UserDefaults synchronize];
    
    NSInteger time = (newTimeInterVal - oldTimeInterVal);
    BOOL isOverWeak = time > timeSeconds;
    if ((oldTimeInterVal == 0) || !isOverWeak) {
        return NO;
    }else{
        return YES;
    }
}

/**
 * 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 * nowMinutes:现在的时间加上 nowMinutes(分钟)的时间是否在 fromHour 和 toHour 之间
 */
+ (BOOL)dateIsBetweenFromNow:(NSInteger )nowMinutes FromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *dateFromHour = [self getCustomDateWithHour:fromHour];
    NSDate *dateToHour = [self getCustomDateWithHour:toHour];

    //8小时的时差
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:8*3600 + 60*nowMinutes];
    
    if ([currentDate compare:dateFromHour]==NSOrderedDescending && [currentDate compare:dateToHour]==NSOrderedAscending)
    {
        return YES;
    }
    
    return NO;
}

/**
 * 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
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
    resultComps.timeZone = [NSTimeZone systemTimeZone];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

//计算2个NDDate的天数差值
+(NSInteger )getDaysFrom:(NSDate *)startDate withToDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:1];//1代表周日,2代表周一，所以每周的第一天从周一开始
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:startDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

//计算2个NDDate的月数差值
+(NSInteger )getMonthsFrom:(NSDate *)startDate withToDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:1];//1代表周日,2代表周一，所以每周的第一天从周一开始
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitMonth startDate:&fromDate interval:NULL forDate:startDate];
    [gregorian rangeOfUnit:NSCalendarUnitMonth startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.month;
}

+(NSInteger )getDaysThisMothFrom:(NSDate *)fromDate withToDate:(NSDate *)toDate{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    NSDateComponents *fromDateComponents = [calendar components:unit fromDate:fromDate];
    
    NSDateComponents *toDateComponents = [calendar components:unit fromDate:toDate];
    
    if (toDateComponents.month == fromDateComponents.month && toDateComponents.year == fromDateComponents.year) {
        return toDateComponents.day - fromDateComponents.day;
    }else{
        return INT32_MAX;
    }
    
}

//时间戳的差值
+ (NSUInteger )dateTimesTampDValue:(NSString *)timesTamp{
    NSDate* noewdate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSUInteger nowInterVal = [noewdate timeIntervalSince1970] ;
    NSUInteger oldTimeInterVal = [timesTamp integerValue];
    
    NSUInteger timeDValue = nowInterVal - oldTimeInterVal;
    return timeDValue;
}

#pragma mark - 项目特定的
+ (NSString *)timeConsume:(NSString *)timeString{
    NSUInteger timeDValue = [self dateTimesTampDValue:timeString];

    NSUInteger timeMinuteS = timeDValue/60;
    
    NSString *timeStr;
    if (timeMinuteS < 60) {
        timeStr = [NSString stringWithFormat:@"%@分钟前",@(timeMinuteS)];
    }else if(timeMinuteS < 1440){
        timeStr = [NSString stringWithFormat:@"%@小时前",@(timeMinuteS/60)];
    }else if(timeMinuteS < 525600){
        
        timeStr = [NSString stringWithFormat:@"%@天前",@(timeMinuteS/1440)];
    }else{
        timeStr = [NSString stringWithFormat:@"%@年前",@(timeMinuteS/525600)];
    }
    
    return timeStr;
}

+ (NSString *)timeConsumeByStime:(NSString *)stime createTime:(NSString *)createTime
{
    NSUInteger timeDValue = [stime integerValue] - [createTime integerValue];
    NSUInteger timeMinuteS = timeDValue/60;
    
    NSString *timeStr;
    if (timeMinuteS < 60) {
        timeStr = [NSString stringWithFormat:@"%@分钟前",@(timeMinuteS)];
    }else if(timeMinuteS < 1440){
        timeStr = [NSString stringWithFormat:@"%@小时前",@(timeMinuteS/60)];
    }else if(timeMinuteS < 525600){
        NSDate *startDate = [self timeSpStringToNSDate:stime];
        NSDate *endDate = [self timeSpStringToNSDate:createTime];
        NSInteger daysValue = [self getDaysFrom:endDate withToDate:startDate];
        timeStr = [NSString stringWithFormat:@"%@天前",@(daysValue)];
    }else{
        timeStr = [NSString stringWithFormat:@"%@年前",@(timeMinuteS/525600)];
    }
    
    return timeStr;
}

+ (NSString *)getJLGTimeStrMdhm:(NSString *)timesTamp{
    return [NSDate dateTimesTampToString:timesTamp format:@"MM-dd hh:mm"];
}


+ (NSString *)getJLGTimeStrYMdhm:(NSString *)timesTamp{
    return [NSDate dateTimesTampToString:timesTamp format:@"YYYY-MM-dd hh:mm"];
}

+ (NSString *)getJLGTimeStrYMd:(NSString *)timesTamp{
    return [NSDate dateTimesTampToString:timesTamp format:@"YYYY-MM-dd"];
}

+ (NSString *)getJLGTimeDValueStartTime:(NSString *)start_TimesTamp endTime:(NSString *)end_TimesTamp{
    NSUInteger startTimeInteger = [start_TimesTamp integerValue];
    NSUInteger endTimeInteger = [end_TimesTamp integerValue];
    NSUInteger timeDValue = endTimeInteger - startTimeInteger;
 
    NSUInteger timeMinteS = timeDValue/60;
    
    NSString *timeStr;
    if (timeMinteS < 60) {
        timeStr = [NSString stringWithFormat:@"%@分钟",@(timeMinteS)];
    }else if(timeMinteS < 1440){
        timeStr = [NSString stringWithFormat:@"%@小时",@(timeMinteS/60)];
    }else if(timeMinteS < 525600){
        timeStr = [NSString stringWithFormat:@"%@天",@(timeMinteS/1440)];
    }else{
        timeStr = [NSString stringWithFormat:@"%@年",@(timeMinteS/525600)];
    }
    
    return timeStr;
}

//获取本月的最后一天
+(NSDate *)getLastDayOfThisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit |NSDayCalendarUnit fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return lastDay;
}


+(NSDate *)getLastWeekOfThisMonth
{
    NSDate *firstDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    
    NSDateComponents *lastDateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit fromDate:firstDay];
    
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]].length;
    
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return lastDay;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];

    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];

    return currentDateStr;
}


//NSString转化为NSDate
+ (NSDate *)dateFromString:(NSString *)string withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

+ (NSInteger )weekdayStringFromDate:(NSDate*)inputDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
