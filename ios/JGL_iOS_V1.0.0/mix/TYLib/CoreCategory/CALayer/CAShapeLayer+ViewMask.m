//
//  CAShapeLayer+ViewMask.m
//  TYSamples
//
//  Created by Tony on 2016/9/20.
//  Copyright © 2016年 TonyReet. All rights reserved.
//


#import "CAShapeLayer+ViewMask.h"

#define kViewMaskEdgeSpace 10.0
#define kViewMaskTopSpace 15.0

//圆弧相距顶点的距离
#define KviewQuadCurveFloat 0

@implementation CAShapeLayer (ViewMask)

+ (instancetype)createLeftMaskLayerWithView : (UIView *)view{
    return [self createLeftMaskLayerWithView:view cornerRadius:KviewQuadCurveFloat];
}

+ (instancetype)createLeftMaskLayerWithView : (UIView *)view cornerRadius:(CGFloat )cornerRadius{
    return [self createLeftMaskLayerWithView:view edgeSpage:kViewMaskEdgeSpace topSpace:kViewMaskTopSpace cornerRadius:cornerRadius];
}

+ (instancetype)createLeftMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGPoint point1 = CGPointMake(edgeSpage, 0);
    CGPoint point2 = CGPointMake(viewWidth, 0);
    CGPoint point3 = CGPointMake(viewWidth, viewHeight);
    CGPoint point4 = CGPointMake(edgeSpage, viewHeight);
    CGPoint point5 = CGPointMake(edgeSpage, topSpace+10.);
    CGPoint point6 = CGPointMake(0, topSpace);
    CGPoint point7 = CGPointMake(edgeSpage, topSpace);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

+ (instancetype)createLeftMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace cornerRadius:(CGFloat )cornerRadius{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGPoint point1 = CGPointMake(edgeSpage + cornerRadius, 0);
    CGPoint point2 = CGPointMake(viewWidth - cornerRadius, point1.y);
    CGPoint point3 = CGPointMake(viewWidth, cornerRadius);
    CGPoint point4 = CGPointMake(point3.x, viewHeight - cornerRadius);
    CGPoint point5 = CGPointMake(point2.x, viewHeight);
    CGPoint point6 = CGPointMake(point1.x, point5.y);
    CGPoint point7 = CGPointMake(edgeSpage, point4.y);
    CGPoint point8 = CGPointMake(edgeSpage, topSpace+10.);
    CGPoint point9 = CGPointMake(0, topSpace);
    CGPoint point10 = CGPointMake(edgeSpage, point9.y);
    CGPoint point11 = CGPointMake(point10.x, cornerRadius);
    
    CGPoint controlPoint1 = CGPointMake(viewWidth, 0);
    CGPoint controlPoint2 = CGPointMake(controlPoint1.x, viewHeight);
    CGPoint controlPoint3 = CGPointMake(edgeSpage, controlPoint2.y);
    CGPoint controlPoint4 = CGPointMake(controlPoint3.x, controlPoint1.y);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addQuadCurveToPoint:point3 controlPoint:controlPoint1];
    
    [path addLineToPoint:point4];
    [path addQuadCurveToPoint:point5 controlPoint:controlPoint2];
    
    [path addLineToPoint:point6];
    [path addQuadCurveToPoint:point7 controlPoint:controlPoint3];
    
    [path addLineToPoint:point8];
    [path addLineToPoint:point9];
    [path addLineToPoint:point10];
    [path addLineToPoint:point11];
    [path addQuadCurveToPoint:point1 controlPoint:controlPoint4];
    [path closePath];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

+ (instancetype)createRightMaskLayerWithView : (UIView *)view{
    return [self createRightMaskLayerWithView:view cornerRadius:KviewQuadCurveFloat];
}

+ (instancetype)createRightMaskLayerWithView : (UIView *)view cornerRadius:(CGFloat )cornerRadius{
    return [self createRightMaskLayerWithView:view edgeSpage:kViewMaskEdgeSpace topSpace:kViewMaskTopSpace cornerRadius:cornerRadius];
}

+ (instancetype)createRightMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth-edgeSpage, 0);
    CGPoint point3 = CGPointMake(viewWidth-edgeSpage, topSpace);
    CGPoint point4 = CGPointMake(viewWidth, topSpace);
    CGPoint point5 = CGPointMake(viewWidth-edgeSpage, topSpace+10.);
    CGPoint point6 = CGPointMake(viewWidth-edgeSpage, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    
    [path addLineToPoint:point7];
    [path closePath];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

+ (instancetype)createRightMaskLayerWithView : (UIView *)view edgeSpage:(CGFloat )edgeSpage topSpace:(CGFloat )topSpace cornerRadius:(CGFloat )cornerRadius{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGPoint point1 = CGPointMake(cornerRadius, 0);
    CGPoint point2 = CGPointMake(viewWidth-edgeSpage-cornerRadius, point1.y);
    CGPoint point3 = CGPointMake(viewWidth-edgeSpage, cornerRadius);
    CGPoint point4 = CGPointMake(point3.x,  topSpace);
    CGPoint point5 = CGPointMake(viewWidth, topSpace);
    CGPoint point6 = CGPointMake(point3.x, topSpace+10.);
    CGPoint point7 = CGPointMake(point3.x, viewHeight - cornerRadius);
    CGPoint point8 = CGPointMake(point2.x, viewHeight);
    CGPoint point9 = CGPointMake(point1.x, point8.y);
    CGPoint point10 = CGPointMake(0, point7.y);
    CGPoint point11 = CGPointMake(0, point3.y);
    
    CGPoint controlPoint1 = CGPointMake(viewWidth-edgeSpage, 0);
    CGPoint controlPoint2 = CGPointMake(controlPoint1.x, viewHeight);
    CGPoint controlPoint3 = CGPointMake(0, viewHeight);
    CGPoint controlPoint4 = CGPointMake(0, 0);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addQuadCurveToPoint:point3 controlPoint:controlPoint1];
    
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path addQuadCurveToPoint:point8 controlPoint:controlPoint2];
    
    [path addLineToPoint:point9];
    [path addQuadCurveToPoint:point10 controlPoint:controlPoint3];
    
    [path addLineToPoint:point11];
    [path addQuadCurveToPoint:point1 controlPoint:controlPoint4];
    [path closePath];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

+ (CGSize )getFitImageSize:(UIImage *)image maxImageSize:(CGSize )maxImageSize{
    
    //分别获取自己设置的最大宽高
    CGFloat maxImageW = maxImageSize.width;
    CGFloat maxImageH = maxImageSize.height;
    
    
    // 根据图片的宽高尺寸设置图片比例
    CGFloat standardWHRatio = maxImageW / maxImageH;
    
    CGFloat imageWHRatio = 0;
    
    //图片实际的狂傲
    CGFloat imageH = image.size.height;
    CGFloat imageW = image.size.width;
    
    
    //如果图片的宽或高超过了范围
    if (imageW > maxImageW || imageW > maxImageH) {
        
        imageWHRatio = imageW / imageH;
        
        if (imageWHRatio > standardWHRatio) {
            //如果图片的比例大于设置的比例，就以宽为标准
            imageW = maxImageW;
            imageH = imageW * (image.size.height / image.size.width);
        } else {
            //如果图片的比例小于设置的比例，就以高为标准
            imageH = maxImageH;
            imageW = imageH * imageWHRatio;
        }
    }
    
    return CGSizeMake(imageW, imageH);
}
@end
