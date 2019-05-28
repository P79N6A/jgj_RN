//
//  NSString+AttributedStr.h
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedStr)

/**
 *  增加下划线
 */
- (NSMutableAttributedString *)addUnderline;

/**
 *  添加颜色
 *
 *  @param color 颜色
 */
- (NSMutableAttributedString *)addColor:(UIColor *)color;

/**
 *  添加颜色
 *
 *  @param color    颜色
 *  @param strRange 范围
 */
- (NSMutableAttributedString *)addColor:(UIColor *)color withRange:(NSRange )strRange;
@end
