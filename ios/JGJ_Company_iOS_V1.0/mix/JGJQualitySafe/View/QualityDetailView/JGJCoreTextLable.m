//
//  JGJCoreTextLable.m
//  mix
//
//  Created by YJ on 2017/10/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCoreTextLable.h"

#import "JGJQuaSafeTool.h"

#import "JGJCoreTextLable+Category.h"

@implementation JGJCoreTextModel


@end

@interface JGJCoreTextLable ()

@property (nonatomic, strong) YYTextLinePositionSimpleModifier *contentMod;

@end

@implementation JGJCoreTextLable

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (!self.textColor) {
        
        self.textColor = AppFont333333Color;
    }
    
    self.userInteractionEnabled = YES;
    
    self.numberOfLines = 0;
    
    YYTextLinePositionSimpleModifier *contentMod = [YYTextLinePositionSimpleModifier new];
    
    self.contentMod = contentMod;
    
    contentMod.fixedLineHeight = self.font.pointSize;
    
    self.linePositionModifier = contentMod;
    
    TYWeakSelf(self);
    
    self.copyActionBlock = ^{
        
        if (weakself.copyBlock) {
            
            weakself.copyBlock();
        }
    };
}



- (void)setContentTextlinkAttCoreTextModel:(JGJCoreTextModel *)coreTextModel contentText:(NSString *)contentText {
    
    UIColor *contentColor = coreTextModel.contentColor?:AppFont333333Color;
    
    UIColor *changeColor = coreTextModel.changeColor?:AppFont4990e2Color;
    
    UIFont *contentFont = coreTextModel.contentFont?: [UIFont systemFontOfSize:AppFont30Size];
    
    if (!coreTextModel) {
        
        contentColor = AppFont333333Color;
        
        changeColor =  AppFont4990e2Color;
        
        contentFont = [UIFont systemFontOfSize:AppFont30Size];
    }
    
    // 转成可变属性字符串
    NSMutableAttributedString * mAttributedString = [NSMutableAttributedString new];
    
    // 调整行间距段落间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //    [paragraphStyle setLineSpacing:2];
    //    [paragraphStyle setParagraphSpacing:4];
    
    // 设置文本属性
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[contentFont, contentColor, paragraphStyle] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName]];
    
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:contentText?:@"" attributes:attri]];
    
    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    mAttributedString.yy_font = [UIFont systemFontOfSize:AppFont30Size];
    
    mAttributedString.yy_lineSpacing = self.lineSpace;
    
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
            one.yy_font = contentFont;
            one.yy_underlineStyle = NSUnderlineStyleSingle;
            one.yy_color = contentColor;
            
            [one yy_setTextHighlightRange:one.yy_rangeOfAll color:changeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                NSString *linkUrl = [self subContentLinkUrl:text.string linkRange:range];
                
                [JGJQuaSafeTool linkHandlerWithLinkUrl:linkUrl curView:self target:nil];
                
                TYLog(@"======= %@", text);
            }];
            
            // 根据range替换字符串
            [mAttributedString replaceCharactersInRange:match.range withAttributedString:one];
        }
    }
    
    // 使用YYLabel显示
    
    if (![NSString isEmpty:coreTextModel.changeStr]) {
        
        NSRange range = NSMakeRange(0, coreTextModel.changeStr.length);
        
        NSString *changeColorStr = [mAttributedString.string substringWithRange:range];
        
        NSMutableAttributedString *changeStr = [[NSMutableAttributedString alloc] initWithString:changeColorStr];
        
        changeStr.yy_color = coreTextModel.changeColor;
        
        changeStr.yy_font = coreTextModel.changeStrFont;
        
        // 根据range替换字符串
        [mAttributedString replaceCharactersInRange:range withAttributedString:changeStr];
    }
    
    self.userInteractionEnabled = YES;
    
    self.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    self.attributedText = mAttributedString;
    
    //    // 利用YYTextLayout计算高度
    //    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(260, MAXFLOAT)];
    //    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text: mAttributedString];
    //    label.height = textLayout.textBoundingSize.height;
    
}

- (NSString *)subContentLinkUrl:(NSString *)linkUrl linkRange:(NSRange)linkRange {
    
    NSString *url = @"";
    
    if (![NSString isEmpty:linkUrl]) {
        
        url = [linkUrl substringWithRange:linkRange];
    }
    
    return url;
    
}

- (void)setIsCanCopy:(BOOL)isCanCopy {
    
    _isCanCopy = isCanCopy;
    
    if (_isCanCopy) {
        
        [self canCopy];
    }
    
}

/**
 *传入宽度内容字体获得高度
 */
- (CGFloat)stringWithContentWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace changeStr:(NSString *)changeStr changeColor:(UIColor *)changeColor;
{
    NSMutableAttributedString *introText = self.attributedText.mutableCopy;
    
    introText.yy_font = [UIFont systemFontOfSize:AppFont30Size];
    
    introText.yy_lineSpacing = lineSpace;
    
    //    introText.yy_color = AppFont333333Color;
    
    
    if (![NSString isEmpty:changeStr]) {
        
        NSRange range = [changeStr rangeOfString:changeStr];
        
        [introText yy_setColor:changeColor range:range];
    }
    
    self.attributedText = introText;
    
    CGSize introSize = CGSizeMake(width, CGFLOAT_MAX);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    
    self.textLayout = layout;
    
    CGFloat introHeight = layout.textBoundingSize.height;
    
    return introHeight;
}

@end

