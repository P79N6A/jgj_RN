//
//  JGJTinyAmountMarkBillViewController.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJTinyAmountMarkBillController.h"
#import "UILabel+GNUtil.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "JGJMarkBillBottomSaveView.h"
#import "JGJTinyAmountMarkBillTableViewCell.h"
#import "JGJMarkBillNormalCellModel.h"
#import "JGJCusSeniorPopView.h"
#import "JGJNewSelectedDataPickerView.h"
#import "JGJWorkTplHaveDiffAlertView.h"
#import "JGJWageLevelViewController.h"
#import "JGJManHourPickerView.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJMarkBillRemarkViewController.h"
#import "JGJCreatTeamVC.h"
#import "JGJCusAlertView.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "JGJLeaderRecordsViewController.h"
#import "JGJMorePeopleViewController.h"
#import "FDAlertView.h"
#import "JGJRecordWorkpointsVc.h"
#import "YZGMateWorkitemsViewController.h"
#import "JGJSurePoorbillViewController.h"
#import "JGJMoreDayViewController.h"
@interface JGJTinyAmountMarkBillController ()
<UITableViewDelegate,UITableViewDataSource,JGJNewSelectedDataPickerViewDelegate,JGJManHourPickerViewDelegate,JGJNewMarkBillChoiceProjectViewControllerDelgate,JGJMarkBillRemarkViewControllerDelegate,FDAlertViewDelegate>
{
    JGJTinyAmountMarkBillTableViewCell *_cell;
    
    YZGAddForemanModel *_selectedForemanModel;
    BOOL _isChoiceManHourOrOverHour;
    
    BOOL _isSaveToServerSuccess;
    BOOL _isClearEditMoney;
    
}
@property (nonatomic, strong) UITableView *tinyAmountTable;// 点工列表
@property (nonatomic, strong) JGJMarkBillBottomSaveView *bottomSaveView;// 底部保存按钮
@property (nonatomic,strong) NSMutableArray *remarkImagesArray;

@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;
@property (nonatomic, strong) NSMutableDictionary *theLastToServerPramedic;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;

@property (nonatomic,strong)  NSString *treadid;
@property (nonatomic, strong) NSString *is_next_act;
@property (nonatomic, strong) NSString *accounts_type;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *uid;

@property (nonatomic, assign) BOOL isChoiceOtherPartyTemplate;// 是否同意对方的模板


@end

@implementation JGJTinyAmountMarkBillController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;

    [self initializeAppearance];
    self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
    
    [self initLastRecordNews];
}

- (void)initLastRecordNews {
   
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    if (!JLGisLeaderBool) {
        
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        parmDic = [TYUserDefaults objectForKey:key];
        
        if (parmDic && [parmDic[@"accounts_type"] integerValue] == 1 && !_markBillMore && !_is_Home_ComeIn) {// 本地有记账信息 且上笔账的身份信息和当前身份信息一致 班组长身份不取值 只选中类型
            
            YZGGetBillModel *billModel = [YZGGetBillModel mj_objectWithKeyValues:parmDic];
            self.tinyYzgGetBillModel.name = billModel.name;
            self.tinyYzgGetBillModel.uid = billModel.uid;
            self.tinyYzgGetBillModel.proname = billModel.proname;
            self.tinyYzgGetBillModel.pid = billModel.pid;
            self.tinyYzgGetBillModel.manhour = billModel.manhour;
            self.tinyYzgGetBillModel.isRest = billModel.isRest;
            
            if (self.tinyYzgGetBillModel.uid == 0) {
                
                return;
            }
            
            // 获取模板
            NSDictionary *param = @{@"accounts_type":@"1",
                                    @"uid":@(self.tinyYzgGetBillModel.uid)
                                    };
            [TYLoadingHub showLoadingWithMessage:nil];
            [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
                
                [TYLoadingHub hideLoadingView];
                JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
                getWorkTplByUidModel.user_name = self.tinyYzgGetBillModel.name;
                // 先判断 自己设置考勤模板会对方设置的是否相同
                if (getWorkTplByUidModel.is_diff == 0) {// 表示无差异
                    
                    self.isChoiceOtherPartyTemplate = NO;
                    self.tinyYzgGetBillModel.set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                    self.tinyYzgGetBillModel.set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    self.tinyYzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    self.tinyYzgGetBillModel.set_tpl.o_s_tpl = getWorkTplByUidModel.my_tpl.o_s_tpl;
                    self.tinyYzgGetBillModel.set_tpl.hour_type = getWorkTplByUidModel.my_tpl.hour_type;
                    
                    [self setSalary];
                    [self.tinyAmountTable reloadData];
                    
                }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                    
                    JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                    [diffTplAlertView show];
                    
                    diffTplAlertView.difTplBill = getWorkTplByUidModel;
                    diffTplAlertView.markSlectBtnType = JGJMarkSelectTinyBtnType;
                    
                    TYWeakSelf(self);
                    // 取消
                    diffTplAlertView.cancle = ^{// 用自己的工资模板
                        
                        weakself.isChoiceOtherPartyTemplate = NO;                        
                        self.tinyYzgGetBillModel.set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl ;
                        self.tinyYzgGetBillModel.set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                        self.tinyYzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                        self.tinyYzgGetBillModel.set_tpl.o_s_tpl = getWorkTplByUidModel.my_tpl.o_s_tpl;
                        self.tinyYzgGetBillModel.set_tpl.hour_type = getWorkTplByUidModel.my_tpl.hour_type;
                        [self setSalary];
                        [self.tinyAmountTable reloadData];
                    };
                    
                    // 同意
                    diffTplAlertView.agree = ^{// 用对方的工资模板
                    
                        weakself.isChoiceOtherPartyTemplate = YES;
                        // 加班方式都是按工天的情况下，使用对方模板，金额依然取自己的，否则取对方的

                        self.tinyYzgGetBillModel.set_tpl.s_tpl = (getWorkTplByUidModel.my_tpl.hour_type == 0 && getWorkTplByUidModel.oth_tpl.hour_type == 0) ? getWorkTplByUidModel.my_tpl.s_tpl : getWorkTplByUidModel.oth_tpl.s_tpl;
                        self.tinyYzgGetBillModel.set_tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                        self.tinyYzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                        self.tinyYzgGetBillModel.set_tpl.o_s_tpl = getWorkTplByUidModel.oth_tpl.o_s_tpl;
                        self.tinyYzgGetBillModel.set_tpl.hour_type = getWorkTplByUidModel.oth_tpl.hour_type;
                        [self setSalary];
                        [self.tinyAmountTable reloadData];
                    };
                }
                
                
                
            } failure:^(NSError *error) {
                
                [TYLoadingHub hideLoadingView];
            }];
            
            // 获取最后一次的记账项目
            if (!_markBillMore) {
                
                [self JLGHttpRequest_LastproWithUid: self.tinyYzgGetBillModel.uid];
            }
        }
    }
    
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomSaveView];
    [self.view addSubview:self.tinyAmountTable];
    [self setUpLayout];
    
