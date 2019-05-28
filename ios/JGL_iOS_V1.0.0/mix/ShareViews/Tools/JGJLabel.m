//
//  JGJLabel.m
//  mix
//
//  Created by Tony on 16/4/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJLabel.h"
#import "TYFMDB.h"
#import "YYText.h"

//#define LabelDebug YES//是否测试最多字的情况
static const CGFloat JGJLabelNormalMargin = 14.0;//正常的间距
static const CGFloat JGJLabelSmallFontFloat = 12.0;//小点的字号
static const CGFloat JGJLabelNormalFontFloat = 14.0;//正常的字号

#define JGJLabelLineBreakFontFloat  8.0//换行符的字号

//富文本算出的需要添加的多余的margin
#define JGJAttStrMoreMargin 2*JGJLabelNormalMargin

//人数对齐的最大数
#define JGJLabelPersonCountMaxFontCount  ((IS_IPHONE_4_OR_LESS||IS_IPHONE_5)?38:41)*GetUIScreenWidthRatio

//这里计算高度的,富文本的字号
#define JGJLabelAttributedHeightFont (JGJLabelNormalFontFloat - JGJLabelLineBreakFontFloat/3)

@implementation JGJLabelModel
@end

@implementation JGJLabel
- (void)_initLabel
{
    [super _initLabel];
    self.numberOfLines = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.textContainerInset = UIEdgeInsetsMake(0, JGJLabelNormalMargin, 0, JGJLabelNormalMargin);
}

#pragma mark -获取的富文本和高度的Model
+ (JGJLabelModel *)getModel:(JLGFindProjectModel *)proModel maxWith:(CGFloat )maxWith{
    
    NSAttributedString *attributedStr = [self getModelAttributeString:proModel];
    
    CGSize attributeStrSize = CGSizeMake(maxWith - 2*JGJLabelNormalMargin,CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    //因为获取的富文本换行符的大小比JGJLabelNormalFontFloat大
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:JGJLabelAttributedHeightFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize maxStrSize = [[attributedStr string] boundingRectWithSize:attributeStrSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    JGJLabelModel *jgjLabelModel = [[JGJLabelModel alloc] init];
    jgjLabelModel.strViewH = maxStrSize.height + JGJAttStrMoreMargin;
    jgjLabelModel.attributedStr = attributedStr;
    return jgjLabelModel;
}

#pragma mark -获取的富文本的高度
+ (CGFloat )getModelStrHeight:(JLGFindProjectModel *)proModel maxWith:(CGFloat )maxWith{

    NSAttributedString *attributedStr = [self getModelAttributeString:proModel];
    
    CGSize attributeStrSize = CGSizeMake(maxWith - 2*JGJLabelNormalMargin,CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    //因为获取的富文本换行符的大小比JGJLabelNormalFontFloat大
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:JGJLabelAttributedHeightFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize maxStrSize = [[attributedStr string] boundingRectWithSize:attributeStrSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return maxStrSize.height + JGJAttStrMoreMargin;
}

#pragma mark - 设置工种的富文本
+ (NSAttributedString *)getModelAttributeString:(JLGFindProjectModel *)findProModel{
    __block NSMutableAttributedString *attributedString = [NSMutableAttributedString new];

    NSArray *classesArray = findProModel.classes;

    [classesArray enumerateObjectsUsingBlock:^(Classes *obj, NSUInteger idx, BOOL *stop) {
        if (obj.cooperate_type.code != 3) {
            //包工,点工
            [attributedString appendAttributedString:[self getCooperate:[NSString stringWithFormat:@" %@ ",obj.cooperate_type.name] cooperateCode:obj.cooperate_type.code]];
            [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:2 fontSize:JGJLabelSmallFontFloat]];

            //学徒工,熟练工..
            [attributedString appendAttributedString:[self getWorklevel:[NSString stringWithFormat:@" %@ ",obj.worklevel.name?:@"学徒工"]]];
            [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:1 fontSize:JGJLabelNormalFontFloat]];
            
#ifdef LabelDebug
            obj.worktype.name = @"测试的工种";
#endif
            //工种...
            [attributedString appendAttributedString:[self getWorktype:[self getNoPlaceholderRightStr:obj.worktype.name MaxLength:5]]];

            //补全空白字符串，主要是为了对齐
            [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:[self placeholderMax:[attributedString string] length:JGJLabelPersonCountMaxFontCount] fontSize:JGJLabelNormalFontFloat]];

#ifdef LabelDebug
            obj.person_count = 444;
#endif
            //人数...
            [attributedString appendAttributedString:[self getRersonCount:[self getNoPlaceholderLeftStr:[NSString stringWithFormat:@"%@",@(obj.person_count)] MaxLength:3] unitStr:@"人"]];
            [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:2 fontSize:JGJLabelNormalFontFloat]];
#ifdef LabelDebug
            obj.money = [NSString stringWithFormat:@"44444"];
#endif
            //单位
            NSString *balanceMoney;
            if ([obj.money isEqualToString:@"面议"]) {//如果是面议，不需要添加后面单位
                balanceMoney = obj.money;
            }else{
                balanceMoney = [NSString stringWithFormat:@"%@元/%@",[self getNoPlaceholderLeftStr:obj.money MaxLength:5],[obj.balanceway isEqualToString:@""]?@"天":obj.balanceway];
            }

            [attributedString appendAttributedString:[self getBalanceMoney:[self getNoPlaceholderLeftStr:obj.money MaxLength:5] balanceway:balanceMoney]];
            
            //换行
            if (classesArray.count - 1 != idx) {
                [attributedString appendAttributedString:[self paddingStr:@"\n\n" lengthStr:1 fontSize:JGJLabelLineBreakFontFloat]];
            }
        }else{//总包
            attributedString = [self getTotalBy:obj.cooperate_type.name money:obj.money];
            *stop = YES;
        }
    }];

    return [attributedString copy];
}

