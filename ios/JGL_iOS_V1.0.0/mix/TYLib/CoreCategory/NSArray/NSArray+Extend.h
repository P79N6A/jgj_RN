//
//  NSArray+Extend.h
//  Wifi
//
//  Created by muxi on 14/11/27.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extend)


/**
 *  数组转字符串
 */
-(NSString *)string;


/**
 *  数组比较
 */
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array;


/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/**
 *  数据计算差集
 */
-(NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray;

/**
 *  判断是否包含对应的类
 *
 *  @param customClass 自定义的类
 *
 *  @return 包含返回YES,不包含返回NO
 */
-(BOOL )containsClass:(id)customClass;

@end