#pragma mark - 提交数据到服务器
    TYWeakSelf(self);
    _bottomSaveView.saveToServer = ^{
      
        [weakself pushTinyAmountBillDataToServer];
    };
}

- (void)setUpLayout {
    
    [_bottomSaveView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-JGJ_IphoneX_BarHeight);
        make.height.mas_equalTo(60);
    }];
    
    [_tinyAmountTable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(_bottomSaveView.mas_top).offset(0);
        make.left.right.top.mas_equalTo(0);
    }];
    
}

- (void)markBillMoreDaySuccessComeBack {
    
    [self manegerCleanCurrentPageData];
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    
    if (self.markBillMore) {//几多人进来
        
        _workProListModel = workProListModel;
        self.tinyYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [workProListModel.pro_id?:@"0" longLongValue];
        
    }
    
    if (_is_Home_ComeIn) {
        
        self.tinyYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.tinyYzgGetBillModel.name = workProListModel.creater_name?:@"";
        self.tinyYzgGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
        [self mainGoinGetTPL];
    }
    
}

#pragma UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    }else if (section == 1) {
        
        return 4;
    }else {
        
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (self.tinyYzgGetBillModel.set_tpl.hour_type == 0) {
            
            if (self.tinyYzgGetBillModel.set_tpl.s_tpl > 0) {
                
                return 90;
                
            }else {
                
                return 55;
            }
            
        }else {
            
            return 75;
        }
        
    }else {
        
        return 55;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [JGJTinyAmountMarkBillTableViewCell cellWithTableViewNotXib:tableView];
    
    _cell.is_Home_ComeIn = self.is_Home_ComeIn;
    _cell.isAgentMonitor = self.isAgentMonitor;
    _cell.markBillMore = _markBillMore;
    
    _cell.cellTag = indexPath.section * 10 + indexPath.row;
    _cell.yzgGetBillModel = self.tinyYzgGetBillModel;
    
    [_cell stopTwinkleAnimation];
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 1) {
        
        if ([NSString isEmpty:self.tinyYzgGetBillModel.name]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }else if (section == 1){
        
        if ([NSString isEmpty: self.tinyYzgGetBillModel.name]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }else if ([NSString isEmpty:self.tinyYzgGetBillModel.date]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }else if (row > 0) {
            
            if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                [self startCellTwinkleAnimationWithIndexPath:path];
                return;
            }
        }
        
    }else if (section == 2){
        
        if (row == 0 && self.markBillMore) {
            
            return;
        }
        if (!self.tinyYzgGetBillModel.name) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }else if (!self.tinyYzgGetBillModel.date) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }else  if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
        
    }
    if (section == 0) {
        
        if (row == 0) {
         
            if (_is_Home_ComeIn) {
                
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.tinyYzgGetBillModel];
            
        }else if (row == 1) {
            
            [self showDatePickerByIndexPath:indexPath];
        }
    }else if (section == 1) {
        
        if (row == 0) {
            
            JGJWageLevelViewController *WageLevelVc = [[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];

            WageLevelVc.isChoiceOtherPartyTemplate = self.isChoiceOtherPartyTemplate;
            WageLevelVc.isAgentMonitor = self.isAgentMonitor;
            if (_tinyYzgGetBillModel.set_tpl.hour_type == 0) {
                
                _tinyYzgGetBillModel.set_tpl.o_s_tpl = 0.0;
            }

            WageLevelVc.yzgGetBillModel = _tinyYzgGetBillModel;

            [self.navigationController pushViewController:WageLevelVc animated:YES];

            TYWeakSelf(self);
            WageLevelVc.setWageLevelSuccessWithBillModel = ^(YZGGetBillModel *billModel) {

                weakself.tinyYzgGetBillModel = billModel;
                if (billModel.manhour == 0 && !billModel.isRest) {

                    weakself.tinyYzgGetBillModel.manhour = billModel.set_tpl.w_h_tpl;
                }
                if (billModel.overtime == 0 && !billModel.isOverWork) {

                    weakself.tinyYzgGetBillModel.overtime = 0;
                }

                [weakself setSalary];
            };
            
        }else if (row == 1) {
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.tinyYzgGetBillModel isShowHalfOrOneSelectedView:YES];
            
        }else if (row == 2) {
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.tinyYzgGetBillModel isShowHalfOrOneSelectedView:self.tinyYzgGetBillModel.set_tpl.hour_type == 1 ? NO : YES];

        }else {
            
            [TYShowMessage showPlaint:@"点工工钱是根据工资标准和上班加班时长计算的"];
        }
    }else {
        
        if (row == 0) {
            
            [self showProjectPickerByIndexPath:indexPath];
            
        }else {
            
            [self markBillRemark];
        }
    }
}

