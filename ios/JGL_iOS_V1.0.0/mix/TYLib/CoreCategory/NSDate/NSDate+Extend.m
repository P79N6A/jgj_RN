//
//  NSDate+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSDate+Extend.h"

#import "IDJCalendarUtil.h"

#import "IDJChineseCalendar.h"

#import "NSDate+FSExtension.h"

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
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

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
    
    //    NSDate *date = [NSDate timeSpStringToNSDate:@"1514787399"];
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents = [NSDate date].ymdDate.components;
    
    //比较    今天是2018-01-01 14:16:39(1514787399)那么2017-12-31是昨天
    
    BOOL res=(dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day) || ((dateComponents.month==12 && dateComponents.day==31) && (nowComponents.month==1 && nowComponents.day==1));
    
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

#pragma mark - 给一个时间，给一个数，正数是以后n个月，负数是前n个月
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month {
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
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
    NSUInteger oldTimeInterVal = [[TYUserDefaults objectForKey:key] integerValue];
    
    [TYUserDefaults setObject:[NSString stringWithFormat:@"%@",@(newTimeInterVal)] forKey:key];
    [TYUserDefaults synchronize];
    
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

+ (NSDate *)dateFromStringWith0GMT:(NSString *)string withDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
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

/*
 今天：12:00
 昨天 | 昨天是去年的最后一天：昨天 12:00
 今年之内、昨天之前：10-22 12:00
 今年之前：2016-10-10 12:00
 */
+ (NSString *)showDateWithTimeStamp:(NSString *)timeStamp {
    //    timeStamp = @"1513063820"; 今天
    //        timeStamp = @"1512977420";//昨天
    //        timeStamp = @"1512489600";
    //        timeStamp = @"1481441420";//去年
    
    if ([timeStamp isEqualToString:@"0"] || [NSString isEmpty:timeStamp]) {
        return @"";
    }
    NSString *dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    NSArray *componentsDates = [dateString componentsSeparatedByString:@"-"];
    if (date.isToday) { //今日显示
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
    }else if (date.isYesToday) {
        
//        NSString *hourMinuteStr = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
        
        dateString = @"昨天";
        
    }else if (!date.isThisYear) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd HH:mm"];
        
        //        dateString = [NSString stringWithFormat:@"%@年", dateString];
        
    }else if (componentsDates.count >=2) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"MM-dd HH:mm"];
        
        //        dateString = [NSString stringWithFormat:@"%@月%@日",componentsDates[1],componentsDates[2]];
        
    }
    
    return dateString;
}

/*
 今天：12:00
 昨天 | 昨天是去年的最后一天：昨天 12:00
 今年之内、昨天之前：10-22 12:00
 今年之前：2016-10-10 12:00
 */
+ (NSString *)chatShowDateWithTimeStamp:(NSString *)timeStamp {
    //    timeStamp = @"1513063820"; 今天
    //        timeStamp = @"1512977420";//昨天
    //        timeStamp = @"1512489600";
//            timeStamp = @"1481441420";//去年
    
    if ([timeStamp isEqualToString:@"0"] || [NSString isEmpty:timeStamp]) {
        return @"";
    }
    NSString *dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    NSArray *componentsDates = [dateString componentsSeparatedByString:@"-"];
    if (date.isToday) { //今日显示
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
    }else if (date.isYesToday) {
        
        //        NSString *hourMinuteStr = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
        
        dateString = @"昨天";
        
    }else if (!date.isThisYear) {
        
//        dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
        
        dateString = [NSString stringWithFormat:@"%@年", @(date.components.year)];
        
    }else if (componentsDates.count >=2) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"MM-dd"];
        
        //        dateString = [NSString stringWithFormat:@"%@月%@日",componentsDates[1],componentsDates[2]];
        
    }
    
    return dateString;
}

