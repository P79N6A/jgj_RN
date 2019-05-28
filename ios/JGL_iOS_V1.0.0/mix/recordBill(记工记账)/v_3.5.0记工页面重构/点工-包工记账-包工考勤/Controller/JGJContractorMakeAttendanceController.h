//
//  JGJContractorMakeAttendanceController.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//  包工记考勤控制器

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJAccountingMemberVC.h"
@interface JGJContractorMakeAttendanceController : UIViewController

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否是从首页进入记账页面
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) BOOL oneDayAttendanceComeIn;// 每日考勤进入
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid

@property (strong ,nonatomic)NSDate *selectedDate;
@property (nonatomic,strong) YZGGetBillModel *attendanceGetBillModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;

- (void)getWorkTplByUidWithUid:(NSString *)uid accounts_type:(NSString *)accounts_type accoumtMember:(JGJSynBillingModel *)accoumtMember;

- (void)stopCellTwinkleAnimation;

@end
