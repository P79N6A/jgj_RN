//
//  CAShapeLayer+Cycle.m
//  mix
//
//  Created by Tony on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "CAShapeLayer+Cycle.h"

@implementation CAShapeLayer (Cycle)

+ (CAShapeLayer *)drawCycleProgressByView:(UIView *)cycleView byProgress:(CGFloat )progress strokeColor:(UIColor *)strokeColor cycleWidth:(CGFloat )cycleWidth margin:(CGFloat )margin
{
    return [self drawCycleProgressByFrame:cycleView byProgress:100 fillColor:[UIColor clearColor] strokeColor:strokeColor opacity:1 cycleWidth:cycleWidth margin:margin];
}

+ (CAShapeLayer *)drawCycleProgressByView:(UIView *)cycleView byProgress:(CGFloat )progress strokeColor:(UIColor *)strokeColor cycleWidth:(CGFloat )cycleWidth
{
    return [self drawCycleProgressByFrame:cycleView byProgress:100 fillColor:[UIColor clearColor] strokeColor:strokeColor opacity:1 cycleWidth:cycleWidth];
}

+ (CAShapeLayer *)drawCycleProgressByFrame:(UIView *)cycleView byProgress:(CGFloat )progress fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor opacity:(CGFloat )opacity cycleWidth:(CGFloat )cycleWidth{
    return [self drawCycleProgressByFrame:cycleView byProgress:progress fillColor:fillColor strokeColor:strokeColor opacity:opacity cycleWidth:cycleWidth margin:0];
}


+ (CAShapeLayer *)drawCycleProgressByFrame:(UIView *)cycleView byProgress:(CGFloat )progress fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor opacity:(CGFloat )opacity cycleWidth:(CGFloat )cycleWidth margin:(CGFloat )margin
{
    CGPoint center = CGPointMake(cycleView.bounds.size.width/2, cycleView.bounds.size.height/2);//cycleView.center;
    CGFloat radius = (cycleView.frame.size.width + cycleWidth)/2 + margin;//半径
    CGFloat startA = - M_PI_2;  //设置进度条起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * progress;  //设置进度条终点位置
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    CAShapeLayer *progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    progressLayer.frame = cycleView.bounds;
    progressLayer.fillColor = [fillColor CGColor];  //填充色为无色
    progressLayer.strokeColor = [strokeColor CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    progressLayer.opacity = opacity; //背景颜色的透明度
    progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    progressLayer.lineWidth = cycleWidth;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    return progressLayer;
}

@end
