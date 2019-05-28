//
//  NSData+Archiver.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Archiver)
//归档
+ (void )archiveRootObject:(id)obj byKey:(NSString *)key;

//删除
+ (void )removeRootObjectByKey:(NSString *)key;

//解档 传入的obj为初始化以后，需要存储的类
+ (id)unarchiveObjectWithObject:(id)obj byKey:(NSString *)key;
@end
