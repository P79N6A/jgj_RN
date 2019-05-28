//
//  JGJMoreDayViewController.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJSelectProViewController.h"
#import "YZGGetBillModel.h"
#import "JGJContractorTypeChoiceHeaderView.h"
typedef NS_ENUM(NSInteger, pushStatus) {
    editePush          = 0,
    NormalPush         = 1,

};

typedef void(^JGJMoreDayRecordBillSuccess)(void);
@interface JGJMoreDayViewController : UIViewController
@property (nonatomic,strong) YZGGetBillModel *JlgGetBillModel;
@property (nonatomic,strong)jgjrecordselectedModel *selectdModel;
@property (nonatomic,strong)YZGGetBillModel *recordBillModel;
@property (nonatomic,assign)BOOL teamJoin ;
@property (nonatomic, assign)pushStatus myPushStatus;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *WorkCircleProListModel;

@property (nonatomic, copy) JGJMoreDayRecordBillSuccess recordBillSuccess;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid
@property (nonatomic, assign) BOOL chatType;
@property (nonatomic, assign) BOOL isMarkMoreBill;
// 是否需要去 选中类型的本地缓存
@property (nonatomic, assign) BOOL is_Need_ChoiceType_Cache;

@property (nonatomic, assign) NSInteger tinyOrAttentComeIn;//点工或者包工记考勤进入 1 点工 5 包工考勤

/*
 *
 *判断是不是从记账首页进入  因为返回界面不同
 *
 */
@property (nonatomic,assign)BOOL Mainrecod ;

@property (nonatomic,assign)BOOL editeProname;
/*
 *
 *判断是不是从记账首页进入  因为返回界面不同
 *
 */
@property (nonatomic,strong)JGJAddProModel *jgjAddproModel;
// 选择的记多天类型 JGJRecordSelLeftBtnType -> 点工记多天 JGJRecordSelRightBtnType -> 包工考勤记多天
@property (nonatomic, assign) JGJRecordSelBtnType selBtnType;

- (void)setPayRate;// 设置工资标准

- (void)showMoreDayPickerView;
@end
