//
//  TYModel.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYModel.h"

#ifdef DEBUG
#define TYDebugLog(...) NSLog(@"\n\n函数:%s 行号:%d\n打印信息:%@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TYDebugLog(...) do { } while (0);
#endif

@implementation TYModel

//防止解析不出数据崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    TYDebugLog(@"没有定义的变量:%@ = %@",key,value);
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (!value) {
//        TYDebugLog(@"空变量:%@ = %@",key,value);
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder

{
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
        
    }
    
    free(ivars);
    
    
}

- (id)initWithCoder:(NSCoder *)decoder

{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
            
        }
        free(ivars);
        
    }
    
    return self;
    
}

@end
