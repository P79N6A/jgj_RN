//
//  TYPredicate.h
//  mix
//
//  Created by jizhi on 15/11/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYPredicate : NSObject

/**
 *  判断是否是手机
 *
 *  @param candidate 手机号
 */
+ (BOOL)isRightPhoneNumer:(NSString*)candidate;

/**
 *  判断是否是身份证
 *
 *  @param IDCardStr 身份证字符串
 *
 *  @return YES:是身份证,NO不是身份证
 */
+ (BOOL)isRightIDCard:(NSString *)IDCardStr;

/**
 *  判断是不是姓名
 *
 *  @param IDNameStr 传入的字符串
 *
 *  @return 是否是姓名
 */
+ (BOOL)isRightIDName:(NSString *)IDNameStr;

//检测URL地址
+ (BOOL)isCheckUrl:(NSString*)url;
@end
