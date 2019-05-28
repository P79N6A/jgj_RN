//
//  NSString+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSString+Extend.h"

#import "NSDate+Extend.h"

#import "PinYin4Objc.h"
#import "YYText.h"
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
    if ([NSString isEmpty:string]) {//异常情况直接返回
        return nil;
    }
    
    NSRange range = {0};
    //是否查找到对应的字符串
    for (NSString *obj in stringArray) {
        if([string containsString:obj])
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
////    //转成了可变字符串
//    NSMutableString *str = [NSMutableString stringWithString:string];
//    //先转换为带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    //再转换为不带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
//    //转化为大写拼音
//    //    NSString *pinYin = [str capitalizedString];
//    //获取并返回首字母
//    return [str substringToIndex:1];
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    if ([NSString isEmpty:string]) {
        
        string = @"1"; //空值复制为1匹配出来首字母是~
    }else if ([self matchLetter:string]) { //第一个是字母直接返回
    
        return [string substringToIndex:1];
    }
    
    NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[string characterAtIndex:0] withHanyuPinyinOutputFormat:outputFormat];
    
    if ([NSString isEmpty:mainPinyinStrOfChar]) {
        
        mainPinyinStrOfChar = @"~";
        
        if (![NSString isEmpty:string]) {
            
            NSString *firstLetter = [string substringToIndex:1];
            
            if ([NSString matchLetter:firstLetter]) {
                
                mainPinyinStrOfChar = firstLetter;
            }
            
        }
        
    }else {
        
        mainPinyinStrOfChar = [mainPinyinStrOfChar substringToIndex:1];
    }
    
    return mainPinyinStrOfChar;
    
}

/**
 将中文字符串转化成大写拼音
 @param str 中文字符串
 @return 大写拼音
 */
+ (NSString *)toHanyuPinyinStringWithNSString:(NSString *)str {
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    
    [outputFormat setToneType:ToneTypeWithoutTone];
    
    [outputFormat setVCharType:(VCharTypeWithV)];
    
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSString *pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:str withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return pinyin;
}
/**
 将中文字符串转化成首字母拼音(大写)
 @param str 中文字符串
 @return 首字母拼音
 */
+ (NSString *)toHeadPinyinWithChinese:(NSString *)str
{
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    
    [outputFormat setToneType:ToneTypeWithoutTone];
    
    [outputFormat setVCharType:(VCharTypeWithV)];
    
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSMutableString *headPinyin = [NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        NSString *pinyin = [PinyinHelper getFirstHanyuPinyinStringWithChar:ch withHanyuPinyinOutputFormat:outputFormat];
        if (pinyin) {
            [headPinyin appendString:[pinyin substringToIndex:1]];
        } else {
            NSString *currentStr = [str substringWithRange:NSMakeRange(i, 1)];
            [headPinyin appendString:currentStr.capitalizedString];
        }
    }
    return headPinyin;
}


/**
 是否匹配某个正则表达式
 @param str 正则表达式
 @return 匹配结果
 */
- (BOOL)match:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
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
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
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

+ (BOOL)isFloatZero:(CGFloat)v{
    float epsinon = 0.00001;
    
    if (v > -epsinon && v < epsinon) {
        return YES;
    }
    return NO;
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

+(BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isInputChinese:(NSString *)inputText {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:inputText]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInputNum:(NSString *)inputText {
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:inputText]) {
        return YES;
    }
    return NO;
}

+ (UIColor *)modelBackGroundColor:(NSString *)changeColorValue {
    UIColor *backGroundColor = TYColorHex(0xe6884f);
    NSArray *hashColors = @[TYColorHex(0xe6884f),TYColorHex(0xffae2f),TYColorHex(0x99bb4f),TYColorHex(0x56c2c5),TYColorHex(0x62b1da),TYColorHex(0x5990d4),TYColorHex(0x7266ca),TYColorHex(0xbf67cf),TYColorHex(0xda63af),TYColorHex(0xdf5e5e)];
    NSInteger hashCode = [self getHashCode:changeColorValue];
    NSString *lastHashCodeStr = [NSString stringWithFormat:@"%@", @(hashCode)];
    NSInteger colorIndx = [lastHashCodeStr characterAtIndex:lastHashCodeStr.length - 1];
    colorIndx -= 48;
    if ([hashColors indexOfObject:hashColors[colorIndx]] == NSNotFound) {
        NSInteger index = arc4random() % 9;
        backGroundColor = hashColors[index];
    }else {
        backGroundColor = hashColors[colorIndx];
    }
    
    return backGroundColor;
}

+ (NSInteger)getHashCode:(NSString *)real_name {
    NSString *lastName = [real_name substringWithRange:NSMakeRange(real_name.length - 1, 1)];
//    NSInteger hash = 1315423911;
    NSInteger temp = (NSInteger)[lastName characterAtIndex:0];
//    hash ^= ((hash << 5) + temp + (hash >> 2));
    return temp;
}

