//
//  JGJWageLevelViewController.h
//  mix
//
//  Created by Tony on 2018/1/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGGetBillModel.h"

typedef void(^SetWageLevelSuccess)(void);
typedef void(^SetWageLevelSuccessWithBillModel)(YZGGetBillModel *billModel);
@interface JGJWageLevelViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长

//设置工资模板的人员
@property (nonatomic, strong) NSMutableArray *wagesMembers;

@property (nonatomic, copy) SetWageLevelSuccess setWageLevelSuccess;
@property (nonatomic, copy) SetWageLevelSuccessWithBillModel setWageLevelSuccessWithBillModel;

// 是否是修改点工记账进入薪资模板
@property (nonatomic, assign) BOOL isModifyTinyAmountBillComeIn;

// 是否取对面的工资模板
@property (nonatomic, assign) BOOL isChoiceOtherPartyTemplate;

@end