- (void)startCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJTinyAmountMarkBillTableViewCell *cell = [self.tinyAmountTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)stopCellTwinkleAnimation {
    
    [_tinyAmountTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc]init];
    [footerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    
    UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewTap)];
    footerView.userInteractionEnabled = YES;
    [footerView addGestureRecognizer:gestur];
    
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
    upLine.backgroundColor = AppFontdbdbdbColor;
    [footerView addSubview:upLine];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5)];
    downLine.backgroundColor = AppFontdbdbdbColor;
    [footerView addSubview:downLine];
    
    if (section == 2) {
        
        downLine.hidden = YES;
        
    }else {
        
        downLine.hidden = NO;
    }
    return footerView;
}

- (void)footerViewTap {
    
    [self.view endEditing:YES];
}
#pragma marl - method
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    
    self.addForemanModel.telph = billModel.phone_num;
    
    self.addForemanModel.uid = billModel.uid;
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
    //返回的时候用
    
    accountingMemberVC.isMarkBill = self.markBillMore;

    if (self.isAgentMonitor) {

        accountingMemberVC.agency_title = @"工人";
        accountingMemberVC.isAgentMonitor = self.isAgentMonitor;
    }
    
    seledAccountMember.name = billModel.name;
    
    seledAccountMember.telph = billModel.phone_num;
    
    seledAccountMember.uid = [NSString stringWithFormat:@"%@", @(billModel.uid)];
    
    accountingMemberVC.seledAccountMember = seledAccountMember;
    
    //返回的时候用
    accountingMemberVC.isGroupMember = YES;

    accountingMemberVC.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员,如果删除之后accoumtMember为nil
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {

        // v3.4.2现在这里 选中人后 通过接口获取新的工资模板
        [self getWorkTplByUidWithUid:accoumtMember.uid accounts_type:@"1" accoumtMember:accoumtMember];

    };
}

