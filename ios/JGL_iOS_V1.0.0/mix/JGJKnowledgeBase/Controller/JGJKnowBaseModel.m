//
//  JGJKnowBaseModel.m
//  mix
//
//  Created by yj on 17/4/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowBaseModel.h"

@implementation JGJKnowBaseCommonModel

@end

@implementation JGJKnowBaseModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"knowBaseId" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {


    return @{@"child" : @"JGJKnowBaseModel"};
}

@end

@implementation JGJWorkCircleMiddleInfoModel

@end