+ (NSString *)filterSpecialCharacters:(NSString *)characters {
    // 准备对象
    if ([NSString isEmpty:characters]) {
        return @"";
    }
    NSString * searchStr = characters;
    //    NSString * regExpStr = @"[0-9A-Z!@#$%&*=_+()（） ]";
    NSString *regExpStr = @"[^0-9a-zA-z\u4e00-\u9fa5]*";
    NSString * replacement = @"";
    // 创建 NSRegularExpression 对象,匹配 正则表达式
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *resultStr = searchStr;
    // 替换匹配的字符串为 searchStr
    resultStr = [regExp stringByReplacingMatchesInString:searchStr
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, searchStr.length)
                                            withTemplate:replacement];
    return resultStr;
    
}

+ (CGFloat)getContentHeightWithString:(NSString *)content maxWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSapce {
    
    YYTextContainer  *contentContarer = [YYTextContainer new];
    
    //限制宽度
    contentContarer.size = CGSizeMake(width, CGFLOAT_MAX);
    
    if ([NSString isEmpty:content]) {
        
        content = @"";
    }
    
    NSMutableAttributedString * contentAttr = [[NSMutableAttributedString alloc] initWithString:content];
    
    //对齐方式 这里是 两边对齐
    //    resultAttr.yy_alignment = NSTextAlignmentJustified;
    //设置行间距
    //    resultAttr.yy_lineSpacing = 2;
    //设置字体大小
    contentAttr.yy_font = [UIFont systemFontOfSize:font];
    
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    //resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    contentAttr.yy_lineSpacing = lineSapce;
    
    YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
    
    CGFloat height = contentLayout.textBoundingSize.height;
    
    return height;
    
}


+ (CGSize)stringWithContentSize:(CGSize)size content:(NSString *)content font:(CGFloat)font
{
    UIFont *contentFont = [UIFont systemFontOfSize:font];
    
    CGSize contentSize = CGSizeZero;
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        contentSize = [content boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{
                                                      NSFontAttributeName: contentFont,
                                                      NSParagraphStyleAttributeName: textParagraphStyle
                                                      }
                                            context:nil].size;
    }else {
        
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        contentSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: contentFont,NSParagraphStyleAttributeName: textParagraphStyle} context:nil].size;
        
        
    }
    
    return contentSize;
}

+ (CGFloat)stringWithContentWidth:(CGFloat)width content:(NSString *)content font:(CGFloat)font {
    
    return [self stringWithContentSize:CGSizeMake(width, CGFLOAT_MAX) content:content font:font].height;
    
}

+ (CGFloat)stringWithContentWidth:(CGFloat)width content:(NSString *)content font:(CGFloat)font lineSpace:(CGFloat)lineSpace {

        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
        paraStyle.alignment = NSTextAlignmentLeft;
    
        paraStyle.lineSpacing = lineSpace;
    
        paraStyle.firstLineHeadIndent = 0.0;
    
        paraStyle.paragraphSpacingBefore = 0.0;
    
        paraStyle.headIndent = 0;
    
        paraStyle.tailIndent = 0;
    
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle
                              };
    
        CGSize size = [content boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
  
        return size.height + 1;

}

+ (NSString *)getUrlWithStr:(NSString *)headStr {
    
    NSRange range = [headStr rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        
        NSString *urlStr = [headStr substringFromIndex:range.location + 1];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        NSArray *qrCodes = [urlStr componentsSeparatedByString:@"&"];
        NSMutableDictionary *headInfoDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < qrCodes.count; i ++) {
            NSString *valueStr = qrCodes[i];
            NSString *keyStr = [valueStr substringToIndex:[valueStr rangeOfString:@":"].location];
            NSString *value = [valueStr substringFromIndex:[valueStr rangeOfString:@":"].location + 1];
            [headInfoDic setObject:value forKey:keyStr];
        }
        return [headInfoDic objectForKey:@"name"];
    }
    
    return nil;
}

+ (NSString *)cutWithContent:(NSString *)content maxLength:(NSInteger)maxLength {

    NSString *maxContent = content;
    
    if (![NSString isEmpty:content]) {
        
        if ([content isKindOfClass:[NSString class]]) {
            
            if (content.length < maxLength) {
                
                maxContent = content;
                
            }else {
            
                maxContent = [NSString stringWithFormat:@"%@...", [content substringToIndex:maxLength - 1]];

            }
            
        }
    }
    
    return maxContent;
    

}
#pragma mark - 获取内容高度
+ (CGFloat)getContentHeightWithString:(NSString *)content maxWidth:(CGFloat)width{
    
    
    YYTextContainer  *contentContarer = [YYTextContainer new];
    
    //限制宽度
    contentContarer.size = CGSizeMake(width, CGFLOAT_MAX);
    
    if ([NSString isEmpty:content]) {
        
        content = @"";
    }
    
    NSMutableAttributedString  *contentAttr = [self getAttr:content];
    
    contentAttr.yy_lineSpacing = 4.0;
    
    YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
    
    CGFloat height = contentLayout.textBoundingSize.height;
    
    return height;
}

