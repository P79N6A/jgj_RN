//
//  JGJWaitTaskVc.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskRootVc.h"

#import "JGJTaskRequestModel.h"

#import "JGJMsgFlagView.h"

@interface JGJWaitTaskVc : JGJTaskRootVc

@property (nonatomic, strong) JGJTaskRequestModel *taskRequestModel; //新任务列表请求模型

//切换全部任务和我负责的任务需要删除数据
@property (nonatomic, strong) NSMutableArray *taskModels;

//发布万任务刷新用
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, readonly) JGJTaskListModel *taskListModel; //任务列表模型

//判断cell类型改变字体。已完成和和其他类型
@property (nonatomic, assign) WaitTaskCellType waitTaskCellType;


@end

