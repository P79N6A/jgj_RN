
//
//  JGJContractorMakeAccountController.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAccountController.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJMarkBillRemarkViewController.h"
#import "JGJPackNumViewController.h"

#import "JGJMarkBillBottomSaveView.h"
#import "JGJNewSelectedDataPickerView.h"

#import "JGJContractorMakeAccountNormalCell.h"
#import "JGJContractorMakeAccountInputCell.h"
#import "TYTextField.h"
#import "JGJCusSeniorPopView.h"
#import "JGJCreatTeamVC.h"
#import "JGJCusAlertView.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "JGJLeaderRecordsViewController.h"
#import "JGJMorePeopleViewController.h"
#import "JGJContractorSubentryModel.h"
#import "SJButton.h"
#import "JGJCustomPopView.h"
#import "JGJMakeAccountChoiceSubentryTemplateController.h"
#import "JGJChoiceSubentryTypeHeaderView.h"
#import "JGJContractorMakeAccountInputCountAndUnitsCell.h"
#import "JGJWeatherPickerview.h"
@interface JGJContractorMakeAccountController ()
<UITableViewDelegate,UITableViewDataSource,JGJNewSelectedDataPickerViewDelegate,JGJNewMarkBillChoiceProjectViewControllerDelgate,JGJMarkBillRemarkViewControllerDelegate,JGJContractorMakeAttendanceInputCellDelegate,JGJContractorMakeAccountInputCountAndUnitsCellDelegate,didselectweaterindexpath>
{
    JGJContractorMakeAccountNormalCell *_normalCell;
    JGJContractorMakeAccountInputCell *_inputCell;
    JGJContractorMakeAccountInputCountAndUnitsCell *_inputCountAndUnitsCell;
    YZGAddForemanModel *_selectedForemanModel;
    
    NSInteger _inputCountAndUnitsCellTag;
}
@property (nonatomic, strong) UITableView *accountTable;// 包工记账列表
@property (nonatomic, strong) JGJMarkBillBottomSaveView *bottomSaveView;// 底部保存按钮

@property (nonatomic,strong) NSMutableArray *remarkImagesArray;// 备注图片数组

@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;// 日期选择器


@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;

@property (nonatomic, strong) NSMutableArray *subentryArray;// 分项数组
@property (nonatomic, strong) JGJChoiceSubentryTypeHeaderView *subentryTypeHeader;
@property (nonatomic, assign) NSInteger subentryType;// 承包 还是 分包 0 - 承包， 1 - 分包
@end

@implementation JGJContractorMakeAccountController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    JGJContractorSubentryModel *subentryModel = [[JGJContractorSubentryModel alloc] init];
    subentryModel.subentryName = @"";
    subentryModel.subentryUnitePrice = 0;
    subentryModel.subentryAccount = 0;
    subentryModel.subentryMoney = 0;
    subentryModel.units = @"平方米";
    subentryModel.tpl_id = @"0";
    [self.subentryArray addObject:subentryModel];
    
    if (_markBillMore) {
        
        _subentryType = 1;
        
    }else {
        
        _subentryType = 0;
    }
    
    
    [self initializeAppearance];
    
    self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
    
    [self initLastRecordNews];
}