- (void)getWorkTplByUidWithUid:(NSString *)uid accounts_type:(NSString *)accounts_type accoumtMember:(JGJSynBillingModel *)accoumtMember{
    
    if (accoumtMember.isDelMember) {
        
        if (JLGisMateBool) {
            
            //删除最后一次记账的数据(工人记工头，删除同一个)
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",JLGUserUid];
            parmDic = [TYUserDefaults objectForKey:key];
            self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
            
            NSString *uid = [NSString stringWithFormat:@"%@", @(self.addForemanModel.uid)];
            
            if ([uid isEqualToString:accoumtMember.uid]) {
                
                [TYUserDefaults removeObjectForKey:key];
            }
            
        }
        
        if (!self.markBillMore) {
            
            self.tinyYzgGetBillModel = [[YZGGetBillModel alloc] init];
            self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
            
        }
        [self.tinyAmountTable reloadData];
        
    }else {
        
        NSDictionary *param = @{
                                @"accounts_type":accounts_type,
                                @"uid":uid
                                };
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
            
            addForemanModel.uid = [accoumtMember.uid integerValue];
            
            addForemanModel.telph = accoumtMember.telph;
            
            addForemanModel.name = accoumtMember.name;
            
            addForemanModel.head_pic = accoumtMember.head_pic;
            addForemanModel.is_not_telph = accoumtMember.is_not_telph;
            JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
            getWorkTplByUidModel.user_name = accoumtMember.real_name;
            
            // 先判断 自己设置考勤模板会对方设置的是否相同
            if (getWorkTplByUidModel.is_diff == 0) {// 表示无差异
                
                self.isChoiceOtherPartyTemplate = NO;
                GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                
                set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                set_tpl.o_s_tpl = getWorkTplByUidModel.my_tpl.o_s_tpl;
                set_tpl.hour_type = getWorkTplByUidModel.my_tpl.hour_type;
                addForemanModel.tpl = set_tpl;
                
                
            }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                
                JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                [diffTplAlertView show];
                
                diffTplAlertView.difTplBill = getWorkTplByUidModel;
                diffTplAlertView.markSlectBtnType = JGJMarkSelectTinyBtnType;
                
                TYWeakSelf(self);
                // 取消
                diffTplAlertView.cancle = ^{// 用自己的工资模板
                    
                    weakself.isChoiceOtherPartyTemplate = NO;
                    GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                    
                    set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                    set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    set_tpl.o_s_tpl = getWorkTplByUidModel.my_tpl.o_s_tpl;
                    set_tpl.hour_type = getWorkTplByUidModel.my_tpl.hour_type;
                    addForemanModel.tpl = set_tpl;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
                
                // 同意
                diffTplAlertView.agree = ^{// 用对方的工资模板
                    
                    weakself.isChoiceOtherPartyTemplate = NO;
                    GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                    
                    // 加班s方式都是按工天的情况下，使用对方模板，金额依然去自己的，否则去对方的
                    set_tpl.s_tpl = (getWorkTplByUidModel.my_tpl.hour_type == 0 && getWorkTplByUidModel.oth_tpl.hour_type == 0) ? getWorkTplByUidModel.my_tpl.s_tpl : getWorkTplByUidModel.oth_tpl.s_tpl;
                    set_tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
//                    set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                    
                    set_tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                    set_tpl.o_s_tpl = getWorkTplByUidModel.oth_tpl.o_s_tpl;
                    set_tpl.hour_type = getWorkTplByUidModel.oth_tpl.hour_type;
                    addForemanModel.tpl = set_tpl;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
            }
            
            _selectedForemanModel = addForemanModel;
            [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
}

- (void)reqeustAccountInfoWithAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    self.addForemanModel = addForemanModel;
    
    self.tinyYzgGetBillModel.name = addForemanModel.name;
    self.tinyYzgGetBillModel.uid = addForemanModel.uid;
    self.tinyYzgGetBillModel.set_tpl = addForemanModel.tpl;
    self.tinyYzgGetBillModel.manhour = addForemanModel.tpl.w_h_tpl;//默认的情况下，工作时长就是模板的时间
    self.tinyYzgGetBillModel.overtime = 0;//移除账单，默认情况下是不加班
    self.tinyYzgGetBillModel.is_not_telph = addForemanModel.is_not_telph;
    self.tinyYzgGetBillModel.phone_num = addForemanModel.telph;
    [self setSalary];

    if (!_markBillMore) {
        
        if (self.tinyYzgGetBillModel.uid) {
            
            [self JLGHttpRequest_LastproWithUid: self.tinyYzgGetBillModel.uid];
        }
    }

}

#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":@"1",
                 @"group_id":self.is_Home_ComeIn ? self.workProListModel.group_id ?:@"":@""
                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
        
        if ([NSString isEmpty: responseObject[@"pro_name"]]) {
            
            self.tinyYzgGetBillModel.proname = self.workProListModel.all_pro_name;
            self.tinyYzgGetBillModel.pid = 0;
            
        }else{
            
            if ([responseObject[@"pro_name"] length] < 2 && _is_Home_ComeIn) {
                
                self.tinyYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                self.tinyYzgGetBillModel.pid = 0;
                
            }else{
                
                self.tinyYzgGetBillModel.proname = responseObject[@"pro_name"]?:@"";
                self.tinyYzgGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
            }
            
        }
        
        [self.tinyAmountTable reloadData];
        
    }failure:^(NSError *error) {
        
    }];
}

- (void)setSalary {
    
    if (!_isChoiceManHourOrOverHour) {
        
        self.tinyYzgGetBillModel.manhour = self.tinyYzgGetBillModel.set_tpl.w_h_tpl;
        self.tinyYzgGetBillModel.overtime = 0.0;
    }
    
    if (self.tinyYzgGetBillModel.set_tpl.hour_type == 0) {
        
        self.tinyYzgGetBillModel.salary = (CGFloat )self.tinyYzgGetBillModel.set_tpl.s_tpl * self.tinyYzgGetBillModel.manhour /self.tinyYzgGetBillModel.set_tpl.w_h_tpl + (CGFloat )self.tinyYzgGetBillModel.set_tpl.s_tpl * self.tinyYzgGetBillModel.overtime/self.tinyYzgGetBillModel.set_tpl.o_h_tpl;
        
    }else {
        
        self.tinyYzgGetBillModel.salary = (CGFloat )self.tinyYzgGetBillModel.set_tpl.s_tpl * self.tinyYzgGetBillModel.manhour /self.tinyYzgGetBillModel.set_tpl.w_h_tpl + self.tinyYzgGetBillModel.set_tpl.o_s_tpl * self.tinyYzgGetBillModel.overtime;
    }
    
    
    self.tinyYzgGetBillModel.salary = [[NSString decimalwithFormat:@"0.00" doubleV:self.tinyYzgGetBillModel.salary] doubleValue];
    
    if (isnan(self.tinyYzgGetBillModel.salary)) {
        
        self.tinyYzgGetBillModel.salary = 0.f;
    }
    
    [self.tinyAmountTable reloadData];
}

- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    
    self.theNewSelectedDataPickerView.isNeddShowMoreDayChoiceBtn = YES;
    
    _theNewSelectedDataPickerView.selectedDate = _selectedDate?:[NSDate date];
    
    [_theNewSelectedDataPickerView show];
    
    _theNewSelectedDataPickerView.choiceData = ^(NSArray *dataArray, NSString *timeStr) {
        
    };
    
}

#pragma mark - JGJNewSelectedDataPickerViewDelegate
- (void)JGJNewSelectedDataPickerViewSelectedDate:(NSDate *)date {
    
    self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:date];
    _selectedDate = date;
    [_tinyAmountTable reloadData];
}

