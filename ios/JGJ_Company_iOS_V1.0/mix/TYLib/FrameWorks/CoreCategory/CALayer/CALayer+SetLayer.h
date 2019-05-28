//
//  CALayer+SetLayer.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@interface CALayer (SetLayer)

/**
 *  通过比例设置圆角
 *
 *  @param ration 圆角的比例
 */
- (void)setLayerCornerRadiusWithRatio:(CGFloat )ration;

/*
 *  设置圆角
 */
- (void)setLayerCornerRadius:(CGFloat )radius;

/**
 *  通过比例设置边框圆角
 *
 *  @param color  颜色
 *  @param width  线宽
 *  @param radius 圆角
 */
- (void)setLayerBorderWithColor:(UIColor *)color width:(CGFloat )width ration:(CGFloat )ration;

/*
 *  设置边框圆角和颜色
 */
- (void)setLayerBorderWithColor:(UIColor *)color width:(CGFloat )width radius:(CGFloat )radius;

/*
 *  设置阴影
 */
- (void)setLayerShadowWithColor:(UIColor *)color offset:(CGSize )cgoffset opacity:(float )opaticy radius:(CGFloat )radius;


@end