- (void)initLastRecordNews {
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    if (!JLGisLeaderBool) {
        
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        parmDic = [TYUserDefaults objectForKey:key];
        if (parmDic  && [parmDic[@"accounts_type"] integerValue] == 2 && !_markBillMore && !_is_Home_ComeIn) {// 本地有记账信息 且上笔账的身份信息和当前身份信息一致 班组长身份不取值 只选中类型
            
            YZGGetBillModel *billModel = [YZGGetBillModel mj_objectWithKeyValues:parmDic];
            self.attendanceGetBillModel.name = billModel.name;
            self.attendanceGetBillModel.uid = billModel.uid;
            self.attendanceGetBillModel.proname = billModel.proname;
            self.attendanceGetBillModel.pid = billModel.pid;
            if (self.attendanceGetBillModel.uid == 0) {
                
                return;
            }
            
            [self.accountTable reloadData];
            
            // 获取最后一次的记账项目
            if (!_markBillMore) {
                
                [self JLGHttpRequest_LastproWithUid: self.attendanceGetBillModel.uid];
            }
            
        }
    }else {
        
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordLeaderBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        parmDic = [TYUserDefaults objectForKey:key];
        
        if ([parmDic[@"accounts_type"] integerValue] == 2) {// 本地有记账信息 且上笔账的身份信息和当前身份信息一致 班组长身份不取值 只选中类型
            
            YZGGetBillModel *billModel = [YZGGetBillModel mj_objectWithKeyValues:parmDic];
            self.subentryType = billModel.contractor_type;
            if (self.attendanceGetBillModel.uid == 0) {
                
                return;
            }
            
            [self.accountTable reloadData];
            
            // 获取最后一次的记账项目
            if (!_markBillMore) {
                
                [self JLGHttpRequest_LastproWithUid:self.attendanceGetBillModel.uid];
            }
        }
    }
    
}
- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomSaveView];
    [self.view addSubview:self.accountTable];
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
    
    [_accountTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    return 2 + self.subentryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
        
    }else if (section == 2 + self.subentryArray.count - 1) {
        
        return 1;
        
        
    }else {
        
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 || indexPath.section == 2 + self.subentryArray.count - 1) {
        
        _normalCell = [JGJContractorMakeAccountNormalCell cellWithTableViewNotXib:tableView];
        _normalCell.is_Home_ComeIn = self.is_Home_ComeIn;
        _normalCell.isAgentMonitor = self.isAgentMonitor;
        _normalCell.markBillMore = _markBillMore;
        _normalCell.subentryType = self.subentryType;
        _normalCell.subentryAccount = self.subentryArray.count;
        _normalCell.cellTag = indexPath.section * 10 + indexPath.row;
        _normalCell.yzgGetBillModel = self.attendanceGetBillModel;
        [_normalCell stopTwinkleAnimation];
        return _normalCell;
        
    }else {
        
        JGJContractorSubentryModel *subentryModel = self.subentryArray[indexPath.section - 1];
        self.attendanceGetBillModel.sub_proname = subentryModel.subentryName;// 名称
        self.attendanceGetBillModel.unitprice = subentryModel.subentryUnitePrice;// 单价
        self.attendanceGetBillModel.quantities = subentryModel.subentryAccount;// 数量
        self.attendanceGetBillModel.units = subentryModel.units;// 单位
        self.attendanceGetBillModel.salary = subentryModel.subentryMoney;// 包工工钱
        
        if (indexPath.row == 1) {
            
            _inputCell = [JGJContractorMakeAccountInputCell cellWithTableViewNotXib:tableView];
            _inputCell.cellTag = indexPath.section * 10 + indexPath.row;
            _inputCell.yzgGetBillModel = self.attendanceGetBillModel;
            _inputCell.delegate = self;
            return _inputCell;
            
        }else if (indexPath.row == 2) {

            _inputCountAndUnitsCell = [JGJContractorMakeAccountInputCountAndUnitsCell cellWithTableViewNotXib:tableView];
            _inputCountAndUnitsCell.delegate = self;
            _inputCountAndUnitsCell.cellTag = indexPath.section * 10 + indexPath.row;
            _inputCountAndUnitsCell.yzgGetBillModel = self.attendanceGetBillModel;
            
            return _inputCountAndUnitsCell;
            
        }else {
            
            _normalCell = [JGJContractorMakeAccountNormalCell cellWithTableViewNotXib:tableView];
            _normalCell.is_Home_ComeIn = self.is_Home_ComeIn;
            _normalCell.isAgentMonitor = self.isAgentMonitor;
            _normalCell.markBillMore = _markBillMore;
            _normalCell.subentryAccount = self.subentryArray.count;
            _normalCell.cellTag = indexPath.section * 10 + indexPath.row;
            _normalCell.yzgGetBillModel = self.attendanceGetBillModel;
            
            return _normalCell;
            
        }
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        
        if (row == 0 && self.markBillMore) {
            
            return;
            
        }else if (row == 2) {
            
            if ([NSString isEmpty:self.attendanceGetBillModel.name]) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
                [self startCellTwinkleAnimationWithIndexPath:path];
                return;
            }
        }
        
    }else if (section == 2 + self.subentryArray.count - 1) {
        
        if (!self.attendanceGetBillModel.name) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
        
    }else {
        
        if (row == 0 || row == 1 || row == 2) {
            
            if ([NSString isEmpty: self.attendanceGetBillModel.name]) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
                [self startCellTwinkleAnimationWithIndexPath:path];
                return;
                
            }
        }
        
    }
    
    if (section == 0) {
        
        if (row == 0) {
            
            [self showProjectPickerByIndexPath:indexPath];
            
        }else if (row == 1) {
            
            if (_is_Home_ComeIn) {
                
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.attendanceGetBillModel];
            
        }else if (row == 2) {
            
            [self showDatePickerByIndexPath:indexPath];
        }
    }else if (section == 2 + self.subentryArray.count - 1) {
        
        if (row == 0) {
            
            [self markBillRemark];
        }
        
    }else {
        
        __block JGJContractorSubentryModel *subentryModel = self.subentryArray[indexPath.section - 1];
        if (row == 0) {
            
            JGJMakeAccountChoiceSubentryTemplateController *subentryListVC = [[JGJMakeAccountChoiceSubentryTemplateController alloc] init];
            subentryListVC.isAgentMonitor = self.isAgentMonitor;
            subentryListVC.workProListModel = self.workProListModel;
            subentryListVC.cellTag = indexPath.section * 10 + indexPath.row;
            [self.navigationController pushViewController:subentryListVC animated:YES];
            
            // 分项名称输入确定回调
            TYWeakSelf(self);
            TYStrongSelf(self);
            subentryListVC.sureSubenTryInput = ^(NSInteger cellTag, NSString *subentryName) {
              
                NSInteger section = cellTag / 10;
                NSInteger row = cellTag % 10;
                JGJContractorSubentryModel *subentryModel = weakself.subentryArray[section - 1];
                
                if (row == 0) {
            
                    // 分项名称
                    subentryModel.subentryName = subentryName?:@"";
                }
                
                [weakself.accountTable reloadData];
            };
            
            subentryListVC.selectedSubentryModel = ^(NSInteger cellTag, JGJSubentryListModel *subentryModel) {
              
                NSInteger section = cellTag / 10;
                NSInteger row = cellTag % 10;
                
                JGJContractorSubentryModel *subentry = weakself.subentryArray[section - 1];
                // 分项名称
                subentry.subentryName = subentryModel.sub_pro_name;
                // 单价
                subentry.subentryUnitePrice = [subentryModel.set_unitprice?:@"0" doubleValue];
                // 单位
                subentry.units = subentryModel.units;
                
                // 数量
                subentry.subentryAccount = 0;;
                subentry.subentryMoney = 0;
                
                // 模板tpl_id
                subentry.tpl_id = subentryModel.tpl_id;
                
                [weakself.accountTable reloadData];
            };
        }else if (row == 1) {// 输入框的响应区域扩大到点击整行
            
            [self.view endEditing:YES];
            JGJContractorMakeAccountInputCell *inputCell = (JGJContractorMakeAccountInputCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [inputCell.inputField becomeFirstResponder];
            
        }else if (row == 2) {
            
            [self.view endEditing:YES];
            JGJContractorMakeAccountInputCountAndUnitsCell *inputCountAndUnitsCell = (JGJContractorMakeAccountInputCountAndUnitsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [inputCountAndUnitsCell.inputField becomeFirstResponder];
        }
    }
}

- (void)startCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJContractorMakeAccountNormalCell *cell = [self.accountTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)stopCellTwinkleAnimation {
    
    [_accountTable reloadData];
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
    
    if (self.subentryType == 0 && JLGisLeaderBool) {
        
        accountingMemberVC.contractor_type = @"1";
        
    }
    
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
            
            if (!weakSelf.markBillMore) {
                
                weakSelf.attendanceGetBillModel = [[YZGGetBillModel alloc] init];
                weakSelf.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
                
            }
            [self.accountTable reloadData];
            
        }else{
            
            if (self.isAgentMonitor) {
                
                // 代班长 选择班组长时 弹窗提示框，选择自己时不弹
                if ([accoumtMember.uid isEqualToString:self.workProListModel.creater_uid]) {
                    
                    [TYShowMessage showPlaint:@"不能选择班组长"];
                    [self manegerCleanCurrentPageData];
                }else {
                    
                    [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
                }
            }else {
                
                // 班组长自己对自己记工，选择分包时，气泡提示“自己对自己记账只能选择承包”，同时，包工类型选中承包。
                if ([accoumtMember.telph isEqualToString:[TYUserDefaults objectForKey:JLGPhone]] && self.subentryType == 1) {
                
                    if (!_markBillMore) {
                        
                        [TYShowMessage showPlaint:@"自己对自己记账只能选择承包"];
                        self.subentryType = 0;
                        [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
                        
                    }else {// 记多人进入记单笔
                        
                        [TYShowMessage showPlaint:@"不能选择班组长"];
                        self.subentryType = 1;
                        [self manegerCleanCurrentPageData];
                    }
                    
                    
                }else {
                    
                    // 错误 #19075 【包工记账】选择记工对象，单位，数量后更换记工对象 数据应该清空
                    if (JLGisLeaderBool) {
                        
                        [self manegerCleanCurrentPageData];
                        
                    }else {
                        
                        [self mateClearCurentPageData];
                    }
                    
                    [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
                }
                
            }
            
            
            
        }
    };
}

- (void)getMarkBillPersonInfoWithAccountMember:(JGJSynBillingModel *)accoumtMember {
    
    
    YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
    
    addForemanModel.uid = [accoumtMember.uid integerValue];
    
    addForemanModel.telph = accoumtMember.telph;
    
    addForemanModel.name = accoumtMember.name;
    
    addForemanModel.head_pic = accoumtMember.head_pic;
    _selectedForemanModel = addForemanModel;
    [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
}

- (void)reqeustAccountInfoWithAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    self.addForemanModel = addForemanModel;
    
    self.attendanceGetBillModel.name = addForemanModel.name;
    self.attendanceGetBillModel.uid = addForemanModel.uid;
    
    [self.accountTable reloadData];
    if (!_markBillMore) {
        
        if (self.attendanceGetBillModel.uid) {
            
            if (JLGisMateBool) {
                
                [self JLGHttpRequest_LastproWithUid: self.attendanceGetBillModel.uid];
            }
            
        }
    }

}

#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":@"2",
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
        
        [self.accountTable reloadData];
        
    }failure:^(NSError *error) {
        
    }];
}

- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    
    self.theNewSelectedDataPickerView.isNeddShowMoreDayChoiceBtn = NO;
    
    _theNewSelectedDataPickerView.selectedDate = _selectedDate?:[NSDate date];
    
    [_theNewSelectedDataPickerView show];
    
    _theNewSelectedDataPickerView.choiceData = ^(NSArray *dataArray, NSString *timeStr) {
        
    };
    
}

#pragma mark - JGJNewSelectedDataPickerViewDelegate
- (void)JGJNewSelectedDataPickerViewSelectedDate:(NSDate *)date {
    
    self.attendanceGetBillModel.date = [NSString getWeekDaysString:date];
    _selectedDate = date;
    [_accountTable reloadData];
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
    projectVC.billModel = self.attendanceGetBillModel;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.attendanceGetBillModel.proname = projectModel.pro_name;
    self.attendanceGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.accountTable reloadData];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.attendanceGetBillModel.proname = @"";
    self.attendanceGetBillModel.pid     = 0;
    [self.accountTable reloadData];
    
}

#pragma mark - 备注
- (void)markBillRemark{
    
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    self.attendanceGetBillModel.accounts_type.code = 2;
    otherInfoVc.yzgGetBillModel = self.attendanceGetBillModel;
    
    otherInfoVc.remarkBillType = JGJRemarkBillContractType;
    otherInfoVc.yzgGetBillModel.role = JLGisLeaderBool ? 1:2;
    otherInfoVc.imagesArray = self.remarkImagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.remarkImagesArray = images;
    self.attendanceGetBillModel.notes_img = images.copy;
    self.attendanceGetBillModel.notes_txt = remarkText;
    [self.accountTable reloadData];
}