+ (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
    //    resultAttr.yy_alignment = NSTextAlignmentJustified;
    //设置行间距
    //    resultAttr.yy_lineSpacing = 2;
    //设置字体大小
    resultAttr.yy_font = [UIFont systemFontOfSize:AppFont32Size];
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    //resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}
#pragma mark -判断是否包含字母
+ (BOOL)matchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

/**
 *传入宽度内容字体获得高度
 */
+ (CGFloat)stringWithYYContentWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace content:(NSString *)content;
{
    if ([NSString isEmpty:content]) {
        
        return CGFLOAT_MIN;
    }
    
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:content?:@""];
    
    introText.yy_font = [UIFont systemFontOfSize:font];
    
    introText.yy_lineSpacing = lineSpace;
    
    CGSize introSize = CGSizeMake(width, CGFLOAT_MAX);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    
    CGFloat introHeight = layout.textBoundingSize.height;
    
    return introHeight;
}

- (NSString *)encodeToPercentEscapeString:(NSString *)input

{
    if ([input containsString:@"#"]) {
        
        NSString *replacedStr = @"?";
        
        if (![input containsString:@"?"]) {
            
            replacedStr = @"?";
            
        }else if ([input containsString:@"&"]) {
            
            replacedStr = @"&";
        }

        input = [input stringByReplacingOccurrencesOfString:@"#" withString:replacedStr];
    }
    
    //URL使用UTF8编码
    input = [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return input;
    
}

/**
 *获取需要处理的子字符串和子串的range
 */
+(NSArray<NSTextCheckingResult *> *)getSubStrRangeArrWithStr:(NSString *)str pattern:(NSString *)pattern{
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return results;
}

+(NSString *)toppattern {
    
    return @"#[^#]+#";
}

+ (NSString *)textEditChanged:(UITextField *)textField maxLength:(NSInteger)maxLength{
    
    if (maxLength == 0) {
        
        maxLength = 20;
    }
    
    NSString *toBeString = textField.text;
    
    BOOL isEmoj = [self containsEmojiStr:toBeString];
    
    NSString *showStr;
    
    toBeString = [self filterEmoji:toBeString];
    
    NSArray *array = [UITextInputMode activeInputModes];
    
    UITextInputMode *current = [array firstObject];
    
    if([current.primaryLanguage isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        
        //        UITextRange *selectedRange = [textField markedTextRange];
        
        //        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        //        if(!position) {
        //
        //            if(toBeString.length > maxLength) {
        //
        //                textField.text = [toBeString substringToIndex:maxLength];
        //
        //                showStr = [toBeString substringToIndex:maxLength];
        //
        //            }
        //        }
        
        if(toBeString.length > maxLength) {
            
            textField.text = [toBeString substringToIndex:maxLength];
            
            showStr = [toBeString substringToIndex:maxLength];
            
        }
        
    }else if ([current.primaryLanguage isEqualToString:@"emoji"]){
        
        [TYShowMessage showPlaint:@"不支持emoji表情输入"];
        
    }else{
        
        if(toBeString.length > maxLength) {
            
            textField.text= [toBeString substringToIndex:maxLength];
            
            showStr = [toBeString substringToIndex:maxLength];
            
        }
    }
    
    if (isEmoj) {
        
        if ([showStr length]) {
            
            textField.text = showStr;
            
        }else{
            
            textField.text = toBeString;
            
        }
    }
    
    return textField.text;
}

#pragma mark - 是否包含表情
+ (BOOL)containsEmojiStr:(NSString *)str
{
    __block BOOL returnValue = NO;
    
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                            options:NSStringEnumerationByComposedCharacterSequences
                         usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                             
                             const unichar high = [substring characterAtIndex: 0];
                             
                             // Surrogate pair (U+1D000-1F9FF)
                             if (0xD800 <= high && high <= 0xDBFF) {
                                 
                                 const unichar low = [substring characterAtIndex: 1];
                                 
                                 const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                 
                                 if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                     
                                     returnValue = YES;
                                     
                                 }
                                 
                                 // Not surrogate pair (U+2100-27BF)
                             } else {
                                 if (0x2100 <= high && high <= 0x27BF){
                                     
                                     returnValue = YES;
                                     
                                 }
                                 
                             }
                             
                         }];
    
    return returnValue;
}
#pragma Mark - 过滤表情
+ (NSString *)filterEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, text.length)
                                                          withTemplate:@""];
    return modifiedString;
}

- (NSString *)URLEncode
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
