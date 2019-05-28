//
//  JGJPosition.m
//  mix
//
//  Created by Json on 2019/5/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJPosition.h"


@implementation JGJPosition

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
                 @"province":@"province_name",
                 @"city":@"city_name",
                 @"latitude":@"lat",
                 @"longitude":@"lng",
                 @"address":@"pro_address"
             };
}

@end