#pragma mark - 输入单价和分项名称 JGJContractorMakeAccountInputCountAndUnitsCellDelegate/JGJContractorMakeAttendanceInputCellDelegate
- (void)JGJContractorMakeAttendanceInputTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag {
    
    NSInteger section = cellTag / 10;
    NSInteger row = cellTag % 10;
    
    JGJContractorSubentryModel *subentryModel = self.subentryArray[section - 1];

    if (row == 1) {
        
        // 单价
        subentryModel.subentryUnitePrice = [text?:@"0" doubleValue];
        subentryModel.subentryMoney = subentryModel.subentryAccount * subentryModel.subentryUnitePrice;
        
    }

}

- (void)JGJContractorMakeAttendanceInputCountTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag {
    
    NSInteger section = cellTag / 10;
    NSInteger row = cellTag % 10;
    
    JGJContractorSubentryModel *subentryModel = self.subentryArray[section - 1];
    
    if (row == 2) {
        
        // 数量
        subentryModel.subentryAccount = [text doubleValue];
        subentryModel.subentryMoney = subentryModel.subentryAccount * subentryModel.subentryUnitePrice;
        
    }
}

- (void)inputTextFieldEndEditing {
    
    [_accountTable reloadData];
}

- (void)inputCountTextFieldEndEditing {
    
    [_accountTable reloadData];
}