#pragma mark - 记多天
- (void)JGJNewSelectedDataPickerViewClickMoreDayBtn {
    
    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
    [self.theNewSelectedDataPickerView hiddenPicker];

    if (self.isAgentMonitor) {

        moreDay.isAgentMonitor = self.isAgentMonitor;
        moreDay.agency_uid = self.agency_uid;

    }

    // 首页直接进入记单笔或者代班长进入记单笔页面
    if (self.isAgentMonitor || self.is_Home_ComeIn || self.markBillMore) {

        moreDay.WorkCircleProListModel = self.workProListModel;
    }
    moreDay.tinyOrAttentComeIn = 1;
    moreDay.chatType = self.is_Home_ComeIn;
    moreDay.isMarkMoreBill = self.markBillMore;
    YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
    JlgGetBillModel = self.tinyYzgGetBillModel;
    moreDay.JlgGetBillModel = JlgGetBillModel;
    moreDay.selBtnType = JGJRecordSelLeftBtnType;
    [self.navigationController pushViewController:moreDay animated:YES];
}

#pragma mark - 选择上班时间
- (void)selectManHourTime:(NSString *)Manhour {
    
    _isChoiceManHourOrOverHour = YES;
    self.tinyYzgGetBillModel.manhour = [Manhour floatValue];
    if ([Manhour floatValue] == 0) {
        
        self.tinyYzgGetBillModel.isRest = YES;
    }
    [self setSalary];
}
#pragma mark - 选择加班时间
- (void)selectOverHour:(NSString *)overTime {
    
    _isChoiceManHourOrOverHour = YES;
    self.tinyYzgGetBillModel.overtime = [overTime floatValue];
    if ([overTime floatValue] == 0) {
        
        self.tinyYzgGetBillModel.isOverWork = YES;
    }
    [self setSalary];
    
    
}

#pragma mark - 快捷选择上班 加班时长
- (void)manHourViewSelectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime {
    
    _isChoiceManHourOrOverHour = YES;
    if (isManHourTime) {// 上班时间选择
        
        self.tinyYzgGetBillModel.manhour = [timeSelected floatValue];
        if ([timeSelected floatValue] == 0) {
            
            self.tinyYzgGetBillModel.isRest = YES;
        }
        [self setSalary];
    }else {
        
        self.tinyYzgGetBillModel.overtime = [timeSelected floatValue];
        if ([timeSelected floatValue] == 0) {
            self.tinyYzgGetBillModel.isOverWork = YES;
        }
        [self setSalary];
    }
}

#pragma mark - 选择项目
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    
    //聊天并且自己是创建者的时候，不能选择项目
    if ([self.workProListModel.myself_group boolValue]) {
        
        return;
    }
    
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    projectVC.isMarkSingleBillComeIn = YES;
    projectVC.projectListVCDelegate = self;
    projectVC.billModel = self.tinyYzgGetBillModel;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
  
    self.tinyYzgGetBillModel.proname = projectModel.pro_name;
    self.tinyYzgGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.tinyAmountTable reloadData];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.tinyYzgGetBillModel.proname = @"";
    self.tinyYzgGetBillModel.pid     = 0;
    [self.tinyAmountTable reloadData];
    
}

#pragma mark - 备注
- (void)markBillRemark{
    
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    self.tinyYzgGetBillModel.accounts_type.code = 1;
    
    otherInfoVc.yzgGetBillModel = self.tinyYzgGetBillModel;
    
    otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
    otherInfoVc.yzgGetBillModel.role = JLGisLeaderBool ? 1:2;
    otherInfoVc.imagesArray = self.remarkImagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.remarkImagesArray = images;
    self.tinyYzgGetBillModel.notes_img = images.copy;
    self.tinyYzgGetBillModel.notes_txt = remarkText;
    [self.tinyAmountTable reloadData];
}

