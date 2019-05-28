//
//  JGJMarkBillViewController.h
//  mix
//
//  Created by Tony on 2017/12/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBottomBtnView.h"

#import "JGJMarkBillCommonHeaderView.h"

#import "YZGGetBillModel.h"

#import "YZGAddContactsTableViewCell.h"

#import "YZGAddForemanAndMateViewController.h"

#import "JGJAccountingMemberVC.h"

typedef enum:NSUInteger{
    
    JGJMarkBillTinyType = 0,
    
    JGJMarkBillContractorType,
    
    JGJMarkBillBrrowType,
    
    JGJMarkBillCloseAccountType,

}JGJMarkBillType;
typedef void(^JGJMarkBillQueryproBlock)(void);

@interface JGJMarkBillViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topBaseView;

@property (strong, nonatomic) IBOutlet JGJBottomBtnView *bottomView;

@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionview;

@property (assign, nonatomic)  JGJMarkBillType JGJMarkBillType;

@property (strong, nonatomic) IBOutlet JGJMarkBillCommonHeaderView *MarkBillCommonView;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,strong) YZGGetBillModel *tinyYzgGetBillModel;

@property (nonatomic,strong) YZGGetBillModel *contractYzgGetBillModel;

@property (nonatomic,strong) YZGGetBillModel *brrowYzgGetBillModel;

@property (nonatomic,strong) YZGGetBillModel *closeAccountyzgGetBillModel;

@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
/*
 *用于备注回传
 */
@property (nonatomic,strong) YZGGetBillModel *remarkYzgGetBillModel;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (assign ,nonatomic)JGJMarkSelectBtnType markSlectBtnType;

@property (strong ,nonatomic)NSDate *selectedDate;
//填写单位和数量
@property (nonatomic,strong) JGJFilloutNumModel *fillOutModel;
/**
 *  判断是不是从聊天界面进入记账
 */
@property (assign ,nonatomic)BOOL ChatType;

@property (nonatomic,strong) NSMutableArray *imagesArray;

@property (nonatomic,strong) NSMutableDictionary *parametersDic;

/**
 *  1表示工人，2表示班组长/工头，0表示没有设置，直接用当前的身份
 */
@property (nonatomic,assign) NSInteger roleType;

/**
 *  查询项目
 *
 *  @param queryproBlock 查询完项目以后的操作
 */
-(void)querypro:(JGJMarkBillQueryproBlock)queryproBlock;
/**
 *  判断是不是从记账首页进入
 */
@property (nonatomic,assign) BOOL Mainrecord;

/**
 *  该不该初始化薪资模板
 */
@property (nonatomic,assign) BOOL getTpl;
/**
 *  只初始化点工
 */
@property (nonatomic,assign) BOOL tinyMarkBill;
/*
 *计算工资
 */
- (CGFloat)getSalary;

//结算用户信息
@property (nonatomic, strong) JGJSynBillingModel *closeUserInfo;

//滚动到结算类型3.1.0添加消除滚动闪烁
@property (nonatomic, assign) BOOL isScroCloseType;

- (void)startRefresh;

- (void)markBillMoreDaySuccessComeBack;
@end
