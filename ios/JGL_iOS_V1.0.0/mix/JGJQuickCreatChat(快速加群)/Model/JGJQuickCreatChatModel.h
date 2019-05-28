//
//  JGJQuickCreatChatModel.h
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGJQuickJoinedGroupChatKey   @"JGJQuickJoinedGroupChatKey"

#define JGJQuickJoinedGroupChatValue   [TYUserDefaults objectForKey:JGJQuickJoinedGroupChatKey]

@interface JGJQuickCreatChatHeaderViewModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, copy) NSString *remark;


@end

@interface JGJQuickCreatChatListModel : NSObject

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *members_num;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *group_name;

@property (nonatomic, copy) NSString *type;

//是否已添加

@property (nonatomic, assign) BOOL is_exist;

//当前用户的标识
@property (nonatomic, copy) NSString *unique;

//人头像
@property (nonatomic, strong) NSArray *members_head_pic;

@end

@interface JGJQuickCreatChatModel : NSObject

@property (nonatomic, strong) NSArray *local_list;//地方群

@property (nonatomic, strong) NSArray *work_list;//工种群

@property (nonatomic, strong) NSMutableArray *headerModels;//头部描述信息

@end

