//
//  JGJTinyAmountMarkBillViewController.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//  点工记账控制器

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJAccountingMemberVC.h"

@interface JGJTinyAmountMarkBillController : UIViewController

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否是从首页进入记账页面
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL oneDayAttendanceComeIn;// 每日考勤进入
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (strong ,nonatomic) NSDate *selectedDate;
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid

@property (nonatomic,strong) YZGGetBillModel *tinyYzgGetBillModel;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

- (void)markBillMoreDaySuccessComeBack;

- (void)getWorkTplByUidWithUid:(NSString *)uid accounts_type:(NSString *)accounts_type accoumtMember:(JGJSynBillingModel *)accoumtMember;

- (void)stopCellTwinkleAnimation;
@end
