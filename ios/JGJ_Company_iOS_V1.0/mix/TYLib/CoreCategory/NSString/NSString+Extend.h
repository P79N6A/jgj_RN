//
//  NSString+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ProNameLength 20

#define GroupNameLength 20

#define UserNameLength 10

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
 将中文字符串转化成大写拼音
 @param str 中文字符串
 @return 大写拼音
 */
+ (NSString *)toHanyuPinyinStringWithNSString:(NSString *)str;
/**
 将中文字符串转化成首字母拼音(大写)
 @param str 中文字符串
 @return 首字母拼音
 */
+ (NSString *)toHeadPinyinWithChinese:(NSString *)str;

/**
 是否匹配某个正则表达式
 @param str 正则表达式
 @return 匹配结果
 */
- (BOOL)match:(NSString *)pattern;

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
 *  判断浮点数是否为0
 */
+ (BOOL)isFloatZero:(CGFloat)v;

/**
 * 只获取数字
 */
#pragma mark - 只获取数字
+ (NSString * )getNumOlnyByString:(NSString *)originalString;
/**
 * 判断是不是汉子
 */
+(BOOL)isChinese:(NSString *)str;

/**
 * 判断字符串是不是中文
 */
+ (BOOL)isInputChinese:(NSString *)inputText;

/**
 * 判断字符串是不是数字
 */
+ (BOOL)isInputNum:(NSString *)inputText;

/**
 * 最后一个字符根据hash算法更改颜色
 */
+ (UIColor *)modelBackGroundColor:(NSString *)changeColorValue;

/**
 * 过滤特殊字符
 */
+ (NSString *)filterSpecialCharacters:(NSString *)characters;

/**
 *获取当前字符串高度
 */
+ (CGSize)stringWithContentSize:(CGSize)size content:(NSString *)content font:(CGFloat)font;

+ (CGFloat)stringWithContentWidth:(CGFloat)width content:(NSString *)content font:(CGFloat)font;

/**
 *传入地址获取人的姓名
 */
+ (NSString *)getUrlWithStr:(NSString *)headStr;

/**
 *传入宽度内容字体获得高度
 */
+ (CGFloat)stringWithContentWidth:(CGFloat)width content:(NSString *)content font:(CGFloat)font lineSpace:(CGFloat)lineSpace;

+ (CGFloat)getContentHeightWithString:(NSString *)content maxWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSapce;

/**
 *截取字符串
 */
+ (NSString *)cutWithContent:(NSString *)content maxLength:(NSInteger)maxLength;

//获取内容高度
+ (CGFloat)getContentHeightWithString:(NSString *)content maxWidth:(CGFloat)width;

/**
 *传入宽度内容字体获得高度
 */
+ (CGFloat)stringWithYYContentWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace content:(NSString *)content;

//转义地址
- (NSString *)encodeToPercentEscapeString:(NSString *)input;

/**
 *获取需要处理的子字符串和子串的range
 */
+(NSArray<NSTextCheckingResult *> *)getSubStrRangeArrWithStr:(NSString *)str pattern:(NSString *)pattern;

//话题#之间的内容#
+(NSString *)toppattern;

//textfield改变判断表情，并且不显示表情
+ (NSString *)textEditChanged:(UITextField *)textField maxLength:(NSInteger)maxLength;

//  是否包含表情
+ (BOOL)containsEmojiStr:(NSString *)str;

- (NSString *)URLEncode;
@end
