//
//  JLGRPBaseInfoModel.m
//  mix
//
//  Created by jizhi on 15/12/2.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGRPBaseInfoModel.h"
#import "TYFMDB.h"

@implementation JLGRPBaseInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protype = [[Protype alloc] init];
        self.region = [[Region alloc] init];
        self.classes = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"classes" : [RPBaseClasses class]};
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (!value) {
        TYLog(@"空变量:%@ = %@",key,value);
    }else if([key isEqualToString:@"region"]){
        NSArray *regionNameArray = value[@"name"];
        self.regionName = [regionNameArray componentsJoinedByString:@"  "];
        [self.region setValuesForKeysWithDictionary:value];
    }else if([key isEqualToString:@"classes"]){
        NSArray *classesArray = value;

        //去除项目名称以后拼接
        __block NSMutableArray *workTypeNameArray = [NSMutableArray array];
        [classesArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSString *workTypeCode = obj[@"worktype"];
            NSString *workTypeName = [TYFMDB searchItemByTableName:TYFMDBWorkTypeName ByKey:@"id" byValue:workTypeCode byColume:@"name"];

            [workTypeNameArray addObject:workTypeName];
        }];
        
        self.worktypeName = [workTypeNameArray componentsJoinedByString:@","];
        
        [classesArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RPBaseClasses *rpBaseClasses = [[RPBaseClasses alloc] init];
            [rpBaseClasses setValuesForKeysWithDictionary:obj];

            rpBaseClasses.worktypeName = [TYFMDB searchItemByTableName:TYFMDBWorkTypeName ByKey:@"id" byValue:[NSString stringWithFormat:@"%@",rpBaseClasses.worktype] byColume:@"name"];
            [self.classes addObject:rpBaseClasses];
        }];
    }else if([key isEqualToString:@"protype"]){
        [self.protype setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation Protype

@end


@implementation Region

@end


@implementation RPBaseClasses
- (instancetype)init
{
    self = [super init];
    if (self) {//初始化的数据
        self.worklevel = 32;
        self.balanceway = @"日";
        self.cooperate_range = 1;
    }
    return self;
}
@end


