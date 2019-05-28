//
//  JGJCloseAccountBillController.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//  结算 控制器

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJAccountingMemberVC.h"

@interface JGJCloseAccountBillController : UIViewController

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否是从首页进入记账页面
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) BOOL oneDayAttendanceComeIn;// 每日考勤进入
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid
/**
 *  该不该初始化薪资模板
 */
@property (nonatomic,assign) BOOL getTpl;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) YZGGetBillModel *settlementGetBillModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (strong ,nonatomic)NSDate *selectedDate;

//结算用户信息 用于未结工资页面点击 -> 去结算 跳转到结算页面使用
@property (nonatomic, strong) JGJSynBillingModel *closeUserInfo;
#pragma mark - 工资结算获取未结算金额
- (void)getOutstandingAmount;

- (void)stopCellTwinkleAnimation;

@end
