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

- (void)setAddFromType:(JGJFriendAddFromType)addFromType
{
    _addFromType = addFromType;
#if DEBUG
    NSString *source;
    switch (addFromType) {
        case 1:
            source = @"通过群聊添加";
            break;
        case 2:
            source = @"通过通讯录添加";
            break;
        case 3:
            source = @"通过班组添加";
            break;
        case 4:
            source = @"通过项目添加";
            break;
        case 5:
            source = @"通过工友圈添加";
            break;
        case 6:
            source = @"通过找活招工添加";
            break;
        case 7:
            source = @"通过二维码添加";
            break;
        case 8:
            source = @"通过手机号搜索添加";
            break;
        case 9:
            source = @"通过人脉关系添加";
            break;
        case 10:
            source = @"通过单聊(聊天)添加";
            break;
    }
    TYLog(@"=====当前好友来源===>%zd=====%@====",addFromType,source);
#endif

}


@end
