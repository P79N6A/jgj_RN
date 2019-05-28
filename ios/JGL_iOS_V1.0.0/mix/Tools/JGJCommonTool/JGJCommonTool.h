//
//  JGJCommonTool.h
//  mix
//
//  Created by Tony on 2016/7/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extend.h"
#import "NSString+Password.h"

@interface JGJCommonTool : NSObject
/**
 *  获取1758游戏平台需要的URL
 *
 *  @return URL
 */
+ (id )getGame1758PlatformURl;


/**
 *  传入paramsDic 和key
 *
 *  @return 返回加密的sign
 */
+ (NSString *)getSignStr:(NSDictionary *)paramsDic key:(NSString *)key;
@end
