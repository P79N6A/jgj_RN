//
//  TYDeviceInfo.h
//  TYSamples
//
//  Created by Tony on 2016/7/12.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDeviceInfo : NSObject

/**
 *  获取设备型号
 *
 *  @return 获取设备型号
 */
+ (NSString *)getDeviceName;

/**
 *  获取其他的基本信息
 *
 *  @return 返回数据
 */
+ (NSDictionary *)getBaseInfo;
@end
