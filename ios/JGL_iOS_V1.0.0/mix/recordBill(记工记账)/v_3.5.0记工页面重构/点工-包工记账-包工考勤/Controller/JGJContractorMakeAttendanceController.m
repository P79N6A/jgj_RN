//
//  JGJContractorMakeAttendanceController.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAttendanceController.h"
#import "JGJContractorListAttendanceTemplateController.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJMarkBillRemarkViewController.h"

#import "JGJMarkBillBottomSaveView.h"
#import "JGJNewSelectedDataPickerView.h"
#import "JGJWorkTplHaveDiffAlertView.h"
#import "JGJContractorMakeAttendanceNormalCell.h"
#import "JGJManHourPickerView.h"
#import "UILabel+GNUtil.h"
#import "JGJCusSeniorPopView.h"
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
@interface JGJContractorMakeAttendanceController ()
<UITableViewDelegate,UITableViewDataSource,JGJNewSelectedDataPickerViewDelegate,JGJManHourPickerViewDelegate,JGJNewMarkBillChoiceProjectViewControllerDelgate,JGJMarkBillRemarkViewControllerDelegate,FDAlertViewDelegate>
{
    JGJContractorMakeAttendanceNormalCell *_normalCell;
    YZGAddForemanModel *_selectedForemanModel;
    BOOL _isChoiceManHourOrOverHour;
}
@property (nonatomic, strong) UITableView *attendanceTable;// 包工记考勤列表
@property (nonatomic, strong) JGJMarkBillBottomSaveView *bottomSaveView;// 底部保存按钮

@property (nonatomic,strong) NSMutableArray *remarkImagesArray;// 备注图片数组

@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;// 日期选择器
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;


@property (nonatomic, strong) NSMutableDictionary *theLastToServerPramedic;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;

@property (nonatomic,strong)  NSString *treadid;
@property (nonatomic, strong) NSString *is_next_act;
@property (nonatomic, strong) NSString *accounts_type;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *uid;
@end

@implementation JGJContractorMakeAttendanceController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self initializeAppearance];
    
    self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
    
    // 获取上次记账信息
    [self initLastRecordNews];
}

