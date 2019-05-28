//
//  CAShapeLayer+ViewMask.h
//  TYSamples
//
//  Created by Tony on 2016/9/20.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/*
 调用方法
 CAShapeLayer *layer = [CAShapeLayer createMaskLayerWithView:view];
 view.layer.mask = layer;
 */

@interface CAShapeLayer (ViewMask)

/*
 * 增加一个左边的聊天遮盖
 */
+ (instancetype)createLeftMaskLayerWithView : (UIView *)view;

/*
 * 增加一个左边的有圆角的聊天遮盖
 */
+ (instancetype)createLeftMaskLayerWithView : (UIView *)view cornerRadius:(CGFloat )cornerRadius;

/*
 * 增加一个左边的聊天遮盖
 * edgeSpage:尖角边距
 * topSpace:尖角和上面的距离
 */
+ (instancetype)createLeftMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace;

/*
 * 增加一个左边的聊天遮盖
 * edgeSpage:尖角边距
 * topSpace:尖角和上面的距离
 * cornerRadius:圆角
 */
+ (instancetype)createLeftMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace cornerRadius:(CGFloat )cornerRadius;

/*
 * 增加一个右边的聊天遮盖
 */
+ (instancetype)createRightMaskLayerWithView : (UIView *)view;

/*
 * 增加一个右边的有圆角的聊天遮盖
 */
+ (instancetype)createRightMaskLayerWithView : (UIView *)view cornerRadius:(CGFloat )cornerRadius;

/*
 * 增加一个右边的聊天遮盖
 * edgeSpage:尖角边距
 * topSpace:尖角和上面的距离
 */
+ (instancetype)createRightMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace;

/*
 * 增加一个右边的聊天遮盖
 * edgeSpage:尖角边距
 * topSpace:尖角和上面的距离
 * cornerRadius:圆角
 */
+ (instancetype)createRightMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace cornerRadius:(CGFloat )cornerRadius;

/*
 * 传入image和最大能够的size,返回一个合适的size
 */
+ (CGSize )getFitImageSize:(UIImage *)image maxImageSize:(CGSize )maxImageSize;
@end
