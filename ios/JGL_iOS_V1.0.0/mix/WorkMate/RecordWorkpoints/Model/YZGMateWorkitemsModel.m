//
//  YZGMateWorkitems.m
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateWorkitemsModel.h"

@implementation YZGMateWorkitemsModel


+ (NSDictionary *)objectClassInArray{
    return @{@"values" : [MateWorkitemsValues class]};
}

- (id)copyWithZone:(NSZone *)zone {
    YZGMateWorkitemsModel *instance = [[YZGMateWorkitemsModel alloc] init];
    if (instance) {
        instance.values = self.values;
    }
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    YZGMateWorkitemsModel *instance = [[YZGMateWorkitemsModel alloc] init];
    if (instance) {
        instance.values = self.values;
    }
    return instance;
}
@end

@implementation MateWorkitemsValues


+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [MateWorkitemsItems class]};
}

@end


@implementation MateWorkitemsItems

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accounts_type = [[MateWorkitemsAccounts_Type alloc] init];
    }
    return self;
}


- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"overtime"]) {
        if ([value isEqualToString:@""]|| !value) {
            
            self.overtime = @"";
        }else{
            [super setValue:value forKey:key];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


@implementation MateWorkitemsAccounts_Type

@end


