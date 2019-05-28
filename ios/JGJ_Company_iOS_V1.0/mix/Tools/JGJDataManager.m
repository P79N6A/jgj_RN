//
//  JGJDataManager.m
//  mix
//
//  Created by Json on 2019/4/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJDataManager.h"
static JGJDataManager * _manager;
@interface JGJDataManager ()<NSCopying>

@end

@implementation JGJDataManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}



@end
