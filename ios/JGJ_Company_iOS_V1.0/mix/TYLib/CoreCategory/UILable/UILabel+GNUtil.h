//
//  UILabel+MEExtention.h
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MEExtention)
- (CGSize)contentSizeFixWithSize:(CGSize)size;
- (CGSize)contentSizeFixWithWidth:(CGFloat)width;
- (CGSize)contentSizeFixWithHeight:(CGFloat)height;

-(void)setAttributedStringText:(NSString *)text lineSapcing:(CGFloat)lineSapcing;

- (void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing;

- (void)markText:(NSString *)text withColor:(UIColor *)c;
#pragma mark - 重复服文本加载
- (void)markMoreText:(NSString *)text withColor:(UIColor *)c;


- (void)markText:(NSString *)text withFont:(UIFont *)f color:(UIColor *)c;
- (void)markLineText:(NSString *)t withLineFont:(UIFont *)f withColor:(UIColor *)c lineSpace:(CGFloat)lineSpsace;//设置换行符的字体
-(void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing textAlign:(NSTextAlignment)textAlign;//添加对齐方式换行

/**
 *  设置Lable需要改变为color的text,传入数组
 *
 */
- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color;

/**
 *  设置Lable需要改变为color和font的text,传入数组
 *
 */
- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font;

/**
 *  设置Lable需要改变为color和font的text,传入数组，通过isGetAllText判断是否获取所有的text范围
 *
 */
- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL )isGetAllText;

- (void)markattributedTextArray:(NSArray *)textArray color:(UIColor *)color font:(UIFont *)font isGetAllText:(BOOL )isGetAllText withLineSpacing:(CGFloat)lineSpacing;

/**
 *  获取说有的@范围
 *
 */
+ (NSArray *)getAllAtRangeWith:(NSString *)originString;

/**
 *  设置文本的选中的颜色
 *  originString:原来的文字
 *  normalColor:一般文字颜色
 *  highColor:需要显示的颜色
 *  font:字体大小
 */
+ (NSAttributedString *)markAtTextArray:(NSString *)originString normalColor:(UIColor *)normalColor highColor:(UIColor *)highColor font:(UIFont *)font;

/**
 *  变颜色，行间距
 *
 */
- (void)markText:(NSString *)t withColor:(UIColor *)c lineSpace:(CGFloat)lineSpace alignment:(NSTextAlignment)alignment;

/**
 *  传入改变颜色的范围
 */
- (NSMutableAttributedString *)markColor:(UIColor *)c pattern:(NSString *)pattern;
@end