// 选择单位
- (void)inputCountAndUnitsCellChoiceUnitsWithCellTag:(NSInteger)cellTag {
    
    [self.view endEditing:YES];
    _inputCountAndUnitsCellTag = cellTag;
    
    NSInteger section = cellTag / 10;
    NSInteger row = cellTag % 10;
    
    JGJContractorSubentryModel *subentryModel = self.subentryArray[section - 1];
    
    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 265, TYGetUIScreenWidth, 265)];
    picker.delegate = self;
    picker.topname = @"选择单位";
    
    [picker showWeatherPickerView];
    picker.classmodel = JGJPacknumPickermodel;
    picker.selectedUnits = subentryModel.units;
    picker.titlearray = [NSMutableArray arrayWithObjects:@"平方米",@"立方米",@"吨",@"米",@"个",@"次",@"天",@"块",@"组",@"台",@"捆",@"宗",@"项",@"株",nil];
    [picker setLeftButtonTitle:@"" rightButtonTitle:@"关闭"];
}

- (void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content
{
    
    NSInteger section = _inputCountAndUnitsCellTag / 10;
    NSInteger row = _inputCountAndUnitsCellTag % 10;
    
    JGJContractorSubentryModel *subentryModel = self.subentryArray[section - 1];
    subentryModel.units = content;
    
    [_accountTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 2 + _subentryArray.count - 1) {
        
        if (section == 0) {
            
            // 班组长身份
            if (JLGisLeaderBool || self.isAgentMonitor) {
                
                return 74;
                
            }else {
                
                return 0.01;
            }
            
        }else {
            
            return 0.01;
        }
        
    }else {
        
        if (_subentryArray.count > 1) {
            
            return 26;
            
        }else {
            
            return 0.01;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    if (section == 0 || section == 2 + _subentryArray.count - 1) {
        
        if (section == 0) {
            
            // 班组长身份
            if (JLGisLeaderBool || self.isAgentMonitor) {
                
                view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 74);
                
                _subentryTypeHeader = [[JGJChoiceSubentryTypeHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
                _subentryTypeHeader.backgroundColor = [UIColor whiteColor];
                _subentryTypeHeader.subentryType = self.subentryType;
                _subentryTypeHeader.markBillMore = self.markBillMore;
                
                [view addSubview:_subentryTypeHeader];
                
                TYWeakSelf(self);
                __strong typeof(self) strongSelf = self;
                _subentryTypeHeader.choiceSubentryType = ^(NSInteger type) {
                  
                    weakself.subentryType = type;
                    // 班组长自己对自己记工，选择分包时，气泡提示“自己对自己记账只能选择承包”，同时，包工类型选中承包。
                    if (weakself.subentryType == 1) {
                        
                        if ([strongSelf -> _selectedForemanModel.telph isEqualToString:[TYUserDefaults objectForKey:JLGPhone]]) {
                            
                            [TYShowMessage showPlaint:@"自己对自己记账只能选择承包"];
                            weakself.subentryType = 0;
                        }
                    }
                    
                    [weakself manegerCleanCurrentPageData];
                    [weakself.accountTable reloadData];
                };
                
            }else {
                
                view.frame = CGRectZero;
            }
            
        }else {
            
            view.frame = CGRectZero;
        }
        
        
    }else {
        
        if (_subentryArray.count > 1) {
            
            view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 26);
            
            UIView *downLine = [[UIView alloc] init];
            downLine.frame = CGRectMake(0, 25.5, TYGetUIScreenWidth, 0.5);
            downLine.backgroundColor = AppFontdbdbdbColor;
            [view addSubview:downLine];
            
            CGSize serialNumberSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:[NSString stringWithFormat:@"#%ld",section] font:15];
            UILabel *serialNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, serialNumberSize.width, 15)];
            serialNumber.textColor = AppFont999999Color;
            serialNumber.font = FONT(AppFont30Size);
            serialNumber.text = [NSString stringWithFormat:@"#%ld",section];
            
            [view addSubview:serialNumber];
            
            CGSize deleteSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"删除分项" font:15];
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.tag = section - 1;
            deleteBtn.frame = CGRectMake(TYGetUIScreenWidth - 20 - deleteSize.width, 6, deleteSize.width, 15);
            [deleteBtn setTitle:@"删除分项" forState:(UIControlStateNormal)];
            deleteBtn.titleLabel.font = FONT(AppFont30Size);
            [deleteBtn setTitleColor:AppFont4886EDColor forState:(UIControlStateNormal)];
            
            [deleteBtn addTarget:self action:@selector(deleteSubentry:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:deleteBtn];
            
        }else {
            
            view.frame = CGRectZero;
        }
    }
    
    
    return view;
}

