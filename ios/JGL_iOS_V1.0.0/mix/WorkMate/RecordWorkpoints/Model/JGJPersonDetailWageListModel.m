//
//  JGJPersonDetailWageListModel.m
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonDetailWageListModel.h"

@implementation JGJPersonDetailWageListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"pro_list" : [PersonDetailWageListList class]};
}

@end


@implementation PersonDetailWageListList

+ (NSDictionary *)objectClassInArray{
    return @{@"workday" : [PersonDetailWageListWorkday class]};
}

@end


@implementation PersonDetailWageListWorkday

@end


@implementation PersonDetailWageListAccounts_Type

@end


