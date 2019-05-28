//
//  JLGFindProjectModel.m
//  mix
//
//  Created by jizhi on 15/11/30.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFindProjectModel.h"
#import "JGJLabel.h"
#import "JLGFHLeaderDetailModel.h"
@implementation JLGFindProjectModel
//+ (NSDictionary *)objectClassInArray{
//    return @{@"classes" : [Classes class],
//             @"contact_info" : [FindResultModel class] //1.4.4添加联系人模型打电话用
//             };
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"protitle" : @"pro_title",
             @"prodescrip" : @"pro_description",
             @"ctime" : @"create_time",
             @"ctime_txt" : @"create_time_txt",
             @"prolocation": @"pro_location",
             @"total_area" : @"pro_totalarea",
             @"regionname" : @"region_name",
             @"timelimit" : @"pro_timelimit",
             @"friendcount" : @"sharefriendnum",
             @"proaddress" : @"pro_address",
             @"proname" : @"pro_name",
             @"findresult" : @"friend_result"
             };
}

//2.1.2-yj去掉解析

//- (void)setMaxWidth:(CGFloat)maxWidth{
//    _maxWidth = maxWidth;
//    JGJLabelModel *jgjLabelModel = [JGJLabel getModel:self maxWith:maxWidth];
//    self.strViewH = jgjLabelModel.strViewH;
//    self.attributedStr = jgjLabelModel.attributedStr;
//}
MJCodingImplementation
@end

@implementation Classes
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"balanceway" : @"balance_way",
             @"worktype" : @"work_type",
             @"worklevel" : @"work_level"
             };
}
MJCodingImplementation
@end


@implementation Cooperate_Type
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"code" : @"type_id",
             @"name" : @"type_name"
             };
}
MJCodingImplementation
@end


@implementation Worklevel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"code" : @"type_id",
             @"name" : @"type_name"
             };
}
MJCodingImplementation
@end


@implementation Worktype
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"code" : @"type_id",
             @"name" : @"type_name"
             };
}
MJCodingImplementation
@end

@implementation Type_list
MJCodingImplementation
@end

