//
//  TYDistance.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDistance : NSObject

/*
 *  计算2个坐标点之间的距离
 */
+ (CGFloat)getDistanceBylat1:(CGFloat)lat1 lng1:(CGFloat)lng1 lat2:(CGFloat)lat2 lng2:(CGFloat)lng2;
@end
