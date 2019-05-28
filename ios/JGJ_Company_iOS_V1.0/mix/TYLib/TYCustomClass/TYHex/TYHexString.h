//
//  TYHexString.h
//  mix
//
//  Created by Tony on 15/12/30.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHexString : NSObject
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;
@end
