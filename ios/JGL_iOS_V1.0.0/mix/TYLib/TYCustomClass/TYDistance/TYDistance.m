//
//  TYDistance.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYDistance.h"

@implementation TYDistance
//计算2个坐标点之间的距离
+ (CGFloat)getDistanceBylat1:(CGFloat)lat1 lng1:(CGFloat)lng1 lat2:(CGFloat)lat2 lng2:(CGFloat)lng2
{
    //地球半径
    NSUInteger R = 6378137;
    //将角度转为弧度
    CGFloat radLat1 = [self radians:lat1];
    CGFloat radLat2 = [self radians:lat2];
    CGFloat radLng1 = [self radians:lng1];
    CGFloat radLng2 = [self radians:lng2];
    //结果
    CGFloat s = acos(cos(radLat1)*cos(radLat2)*cos(radLng1-radLng2)+sin(radLat1)*sin(radLat2))*R;
    
    //精度
    s = round(s* 10000)/10000;
    
    return  round(s);
}

//将角度转为弧度
+ (CGFloat)radians:(CGFloat)degrees{
    return (degrees*M_PI)/180.0;
}
@end
