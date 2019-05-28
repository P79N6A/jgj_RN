//
//  JLGDashedLine.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLGDashedLine : NSObject

/**
 *  画水平虚线
 *
 *  @param view      需要加线的view
 *  @param startPoit 起点
 *  @param witdh     线的宽度ll
 *  @param lengthPattern 间隔
 *  @param lineColor     线颜色
 */
+ (void)drashHorizontalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byWith:(CGFloat )witdh lengthPattern:(NSArray *)lengthPattern lineColor:(UIColor *)lineColor;
/**
 *  画水平的虚线
 *
 *  @param view      需要加线的view
 *  @param startPoit 起点
 *  @param witdh     线的宽度ll
 */
+ (void)drashHorizontalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byWith:(CGFloat )witdh;

/**
 *  画垂直的虚线
 *
 *  @param view      需要加线的view
 *  @param startPoit 起点
 *  @param witdh     线的高度
 */
+ (void)drashVerticalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byHeight:(CGFloat )height;

/**
 *  画垂直的虚线
 *
 *  @param view      需要加线的view
 *  @param startPoit 起点
 *  @param witdh     线的高度
 *  @param color     颜色
 */
+ (void)drashVerticalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byHeight:(CGFloat )height
                        byColor:(UIColor *)color;
@end
