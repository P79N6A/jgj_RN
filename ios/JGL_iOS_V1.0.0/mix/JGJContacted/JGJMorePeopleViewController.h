//
//  JGJMorePeopleViewController.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "YZGGetBillModel.h"
#import "YZGMateReleaseBillViewController.h"
#import "JGJAddNameHUBView.h"



@interface JGJMorePeopleViewController : UIViewController

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)NSArray *Pro_listModelArr;

@property (nonatomic,strong)JgjRecordlistModel *recordSelectPro;

@property (nonatomic,strong)YZGGetBillModel *jlgGetBillModel;

@property (nonatomic,strong)JGJMoneyListModel *jgjMoneyModel;

@property (nonatomic,strong)JGJMoneyListModel *money_tpl;

@property (nonatomic,strong)NSMutableArray *SaveSuccessArr;//显示保存成功的数据

@property (nonatomic,strong)NSMutableArray *repeatSaveArr;//显示保存成功的数据

//@property (nonatomic,strong)NSMutableArray *repeatSaveArr;//显示保存成功的数据

@property (nonatomic,strong)NSMutableArray *HadRSaveSuccessArr;//显示保存成功的数据

@property (nonatomic,strong) JGJMyWorkCircleProListModel *WorkCircleProListModel;

@property (nonatomic, strong) JgjRecordMorePeoplelistModel * MY_tpl_model;

@property (nonatomic, assign) BOOL isMinGroup;// 是否是首页直接进来的
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*setTplArr;//用来存没有设置薪资模板  设置了薪资模板后

@property (nonatomic,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*moreSelectArr;//2.4.0新增的多选记账

@property (nonatomic, assign) BOOL AddJump;

/*
 *编辑薪资模板
 */
@property (nonatomic, assign) BOOL edietTpl;

-(void)ClickLeftButton;


@end
