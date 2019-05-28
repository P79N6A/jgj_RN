//
//  JLGDashedLine.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGDashedLine.h"
#import "IPDashedLineView.h"

#define JLGDashedLineWitdh 0.5//线的粗线值
@implementation JLGDashedLine

+ (void)drashHorizontalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byWith:(CGFloat )witdh lengthPattern:(NSArray *)lengthPattern lineColor:(UIColor *)lineColor
{
    // 水平直线
    IPDashedLineView *dashV = [[IPDashedLineView alloc] initWithFrame:TYSetRect(startPoit.x,startPoit.y, witdh, JLGDashedLineWitdh)];
    //数组第一个是长度，第二个是间隙
    dashV.lengthPattern = lengthPattern;
    dashV.lineColor = lineColor;
    [view addSubview:dashV];
}

+ (void)drashHorizontalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byWith:(CGFloat )witdh
{
    // 水平直线
    IPDashedLineView *dashV = [[IPDashedLineView alloc] initWithFrame:TYSetRect(startPoit.x,startPoit.y, witdh, JLGDashedLineWitdh)];
    //数组第一个是长度，第二个是间隙
    dashV.lengthPattern = @[@4, @2];
    dashV.lineColor = TYColorHex(0xc9c9c9);
    [view addSubview:dashV];
}


+ (void)drashVerticalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byHeight:(CGFloat )height
{
    // 垂直直线
    IPDashedLineView *dashV = [[IPDashedLineView alloc] initWithFrame:TYSetRect(startPoit.x,startPoit.y, JLGDashedLineWitdh, height)];
    //数组第一个是长度，第二个是间隙
    dashV.lengthPattern = @[@4, @2];
    dashV.lineColor = TYColorHex(0xc9c9c9);
    [view addSubview:dashV];
}

+ (void)drashVerticalLineInView:(UIView *)view byPoint:(CGPoint )startPoit byHeight:(CGFloat )height
 byColor:(UIColor *)color{
    // 垂直直线
    IPDashedLineView *dashV = [[IPDashedLineView alloc] initWithFrame:TYSetRect(startPoit.x,startPoit.y, JLGDashedLineWitdh, height)];
    //数组第一个是长度，第二个是间隙
    dashV.lengthPattern = @[@1, @2];
    dashV.lineColor = color;
    [view addSubview:dashV];
}

@end
