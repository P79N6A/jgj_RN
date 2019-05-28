//
//  JGJBrrowBillController.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//  借支控制器

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJAccountingMemberVC.h"

@interface JGJBrrowBillController : UIViewController

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否是从首页进入记账页面
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) BOOL oneDayAttendanceComeIn;// 每日考勤进入
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid
@property (strong ,nonatomic)NSDate *selectedDate;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) YZGGetBillModel *brrowGetBillModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

- (void)stopCellTwinkleAnimation;

@end