- (void)initLastRecordNews {
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    if (!JLGisLeaderBool) {
        
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        parmDic = [TYUserDefaults objectForKey:key];
        
        if (parmDic && [parmDic[@"accounts_type"] integerValue] == 5  && !_markBillMore && !_is_Home_ComeIn) {// 本地有记账信息 且上笔账的身份信息和当前身份信息一致 班组长身份不取值 只选中类型
            
            YZGGetBillModel *billModel = [YZGGetBillModel mj_objectWithKeyValues:parmDic];
            self.attendanceGetBillModel.name = billModel.name;
            self.attendanceGetBillModel.uid = billModel.uid;
            self.attendanceGetBillModel.proname = billModel.proname;
            self.attendanceGetBillModel.pid = billModel.pid;
            self.attendanceGetBillModel.manhour = billModel.manhour;
            self.attendanceGetBillModel.isRest = billModel.isRest;
            
            if (self.attendanceGetBillModel.uid == 0) {
                
                return;
            }
            NSDictionary *param = @{
                                    @"accounts_type":@"5",
                                    @"uid":@(self.attendanceGetBillModel.uid)
                                    };
            [TYLoadingHub showLoadingWithMessage:nil];
            [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
                
                [TYLoadingHub hideLoadingView];
                
                JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
                getWorkTplByUidModel.user_name = self.attendanceGetBillModel.name;
                
                // 先判断 自己设置考勤模板会对方设置的是否相同
                if (getWorkTplByUidModel.is_diff == 0) {// 表示无差异
                    
                    GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                    quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    
                    self.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                    [self.attendanceTable reloadData];
                    
                }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                    
                    JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                    [diffTplAlertView show];
                    
                    diffTplAlertView.difTplBill = getWorkTplByUidModel;
                    diffTplAlertView.markSlectBtnType = JGJMarkSelectContractBtnType;
                    
                    TYWeakSelf(self);
                    // 取消
                    diffTplAlertView.cancle = ^{// 用自己的工资模板
                        
                        GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                        quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                        quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                        
                        self.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                        [self.attendanceTable reloadData];
                    };
                    
                    // 同意
                    diffTplAlertView.agree = ^{// 用对方的工资模板
                        
                        GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                        quan_Tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                        quan_Tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                        
                        self.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                        [self.attendanceTable reloadData];
                    };
                }
                
                
                
            } failure:^(NSError *error) {
                
                [TYLoadingHub hideLoadingView];
            }];
            
            // 获取最后一次的记账项目
            if (!_markBillMore) {
                
                [self JLGHttpRequest_LastproWithUid: self.attendanceGetBillModel.uid];
            }
        }
    }
   
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomSaveView];
    [self.view addSubview:self.attendanceTable];
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
    
    [_attendanceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_bottomSaveView.mas_top).offset(0);
        make.left.right.top.mas_equalTo(0);
    }];
    
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    
    if (self.markBillMore) {//几多人进来
        if (!_workProListModel) {
            
            _workProListModel = [[JGJMyWorkCircleProListModel alloc]init];
        }
        _workProListModel = workProListModel;
        self.attendanceGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.attendanceGetBillModel.pid = [workProListModel.pro_id?:@"0" longLongValue];
        
    }
    
    if (_is_Home_ComeIn) {
        
        self.attendanceGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.attendanceGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.attendanceGetBillModel.name = workProListModel.creater_name?:@"";
        self.attendanceGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
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
        
        return 3;
        
    }else {
        
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _normalCell = [JGJContractorMakeAttendanceNormalCell cellWithTableViewNotXib:tableView];
    _normalCell.is_Home_ComeIn = self.is_Home_ComeIn;
    _normalCell.isAgentMonitor = self.isAgentMonitor;
    _normalCell.markBillMore = _markBillMore;
    _normalCell.cellTag = indexPath.section * 10 + indexPath.row;
    _normalCell.yzgGetBillModel = self.attendanceGetBillModel;
    
    [_normalCell stopTwinkleAnimation];
    return _normalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 1) {
        
        if ([NSString isEmpty:self.attendanceGetBillModel.name]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }else if (section == 1){
        
        if (row == 0 || row == 1 || row == 2) {
            
            if ([NSString isEmpty: self.attendanceGetBillModel.name]) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                [self startCellTwinkleAnimationWithIndexPath:path];
                return;
                
            }else if ((!self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl || !self.attendanceGetBillModel.unit_quan_tpl.o_h_tpl || self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl < 0) && row != 0) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                [self startCellTwinkleAnimationWithIndexPath:path];
                return;
            }
        }
        
    }else if (section == 2){
        
        if (row == 0 && self.markBillMore) {
            
            return;
        }
        
        if (!self.attendanceGetBillModel.name) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }else if (!self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl || !self.attendanceGetBillModel.unit_quan_tpl.o_h_tpl || self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl < 0) {
            
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
            [self handleAddForemanAdnMateVcWithModel:self.attendanceGetBillModel];
            
        }else if (row == 1) {
            
            [self showDatePickerByIndexPath:indexPath];
        }
    }else if (section == 1) {
        
        if (row == 0) {
            
            JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
            
            templateVC.yzgGetBillModel = self.attendanceGetBillModel;
            [self.navigationController pushViewController:templateVC animated:YES];
            
            __weak typeof(self) weakSelf = self;
            __strong typeof(self) strongSelf = self;
            templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
                
                weakSelf.attendanceGetBillModel = yzgGetBillModel;
                
                if (!strongSelf -> _isChoiceManHourOrOverHour) {
                    
                    weakSelf.attendanceGetBillModel.manhour = yzgGetBillModel.unit_quan_tpl.w_h_tpl;
                    weakSelf.attendanceGetBillModel.overtime = 0.0;
                }
                [weakSelf.attendanceTable reloadData];
            };
            
        }else if (row == 1) {
            
            self.attendanceGetBillModel.set_tpl.w_h_tpl = 0.0;
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.attendanceGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
            
        }else {
            
            self.attendanceGetBillModel.set_tpl.o_h_tpl = 0.0;
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.attendanceGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
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
    
    JGJContractorMakeAttendanceNormalCell *cell = [self.attendanceTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)stopCellTwinkleAnimation {
    
    [_attendanceTable reloadData];
}

#pragma mark - method
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    
    self.addForemanModel.telph = billModel.phone_num;
    
    self.addForemanModel.uid = billModel.uid;
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //返回的时候用
    
    accountingMemberVC.isMarkBill = self.markBillMore;
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
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
        
        [self getWorkTplByUidWithUid:accoumtMember.uid accounts_type:@"5" accoumtMember:accoumtMember];
//        if (accoumtMember.isDelMember) {
//
//            if (JLGisMateBool) {
//
//                //删除最后一次记账的数据(工人记工头，删除同一个)
//                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",JLGUserUid];
//                parmDic = [TYUserDefaults objectForKey:key];
//                self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
//
//                NSString *uid = [NSString stringWithFormat:@"%@", @(self.addForemanModel.uid)];
//
//                if ([uid isEqualToString:accoumtMember.uid]) {
//
//                    [TYUserDefaults removeObjectForKey:key];
//                }
//
//            }
//
//
//            if (!weakSelf.markBillMore) {
//
//                weakSelf.attendanceGetBillModel = [[YZGGetBillModel alloc] init];
//                weakSelf.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
//
//            }
//            [self.attendanceTable reloadData];
//
//        }else{
//
//            // v3.4.2现在这里 选中人后 通过接口获取新的工资模板
//            [self getWorkTplByUidWithUid:accoumtMember.uid accounts_type:@"5" accoumtMember:accoumtMember];
//        }
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
            
            self.attendanceGetBillModel = [[YZGGetBillModel alloc] init];
            self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
            
        }
        [self.attendanceTable reloadData];
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
                
                GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                
                self.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                self.attendanceGetBillModel.manhour = getWorkTplByUidModel.my_tpl.w_h_tpl;
                self.attendanceGetBillModel.overtime = 0;
                self.attendanceGetBillModel.isRest = NO;
                self.attendanceGetBillModel.isOverWork = NO;
                [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
                
            }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                
                JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                [diffTplAlertView show];
                diffTplAlertView.difTplBill = getWorkTplByUidModel;
                diffTplAlertView.markSlectBtnType = JGJMarkSelectContractBtnType;
                
                TYWeakSelf(self);
                // 取消
                diffTplAlertView.cancle = ^{// 用自己的考勤模板
                    
                    GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                    quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    
                    weakself.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                    weakself.attendanceGetBillModel.manhour = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    weakself.attendanceGetBillModel.overtime = 0;
                    weakself.attendanceGetBillModel.isRest = NO;
                    weakself.attendanceGetBillModel.isOverWork = NO;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
                
                // 同意
                diffTplAlertView.agree = ^{// 用对方的考勤模板
                    
                    GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                    quan_Tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                    quan_Tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                    
                    weakself.attendanceGetBillModel.unit_quan_tpl = quan_Tpl;
                    weakself.attendanceGetBillModel.manhour = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                    weakself.attendanceGetBillModel.overtime = 0;
                    weakself.attendanceGetBillModel.isRest = NO;
                    weakself.attendanceGetBillModel.isOverWork = NO;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
            }
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
}

- (void)reqeustAccountInfoWithAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    self.addForemanModel = addForemanModel;
    self.attendanceGetBillModel.name = addForemanModel.name;
    self.attendanceGetBillModel.uid = addForemanModel.uid;
    self.attendanceGetBillModel.is_not_telph = addForemanModel.is_not_telph;
    self.attendanceGetBillModel.phone_num = addForemanModel.telph;
    [_attendanceTable reloadData];
    
    if (!_markBillMore) {
        
        if (self.attendanceGetBillModel.uid) {
            
            [self JLGHttpRequest_LastproWithUid: self.attendanceGetBillModel.uid];
        }
    }
}
#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":@"5",
                 @"group_id":self.is_Home_ComeIn ? self.workProListModel.group_id ?:@"":@""
                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
        
        if ([NSString isEmpty: responseObject[@"pro_name"]]) {
            
            self.attendanceGetBillModel.proname = self.workProListModel.all_pro_name;
            self.attendanceGetBillModel.pid = 0;
            
        }else{
            
            if ([responseObject[@"pro_name"] length] < 2 && _is_Home_ComeIn) {
                
                self.attendanceGetBillModel.proname = self.workProListModel.all_pro_name;
                self.attendanceGetBillModel.pid = 0;
                
            }else{
                
                self.attendanceGetBillModel.proname = responseObject[@"pro_name"]?:@"";
                self.attendanceGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
            }
            
        }
        
        [self.attendanceTable reloadData];
        
    }failure:^(NSError *error) {
        
    }];
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
    
    self.attendanceGetBillModel.date = [NSString getWeekDaysString:date];
    _selectedDate = date;
    [_attendanceTable reloadData];
}