+(NSMutableAttributedString *)getCooperate:(NSString *)cooperateString cooperateCode:(NSInteger )cooperatecode{//点工:0xeb7a4e 包工:0xeb4e4e
    NSMutableAttributedString *attributedString = [self getAttStr:cooperateString fillColor:cooperatecode == 1?ColorHex(0xeb7a4e):ColorHex(0xeb4e4e)];

    return [attributedString copy];
}

+(NSMutableAttributedString *)getAttStr:(NSString *)attStr fillColor:(UIColor *)fillColor{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:attStr];
    attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelSmallFontFloat];
    attributedString.yy_color = [UIColor whiteColor];
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 2;
    border.strokeWidth = 0.5;
    border.strokeColor = attributedString.yy_backgroundColor;
    border.lineStyle = YYTextLineStyleSingle;
    border.fillColor = fillColor;
    attributedString.yy_textBackgroundBorder = border;
    
    return [attributedString copy];
}

+(NSMutableAttributedString *)getWorklevel:(NSString *)worklevel{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:worklevel];
    attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelSmallFontFloat];
    attributedString.yy_color = AppFont999999Color;
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 2;
    border.strokeWidth = 0.5;
    border.strokeColor = attributedString.yy_color;
    border.lineStyle = YYTextLineStyleSingle;
    attributedString.yy_textBackgroundBorder = border;
    
    return [attributedString copy];
}

+(NSMutableAttributedString *)getWorktype:(NSString *)worktype{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:worktype];
    attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelNormalFontFloat];
    attributedString.yy_color = AppFont333333Color;
    return [attributedString copy];
}

+(NSMutableAttributedString *)getRersonCount:(NSString *)personCount unitStr:(NSString *)unitStr{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",personCount,unitStr]];
    attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelNormalFontFloat];
    attributedString.yy_alignment = NSTextAlignmentRight;
    [attributedString yy_setColor:AppFont333333Color range:NSMakeRange(0, personCount.length)];
    
    NSRange unitRange = NSMakeRange(personCount.length,unitStr.length);
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:JGJLabelSmallFontFloat] range:unitRange];
    [attributedString yy_setColor:AppFont999999Color range:unitRange];
    return [attributedString copy];
}

+(NSMutableAttributedString *)getBalanceMoney:(NSString *)money balanceway:(NSString *)balanceway{
    NSMutableAttributedString *attributedString;
    if ([balanceway isEqualToString:@"面议"]) {//面议的情况
        attributedString = [[NSMutableAttributedString alloc] initWithString:money];
        attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelNormalFontFloat];
        attributedString.yy_alignment = NSTextAlignmentRight;
        [attributedString yy_setColor:JGJMainColor range:NSMakeRange(0, money.length)];
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithString:balanceway];
        attributedString.yy_font = [UIFont systemFontOfSize:JGJLabelNormalFontFloat];
        attributedString.yy_alignment = NSTextAlignmentRight;
        [attributedString yy_setColor:JGJMainColor range:NSMakeRange(0, money.length)];
        
        NSRange unitRange = NSMakeRange(money.length,balanceway.length - money.length);
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:JGJLabelSmallFontFloat] range:unitRange];
        [attributedString yy_setColor:AppFont999999Color range:unitRange];
    }

    return [attributedString copy];
}