+ (NSString *)chatShowActivityDateWithTimeStamp:(NSString *)timeStamp {
    
    if ([timeStamp isEqualToString:@"0"] || [NSString isEmpty:timeStamp]) {
        return @"";
    }
    NSString *dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    NSArray *componentsDates = [dateString componentsSeparatedByString:@"-"];
    if (date.isToday) { //今日显示
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
    }else if (date.isYesToday) {
        
//        dateString = @"昨天";
        dateString = [NSString stringWithFormat:@"昨天 %@",[NSDate dateTimesTampToString:timeStamp format:@"HH:mm"]];
        
    }else if (!date.isThisYear) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
        
        
    }else if (componentsDates.count >=2) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"MM-dd HH:mm"];
        
    }
    
    return dateString;
}

/*
 今天：12:00
 昨天 | 昨天是去年的最后一天：昨天 12:00
 今年之内、昨天之前：10-22 12:00
 今年之前：2016-10-10 
 */
+ (NSString *)chatMsgListShowDateWithTimeStamp:(NSString *)timeStamp {
    //    timeStamp = @"1513063820"; 今天
    //        timeStamp = @"1512977420";//昨天
    //        timeStamp = @"1512489600";
//            timeStamp = @"1546271999";//去年
    
    if ([timeStamp isEqualToString:@"0"] || [NSString isEmpty:timeStamp]) {
        return @"";
    }
    NSString *dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    NSArray *componentsDates = [dateString componentsSeparatedByString:@"-"];
    if (date.isToday) { //今日显示
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"];
        
    }else if (date.isYesToday) {
        
        dateString = [NSString stringWithFormat:@"昨天 %@", [NSDate dateTimesTampToString:timeStamp format:@"HH:mm"]];

    }else if (!date.isThisYear) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"yyyy-MM-dd"];
        
    }else if (componentsDates.count >=2) {
        
        dateString = [NSDate dateTimesTampToString:timeStamp format:@"MM-dd HH:mm"];
        
    }
    
    return dateString;
}

//获取当月行数
+ (NSInteger)calculateCalendarRows:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    
    components.day = 1;
    
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    
    NSInteger weekdayOfFirstDay = [calendar component:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:date];
    
    NSInteger numberOfDaysInMonth = days.length;
    
    NSInteger numberOfPlaceholdersForPrev = ((weekdayOfFirstDay - calendar.firstWeekday) + 7) % 7;
    
    NSInteger headDayCount = numberOfDaysInMonth + numberOfPlaceholdersForPrev;
    
    NSInteger numberOfRows = (headDayCount/7) + (headDayCount%7>0);
    
    return numberOfRows;
}

+ (NSDateComponents *)getYearAndMonthWithDate:(NSDate *)date {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    
    NSCalendarUnitDay;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    
    NSDateComponents *com = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return com;
}

+ (NSString *)convertChineseDateWithDate:(NSString *)date {
    
    NSDate  *currentDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM-dd"];
    
    IDJCalendar *cal = [[IDJCalendar alloc] init];
    
    cal.year = [NSString stringWithFormat:@"%@", @(currentDate.fs_year)];
    
    cal.month = [NSString stringWithFormat:@"%@", @(currentDate.fs_month)];
    
    cal.day = [NSString stringWithFormat:@"%@", @(currentDate.fs_day)];
    
    //农历第三方规表示是否润月a- b-
    cal = [[IDJChineseCalendar alloc]initWithYearStart:currentDate.fs_year-1 end:currentDate.fs_year+1 IDJCalendar:cal];
    
    if ([cal.month containsString:@"a-"] || [cal.month containsString:@"b-"]) {
        
        if ([cal.month containsString:@"a-"]) {
            
            cal.month = [cal.month stringByReplacingOccurrencesOfString:@"a-" withString:@""];
            
        }else if ([cal.month containsString:@"b-"]) {
            
            cal.month = [cal.month stringByReplacingOccurrencesOfString:@"b-" withString:@""];
        }
    }
    
    date = [NSString stringWithFormat:@"%@%@", [self chineseMonthsWithMonth:[cal.month integerValue]],[self chineseDaysWithDay:[cal.day integerValue]]];
    
    NSLog(@"111111currentDate = %@ ,year = %@ ,month=%@, day=%@",currentDate,cal.year,cal.month,cal.day);
    
    return date;
    
}

