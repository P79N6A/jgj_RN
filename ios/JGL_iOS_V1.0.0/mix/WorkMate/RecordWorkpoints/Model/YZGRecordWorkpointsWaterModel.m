//
//  YZGRecordWorkpointsWaterModel.m
//  mix
//
//  Created by celion on 16/2/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkpointsWaterModel.h"

@implementation YZGRecordWorkpointsWaterModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"workday"])
    {
        _workday = [NSMutableArray new];
        NSArray *bigArray = (NSArray *)value;
        for (NSInteger i = 0; i < bigArray.count; i++)
        {
            NSMutableArray *modelArray = [NSMutableArray new];
            NSArray *smallArray = (NSArray *)[bigArray objectAtIndex:i];
            for (NSInteger j = 0; j < smallArray.count; j++)
            {
                WorkdayModel *model = [WorkdayModel new];
                [model setValuesForKeysWithDictionary:(NSDictionary *)[smallArray objectAtIndex:j]];
                [modelArray addObject:model];
            }
            [_workday addObject:[NSArray arrayWithArray:modelArray]];
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end

@implementation WorkdayModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        [self setValue:value forKey:@"ID"];
    }
    else if ([key isEqualToString:@"accounts_type"])
    {
        _accounts_type = [Accounts_Type new];
        [_accounts_type setValuesForKeysWithDictionary:(NSDictionary *)value];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end

@implementation Accounts_Type

@end


