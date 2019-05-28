//
//  JGJVideoListRequestModel.m
//  mix
//
//  Created by yj on 2018/3/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJVideoListRequestModel.h"

@implementation JGJVideoListRequestCommonModel


@end

@implementation JGJVideoListRequestModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"postId" : @"id"};
}

@end
