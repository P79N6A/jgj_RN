//
//  JGJCommonTool.m
//  mix
//
//  Created by Tony on 2016/7/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCommonTool.h"
#import "JGJAllWebURL.h"


//static const NSString * = @"467c583750036bb38ac21bb36eea07de";
@implementation JGJCommonTool

+ (id )getGame1758PlatformURl{
    //设置para1758参数
    //获取token，如果不存在返回空字符串
    NSString *userTokenStr = [NSString isEmpty:[TYUserDefaults objectForKey:JLGToken]]?@"":[TYUserDefaults objectForKey:JLGToken];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"" forKey:@"para1758"];
    [paramsDic setObject:userTokenStr forKey:@"userToken"];
    
    NSString *contentStr = [self getSignData:[paramsDic copy]];
    NSString *signStr = [[contentStr stringByAppendingString:@"467c583750036bb38ac21bb36eea07de"] md5].uppercaseString;
    NSString *gamePlatformURLStr = [GamePlatform1758URL stringByAppendingString:[NSString stringWithFormat:@"%@&sign=%@",contentStr,signStr]];
    
    return [NSURL URLWithString:gamePlatformURLStr];
}

+ (NSString *)getSignStr:(NSDictionary *)paramsDic key:(NSString *)key{
    NSString *contentStr = [self getSignDataJGJ:[paramsDic copy]];
    NSString *signStr = [[contentStr stringByAppendingString:key] md5].uppercaseString;
    return signStr;
}

+(id )getSignData:(NSDictionary *)paramsListDic{
    NSString *contentStr = @"";
    NSArray* allKeys = [paramsListDic allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    __block NSMutableArray *sortParamsArr = [NSMutableArray array];
    [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sortParamsArr addObject:@{obj:paramsListDic[obj]}];
    }];

    for (NSUInteger idx = 0; idx < sortParamsArr.count; idx++) {
        NSDictionary *paramsDic = (NSDictionary *)sortParamsArr[idx];
        NSString *key = [paramsDic.allKeys firstObject];
        if ([NSString isEmpty:key]) {
            continue;
        }

        NSString *value = [paramsDic.allValues firstObject];
        if (![NSString isEmpty:value]) {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@%@=%@",idx == 0?@"":@"&",key,value]];
        } else {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@%@=",idx == 0?@"":@"&",key]];
        }
    }

    return contentStr;
}

+(id )getSignDataJGJ:(NSDictionary *)paramsListDic{
    NSString *contentStr = @"";
    NSArray* allKeys = [paramsListDic allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    __block NSMutableArray *sortParamsArr = [NSMutableArray array];
    [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sortParamsArr addObject:@{obj:paramsListDic[obj]}];
    }];
    
    for (NSUInteger idx = 0; idx < sortParamsArr.count; idx++) {
        NSDictionary *paramsDic = (NSDictionary *)sortParamsArr[idx];
        NSString *key = [paramsDic.allKeys firstObject];
        if ([NSString isEmpty:key]) {
            continue;
        }
        
        id value = [paramsDic.allValues firstObject];
        if ((NSNull *)value == [NSNull null]) {
            continue;
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        value = [NSString stringWithFormat:@"%@",value];
        if ([NSString isEmpty:value]) {
            continue;
        }
        
        if ([key isEqualToString:@"msg_prodetail"]) {
            
            continue;
        }

        if (![NSString isEmpty:value]) {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@%@=%@",idx == 0?@"":@"&",key,value]];
        } else {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@%@=",idx == 0?@"":@"&",key]];
        }
    }
    
    TYLog(@"contentStr = %@",contentStr);
    return contentStr;
}
@end