#pragma mark - 总包的富文本
+(NSMutableAttributedString *)getTotalBy:(NSString *)cooperateName money:(NSString *)money{
    NSString *balanceway = [NSString string];
    if (![money isEqualToString:@"面议"]) {
        balanceway = @"元";
    }
    balanceway = [NSString stringWithFormat:@"%@ %@",money,balanceway];
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    
    //总包标题
    [attributedString appendAttributedString:[self getAttStr:[NSString stringWithFormat:@" %@ ",cooperateName] fillColor:ColorHex(0xebaa4e)]];
    [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:13*GetUIScreenWidthRatio fontSize:JGJLabelSmallFontFloat]];

    //总包名字
    [attributedString appendAttributedString:[self getWorktype:cooperateName]];
    //补全空白字符串，主要是为了对齐
    NSInteger subFontCount = (JGJLabelPersonCountMaxFontCount - [[attributedString string] lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    [attributedString appendAttributedString:[self paddingStr:@" " lengthStr:subFontCount+13 fontSize:JGJLabelAttributedHeightFont]];
    
    //单位
    [attributedString appendAttributedString:[self getBalanceMoney:money balanceway:balanceway]];

    return attributedString;
}


/**
 *  填充的空白字符
 *
 *  @param paddingStr 需要填充的字符串
 *  @param lengthStr  需要填充的长度
 *  @param fontSize   需要填充的字符串的字体大小
 *
 *  @return 返回对应的富文本
 */
+ (NSMutableAttributedString *)paddingStr:(NSString *)paddingStr lengthStr:(NSInteger )lengthStr fontSize:(CGFloat)fontSize{
    NSString *paddingString = [NSString string];
    if (lengthStr > 0) {
        for (NSInteger index = 0; index < lengthStr; index++) {
            paddingString = [paddingString stringByAppendingString:paddingStr];
        }
    }

    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:paddingString];
    pad.yy_font = [UIFont systemFontOfSize:fontSize];

    return pad;
}


/**
 *  获取已有的数据长度
 *
 *  @param attributedStr 传入的字符串
 *  @param length        length
 *
 *  @return 返回占位的长度
 */
+ (NSInteger )placeholderMax:(NSString *)placeholderStr length:(NSInteger )length{
    __block NSMutableArray *stringArray = @[].mutableCopy;
    //补全空白字符串，主要是为了对齐
    stringArray = [[placeholderStr componentsSeparatedByString:@"\n"] mutableCopy];
    NSString *lastString = (NSString *)[stringArray lastObject];
    NSInteger subFontCount = (length - [lastString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    return subFontCount;
}


+(NSString *)getPlaceholderLeftStr:(NSString *)str MaxLength:(NSInteger )maxLength{
    return [self getStr:str MaxLength:maxLength addPlaceholder:YES left:YES];
}

+(NSString *)getNoPlaceholderLeftStr:(NSString *)str MaxLength:(NSInteger )maxLength{
    return [self getStr:str MaxLength:maxLength addPlaceholder:NO left:YES];
}

+(NSString *)getPlaceholderRightStr:(NSString *)str MaxLength:(NSInteger )maxLength{
    return [self getStr:str MaxLength:maxLength addPlaceholder:YES left:NO];
}

+(NSString *)getNoPlaceholderRightStr:(NSString *)str MaxLength:(NSInteger )maxLength{
    return [self getStr:str MaxLength:maxLength addPlaceholder:NO left:NO];
}

/**
 *  获取对应的的字符串
 *
 *  @param str       传入的字符串
 *  @param maxLength 最大的长度
 *  @param addPlaceholderBool 是否增加占位符@"..."
 *  @return 超过最大长度，就返回xxx...
 */
+(NSString *)getStr:(NSString *)str MaxLength:(NSInteger )maxLength addPlaceholder:(BOOL)addPlaceholderBool left:(BOOL )leftBool{
    NSString *maxStr = [NSString string];
    if (addPlaceholderBool && str.length >= maxLength) {//如果相等并且超过了，并且可以剪切
        maxStr = [NSString stringWithFormat:@"%@...",[str substringWithRange:NSMakeRange(0, maxLength - 1)]];
    }else if(str.length >= maxLength){//如果相等并且超过了，不能剪切就用原来的
        maxStr = str;
    }else{
        NSString *placeholderStr = [NSString string];
        for (NSInteger index = 0; index < maxLength - str.length; index ++) {
            placeholderStr = [placeholderStr stringByAppendingString:@"  "];
        }
        
        if (leftBool) {
            maxStr = [placeholderStr stringByAppendingString:str];
        }else{
            maxStr = [str stringByAppendingString:placeholderStr];
        }
    }
    return maxStr;
}
@end
