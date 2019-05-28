//
//  JLGProjectModel.m
//  mix
//
//  Created by jizhi on 15/12/9.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGProjectModel.h"

@implementation JLGProjectModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.proid = [value integerValue];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
