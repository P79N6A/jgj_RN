//
//  JGJRecordWorkpointsVc.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordWorkpointsVc : UIViewController

//统计详情页
@property (nonatomic, strong) JGJRecordWorkStaDetailListModel *staDetailListModel;

@property (nonatomic, assign) BOOL isMarkBillMoreDay;//是不是从一人多天跳过来的

//是否需要刷新
@property (nonatomic, assign) BOOL isFresh;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;


//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

//统计进入是否隐藏查看按钮
@property (nonatomic, assign) BOOL is_hidden_checkBtn;

//是否禁止跳转到记工流水页面(同步给我的记工查看的时候)
@property (assign, nonatomic) BOOL isForbidSkipWorkpoints;

//是否是同步带过来的数据
@property (nonatomic, copy) NSString *is_sync;

@end