#pragma mark - 选择上班时间
- (void)selectManHourTime:(NSString *)Manhour {
    
    _isChoiceManHourOrOverHour = YES;
    self.attendanceGetBillModel.manhour = [Manhour floatValue];
    if ([Manhour floatValue] == 0) {
        
        self.attendanceGetBillModel.isRest = YES;
    }
    
    [self.attendanceTable reloadData];
    
    
}
#pragma mark - 选择加班时间
- (void)selectOverHour:(NSString *)overTime {
    
    _isChoiceManHourOrOverHour = YES;
    self.attendanceGetBillModel.overtime = [overTime floatValue];
    if ([overTime floatValue] == 0) {
        
        self.attendanceGetBillModel.isOverWork = YES;
    }
    
    [self.attendanceTable reloadData];
    
}

#pragma mark - 快捷选择上班 加班时长
- (void)manHourViewSelectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime {
    
    _isChoiceManHourOrOverHour = YES;
    if (isManHourTime) {// 上班时间选择
        
        self.attendanceGetBillModel.manhour = [timeSelected floatValue];
        if ([timeSelected floatValue] == 0) {
            
            self.attendanceGetBillModel.isRest = YES;
        }
        
        [self.attendanceTable reloadData];
        
    }else {
        
        self.attendanceGetBillModel.overtime = [timeSelected floatValue];
        if ([timeSelected floatValue] == 0) {
            
            self.attendanceGetBillModel.isOverWork = YES;
        }
        
        [self.attendanceTable reloadData];
    }
}


