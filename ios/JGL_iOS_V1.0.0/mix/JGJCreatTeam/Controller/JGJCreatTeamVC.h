//
//  JGJCreatTeamVC.h
//  mix
//
//  Created by yj on 16/8/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCreatTeamVC : UIViewController

/**
 *  保存通信录排好序的数据
 */
@property (nonatomic, strong) NSMutableArray *sortFindResult;

/**
 *  加入班组选择的项目如果是未创建班组时跳转到创建项目
 */
@property (nonatomic, strong) JGJProjectListModel *projectListModel;

/**
 *  记账选择的项目没有创建班组，带入项目名字
 */
@property (nonatomic, strong) JGJProjectListModel *accountProModel;

/**
 *  通知详情所选项目，未创建班组时，传入的通知模型，创建班组.操作结束回执notify_id给服务器
 */
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;

@property (nonatomic, assign) JGJNewNotifyProType proType; //新通知创建项目组类型

//记账完成创建成功返回
@property (nonatomic, assign) BOOL isPopVc;

//直接返回当前页面(我的班组扫码、创建班组使用)
@property (nonatomic, strong) UIViewController *popVc;

/**
 *  返回添加的成员
 */
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType;
@end
