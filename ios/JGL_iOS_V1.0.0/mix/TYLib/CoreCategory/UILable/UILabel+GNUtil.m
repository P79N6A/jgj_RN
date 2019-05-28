//
//  UILabel+MEExtention.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UILabel+GNUtil.h"

#define MAX_INT 99999

@implementation UILabel (GNUtil)

- (CGSize)contentSizeFixWithSize:(CGSize)size
{
    
    self.numberOfLines = 0;
    
    CGSize contentSize = CGSizeZero;
    
    if ([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = self.textAlignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        contentSize = [self.text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName: self.font,
                                                        NSParagraphStyleAttributeName: textParagraphStyle
                                                        }
                                              context:nil].size;
    }else {
        
        //#pragma clang diagnostic push
        //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        contentSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font,NSParagraphStyleAttributeName: textParagraphStyle} context:nil].size;
        
        //#pragma clang diagnostic pop
        
    }
    
    
    return contentSize;
}

- (CGSize)contentSizeFixWithWidth:(CGFloat)width
{
    return [self contentSizeFixWithSize:CGSizeMake(width, MAX_INT)];
}

- (CGSize)contentSizeFixWithHeight:(CGFloat)height
{
    return [self contentSizeFixWithSize:CGSizeMake(MAX_INT, height)];
}

-(void)setAttributedStringText:(NSString *)text lineSapcing:(CGFloat)lineSapcing {
    if (!text) {
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSapcing;
    style.alignment = NSTextAlignmentLeft;
    
    
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    [string setAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, string.length)];

    self.attributedText =  [string copy];
}

-(void)setAttributedStringText:(NSString *)text font:(UIFont *)font lineSapcing:(CGFloat)lineSapcing {
    if (!text) {
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSapcing;
    style.alignment = NSTextAlignmentLeft;
    
    
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    
    [string setAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, string.length)];
    
    [string setAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} range:NSMakeRange(0, text.length)];
        
    self.attributedText =  [string copy];
}

-(void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing {
    if (!text) {
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSapcing;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
    self.attributedText = string;
}

-(void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing textAlign:(NSTextAlignment)textAlign {
    if (!text) {
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSapcing;
    style.alignment = textAlign;
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
    self.attributedText = string;
}

- (void)markText:(NSString *)t withColor:(UIColor *)c
{
    NSString *text = self.text;
    if (t == nil || t.length == 0) {
        return;
    }
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        NSLog(@"====99999===>%@",arr);
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
        self.attributedText = str;
    }
}
-(void)markMoreText:(NSString *)text withColor:(UIColor *)c
{
    NSString *ntext = self.text;
    if (text == nil || text.length == 0) {
        return;
    }
    if (ntext) {
        NSArray *arr = [ntext componentsSeparatedByString:text];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, text.length);
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableAttributedString* str = [self.attributedText mutableCopy];

        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];

        self.attributedText = str;
    }


}
- (void)markLineText:(NSString *)t withLineFont:(UIFont *)f withColor:(UIColor *)c lineSpace:(CGFloat)lineSpsace
{
    NSString *text = self.text;
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
        
        //设置间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpsace];//调整行间距
        paragraphStyle.alignment = self.textAlignment;
        
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        if ([str.string containsString:@"\n"]) {
            
            NSRange lineRange =  [str.string rangeOfString:@"\n"];
            [str addAttribute:NSFontAttributeName value:f range:NSMakeRange(lineRange.location + 1, t.length)];
        }
        self.attributedText = str;
    }
}

- (void)markLineTextWithLeftTextAlignment:(NSString *)t withLineFont:(UIFont *)f withColor:(UIColor *)c lineSpace:(CGFloat)lineSpsace {
    
    NSString *text = self.text;
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
        
        //设置间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpsace];//调整行间距
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        if ([str.string containsString:@"\n"]) {
            
            NSRange lineRange =  [str.string rangeOfString:@"\n"];
            [str addAttribute:NSFontAttributeName value:f range:NSMakeRange(lineRange.location + 1, t.length)];
        }
        self.attributedText = str;
    }
}
- (void)markText:(NSString *)t withFont:(UIFont *)f color:(UIColor *)c{
    NSString *text = self.text;
    
    if (!text) {
        return;
    }
    
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:rangeLeft];
        [str addAttribute:NSFontAttributeName value:f range:rangeMiddle];
        [str addAttribute:NSFontAttributeName value:self.font range:rangeRight];

        self.attributedText = str;
    }
}

- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color {
    [self markattributedTextArray:textArray color:color font:self.font];
}

- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font{
    [self markattributedTextArray:textArray color:color font:font isGetAllText:NO];
}

- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL )isGetAllText{
    if (self.text.length == 0 || self.text == nil) {
        return;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i = 0;i < textArray.count; i ++) {
        NSString *text = textArray[i];
        if (text.length == 0 || text == nil) {
            return;
        }
    
        
        if (isGetAllText) {//获取所有的range
            NSArray *rangeArr = [self getAllRangeWith:self.text keyString:text];

            str = [self setAttributedText:str rangeArr:rangeArr text:text color:color font:font];
        }else{//只判断第一个range
            NSRange range = [self.text rangeOfString:text];
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    self.attributedText = str;
}

- (void)markTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL )isGetAllText{
    if (self.text.length == 0 || self.text == nil) {
        return;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i = 0;i < textArray.count; i ++) {
        NSString *text = textArray[i];
        if (text.length == 0 || text == nil) {
            return;
        }
        
        
        if (isGetAllText) {//获取所有的range
            NSArray *rangeArr = [self getAllRangeWith:self.text keyString:text];
            
            str = [self setAttributedText:str rangeArr:rangeArr text:text color:color font:font];
        }else{//只判断第一个range
            NSRange range = [self.text rangeOfString:text];
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    self.attributedText = str;
}

#pragma mark - 忽略大小写所有的
- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL)isGetAllText withLineSpacing:(CGFloat)lineSpacing {
    
    if (self.text.length == 0 || self.text == nil) {
        return;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.alignment = NSTextAlignmentLeft;
    
    [str setAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, str.length)];
    
    for (int i = 0;i < textArray.count; i ++) {
        NSString *text = textArray[i];
        if (text.length == 0 || text == nil) {
            return;
        }
        
        
        if (isGetAllText) {//获取所有的range
            NSArray *rangeArr = [self getAllRangeOriginString:self.text keyString:text];
            
            str = [self setAttributedText:str rangeArr:rangeArr text:text color:color font:font];
        }else{//只判断第一个range
            NSRange range = [self.text rangeOfString:text];
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    
    self.attributedText = str;
}

#pragma mark 根据rangeArr 设置对应的颜色和字体
- (NSMutableAttributedString *)setAttributedText:(NSMutableAttributedString *)attrStr rangeArr:(NSArray *)rangeArr text:(NSString *)text color:(UIColor *)color font:(UIFont *)font{

    [rangeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(obj);
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attrStr addAttribute:NSFontAttributeName value:font range:range];
    }];
    
    return attrStr;
}

#pragma mark - 获取originString里面所有keyString的range
- (NSArray *)getAllRangeWith:(NSString *)originString keyString:(NSString *)keyString{
    //保存range的数组
    __block NSMutableArray *rangeArr = [NSMutableArray array];
    
    originString = [originString lowercaseString];
    
    //用于每次都判断的字符串
    __block NSString *subString = [originString lowercaseString];
    
    //用于每次修改的range
    __block NSRange subRange = NSMakeRange(0, 0);
    
    keyString = [keyString lowercaseString];
    
    //数组的大小就是包含了多少个
    NSArray *separateArr = [originString componentsSeparatedByString:keyString];
    
    //循环找出range
    [separateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        subRange = [subString rangeOfString:keyString];
        
        if(subRange.location != NSNotFound) {
            //取出最新的一个range
            NSRange lastRange = NSRangeFromString([rangeArr lastObject]);
            if (lastRange.location == NSNotFound) {
                lastRange = NSMakeRange(0, 0);
            }
            
            //将转换的range添加到数组
            NSRange strRange = NSMakeRange(lastRange.location + lastRange.length + subRange.location, subRange.length);
            [rangeArr addObject:NSStringFromRange(strRange)];
            
            //取出下一次需要判断的string
            NSInteger startLocation = subRange.location + subRange.length;
            subString = [subString substringWithRange:NSMakeRange(startLocation, subString.length - startLocation)];
        }else{
            *stop = YES;
        }
    }];
    
    return rangeArr.copy;
}

#pragma mark - 获取originString里面所有keyString的range忽略大小写
- (NSArray *)getAllRangeOriginString:(NSString *)originString keyString:(NSString *)keyString{
    //保存range的数组
    __block NSMutableArray *rangeArr = [NSMutableArray array];
    
    //用于每次都判断的字符串
    __block NSString *subString = [originString lowercaseString];
    
    //用于每次修改的range
    __block NSRange subRange = NSMakeRange(0, 0);
    
    //数组的大小就是包含了多少个
    NSArray *separateArr = [originString componentsSeparatedByString:[keyString lowercaseString]];
    
    //循环找出range
    [separateArr enumerateObjectsUsingBlock:^(NSString  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        subRange = [subString rangeOfString:keyString];
        
        if(subRange.location != NSNotFound) {
            //取出最新的一个range
            NSRange lastRange = NSRangeFromString([rangeArr lastObject]);
            if (lastRange.location == NSNotFound) {
                lastRange = NSMakeRange(0, 0);
            }
            
            //将转换的range添加到数组
            NSRange strRange = NSMakeRange(lastRange.location + lastRange.length + subRange.location, subRange.length);
            [rangeArr addObject:NSStringFromRange(strRange)];
            
            //取出下一次需要判断的string
            NSInteger startLocation = subRange.location + subRange.length;
            subString = [subString substringWithRange:NSMakeRange(startLocation, subString.length - startLocation)];
        }else{
            *stop = YES;
        }
    }];
    
    return rangeArr.copy;
}

+ (NSAttributedString *)markAtTextArray:(NSString *)originString normalColor:(UIColor *)normalColor highColor:(UIColor *)highColor font:(UIFont *)font {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:originString];
    
    //设置普通状态
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:normalColor,NSFontAttributeName:font} range:NSMakeRange(0, originString.length)];
    
    NSArray *atRangeArr = [self getAllAtRangeWith:originString];
    
    //设置选中范围的状态
    [atRangeArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributedStr addAttributes:@{NSForegroundColorAttributeName:highColor} range:NSRangeFromString(obj)];
    }];
    
    return attributedStr.copy;
}

