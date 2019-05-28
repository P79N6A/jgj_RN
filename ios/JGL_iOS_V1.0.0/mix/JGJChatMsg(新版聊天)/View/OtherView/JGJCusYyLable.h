//
//  JGJCusYyLable.h
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "YYLabel.h"

typedef void(^TapHighlightBlock)();

@interface JGJCusYyLable : YYLabel

@property (nonatomic, copy) TapHighlightBlock tapHighlightBlock;

/**
 *聊天使用3.4添加
 */
- (void)setContentTextlinkAttWithContent:(NSString *)content contentColor:(UIColor *)contentColor linespace:(CGFloat)linespace;

/**
 *传入宽度内容字体获得高度
 */
+ (CGFloat)stringWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace;

/**
 *设置行间距
 */
- (void)setContent:(NSString *)content lineSpace:(CGFloat)lineSpace;

/**
 *设置变颜色的字体
 */
- (void)setUnderlineContent:(NSString *)content font:(CGFloat)font color:(UIColor *)color lineStyle:(NSUnderlineStyle)lineStyle tapHighlightBlock:(TapHighlightBlock)tapHighlightBlock;

/**
 *单独改变内容中某个文字的颜色
 **/
- (void)changeTextColorInTextContentWithTextArray:(NSArray *)changeTextArr textColor:(UIColor *)color;
@end
