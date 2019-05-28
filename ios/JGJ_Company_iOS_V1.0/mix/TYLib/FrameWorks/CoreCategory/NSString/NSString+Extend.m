//
//  NSString+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSString+Extend.h"

#import "NSDate+Extend.h"

@implementation NSString (Extend)


/*
 *  时间戳对应的NSDate
 */
-(NSDate *)date{
    
    NSTimeInterval timeInterval=self.floatValue;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}


+ (NSString *)getSubString:(NSString *)string ExcludeSring:(NSString *)excluedString{
    return [self getSubString:string ExcludeSring:@[excluedString].copy];
}

+ (NSString *)getSubString:(NSString *)string Exclude:(NSArray *)stringArray{
    if (!string || [string isEqualToString:@""]) {//异常情况直接返回
        return nil;
    }
    
    NSRange range;
    
    //是否查找到对应的字符串
    for (NSString *obj in stringArray) {
        if([string rangeOfString:obj].location !=NSNotFound)
        {
            range = [string rangeOfString:obj];
            break;
        }
    }
    
    NSRange subRange = NSMakeRange(0, string.length - range.length);
    NSString *subString = [string substringWithRange:subRange];//截取范围类的字符串;
    return subString;
}

+ (NSString *)string:(NSString *)string deleteChar:(NSString *)charString{
    //去掉特殊字符
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:charString];
    NSString *finalString = [string stringByTrimmingCharactersInSet:set];
    
    return finalString;
}

//获取拼音首字母(传入汉字字符串, 返回拼音首字母)
+ (NSString *)firstCharactor:(NSString *)string
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    //    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [str substringToIndex:1];
}

+ (NSString *)getCharactor:(NSString *)string
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    //    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return str;
}

+ (NSString *)getTimeLimitString:(NSInteger )timelimit{
    NSString *timeLimitString;

    if (timelimit < 30) {
        timeLimitString = [NSString stringWithFormat:@"工期:%@天",@(timelimit)];
    }else{
        NSInteger yearInteger = timelimit/365;
        NSInteger monthInteger = timelimit/30;
        NSInteger dayInteger = timelimit%30;
        
        if(timelimit < 365){
            timeLimitString = [NSString stringWithFormat:@"工期:%@个月",@(monthInteger)];
            timeLimitString = dayInteger!=0?[timeLimitString stringByAppendingString:[NSString stringWithFormat:@"%@天",@(dayInteger)]]:timeLimitString;
        }else{
            timeLimitString = [NSString stringWithFormat:@"工期:%@月",@(yearInteger)];
            timeLimitString = monthInteger!=0?[timeLimitString stringByAppendingString:[NSString stringWithFormat:@"%@个月",@(monthInteger)]]:timeLimitString;
            timeLimitString = dayInteger!=0?[timeLimitString stringByAppendingString:[NSString stringWithFormat:@"%@天",@(dayInteger)]]:timeLimitString;
        }
    }
    return timeLimitString;
}

//NSDate转化为NSString
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];//@"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *string = [dateFormatter stringFromDate:date];
    
    return string;
}

//一种日期格式的NSString转化为另一种日期格式的NSString
+ (NSString *)stringWithDateFormat:(NSString *)dateFormat2 fromString:(NSString *)string1 withDateFormat:(NSString *)dateFormat1
{
    return [NSString stringFromDate:[NSDate dateFromString:string1 withDateFormat:dateFormat1] withDateFormat:dateFormat2];
}

//判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string
{
    if (!string || [string isEqualToString:@""] || string.length == 0)
    {
        return YES;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}


#pragma mark - 只获取数字
+ (NSString * )getNumOlnyByString:(NSString *)originalString{
    //
    NSCharacterSet *setToRemove =
    [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
     invertedSet ];
    
    //只获取数字,纯数字,只有数字
    NSString *newString =
    [[originalString componentsSeparatedByCharactersInSet:setToRemove]
     componentsJoinedByString:@""];
    return newString;
}

@end