#pragma mark - 删除分项
- (void)deleteSubentry:(UIButton *)sender {
    
    TYWeakSelf(self);
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    NSString *popDetail = popDetail = @"你确定要删除该分项吗？";
    
    desModel.popDetail = popDetail;
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    desModel.popTextAlignment = NSTextAlignmentCenter;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentCenter;
    
    alertView.onOkBlock = ^{
        
        [weakself.subentryArray removeObjectAtIndex:sender.tag];
        [weakself.accountTable reloadData];
        [TYShowMessage showSuccess:@"分项删除成功"];
    };
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 2 + _subentryArray.count - 1) {
        
        return 10;
    }else {
        
        if (section == _subentryArray.count) {// 分项最后一组
            
            return 75;
            
        }else {
            
            return 10;
        }
    }
    
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
    
    
    UIView *downLine = [[UIView alloc] init];
    
    if (section == 0 || section == 2 + _subentryArray.count - 1) {
        
        downLine.frame = CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5);
        
    }else {
        
        if (section == _subentryArray.count) {
            
            downLine.frame = CGRectMake(0, 74.5, TYGetUIScreenWidth, 0.5);
        }else {
            
            downLine.frame = CGRectMake(0, 35.5, TYGetUIScreenWidth, 0.5);
        }
    }
    downLine.backgroundColor = AppFontdbdbdbColor;
    [footerView addSubview:downLine];
    
    if (section == 2 + self.subentryArray.count - 1) {
        
        downLine.hidden = YES;
        
    }else {
        
        downLine.hidden = NO;
    }
    
    if (section == 0) {
        
        if (_subentryArray.count > 1) {
            
            downLine.hidden = YES;
            
        }else {
            
            downLine.hidden = NO;
        }
    }
    
#pragma mark - v3.5.2新增 添加分项按钮 和 过多分项是的分组编号和删除按钮
    if (section == 0 || section == 2 + _subentryArray.count - 1) {
        
        // 不做任何添加
    }else {
        
        if (section == _subentryArray.count) {// 增加 添加分项按钮
            
            UIButton *addSubentry = [UIButton buttonWithType:UIButtonTypeCustom];
            addSubentry.frame = CGRectMake(11, 10, TYGetUIScreenWidth - 22, 45);
            addSubentry.titleLabel.font = FONT(AppFont30Size);
            [addSubentry setImage:IMAGE(@"black_add") forState:(UIControlStateNormal)];
            [addSubentry setTitle:@"添加分项" forState:(UIControlStateNormal)];
            [addSubentry setTitleColor:AppFont333333Color forState:UIControlStateNormal];
            [addSubentry setBackgroundColor:AppFontf1f1f1Color];
            addSubentry.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            
            CAShapeLayer *border = [CAShapeLayer layer];
            //虚线的颜色
            border.strokeColor = AppFont333333Color.CGColor;
            //填充的颜色
            border.fillColor = [UIColor clearColor].CGColor;
            border.masksToBounds = YES;
            //设置路径
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:addSubentry.bounds cornerRadius:5];
            border.path = path.CGPath;
            border.frame = addSubentry.bounds;
            //虚线的宽度
            border.lineWidth = 1.f;
            //设置线条的样式
            border.lineCap = @"square";
            //虚线的间隔
            border.lineDashPattern = @[@2, @2];
            [addSubentry.layer addSublayer:border];
            
            [addSubentry addTarget:self action:@selector(addSubentryMethod:) forControlEvents:(UIControlEventTouchUpInside)];
            [footerView addSubview:addSubentry];
            
        }
    }
    return footerView;
}

- (void)addSubentryMethod:(UIButton *)sender {// 添加分项
    
    if ([NSString isEmpty:self.attendanceGetBillModel.name]) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    
    if (self.subentryArray.count == 10) {
        
        [TYShowMessage showPlaint:@"你已经添加10个分项了，不能再添加啦"];
        return;
    }
    
    
    JGJContractorSubentryModel *subentryModel = [[JGJContractorSubentryModel alloc] init];
    subentryModel.subentryName = @"";
    subentryModel.subentryUnitePrice = 0;
    subentryModel.subentryAccount = 0;
    subentryModel.subentryMoney = 0;
    subentryModel.units = @"平方米";
    subentryModel.tpl_id = @"0";
    [self.subentryArray addObject:subentryModel];
    [_accountTable reloadData];
}

