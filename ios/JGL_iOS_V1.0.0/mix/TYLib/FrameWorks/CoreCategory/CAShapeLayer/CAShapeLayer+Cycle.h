//
//  CAShapeLayer+Cycle.h
//  mix
//
//  Created by Tony on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (Cycle)

/**
 *  根据progress的值画空心圆,100就是整圆,50就是半圆
 *
 *  @param cycleView   需要添加圆的view
 *  @param progress    画圆的值
 *  @param strokeColor 圆的颜色
 *  @param cycleWidth  圆的宽度
 *
 *  @return 用于cycleView addlayer
 */
+ (CAShapeLayer *)drawCycleProgressByView:(UIView *)cycleView byProgress:(CGFloat )progress strokeColor:(UIColor *)strokeColor cycleWidth:(CGFloat )cycleWidth;

/**
 *  根据progress的值画空心圆,100就是整圆,50就是半圆
 *
 *  @param cycleView   需要添加圆的view
 *  @param progress    画圆的值
 *  @param strokeColor 圆的颜色
 *  @param cycleWidth  圆的宽度
 *  @param margin  距离边缘的距离
 *  @return 用于cycleView addlayer
 */
+ (CAShapeLayer *)drawCycleProgressByView:(UIView *)cycleView byProgress:(CGFloat )progress strokeColor:(UIColor *)strokeColor cycleWidth:(CGFloat )cycleWidth margin:(CGFloat )margin;
@end
