//
//  JGJModifyBillListViewController.h
//  mix
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPhotoViewController.h"

#import "YZGMateWorkitemsModel.h"

#import "YZGGetBillModel.h"

#import "YZGAddContactsTableViewCell.h"
typedef enum: NSUInteger{
    JGJTextFildContractSubProType = 0,//分项
    JGJTextFildContractUnitePrice,//单价
    JGJTextFildContractNum,//数量
    JGJTextFildContracAccount,
    JGJTextFildBrrowAccount = 10,
    JGJTextFildCloseAccountPayType = 40,
}JGJTextFildType;
typedef void(^JGJMarkBillQueryproBlock)(void);

typedef void(^ModifyBillSuccessToCurrentSureBillVCWithModel)(JGJRecordWorkPointListModel *recordPointModel);


@interface JGJModifyBillListViewController : UIPhotoViewController

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIView *baseView;

@property (strong, nonatomic) IBOutlet UIView *buttomView;

@property (strong, nonatomic) IBOutlet UILabel *lineView;

@property (strong, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsItems;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;

@property (nonatomic,strong) JGJFilloutNumModel *fillOutModel;

@property (assign, nonatomic)BOOL billModify;//差账弹框进入

@property (assign, nonatomic)JGJTextFildType textFildType;//输入框类型

@property (nonatomic, assign) BOOL isNeedRoleType;// 是否需要传入当前角色,只在待确认记工,点击修改时传YES

@property (nonatomic, assign) BOOL isNotNeedJudgeHaveChangedParameters;// 是否需要判断有没有修改内容，这里在确实是不是点击修改进来的，是的话不同判断，不是的话需要判断有没有改过值，没改过，点击保存直接返回不走接口，有修改点击保存才走接口
/*
 *已经记过帐弹框跳转到详情界面然后删除返回
 */
@property (assign,nonatomic) BOOL delshowViewBool;
/**
 *  查询项目
 *
 *  @param queryproBlock 查询完项目以后的操作
 */
-(void)querypro:(JGJMarkBillQueryproBlock )queryproBlock;

// 设置原始的上班时间和加班时间
//- (void)setOriginalWorkTime:(CGFloat )workTime overTime:(CGFloat)overTime;
@property (nonatomic, assign) BOOL is_surePoorBill_ComeIn;// 对账页面进入

@property (nonatomic, assign) BOOL is_currentSureBill_ComeIn;// 本次确认的z账 页面进入
@property (nonatomic, strong) JGJRecordWorkPointListModel *recordPointModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) ModifyBillSuccessToCurrentSureBillVCWithModel ModifyBillSuccessToCurrentSureBillVCWithModel;


@end
