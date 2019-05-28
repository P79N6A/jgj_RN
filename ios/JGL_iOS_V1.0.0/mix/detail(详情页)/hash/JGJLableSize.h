//
//  JGJLableSize.h
//  JGJCompany
//
//  Created by Tony on 2017/12/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJLableSize : NSObject
+ (float)RowWidth:(NSString *)Str andFont:(UIFont *)font;//根据一个字符串返回宽度

+ (float)RowWidth:(NSString *)Str departLeftAndRight:(float)depart andFont:(UIFont *)font;//根据字符串返回高度

+ (float)RowHeight:(NSString *)Str andFont:(UIFont *)font;//根据字符串返回高度
+ (float)RowHeight:(NSString *)Str departLeftAndRight:(float)depart andFont:(UIFont *)font;//根据字符串返回高度

+ (float)RowMoreHeight:(NSString *)Str departLeftAndRight:(float)TotalDepart andFont:(UIFont *)font andOtherStr:(NSString *)otherStr andOtherFont:(UIFont *)otherFont;//有两个lable一个只有一行 另外一个很多行

+ (float)RowHeight:(NSString *)Str andFont:(UIFont *)font totalDepart:(float)depart;//根据字符串返回高度

@end
