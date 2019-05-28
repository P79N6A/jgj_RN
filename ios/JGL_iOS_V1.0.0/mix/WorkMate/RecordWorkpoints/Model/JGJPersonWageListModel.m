//
//  JGJPersonWageListModel.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListModel.h"

@implementation JGJPersonWageListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PersonWageListList class]};
}

- (void)setList:(NSArray<PersonWageListList *> *)list{
    _list = list;

    //找出最大值
    __block NSInteger total_maxManhour = 0;
    [list enumerateObjectsUsingBlock:^(PersonWageListList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.list enumerateObjectsUsingBlock:^(PersonWageListListList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total_maxManhour = MAX(total_maxManhour, obj.total_manhour);
        }];
    }];
    
    //反赋最大值
    [list enumerateObjectsUsingBlock:^(PersonWageListList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.list enumerateObjectsUsingBlock:^(PersonWageListListList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.total_maxManhour = total_maxManhour;
        }];
    }];
}
@end


@implementation PersonWageListList

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PersonWageListListList class]};
}
@end


@implementation PersonWageListListList

@end