+ (NSString *)convertSolaDateWithDate:(NSString *)date {
    
    NSDate  *currentDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM-dd"];
    
    IDJCalendar *cal = [[IDJCalendar alloc] init];
    
    cal.year = [NSString stringWithFormat:@"%@", @(currentDate.fs_year)];
    
    cal.month = [NSString stringWithFormat:@"a-%@", @(currentDate.fs_month)];
    
    cal.day = [NSString stringWithFormat:@"%@", @(currentDate.fs_day)];
    
    if ([cal.month containsString:@"-"]) {
        
        NSDateComponents *components = [IDJCalendarUtil toSolarDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
        
        cal.year = [NSString stringWithFormat:@"%@", @(components.year)];
        
        cal.month = [NSString stringWithFormat:@"%.2ld", components.month];
        
        cal.day = [NSString stringWithFormat:@"%@", @(components.day)];
        
    }
    
    date = [NSString stringWithFormat:@"%@-%@-%@",cal.year, cal.month, cal.day];
    
    return date;
}

+(NSString *)chineseMonthsWithMonth:(NSInteger)month {
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月", nil];
    
    NSString *monthStr = @"";
    
    if (month > 0 && month <= 12) {
        
        monthStr = chineseMonths[month-1];
    }
    
    return monthStr;
    
    
}

+(NSString *)chineseDaysWithDay:(NSInteger)day {
    
    NSArray *chineseDays = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSString *dayStr = @"";
    
    if (day > 0 && day <= 31) {
        
        dayStr = chineseDays[day-1];
    }
    
    return dayStr;
    
    
}

+ (NSInteger)numberOfDatesInMonthOfDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                       inUnit:NSCalendarUnitMonth
                                      forDate:date];
    return days.length;
}

+ (NSString *)coverYearMonthWithDateStr:(NSString *)dateStr {
    
    if ([dateStr containsString:@"年"]) {
        
        NSString *format = @"yyyy-MM";
        
        NSDate *date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月"];
        
        if ([dateStr containsString:@"年"] && [dateStr containsString:@"月"] && [dateStr containsString:@"日"]) {
            
            date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月dd日"];
            
        }else if ([dateStr containsString:@"年"] && [dateStr containsString:@"月"] && ![dateStr containsString:@"日"]) {
            
            date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月"];
            
        }
        
        dateStr = [NSDate stringFromDate:date format:format];
        
    }
    
    return dateStr;
}

+ (NSString *)weekdayWithDate:(NSDate *)date {
    
    NSInteger weekday = [self weekdayStringFromDate:date];
    
    NSArray *weekdays = @[@"",@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    if (weekday < weekdays.count) {
        
        return weekdays[weekday];
    }
    
    return nil;
}

//+ (NSString *)getThePreviousMonthWithDate:(NSDate *)currentDate {
//
//    //获取前一个月的时间
//    NSDate *monthagoData = [self getPriousorLaterDateFromDate:_calendar.currentPage?:[NSDate date] withMonth:-1];
//
//    NSString *agoString = [NSDate stringFromDate:monthagoData format:@"yyyy-MM"];
//    TYLog(@"前一个月时间 = %@",agoString);
//
//    NSDate *monthafterData = [self getPriousorLaterDateFromDate:_calendar.currentPage?:[NSDate date] withMonth:+1];
//
//    NSString *afterString = [NSDate stringFromDate:monthafterData format:@"yyyy-MM"];
//    TYLog(@"后一个月时间 = %@",afterString);
//}
//
//+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
//
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//
//    [comps setMonth:month];
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
//    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
//    return mDate;
//
//
//}

@end
