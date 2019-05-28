//
//  NSString+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate *date;

/**
 *  获取string除开excludedString的字符串
 *
 *  @param string        原始字符串
 *  @param excluedString 不需要的字符串
 *
 *  @return 最终的字符串
 */
+ (NSString *)getSubString:(NSString *)string ExcludeSring:(NSString *)excluedString;

/**
 *  获取string除开stringArray的字符串
 *
 *  @param string        原始字符串
 *  @param excluedString 不需要的字符串的数组，如果检索到包含，则立刻break
 *
 *  @return 最终的字符串
 */
+ (NSString *)getSubString:(NSString *)string Exclude:(NSArray *)stringArray;


/**
 *  获取string去除charString的字符串
 *
 *  @param string        原始字符串
 *  @param charString 不需要的字符串的数组，如果检索到包含，则立刻break
 *
 *  @return 最终的字符串
 */
+(NSString *)string:(NSString *)string deleteChar:(NSString *)charString;


/**
 *  获取拼音首字母(传入汉字字符串, 返回拼音首字母)
 *
 *  @param string        原始字符串
 *  @return 最终的字符串
 */
+ (NSString *)firstCharactor:(NSString *)string;

/**
 *  获取拼音字母(传入汉字字符串, 返回拼音字母)
 *
 *  @param string        原始字符串
 *  @return 最终的字符串
 */
+ (NSString *)getCharactor:(NSString *)string;

/**
 *  获取工期天书
 *
 *  @param timelimit        传入的天数
 *  @return 返回的工期字符串
 */
+ (NSString *)getTimeLimitString:(NSInteger )timelimit;

/**
 *  NSDate转化为NSString
 *
 *  @param date       传入date
 *  @param dateFormat data格式
 *
 *  @return 返回的字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;

/**
 *  一种日期格式的NSString转化为另一种日期格式的NSString
 *
 *  @param dateFormat2 格式2
 *  @param string1     日期字符串
 *  @param dateFormat1 格式1
 *
 *  @return 返回的日期字符串
 */
+ (NSString *)stringWithDateFormat:(NSString *)dateFormat2 fromString:(NSString *)string1 withDateFormat:(NSString *)dateFormat1;

/**
 *  判断字符串是否为空
 *
 *  @param string 需要判断的字符串
 *
 *  @return 是否为空，YES:为空，NO非空
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 * 只获取数字
 */
#pragma mark - 只获取数字
+ (NSString * )getNumOlnyByString:(NSString *)originalString;
@end
