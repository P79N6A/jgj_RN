//
//  NSArray+JGJDateSort.h
//  mix
//
//  Created by yj on 2018/8/28.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGJPageSize 20

@interface NSArray (JGJDateSort)

/*
 *传入数组字典
 *返回排序的字典
 */
- (NSArray *)sortDataSource;

@end
