//
//  JLGSqlCityToJsonOrPlist.m
//  mix
//
//  Created by jizhi on 15/12/19.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGSqlCityToJsonOrPlist.h"

#import "TYFMDB.h"
#import "NSString+Extend.h"

#define short_city_url @"initials"
#define iOSUse YES

@implementation JLGSqlCityToJsonOrPlist

+ (void)trasformData{
    NSMutableArray *allCityDataArray = [[TYFMDB getAllListCitys] mutableCopy];
    
    NSString *initial = @"initial";
    
    [allCityDataArray enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *shortName = obj[@"short_name"];
        
        NSString *insPinyin = @"";//取出所有汉字的首字母
        for (int i = 0; i < shortName.length; i++) {
            NSString *shor = [shortName substringWithRange:NSMakeRange(i, 1)];
            NSString *temshor = [NSString firstCharactor:shor];
            insPinyin = [insPinyin stringByAppendingString:temshor];
        }
        
        obj[short_city_url] = insPinyin;
        
        [allCityDataArray replaceObjectAtIndex:idx withObject:obj];
    }];
    
    //排序完以后的数组
    NSArray *sortArr = [allCityDataArray sortedArrayUsingFunction:nickNameSort context:NULL];
    
    //需要检查的字母数组
    NSArray *zimuArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    NSMutableArray *finiDataArray = [NSMutableArray array];//最后保存的数组
    
    //提取每个字母的数据
    [zimuArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *citysDic = [NSMutableDictionary dictionary];
        citysDic[initial] = key;
        
        NSMutableArray *citysArray = [NSMutableArray array];
        [sortArr enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            
            NSString *engString = obj[@"first_char"];
            if ([key isEqualToString:engString]) {//找到了首字母对应的数据
#ifndef iOSUse//删除多余的字符 安卓用
                [obj removeObjectsForKeys:@[@"short_name",@"city_url",@"short_city_url"]];
                [citysArray addObject:obj];
#else//转换成另一种数据类型 苹果用
                NSMutableDictionary *transformDic = [NSMutableDictionary dictionary];
                transformDic[@"city_key"] = obj[@"city_code"];
                transformDic[@"city_name"] = obj[@"city_name"];
                transformDic[@"initials"] = obj[short_city_url];
                transformDic[@"pinyin"] = obj[@"city_url"];
                transformDic[@"short_name"] = obj[@"short_name"];
                [citysArray addObject:transformDic];
#endif
            }
        }];
        citysDic[@"citys"] = citysArray;
        
        [finiDataArray addObject:citysDic];
    }];
    
    NSString *configFile;
#ifndef iOSUse
    configFile = [TYUserDocumentPaths stringByAppendingPathComponent:@"CityData.json"];
    
    //NSDictionary转换为Data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:finiDataArray options:NSJSONWritingPrettyPrinted error:nil];
    
    //Data转换为JSON
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [str writeToFile:configFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    TYLog(@"path = %@",configFile);
#else
    configFile = [TYUserDocumentPaths stringByAppendingPathComponent:@"CityData.plist"];
    
    [finiDataArray writeToFile:configFile atomically:YES];
    TYLog(@"path = %@",configFile);
#endif
}


//排序
NSInteger nickNameSort(id user1, id user2, void *context)
{
    NSMutableDictionary *u1,*u2;
    //类型转换
    u1 = (NSMutableDictionary *)user1;
    u2 = (NSMutableDictionary *)user2;
    return  [u1[short_city_url] localizedCompare:u2[short_city_url]];
}

@end
