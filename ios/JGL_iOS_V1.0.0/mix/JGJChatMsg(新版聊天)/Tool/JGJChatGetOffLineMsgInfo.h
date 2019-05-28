//
//  JGJChatGetOffLineMsgInfo.h
//  mix
//
//  Created by Tony on 2018/8/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
typedef void(^GetChatIndexListSuccess)(JGJMyWorkCircleProListModel *proListModel);
typedef void(^GetChatGroupListSuccess)(BOOL insertSuccess);

typedef void(^GetChatIndexListFailed)(void);

typedef void(^GetHomeCalendarDataSuccess)(void);
@interface JGJChatGetOffLineMsgInfo : NSObject

+ (JGJChatGetOffLineMsgInfo *)shareManager;
@property (nonatomic, copy) GetChatIndexListSuccess getIndexListSuccess;
@property (nonatomic, copy) GetChatGroupListSuccess getGroupListSuccess;
@property (nonatomic, copy) GetChatIndexListFailed getIndexListFailed;
@property (nonatomic, copy) GetHomeCalendarDataSuccess getHomeCalendarDataSuccess;

@property (nonatomic, strong) UIViewController *vc;



// 首页获取项目信息
+ (void)http_getChatIndexList;
// 聊聊列表
+ (void)http_getChatGroupListSuccess:(void (^)(BOOL responseObject))success;
// 获取已关闭
+ (void)http_getClosedGroupList;

// 获取单个列表数据
+ (void)http_getSingleChatGroupWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type success:(void (^)(JGJChatGroupListModel *groupModel))success;


// v4.0.1 app已启动先请求一页首页数据
+ (void)http_getHomeCalendarData;


/**
 *
 * 聊聊列表
 *
 * 去该项目首页功能
 *
 * needChangeVC 是否需要切换到首页
 *
 **/
+ (void)http_gotoTheGroupHomeVCWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type isNeedChangToHomeVC:(BOOL)needChange isNeedHttpRequest:(BOOL)needRequest success:(void (^)(BOOL isSuccess))success;

+ (JGJIndexDataModel *)getTheIndexDataModelWithGroup_id:(NSString *)group_id classType:(NSString *)class_type;

// 刷新首页
+ (void)refreshIndexTbToHomeVC;

// 获取最近项目创建时间的项目 并切换到首页
+ (void)getTheNewestCreatTimeGroupProjectInsertToHomeVcTb;

@end
