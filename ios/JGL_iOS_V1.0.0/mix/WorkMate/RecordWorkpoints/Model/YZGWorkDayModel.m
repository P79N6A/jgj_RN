//
//  YZGWorkDayModel.m
//  mix
//
//  Created by Tony on 16/2/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWorkDayModel.h"
#import "NSString+Extend.h"

@implementation YZGWorkDayModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"btn_desc"]) {
        self.btn_dest = [[WorkDayDtn_desc alloc] init];
        
        [self.btn_dest setValuesForKeysWithDictionary:(NSDictionary *)value];
    }else{
        [super setValue:value forKey:key];
    }
}

- (id )init{
    self = [super init];
    if (self){
        self.unit = @"元";
    };
    
    return self;
}

- (NSString *)todayRecordStr {
    _todayRecordStr = !self.recorded  ? @"马上记一笔" : @"再记一笔";
    return _todayRecordStr;
}

@end

@implementation WorkDayDtn_desc

@end