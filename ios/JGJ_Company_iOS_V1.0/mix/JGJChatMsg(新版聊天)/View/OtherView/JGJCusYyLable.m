//
//  JGJCusYyLable.m
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusYyLable.h"

#import "YYText.h"

#import "JGJQuaSafeTool.h"

@implementation JGJCusYyLable

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.displaysAsynchronously = YES;
    
}

- (void)tapLinkActionWithHighlight:(YYTextHighlight *)highlight tapLinkUrlRange:(NSRange)highlightRange  {
    
    if (highlight.tapAction && ![NSString isEmpty:self.text]) {
        
        NSString *url = [self.text substringWithRange:highlightRange];
        
        if (![NSString isEmpty:url]) {
            
            NSMutableAttributedString *attriUrl = [[NSMutableAttributedString alloc] initWithString:url];
            
            highlight.tapAction(self, attriUrl, highlightRange, CGRectZero);
        }
        
    }
}

- (void)setContentTextlinkAttWithContent:(NSString *)content contentColor:(UIColor *)contentColor linespace:(CGFloat)linespace{
    
    // 转成可变属性字符串
    NSMutableAttributedString * mAttributedString = [NSMutableAttributedString new];
    
    // 调整行间距段落间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //    [paragraphStyle setLineSpacing:2];
    //    [paragraphStyle setParagraphSpacing:4];
    
    // 设置文本属性
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[self.font, contentColor, paragraphStyle] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:attri]];
    
    // 匹配条件
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSError *error = NULL;
    // 根据匹配条件，创建了一个正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!regex) {
        NSLog(@"正则创建失败error！= %@", [error localizedDescription]);
    } else {
        NSArray *allMatches = [regex matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
        for (NSTextCheckingResult *match in allMatches) {
            NSString *substrinsgForMatch2 = [mAttributedString.string substringWithRange:match.range];
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:substrinsgForMatch2];
            // 利用YYText设置一些文本属性
            one.yy_font = self.font;
            one.yy_underlineStyle = NSUnderlineStyleSingle;
            one.yy_color = AppFont4990e2Color;
            
            UIColor *changeColor = AppFont333333Color;
            
            if (![NSString isEmpty:content]) {
                
                changeColor = AppFont4990e2Color;
                
                [one yy_setTextHighlightRange:one.yy_rangeOfAll color:changeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    
                    [JGJQuaSafeTool linkHandlerWithLinkUrl:text.string curView:self target:nil];
                    
                    TYLog(@"======= %@", text);
                }];
                
                [one yy_setTextHighlightRange:one.yy_rangeOfAll color:changeColor backgroundColor:[UIColor clearColor] userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    
                    TYLog(@"======= %@", text);
                    
                } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    
                    TYLog(@"======= %@", text);
                    
                }];
                
                // 根据range替换字符串
                [mAttributedString replaceCharactersInRange:match.range withAttributedString:one];
            }
            
        }
    }
    
//    // 使用YYLabel显示
//
    self.userInteractionEnabled = YES;
    
    self.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    mAttributedString.yy_lineSpacing = linespace;
    
    self.attributedText = mAttributedString;
    
    //    // 利用YYTextLayout计算高度
    //    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(260, MAXFLOAT)];
    //    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text: mAttributedString];
    //    label.height = textLayout.textBoundingSize.height;
    
}

/**
 *传入宽度内容字体获得高度
 */
+ (CGFloat)stringWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace;
{
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:content];
    
    introText.yy_font = [UIFont systemFontOfSize:font];
    
    introText.yy_lineSpacing = lineSpace;
    
    CGSize introSize = CGSizeMake(width, CGFLOAT_MAX);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    
    CGFloat introHeight = layout.textBoundingSize.height;
    
    return introHeight;
}

/**
 *设置行间距
 */
- (void)setContent:(NSString *)content lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString isEmpty:content]?@"":content];
    
    att.yy_lineSpacing = lineSpace;
    
    att.yy_font = self.font;
    
    self.attributedText = att;
}

- (void)setYy_font:(CGFloat)yy_font yy_lineSpacing:(CGFloat)yy_lineSpacing yy_alignment:(NSTextAlignment)yy_alignment yy_underlineStyle:(NSUnderlineStyle)yy_underlineStyle underlineColor:(UIColor *)underlineColor {
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text?:@""];
    
    att.yy_font = [UIFont systemFontOfSize:yy_font];
    
    att.yy_underlineStyle = NSUnderlineStyleSingle | NSUnderlinePatternDot;
    
    att.yy_underlineColor = underlineColor;
    
    att.yy_lineSpacing = yy_lineSpacing;
    
    att.yy_alignment = NSTextAlignmentLeft;
    
    self.attributedText = att;
}

- (void)setUnderlineContent:(NSString *)content font:(CGFloat)font color:(UIColor *)color lineStyle:(NSUnderlineStyle)lineStyle tapHighlightBlock:(TapHighlightBlock)tapHighlightBlock {
    
    if ([NSString isEmpty:content] || [NSString isEmpty:self.text]) {
        
        return;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.text]?:@""];
    
    text.yy_color = self.textColor;
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:content?:@""];
    
    one.yy_font = [UIFont boldSystemFontOfSize:font];
    
    one.yy_underlineStyle = lineStyle;
    
    one.yy_color = color;
    
    [one appendAttributedString:text];
    
    self.attributedText = one;
    
    self.tapHighlightBlock = tapHighlightBlock;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.tapHighlightBlock) {
        
        self.tapHighlightBlock();
    }
}


- (void)changeTextColorInTextContentWithTextArray:(NSArray *)changeTextArr textColor:(UIColor *)color {
    
    if (self.text.length == 0 || self.text == nil) {
        return;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [self.text length])];
    [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [self.text length])];
    for (int i = 0;i < changeTextArr.count; i ++) {
        NSString *text = changeTextArr[i];
        if (text.length == 0 || text == nil) {
            return;
        }
        NSRange range = [self.text rangeOfString:text];
        [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        
    }
    self.attributedText = str;
}


@end
