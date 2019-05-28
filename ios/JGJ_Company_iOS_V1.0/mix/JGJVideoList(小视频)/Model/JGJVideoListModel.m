//
//  JGJVideoListModel.m
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJVideoListModel.h"

@implementation JGJVideoCommonModel


@end

@implementation JGJVideoListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"post_id" : @"id"};
}

@end