- (void)footerViewTap {
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 提交包工记账数据到服务器
- (void)pushTinyAmountBillDataToServer {
    
    [self.view endEditing:YES];
    if ([NSString isEmpty: self.attendanceGetBillModel.name ]) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        
        return;
    }else {
        
        for (int i = 0; i < self.subentryArray.count; i ++) {
            
            JGJContractorSubentryModel *subentryModel = self.subentryArray[i];
            
            if (!subentryModel.subentryUnitePrice) {
                
                [TYShowMessage showPlaint:@"请填写单价"];
                return;
                
            }else if (!subentryModel.subentryAccount) {
                
                [TYShowMessage showPlaint:@"请填写数量"];
                return;
            }
            
        }
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
    self.parametersDic[@"accounts_type"] = @2;
    
    self.parametersDic[@"p_s_time"] = self.yzgGetBillModel.p_s_time?:@"0";
    self.parametersDic[@"p_e_time"] = self.yzgGetBillModel.p_e_time?:@"0";
    
    if (_is_Home_ComeIn) {
        
        [self.parametersDic setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [self.parametersDic setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [self.parametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
    
    [self submitDateToServerWithParametersDicRelase:self.parametersDic dataArray:self.attendanceGetBillModel.dataArr dataNameArray:self.attendanceGetBillModel.dataNameArr];
    
}

- (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray {
    
    NSMutableArray *parametersArrayRelase = [[NSMutableArray alloc] init];
    for (int i = 0; i < _subentryArray.count; i ++) {
        
        JGJContractorSubentryModel *subentryModel = self.subentryArray[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parametersDicRelase];
        [dic setObject:subentryModel.subentryName forKey:@"sub_pro_name"];
        [dic setObject:@(subentryModel.subentryUnitePrice) forKey:@"unit_price"];
        [dic setObject:@(subentryModel.subentryAccount) forKey:@"quantity"];
        [dic setObject:subentryModel.units forKey:@"units"];
        [dic setObject:subentryModel.tpl_id forKey:@"tpl_id"];
        [parametersArrayRelase addObject:dic];
        
    }
    NSString *jesonPa = [parametersArrayRelase mj_JSONString];
    NSMutableDictionary *parameDic = [[NSMutableDictionary alloc] init];
    
    [parameDic setObject:jesonPa forKey:@"info"];
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];
    }
    
    if (![NSString isEmpty:self.agency_uid]) {
        
        [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
    }
    
    if (JLGisLeaderBool) {
        
        [parameDic setObject:@(_subentryType + 1) forKey:@"contractor_type"];
    }else {
        
        [parameDic setObject:@(1) forKey:@"contractor_type"];
    }
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parameDic imagearray:self.remarkImagesArray otherDataArray:[self.yzgGetBillModel.dataArr copy] dataNameArray:[self.yzgGetBillModel.dataNameArr copy] success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
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
            
            alerView.customLeftButtonAlertViewBlock = ^{
                
                [self mateClearCurentPageData];
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
            
            alerView.customLeftButtonAlertViewBlock = ^{
                
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

// 工人清空当前数据
- (void)mateClearCurentPageData {
    
    // 清除关于分项数据
    [self.subentryArray removeAllObjects];
    JGJContractorSubentryModel *subentryModel = [[JGJContractorSubentryModel alloc] init];
    subentryModel.subentryName = @"";
    subentryModel.subentryUnitePrice = 0;
    subentryModel.subentryAccount = 0;
    subentryModel.subentryMoney = 0;
    subentryModel.units = @"平方米";
    subentryModel.tpl_id = @"0";
    [self.subentryArray addObject:subentryModel];
    
    _subentryType = 0;
    
    if (!_makeBillRecordHomeComeIn) {
        
        if (!_oneDayAttendanceComeIn) {
            
            _selectedDate = nil;
        }
        
    }
    
    YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
    oldBillModel.proname = self.yzgGetBillModel.proname;
    oldBillModel.pid = self.yzgGetBillModel.pid;
    oldBillModel.name = self.yzgGetBillModel.name;
    oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
    oldBillModel.unit_quan_tpl = self.yzgGetBillModel.unit_quan_tpl;
    
    //如果是班组类记账
    if (_is_Home_ComeIn) {
        
        self.attendanceGetBillModel = [[YZGGetBillModel alloc] init];
        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
        [self mainGoinGetTPL];
        
    }else{
        
        self.attendanceGetBillModel = [[YZGGetBillModel alloc]init];
        
        if (_markBillMore) {
            
            self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
            self.yzgGetBillModel.pid = oldBillModel.pid;
            
        }
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        [self.accountTable reloadData];
        
    }
}

// 班组长清除当前页面数据
- (void)manegerCleanCurrentPageData {
    
    // 清除关于分项数据
    [self.subentryArray removeAllObjects];
    JGJContractorSubentryModel *subentryModel = [[JGJContractorSubentryModel alloc] init];
    subentryModel.subentryName = @"";
    subentryModel.subentryUnitePrice = 0;
    subentryModel.subentryAccount = 0;
    subentryModel.subentryMoney = 0;
    subentryModel.units = @"平方米";
    subentryModel.tpl_id = @"0";
    [self.subentryArray addObject:subentryModel];
    
    if (_markBillMore) {
        
        _subentryType = 1;
    }
    
    if (!_makeBillRecordHomeComeIn) {
        
        if (!_oneDayAttendanceComeIn) {
            
            _selectedDate = nil;
        }
        
    }
    
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    
    //如果是从聊天进入  则荏苒要默认工头名字
    if (_markBillMore) {
        
#pragma mark - 添加
        self.attendanceGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.attendanceGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.attendanceGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.accountTable reloadData];
        
    }else{
        
        YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
        oldBillModel.proname = self.attendanceGetBillModel.proname;
        oldBillModel.pid = self.attendanceGetBillModel.pid;
        oldBillModel.name = self.attendanceGetBillModel.name;
        oldBillModel.set_tpl = self.attendanceGetBillModel.set_tpl;
        
        self.attendanceGetBillModel = [[YZGGetBillModel alloc] init];
        
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        self.attendanceGetBillModel.proname = oldBillModel.proname;
        self.attendanceGetBillModel.pid = oldBillModel.pid;
        [self.accountTable reloadData];
        
    }
    if (self.remarkImagesArray) {
        
        [self.remarkImagesArray removeAllObjects];
    }
    
}


#pragma mark -保存最近一次非班组项目组的记账人信息
- (void)saveLastRecordBill {
    
    if (JLGisLeaderBool || _markBillMore) {// 当前是工头身份
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(2) forKey:@"accounts_type"];
        [dic setObject:self.attendanceGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.attendanceGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:self.attendanceGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.attendanceGetBillModel.pid)?:@"" forKey:@"pid"];
        [dic setObject:@(1)?:@"" forKey:@"MakrBillIsLeaderBool"];// 保留上次记账身份
        [dic setObject:@(self.subentryType) forKey:@"contractor_type"];
        NSString *key = [NSString stringWithFormat:@"JLGLastRecordLeaderBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
        [TYUserDefaults setObject:dic forKey:key];
        
    }else {// 当前身份是工人身份
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(2) forKey:@"accounts_type"];
        [dic setObject:self.attendanceGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.attendanceGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:self.attendanceGetBillModel.proname?:@"" forKey:@"proname"];
        [dic setObject:@(self.attendanceGetBillModel.pid)?:@"" forKey:@"pid"];
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
        
        self.attendanceGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.attendanceGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        self.attendanceGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.attendanceGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        [self.accountTable reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}


#pragma getter/setter
- (UITableView *)accountTable {
    
    if (!_accountTable) {
        
        _accountTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _accountTable.backgroundColor = AppFontf1f1f1Color;
        _accountTable.showsVerticalScrollIndicator = NO;
        _accountTable.delegate = self;
        _accountTable.dataSource = self;
        _accountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _accountTable.tableFooterView = [[UIView alloc] init];
        _accountTable.rowHeight = 55;
        _accountTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        _accountTable.bounces = NO;
        
    }
    return _accountTable;
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

- (YZGGetBillModel *)yzgGetBillModel {
    
    if (!_yzgGetBillModel) {
        
        _yzgGetBillModel = [[YZGGetBillModel alloc] init];
    }
    return _yzgGetBillModel;
}

- (NSMutableDictionary *)parametersDic {
    
    if (!_parametersDic) {
        
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}

- (NSMutableArray *)subentryArray {
    
    if (!_subentryArray) {
        
        _subentryArray = [[NSMutableArray alloc] init];
    }
    return _subentryArray;
}

@end
