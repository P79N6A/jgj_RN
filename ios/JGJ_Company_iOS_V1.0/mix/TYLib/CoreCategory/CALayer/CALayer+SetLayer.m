//
//  CALayer+SetLayer.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "CALayer+SetLayer.h"

@implementation CALayer (SetLayer)

//通过比例设置圆角
- (void)setLayerCornerRadiusWithRatio:(CGFloat )ration{
    CGFloat cornerRadiusWith = self.frame.size.width*ration;
    self.cornerRadius = cornerRadiusWith;
    self.masksToBounds = YES;
}

//设置圆角
- (void)setLayerCornerRadius:(CGFloat )radius{
    self.cornerRadius = radius;
    self.masksToBounds = YES;
}

//通过比例设置边框圆角
- (void)setLayerBorderWithColor:(UIColor *)color width:(CGFloat )width ration:(CGFloat )ration{
    CGFloat cornerRadiusRadius = self.frame.size.width*ration;
    [self setLayerBorderWithColor:color width:width radius:cornerRadiusRadius];
}

//边框
- (void)setLayerBorderWithColor:(UIColor *)color width:(CGFloat )width radius:(CGFloat )radius{
    if (color != nil) {
        self.borderColor = color.CGColor;
    }
    
    if (width != self.borderWidth) {
        self.borderWidth = width;
    }
    
    if (radius != self.cornerRadius) {
        self.cornerRadius = radius;
    }
    
    self.masksToBounds = NO;
}

//阴影
- (void)setLayerShadowWithColor:(UIColor *)color offset:(CGSize )cgoffset opacity:(float )opaticy radius:(CGFloat )radius{

    if (color != nil) {// 阴影的颜色
        self.shadowColor = color.CGColor;
    }
    
    if (!CGSizeEqualToSize(cgoffset, self.shadowOffset)) {
        self.shadowOffset = cgoffset;// 阴影的范围
    }
    
    if (opaticy != self.shadowOpacity && opaticy != 0) {
        self.shadowOpacity = opaticy;// 阴影透明度
    }
    
    if (radius != self.shadowRadius && radius != 0) {
        self.shadowRadius = radius;// 阴影扩散的范围控制
    }
    
    //    使用阴影必须保证 layer 的masksToBounds = false，因此阴影与系统圆角不兼容
    self.masksToBounds = NO;

    //    仅开启阴影(没有指定路径，同屏数量10个以上)在滚动时帧率会大幅下降，检测到离屏渲染的黄色特征；指定一个与边界相同的简单路径后离屏渲染特征消失，帧率恢复正常。需要在这里面添加bouns
    //    self.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
}

#pragma mark - 离屏渲染的注意点
//    对于内容不发生变化的视图，原本拖后腿的离屏渲染就成为了助力；如果视图内容是动态变化的，使用这个方案有可能让性能变得更糟。
//    如果内容不发生变化的话，可以这样用
//    self.shouldRasterize = YES;
//    self.rasterizationScale = self.contentsScale;

@end