#pragma mark - 提交点工数据到服务器
- (void)pushTinyAmountBillDataToServer {
    
    [self.view endEditing:YES];
    if (!self.tinyYzgGetBillModel.name) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
        
    }else if (!self.tinyYzgGetBillModel.date) {
        
        [TYShowMessage showPlaint:@"请先选择记账日期"];
        return;
    }else  if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    self.yzgGetBillModel = self.tinyYzgGetBillModel;
    
    self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
    
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
    
    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
    //只获取日期
    if ([NSString isEmpty:self.yzgGetBillModel.date]) {
        
        self.yzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
    }
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    self.parametersDic[@"accounts_type"] = @1;
    self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
    self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
    self.parametersDic[@"salary_tpl"] = @(self.yzgGetBillModel.set_tpl.s_tpl);
    self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.w_h_tpl);
    self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.o_h_tpl);
    self.parametersDic[@"overtime_salary_tpl"] = @(self.yzgGetBillModel.set_tpl.o_s_tpl);
    self.parametersDic[@"hour_type"] = @(self.yzgGetBillModel.set_tpl.hour_type);
    
    if (_is_Home_ComeIn) {
        [self.parametersDic setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [self.parametersDic setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [self.parametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
    self.theLastToServerPramedic = self.parametersDic;
    
    [self submitDateToServerWithParametersDicRelase:self.theLastToServerPramedic dataArray:self.tinyYzgGetBillModel.dataArr dataNameArray:self.tinyYzgGetBillModel.dataNameArr];
    
}

- (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray {
    
    NSString *jesonPa = [@[parametersDicRelase] mj_JSONString];
    NSMutableDictionary *parameDic = [[NSMutableDictionary alloc] init];
    
    [parameDic setObject:jesonPa forKey:@"info"];
    if ([_is_next_act integerValue] == 1) {
        
        [parameDic setObject:@"1" forKey:@"is_next_act"];
        
        if (![NSString isEmpty:self.workProListModel.group_id]) {
            
            [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];
            
        }
        
        if (![NSString isEmpty:self.agency_uid]) {
            
            [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
            
        }
        
    }else {
        
        if (![NSString isEmpty:self.workProListModel.group_id]) {
            
            [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];
        }
        
        if (![NSString isEmpty:self.agency_uid]) {
            
            [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
        }
    }
    
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parameDic imagearray:self.remarkImagesArray otherDataArray:[self.yzgGetBillModel.dataArr copy] dataNameArray:[self.yzgGetBillModel.dataNameArr copy] success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"is_exist"] integerValue] == 1) {
            
            _is_next_act = dic[@"is_next_act"];
            _treadid = dic[@"record_id"];
            _date = dic[@"date"];
            _uid = dic[@"uid"];
            _accounts_type = dic[@"accounts_type"];
            [self gotoTransfVcAndTitle:dic[@"msg"]];
            
            return ;
        }
        
        // 保存本次记账信息
        [self saveLastRecordBill];
        
        _isSaveToServerSuccess = YES;
        _isClearEditMoney = YES;
        
        
        // 记账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
        // v3.4.1 cc 添加
        if (JLGisLeaderBool) {// 工头角色 判断当前所选的项目是否有班组,这种判断只会在第一次给工人记工且选择的项目没有班组时出现
            
            // 判断项目没有创建班组提示是否弹出过
            NSString *proIsALert = [TYUserDefaults objectForKey:@"proIsALertKey"];
            NSArray *proArr = [proIsALert componentsSeparatedByString:@","];
            NSString *currentPid = [NSString stringWithFormat:@"%@",self.parametersDic[@"pid"]];
            BOOL isHaveAlert = NO;
            for (NSString *alertPid in proArr) {
                
                if ([alertPid isEqualToString:currentPid]) {
                    
                    isHaveAlert = YES;
                    break;
                }
            }
            //group_id 1:表示有班组，0:表示没有班组 如果是全局是工人角色，不会返回此字段
            NSString *group_id = responseObject[@"group_id"];
            NSDictionary *dic = responseObject;
            if ([group_id integerValue] == 0 && dic.allKeys.count > 0 && !isHaveAlert) { // 这里加个控制 只弹出一次
                
                NSString *hasAlertProStr;
                if ([NSString isEmpty:proIsALert]) {
                    
                    hasAlertProStr = [NSString stringWithFormat:@"%@",self.parametersDic[@"pid"]];
                    
                }else {
                    
                    hasAlertProStr = [NSString stringWithFormat:@"%@,%@",proIsALert,self.parametersDic[@"pid"]];
                }
                
                [TYUserDefaults setObject:hasAlertProStr forKey:@"proIsALertKey"];
                
                JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
                
                desModel.popDetail = [NSString stringWithFormat:@"如果你对[%@]项目新建一个班组，添加成员后，就可以对所有工人批量记工了。\n新建班组吗？",self.yzgGetBillModel.proname];
                desModel.leftTilte = @"取消";
                desModel.rightTilte = @"新建班组";
                JGJCusSeniorPopView *alertView = [JGJCusSeniorPopView showWithMessage:desModel];
                alertView.isMarkSingleBillComeIn = YES;
                
                __weak typeof(self) weakSelf = self;
                // 新建班组
                alertView.onOkBlock = ^{
                    
                    JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
                    
                    JGJProjectListModel *accountProModel = [JGJProjectListModel new];
                    
                    accountProModel.pro_name = self.yzgGetBillModel.proname;
                    
                    accountProModel.pro_id = [NSString stringWithFormat:@"%ld",self.yzgGetBillModel.pid];
                    
                    creatTeamVC.accountProModel = accountProModel;
                    
                    [weakSelf manegerCleanCurrentPageData];
                    [self.navigationController pushViewController:creatTeamVC animated:YES];
                };
                
                // 取消
                alertView.leftButtonBlock = ^{
                    
                    [weakSelf manegerCleanCurrentPageData];
                    
                };
                
                return;
            }
            
        }
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popTextAlignment = NSTextAlignmentCenter;
        desModel.lineSapcing = 4;
        JGJCusAlertView *alerView = [JGJCusAlertView cusAlertViewShowWithDesModel:desModel];
        
        // 工人登陆点击左侧按钮为再记一笔事件/右侧按钮为返回上级事件，班组长登陆则相反 3.1.0v cc修改
        if (JLGisMateBool) {
            
            TYLog(@"工人登陆");
            alerView.customLeftButtonAlertViewBlock = ^{
                
                TYLog(@"再记一笔");
                if (!_oneDayAttendanceComeIn) {// 不是每日考勤进入 清除日期
                
                    _selectedDate = nil;
                    
                }
                
                YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
                oldBillModel.proname = self.yzgGetBillModel.proname;
                oldBillModel.pid = self.yzgGetBillModel.pid;
                oldBillModel.name = self.yzgGetBillModel.name;
                oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
                oldBillModel.unit_quan_tpl = self.yzgGetBillModel.unit_quan_tpl;
                
                //如果是从聊天进入  则荏苒要默认工头名字
                if (_is_Home_ComeIn) {
                    
                    [self mainGoinGetTPL];
                    
                }else{
                    
                    self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
                    
                    if (_markBillMore) {
                        
                        self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
                        self.yzgGetBillModel.pid = oldBillModel.pid;
                    }
                    self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
                    [self.tinyAmountTable reloadData];
                    
                }
            };
            
            alerView.customRightButtonAlertViewBlock = ^{//返回上级
                BOOL isHave = NO;
                if (self.markBillMore) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        
                        if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]) {
                            
                            isHave = YES;
                            break;
                            
                        }else if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]){
                            
                            
                            isHave = YES;
                            break;
                        }else if ([vc isKindOfClass:[JGJMorePeopleViewController class]]){
                            
                            
                            isHave = YES;
                            break;
                        }
                    }
                    if (!isHave) {
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            };
            
            
        }else {
            
            TYLog(@"班组长登陆");
            alerView.customLeftButtonAlertViewBlock = ^{
                
                BOOL isHave = NO;
                TYLog(@"返回上一级");
                if (self.markBillMore) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        
                        if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]) {
                            
                            isHave = YES;
                            break;
                            
                        }else if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]){
                            
                            
                            isHave = YES;
                            break;
                        }else if ([vc isKindOfClass:[JGJMorePeopleViewController class]]){
                            
                            
                            isHave = YES;
                            break;
                        }
                    }
                    
                    if (!isHave) {
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }else {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            
            alerView.customRightButtonAlertViewBlock = ^{//再记一笔
                
                [self manegerCleanCurrentPageData];
            };
            
        }
        if (self.remarkImagesArray) {
            
            [self.remarkImagesArray removeAllObjects];
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

// 班组长清除当前页面数据
- (void)manegerCleanCurrentPageData {
    
    if (!_oneDayAttendanceComeIn) {
        
        _selectedDate = nil;
    }
    YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
    oldBillModel.proname = self.yzgGetBillModel.proname;
    oldBillModel.pid = self.yzgGetBillModel.pid;
    oldBillModel.name = self.yzgGetBillModel.name;
    oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    _isClearEditMoney = YES;
    //如果是从聊天进入  则荏苒要默认工头名字
    if (_markBillMore) {
        
#pragma mark - 添加
        self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.tinyYzgGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.tinyAmountTable reloadData];
        
    }else{
        
        self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
        
        if (_markBillMore) {
            
            self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
            self.yzgGetBillModel.pid = oldBillModel.pid;
        }
        self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        
        [self.tinyAmountTable reloadData];
        
    }
    if (self.remarkImagesArray) {
        
        [self.remarkImagesArray removeAllObjects];
    }
}
- (void)gotoTransfVcAndTitle:(NSString *)title{
    
    // 可以继续走接口
    if ([_is_next_act integerValue] == 1) {
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"取消",@"继续保存", nil];
        [alert setButtonTitleColor:AppFont000000Color fontSize:AppFont30Size atIndex:0];
        [alert setButtonTitleColor:AppFontEB4E4EColor fontSize:AppFont30Size atIndex:1];
        alert.messageLabel.textAlignment = NSTextAlignmentLeft;
        [alert.messageLabel setAttributedStringText:title lineSapcing:5];
        alert.messageLabel.textColor = AppFont000000Color;
        alert.messageLabel.font = FONT(AppFont32Size);
        alert.messageLabelOffset = 35;
        alert.isHiddenDeleteBtn = YES;
        [alert show];
        
    }else {
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"查看该记账", nil];
        alert.messageLabel.textAlignment = NSTextAlignmentLeft;
        alert.messageLabel.font = FONT(AppFont32Size);
        alert.messageLabel.textColor = AppFont000000Color;
        alert.messageLabelOffset = 35;
        [alert show];
    }
    
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([_is_next_act integerValue] == 1) {
        
        if (buttonIndex == 1) {
            
            [self submitDateToServerWithParametersDicRelase:self.theLastToServerPramedic dataArray:self.tinyYzgGetBillModel.dataArr dataNameArray:self.tinyYzgGetBillModel.dataNameArr];
            
        }else {
            
            _is_next_act = nil;
        }
    }else {// 已经记过两笔账了，根据有无uid去判断界面跳转，有uid跳待确认，没有跳每日考勤界面
        
        if (_uid == nil) {
            
            if (self.isAgentMonitor) {
                
                JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
                recordWorkpointsVc.proListModel = self.workProListModel;
                [self.navigationController pushViewController:recordWorkpointsVc animated:YES];
                
            }else {
                
                YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
                yzgMateWorkitemsVc.searchDate = [NSDate dateFromString:_date withDateFormat:@"yyyyMMdd"];
                [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
            }
            
        }else {
            
            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = _date;
            poorBillVC.uid = _uid;
            
            if (self.isAgentMonitor) {
                
                poorBillVC.agency_uid = self.agency_uid;
                poorBillVC.group_id = self.workProListModel.group_id;
                
            }
            
            [self.navigationController pushViewController:poorBillVC animated:YES];
            
        }
        
    }
    
    [alertView hide];
    alertView.delegate = nil;
    alertView = nil;
    
}

