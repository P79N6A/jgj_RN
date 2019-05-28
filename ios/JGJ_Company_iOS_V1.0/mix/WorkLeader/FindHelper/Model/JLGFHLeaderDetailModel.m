//
//  JLGFHLeaderDetailModel.m
//  mix
//
//  Created by jizhi on 15/12/26.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFHLeaderDetailModel.h"

@implementation JLGFHLeaderDetailModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if (!value) {
        TYLog(@"空变量:%@ = %@",key,value);
    }else if([key isEqualToString:@"location"]){
        self.regionName = value;
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)setFindresult:(NSArray *)findresult {

    _findresult = findresult;
    self.contacts = [FindResultModel mj_objectArrayWithKeyValuesArray:findresult];
}

@end

@implementation FindResultModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"headpic" : @"head_pic" };
}
@end
