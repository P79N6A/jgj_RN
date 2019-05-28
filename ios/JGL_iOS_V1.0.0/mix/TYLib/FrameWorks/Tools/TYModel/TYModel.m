//
//  TYModel.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYModel.h"

@implementation TYModel

//防止解析不出数据崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    TYLog(@"没有定义的变量:%@ = %@",key,value);
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (!value) {
        TYLog(@"空变量:%@ = %@",key,value);
    }else{
        [super setValue:value forKey:key];
    }
}

@end