+ (NSArray *)getAllAtRangeWith:(NSString *)originString{
    //保存有效的range的数组
    __block NSMutableArray *rangeArr = [NSMutableArray array];
    
    //保存所有的range的数组
    __block NSMutableArray *allRangeArr = [NSMutableArray array];
    
    //用于每次都判断的字符串
    __block NSString *subString = originString;
    
    //用于每次修改的range
    __block NSRange subRange = NSMakeRange(0, 0);
    
    //数组的大小就是包含了多少个
    NSArray *separateArr = [originString componentsSeparatedByString:@" "];
    
    //循环找出range
    [separateArr enumerateObjectsUsingBlock:^(NSString *detailStr, NSUInteger idx, BOOL * _Nonnull stop) {
        subRange = [detailStr rangeOfString:@"@" options:NSBackwardsSearch];
        
        NSRange lastRange = NSRangeFromString([allRangeArr lastObject]);
        if(subRange.location != NSNotFound) {
            //取出最新的一个range

            if (lastRange.location == NSNotFound) {
                lastRange = NSMakeRange(0, 0);
            }
            
            //将转换的range添加到数组
            NSRange strRange = NSMakeRange(lastRange.location + lastRange.length + subRange.location, (detailStr.length - subRange.location )+ 1);
            [rangeArr addObject:NSStringFromRange(strRange)];
            [allRangeArr addObject:NSStringFromRange(strRange)];
        }else{
            NSRange strRange = NSMakeRange(lastRange.location + lastRange.length + subRange.location, (detailStr.length - subRange.location )+ 1);
            [allRangeArr addObject:NSStringFromRange(strRange)];
        }
        
        //取出下一次需要判断的string
        NSInteger startLocation = subRange.location + detailStr.length + 1;
        
        if (startLocation < subString.length) {
            subString = [subString substringWithRange:NSMakeRange(startLocation, subString.length - startLocation)];
        }
    }];
    
    return rangeArr.copy;
}

- (void)markText:(NSString *)t withColor:(UIColor *)c lineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment
{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    // 行间距
    if(lineSpace > 0){
        
        [paragraphStyle setLineSpacing:lineSpace];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    //关键字
    if (t) {
        NSRange itemRange = [self.text rangeOfString:t];
        
       [attributedString addAttribute:NSFontAttributeName value:self.font range:itemRange];
        
        if (c) {
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:c range:itemRange];
            
        }
    }

    self.attributedText = attributedString;
}

//传入改变颜色的范围
- (NSMutableAttributedString *)markColor:(UIColor *)c pattern:(NSString *)pattern {
    
    if ([NSString isEmpty:self.text]) {
        
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    NSArray *ranges = [NSString getSubStrRangeArrWithStr:self.text pattern:[NSString toppattern]];
    
    for (NSTextCheckingResult *result in ranges) {
        
        if (result.range.location != NSNotFound) {
            
            if (self.font) {
                
               [attributedString addAttribute:NSFontAttributeName value:self.font range:result.range];
            }
            
            if (c) {
                
              [attributedString addAttribute:NSForegroundColorAttributeName value:c range:result.range];
            }
            
        }
        
    }
    
    self.attributedText = attributedString;
        
    return attributedString;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (CGFloat)getHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attributedText;
    CGFloat height = [label.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    return height;
}

- (void)setTopAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight {
    
    CGRect frame = self.frame;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, maxHeight)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.frame = frame;
    self.text = text;
    
}

- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i<= newLinesToPad; i++)
    {
        self.text = [self.text stringByAppendingString:@" \n"];
    }
}

@end