// alertView消失时
- (void)alertViewHide {
    
    _is_next_act = nil;
}

#pragma mark -保存最近一次非班组项目组的记账人信息
- (void)saveLastRecordBill {
    
    if (JLGisLeaderBool || _markBillMore) {// 当前是工头身份

        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(1) forKey:@"accounts_type"];
        [dic setObject:self.tinyYzgGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.tinyYzgGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:@(self.tinyYzgGetBillModel.manhour)?:@"" forKey:@"manhour"];
        [dic setObject:self.tinyYzgGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.tinyYzgGetBillModel.pid)?:@"" forKey:@"pid"];
        [dic setObject:@(self.tinyYzgGetBillModel.isRest) forKey:@"isRest"];
        [dic setObject:@(1)?:@"" forKey:@"MakrBillIsLeaderBool"];// 保留上次记账身份
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordLeaderBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        [TYUserDefaults setObject:dic forKey:key];
        
    }else {// 当前身份是工人身份
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(1) forKey:@"accounts_type"];
        [dic setObject:self.tinyYzgGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.tinyYzgGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:@(self.tinyYzgGetBillModel.manhour)?:@"" forKey:@"manhour"];
        [dic setObject:self.tinyYzgGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.tinyYzgGetBillModel.pid)?:@"" forKey:@"pid"];
        [dic setObject:@(self.tinyYzgGetBillModel.isRest) forKey:@"isRest"];
        [dic setObject:@(0)?:@"" forKey:@"MakrBillIsLeaderBool"];// 保留上次记账身份
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        [TYUserDefaults setObject:dic forKey:key];
        
    }
    
}

