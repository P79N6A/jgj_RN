//
//  YZGWageDetailModel.m
//  mix
//
//  Created by Tony on 16/3/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageDetailModel.h"

@implementation YZGWageDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"values" : [WageDetailValues class]};
}

@end

@implementation WageDetailValues

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WageDetailList class]};
}

@end

@implementation WageDetailList

@end


