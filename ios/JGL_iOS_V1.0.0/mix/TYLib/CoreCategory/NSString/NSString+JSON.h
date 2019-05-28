//
//  NSString+JSON.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  获取json数据
 *
 *  @param theData 传入的字典或者数组
 *  @return 返回的Json字符串,如果有问题，返回nil
 */
+ (NSString *)getJsonByData:(id )theData;


//读取 工程文件中的所有 plist 文件 转成 json 输出
+ (void)showJSON:(NSString *)plistName;
@end