#pragma mark - 首页进入记账获取薪资模板
- (void)mainGoinGetTPL {
    
    NSString *postApi = @"workday/fm-list";
    
    NSDictionary *parameters = @{@"uid":self.workProListModel.creater_uid?:@"",
                                 @"group_id":self.workProListModel.group_id?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:postApi parameters:parameters success:^(NSArray *responseObject) {
        
        GetBillSet_Tpl *bill_Tpl = [GetBillSet_Tpl mj_objectWithKeyValues:responseObject[0][@"tpl"]];
        bill_Tpl.s_tpl = bill_Tpl.s_tpl;
        bill_Tpl.o_h_tpl = bill_Tpl.o_h_tpl;
        bill_Tpl.w_h_tpl = bill_Tpl.w_h_tpl;

        
        self.tinyYzgGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.tinyYzgGetBillModel.set_tpl = bill_Tpl;
        self.tinyYzgGetBillModel.manhour = self.tinyYzgGetBillModel.set_tpl.w_h_tpl;
        self.tinyYzgGetBillModel.overtime = 0;
        self.tinyYzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        //yj添加
        self.tinyYzgGetBillModel.phone_num = responseObject[0][@"telph"];
        
        [self setSalary];
        [self.tinyAmountTable reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}
#pragma getter/setter
- (UITableView *)tinyAmountTable {
    
    if (!_tinyAmountTable) {
        
        _tinyAmountTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tinyAmountTable.backgroundColor = AppFontf1f1f1Color;
        _tinyAmountTable.showsVerticalScrollIndicator = NO;
        _tinyAmountTable.delegate = self;
        _tinyAmountTable.dataSource = self;
        _tinyAmountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tinyAmountTable.tableFooterView = [[UIView alloc] init];
        _tinyAmountTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        _tinyAmountTable.bounces = NO;
    }
    return _tinyAmountTable;
}

- (JGJMarkBillBottomSaveView *)bottomSaveView {
    
    if (!_bottomSaveView) {
        
        _bottomSaveView = [[JGJMarkBillBottomSaveView alloc] init];
        
    }
    return _bottomSaveView;
}

- (JGJNewSelectedDataPickerView *)theNewSelectedDataPickerView {
    
    if (!_theNewSelectedDataPickerView) {
        
        _theNewSelectedDataPickerView = [[JGJNewSelectedDataPickerView alloc] init];
        _theNewSelectedDataPickerView.pickerDelegate = self;
        _theNewSelectedDataPickerView.isNeedShowToday = YES;
        if (self.isAgentMonitor) {

            _theNewSelectedDataPickerView.isAgentMonitor  = self.isAgentMonitor;
            _theNewSelectedDataPickerView.start_time = self.workProListModel.agency_group_user.start_time;
            _theNewSelectedDataPickerView.end_Time = self.workProListModel.agency_group_user.end_time;
        }

    }
    return _theNewSelectedDataPickerView;
}

- (YZGGetBillModel *)tinyYzgGetBillModel{
    
    if (!_tinyYzgGetBillModel) {
    
        _tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _tinyYzgGetBillModel;
}

- (YZGGetBillModel *)yzgGetBillModel {
    
    if (!_yzgGetBillModel) {
        
        _yzgGetBillModel = [[YZGGetBillModel alloc] init];
    }
    return _yzgGetBillModel;
}
- (NSMutableArray *)remarkImagesArray {
    
    if (!_remarkImagesArray) {
        
        _remarkImagesArray = [NSMutableArray new];
    }
    return _remarkImagesArray;
}

- (NSMutableDictionary *)theLastToServerPramedic {
    
    if (!_theLastToServerPramedic) {
        
        _theLastToServerPramedic = [[NSMutableDictionary alloc] init];
    }
    return _theLastToServerPramedic;
}

- (NSMutableDictionary *)parametersDic {
    
    if (!_parametersDic) {
        
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}
@end
