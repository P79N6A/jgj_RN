//
//  NSString+JSON.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

/*
 * 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        TYLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//将data转换位json字符串
+ (NSString *)getJsonByData:(id )theData{
    NSError *error = nil;
    //NSDictionary转换为Data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] && error == nil){
        //Data转换为JSON
        NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return str;
    }else{
        return @"";
    }
}

//读取 工程文件中的所有 plist 文件 转成 json 输出
+ (void)showJSON:(NSString *)plistName{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    if (!data) {
        TYLog(@"读取失败");
        return;
    }
    NSString *configFile = [TYUserDocumentPaths stringByAppendingPathComponent:@"CityData.json"];
    TYLog(@"configFile = %@",configFile);
    NSMutableArray *dataArray = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(NSDictionary *dataobj, NSUInteger idx, BOOL *stop) {
        NSArray *citysArray = dataobj[@"citys"];
        [citysArray enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeObjectForKey:@"initials"];
            [obj removeObjectForKey:@"pinyin"];
            [obj removeObjectForKey:@"short_name"];
            [obj setObject:obj[@"city_key"] forKey:@"city_code"];
            [obj removeObjectForKey:@"city_key"];
            [obj setObject:dataobj[@"initial"] forKey:@"sortLetters"];
            [dataArray addObject:obj];
        }];
    }];
    //NSDictionary转换为Data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
    
    //Data转换为JSON
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (str) {
        [str writeToFile:configFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
@end
