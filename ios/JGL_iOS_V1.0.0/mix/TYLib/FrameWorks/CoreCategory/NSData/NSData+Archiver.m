//
//  NSData+Archiver.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "NSData+Archiver.h"

@implementation NSData (Archiver)

//归档
+ (void )archiveRootObject:(id)obj byKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];//归档,调用encodeWithCoder方法
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

//删除
+ (void )removeRootObjectByKey:(NSString *)key{
    [self archiveRootObject:nil byKey:key];
}

//解档 传入的obj为初始化以后，需要存储的类
+ (id)unarchiveObjectWithObject:(id)obj byKey:(NSString *)key{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [[NSData alloc] init];
    data = [defaults objectForKey:key];
    
    if (data) {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];//读取归档数据,调用initWithCoder
    }
    return obj;
}

@end