#pragma mark - 选择项目
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath {
    
    //聊天并且自己是创建者的时候，不能选择项目
    if ([self.workProListModel.myself_group boolValue]) {
        
        return;
    }
    
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    projectVC.isMarkSingleBillComeIn = YES;
    projectVC.projectListVCDelegate = self;
    projectVC.billModel = self.attendanceGetBillModel;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.attendanceGetBillModel.proname = projectModel.pro_name;
    self.attendanceGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.attendanceTable reloadData];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.attendanceGetBillModel.proname = @"";
    self.attendanceGetBillModel.pid     = 0;
    [self.attendanceTable reloadData];
    
}
#pragma mark - 备注
- (void)markBillRemark {
    
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    self.attendanceGetBillModel.accounts_type.code = 2;
    otherInfoVc.yzgGetBillModel = self.attendanceGetBillModel;
    
    otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
    otherInfoVc.yzgGetBillModel.role = JLGisLeaderBool ? 1:2;
    otherInfoVc.imagesArray = self.remarkImagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.remarkImagesArray = images;
    self.attendanceGetBillModel.notes_img = images.copy;
    self.attendanceGetBillModel.notes_txt = remarkText;
    [self.attendanceTable reloadData];
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

#pragma mark - 提交包工记工天数据到服务器
- (void)pushTinyAmountBillDataToServer {
    
    [self.view endEditing:YES];
    if ([NSString isEmpty: self.attendanceGetBillModel.name ]) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    
    if (self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl == 0 || self.attendanceGetBillModel.unit_quan_tpl.o_h_tpl == 0) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    self.yzgGetBillModel = self.attendanceGetBillModel;
    
    self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
    
    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
    //只获取日期
    if ([NSString isEmpty:self.yzgGetBillModel.date]) {
        
        self.yzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
    }
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    
    self.parametersDic[@"accounts_type"] = @(5);
    self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
    self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
    self.parametersDic[@"pro_name"] = self.yzgGetBillModel.proname ? :@"";
    self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.unit_quan_tpl.w_h_tpl);
    self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.unit_quan_tpl.o_h_tpl);
    self.parametersDic[@"salary_tpl"] = @(0);
    
    if (_is_Home_ComeIn) {
        
        [self.parametersDic setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [self.parametersDic setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [self.parametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
    self.theLastToServerPramedic = self.parametersDic;
    
    
    [self submitDateToServerWithParametersDicRelase:self.parametersDic dataArray:self.attendanceGetBillModel.dataArr dataNameArray:self.attendanceGetBillModel.dataNameArr];
    
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
                if (!_oneDayAttendanceComeIn) {
                    
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
                    
                    self.attendanceGetBillModel = [[YZGGetBillModel alloc]init];
                    
                    if (_markBillMore) {
                        
                        self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
                        self.yzgGetBillModel.pid = oldBillModel.pid;
                    }
                    self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
                    [self.attendanceTable reloadData];
                    
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
    //如果是从聊天进入  则荏苒要默认工头名字
    if (_markBillMore) {
        
#pragma mark - 添加
        self.attendanceGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.attendanceGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.attendanceGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.attendanceTable reloadData];
        
    }else{
        
        self.attendanceGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        
        [self.attendanceTable reloadData];
        
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
            
            [self submitDateToServerWithParametersDicRelase:self.theLastToServerPramedic dataArray:self.attendanceGetBillModel.dataArr dataNameArray:self.attendanceGetBillModel.dataNameArr];
            
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
    moreDay.tinyOrAttentComeIn = 5;
    moreDay.chatType = self.is_Home_ComeIn;
    moreDay.isMarkMoreBill = self.markBillMore;
    YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
    JlgGetBillModel = self.attendanceGetBillModel;
    moreDay.JlgGetBillModel = JlgGetBillModel;
    moreDay.selBtnType = JGJRecordSelRightBtnType;
    [self.navigationController pushViewController:moreDay animated:YES];
}

#pragma mark -保存最近一次非班组项目组的记账人信息
- (void)saveLastRecordBill {

    if (JLGisLeaderBool || _markBillMore) {// 当前是工头身份
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(5) forKey:@"accounts_type"];
        [dic setObject:self.attendanceGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.attendanceGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:@(self.attendanceGetBillModel.manhour)?:@"" forKey:@"manhour"];
        [dic setObject:self.attendanceGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.attendanceGetBillModel.pid)?:@"" forKey:@"pid"];
        [dic setObject:@(self.attendanceGetBillModel.isRest) forKey:@"isRest"];
        [dic setObject:@(1)?:@"" forKey:@"MakrBillIsLeaderBool"];// 保留上次记账身份
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordLeaderBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        [TYUserDefaults setObject:dic forKey:key];
        
    }else {// 当前身份是工人身份
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(5) forKey:@"accounts_type"];
        [dic setObject:self.attendanceGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.attendanceGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:@(self.attendanceGetBillModel.manhour)?:@"" forKey:@"manhour"];
        [dic setObject:self.attendanceGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.attendanceGetBillModel.pid)?:@"" forKey:@"pid"];
        [dic setObject:@(self.attendanceGetBillModel.isRest) forKey:@"isRest"];
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
        
        GetBill_UnitQuanTpl *unitTpl = [GetBill_UnitQuanTpl mj_objectWithKeyValues:responseObject[0][@"unit_quan_tpl"]];
        unitTpl.s_tpl = unitTpl.s_tpl;
        unitTpl.o_h_tpl = unitTpl.o_h_tpl;
        unitTpl.w_h_tpl = unitTpl.w_h_tpl;
        
        self.attendanceGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.attendanceGetBillModel.unit_quan_tpl = unitTpl;
        self.attendanceGetBillModel.manhour = self.attendanceGetBillModel.unit_quan_tpl.w_h_tpl;
        self.attendanceGetBillModel.overtime = 0;
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.attendanceTable reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma getter/setter
- (UITableView *)attendanceTable {
    
    if (!_attendanceTable) {
        
        _attendanceTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _attendanceTable.backgroundColor = AppFontf1f1f1Color;
        _attendanceTable.showsVerticalScrollIndicator = NO;
        _attendanceTable.delegate = self;
        _attendanceTable.dataSource = self;
        _attendanceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _attendanceTable.tableFooterView = [[UIView alloc] init];
        _attendanceTable.rowHeight = 55;
        _attendanceTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        _attendanceTable.bounces = NO;
    }
    return _attendanceTable;
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



- (NSMutableArray *)remarkImagesArray {
    
    if (!_remarkImagesArray) {
        
        _remarkImagesArray = [NSMutableArray new];
    }
    return _remarkImagesArray;
}

- (YZGGetBillModel *)attendanceGetBillModel{
    
    if (!_attendanceGetBillModel) {
        
        _attendanceGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _attendanceGetBillModel;
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
