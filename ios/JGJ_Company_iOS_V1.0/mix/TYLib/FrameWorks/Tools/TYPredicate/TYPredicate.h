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
@end
