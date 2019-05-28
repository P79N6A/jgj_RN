//
//  UIView+Extend.m
//  wucai
//
//  Created by muxi on 14/10/26.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "UIView+Extend.h"





@implementation UIView (Extend)



/**
 *  添加边框：注给scrollView添加会出错
 *
 *  @param direct 方向
 *  @param color  颜色
 *  @param width  线宽
 */
-(void)addSingleBorder:(UIViewBorderDirect)direct color:(UIColor *)color width:(CGFloat)width{
    
    UIView *line=[[UIView alloc] init];
    
    //设置颜色
    line.backgroundColor=color;
    
    //添加
    [self addSubview:line];
    
    //禁用ar
    line.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSDictionary *views=NSDictionaryOfVariableBindings(line);
    NSDictionary *metrics=@{@"w":@(width),@"y":@(self.height - width),@"x":@(self.width - width)};
    
    
    NSString *vfl_H=@"";
    NSString *vfl_W=@"";
    
    //上
    if(UIViewBorderDirectTop==direct){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:|-0-[line(==w)]";
    }
    
    //左
    if(UIViewBorderDirectLeft==direct){
        vfl_H=@"H:|-0-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }
    
    //下
    if(UIViewBorderDirectBottom==direct){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:[line(==w)]-0-|";
    }
    
    //右
    if(UIViewBorderDirectRight==direct){
        vfl_H=@"H:|-x-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }

    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_W options:0 metrics:metrics views:views]];
}



/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB{
    
    NSString *name = NSStringFromClass(self);
    
    UIView *xibView=[[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
    
    if(xibView == nil){
        TYLog(@"CoreXibView：从xib创建视图失败，当前类是：%@",name);
    }
    
    return xibView;
}




- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}



#pragma mark  添加一组子view：
-(void)addSubviewsWithArray:(NSArray *)subViews{
    
    for (UIView *view in subViews) {
        
        [self addSubview:view];
        
    }
}



#pragma mark  圆角处理
-(void)setRadius:(CGFloat)r{
    
    if(r<=0) r=self.frame.size.width * .5f;
    
    //圆角半径
    self.layer.cornerRadius=r;
    
    //强制
    self.layer.masksToBounds=YES;
}

-(CGFloat)radius{
    return 0;
}

/**
 *  添加底部的边线
 */
-(void)setBottomBorderColor:(UIColor *)bottomBorderColor{
    
}




-(UIColor *)bottomBorderColor{
    return nil;
}

/**
 *  添加边框
 */
-(void)setBorder:(UIColor *)color width:(CGFloat)width{
    CALayer *layer=self.layer;
    layer.borderColor=color.CGColor;
    layer.borderWidth=width;
}




/**
 *  调试
 */
-(void)debug:(UIColor *)color width:(CGFloat)width{
    
    [self setBorder:color width:width];
}

/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
    });
}



- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

+ (NSMutableAttributedString *)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL)isGetAllText textField:(UITextField *)txtField {
    
    if (txtField.text.length == 0 || txtField.text == nil) {
        
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:txtField.text];
    for (int i = 0;i < textArray.count; i ++) {
        NSString *text = textArray[i];
        if (text.length == 0 || text == nil) {
            return nil;
        }
        
        if (isGetAllText) {//获取所有的range
            
            NSArray *rangeArr = [self getAllRangeWith:txtField.text keyString:text];
            
            str = [self setAttributedText:str rangeArr:rangeArr text:text color:color font:font];
        }else{//只判断第一个range
            
            NSRange range = [txtField.text rangeOfString:text];
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
    }
//    txtField.attributedText = str;

    return str;
}


#pragma mark 根据rangeArr 设置对应的颜色和字体
+ (NSMutableAttributedString *)setAttributedText:(NSMutableAttributedString *)attrStr rangeArr:(NSArray *)rangeArr text:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    
    [rangeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(obj);
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attrStr addAttribute:NSFontAttributeName value:font range:range];
    }];
    
    return attrStr;
}

#pragma mark - 获取originString里面所有keyString的range
+ (NSArray *)getAllRangeWith:(NSString *)originString keyString:(NSString *)keyString{
    //保存range的数组
    __block NSMutableArray *rangeArr = [NSMutableArray array];
    
    //用于每次都判断的字符串
    __block NSString *subString = originString;
    
    //用于每次修改的range
    __block NSRange subRange = NSMakeRange(0, 0);
    
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





@end
