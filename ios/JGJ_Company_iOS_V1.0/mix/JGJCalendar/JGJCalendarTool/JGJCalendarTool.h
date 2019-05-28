//
//  JGJCalendarTool.h
//  mix
//
//  Created by YJ on 16/7/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"
#import "UIView+YYAdd.h"
@interface JGJCalendarTool : NSObject

+ (instancetype)calendarTool;

+ (NSString *)chineseDateYear:(NSString *)year month:(NSString *)month day:(NSString *)day isConvert:(BOOL)isConvert;

//传入字符串和比较的字符
+ (NSMutableAttributedString *)setAllText:(NSString *)allText compare:(NSString *)compareText font:(UIFont *)font;

//每天随机生成地址
+ (NSMutableArray *)randomGenerationAddress ;

@end
