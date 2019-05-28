//
//  JGJCloseAccountBillController.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCloseAccountBillController.h"
#import "JGJQustionShowView.h"
#import "UILabel+GNUtil.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJMarkBillRemarkViewController.h"
#import "JGJPackNumViewController.h"
#import "JGJUnWagesShortWorkVc.h"
#import "JGJMarkBillBottomSaveView.h"
#import "JGJNewSelectedDataPickerView.h"

#import "JGJCloseAccountBillNormalCell.h"
#import "JGJCloseAccountInputCell.h"
#import "JGJCloseAccountUnpaidWagesCell.h"
#import "JGJCloseAccountSubsidyCell.h"
#import "JGJWaringSuggustTableViewCell.h"
#import "TYTextField.h"
#import "JGJCusSeniorPopView.h"
#import "JGJCreatTeamVC.h"
#import "JGJCusAlertView.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "JGJLeaderRecordsViewController.h"
#import "JGJCloseAnAccountInfoAlertView.h"
#import "JGJUnWagesVc.h"
@interface JGJCloseAccountBillController ()
<UITableViewDelegate,UITableViewDataSource,JGJNewSelectedDataPickerViewDelegate,JGJNewMarkBillChoiceProjectViewControllerDelgate,JGJMarkBillRemarkViewControllerDelegate,JGJWaringSuggustTableViewCellDelegate,JGJCloseAccountInputCellDelegate>
{
    JGJCloseAccountBillNormalCell *_normalCell;
    JGJCloseAccountInputCell *_inputCell;
    JGJCloseAccountUnpaidWagesCell *_unpaidWagesCell;
    JGJCloseAccountSubsidyCell *_subsidyCell;
    JGJWaringSuggustTableViewCell *_wariningSuggusCell;
    
    YZGAddForemanModel *_selectedForemanModel;
    CGFloat _markEditeMoney;
    BOOL _is_unfold_subsidyCell;// 是否展开补贴 奖励 罚款cell
}
@property (nonatomic, strong) UITableView *settlementBillTable;// 包工记账列表
@property (nonatomic, strong) JGJMarkBillBottomSaveView *bottomSaveView;// 底部保存按钮

@property (nonatomic,strong) NSMutableArray *remarkImagesArray;// 备注图片数组

@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;// 日期选择器

@property (nonatomic, assign) BOOL isClearEditMoney;// 是否清空本次实收金额

@property (nonatomic,strong) NSMutableDictionary *parametersDic;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@end

@implementation JGJCloseAccountBillController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self initializeAppearance];
    
    self.settlementGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomSaveView];
    [self.view addSubview:self.settlementBillTable];
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
    
    [_settlementBillTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_bottomSaveView.mas_top).offset(0);
        make.left.right.top.mas_equalTo(0);
    }];
    
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    
    if (_is_Home_ComeIn) {// 首页进入结算
        
        self.settlementGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.settlementGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.settlementGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        
        if (!JLGisLeaderBool) {
            
            self.settlementGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
            id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
            [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
            [self mainGoinGetTPL];
            [self getOutstandingAmount];
        }
        
    }
    
}

- (void)setCloseUserInfo:(JGJSynBillingModel *)closeUserInfo {
    
    _closeUserInfo = closeUserInfo;
    
    // 先设置时间 不然接口报错
    self.settlementGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
    
    YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
    addForemanModel.uid = [self.closeUserInfo.uid integerValue];
    addForemanModel.telph = self.closeUserInfo.telph;
    addForemanModel.name = self.closeUserInfo.name;
    
    [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
    [self JLGHttpRequest_LastproWithUid:addForemanModel.uid];
}

#pragma UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
        
    }else if (section == 1) {
        
        if (![NSString isEmpty:self.settlementGetBillModel.name]) {
            
            return 2;
            
        }else {
            
            return 0;
        }
        
        
    }else if (section == 2) {
        
        if (_is_unfold_subsidyCell) {
            
            return 4;
            
        }else {
            
            return 1;
        }
        
        
    }else if (section == 3) {
        
        return 2;
        
    }else {
        
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 4) {

        _normalCell = [JGJCloseAccountBillNormalCell cellWithTableViewNotXib:tableView];
        _normalCell.is_Home_ComeIn = self.is_Home_ComeIn;
        _normalCell.cellTag = indexPath.section * 10 + indexPath.row;
        _normalCell.yzgGetBillModel = self.settlementGetBillModel;
        return _normalCell;

    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            _unpaidWagesCell = [JGJCloseAccountUnpaidWagesCell cellWithTableViewNotXib:tableView];
            _unpaidWagesCell.cellTag = indexPath.section * 10 + indexPath.row;
            _unpaidWagesCell.yzgGetBillModel = self.settlementGetBillModel;
            [_unpaidWagesCell.unpaidWagesExplainBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
            return _unpaidWagesCell;
            
        }else {
            
            _wariningSuggusCell = [JGJWaringSuggustTableViewCell cellWithTableView:tableView];
            _wariningSuggusCell.delegate = self;
            _wariningSuggusCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([NSString isEmpty:self.settlementGetBillModel.name] || [self.settlementGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {
                
                _wariningSuggusCell.contentView.hidden = YES;
                
            }else{
                
                _wariningSuggusCell.contentView.hidden = NO;;
                _wariningSuggusCell.contentLable.text = self.settlementGetBillModel.salary_desc?:@"";
                [_wariningSuggusCell.contentLable markText:[NSString stringWithFormat:@"%@笔",self.settlementGetBillModel.un_salary_tpl?:@"0"] withColor:AppFontEB4E4EColor];
            }
            return _wariningSuggusCell;
        }
        
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
        
            _subsidyCell = [JGJCloseAccountSubsidyCell cellWithTableViewNotXib:tableView];
            _subsidyCell.cellTag = indexPath.section * 10 + indexPath.row;
            _subsidyCell.is_unfold_subsidyCell = _is_unfold_subsidyCell;
            _subsidyCell.yzgGetBillModel = self.settlementGetBillModel;
            
            return _subsidyCell;
            
        }else {
            
            _inputCell = [JGJCloseAccountInputCell cellWithTableViewNotXib:tableView];
            _inputCell.cellTag = indexPath.section * 10 + indexPath.row;
            _inputCell.yzgGetBillModel = self.settlementGetBillModel;
            _inputCell.delegate = self;
            return _inputCell;
        }
        
        
    }else if (indexPath.section == 3) {
        
        _inputCell = [JGJCloseAccountInputCell cellWithTableViewNotXib:tableView];
        _inputCell.cellTag = indexPath.section * 10 + indexPath.row;
        _inputCell.yzgGetBillModel = self.settlementGetBillModel;
        _inputCell.delegate = self;
        return _inputCell;
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    [JGJQustionShowView removeQustionView];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 1) {

        if ([NSString isEmpty:self.settlementGetBillModel.name]) {

            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }else if (section == 2){
        
        if (row == 0) {
            
            _is_unfold_subsidyCell = !_is_unfold_subsidyCell;
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
            [self.settlementBillTable reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (!self.settlementGetBillModel.name) {

            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }else if (section == 3) {
        
        if (!self.settlementGetBillModel.name) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
        
    }else if (section == 4) {
        
        if (row == 0) {
            
            if (_is_Home_ComeIn && JLGisLeaderBool) {
                
                return;
            }
        }
        if (!self.settlementGetBillModel.name) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }
    if (section == 0) {

        if (row == 0) {

            if (_is_Home_ComeIn && !JLGisLeaderBool) {

                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.settlementGetBillModel];

        }else if (row == 1) {

            [self showDatePickerByIndexPath:indexPath];
        }

    }else if (section == 4) {

        if (row == 0) {

            [self showProjectPickerByIndexPath:indexPath];

        }else {

            [self markBillRemark];
        }
    }
}

- (void)startCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJCloseAccountBillNormalCell *cell = [self.settlementBillTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)startInputCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJCloseAccountInputCell *cell = [self.settlementBillTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)stopCellTwinkleAnimation {
    
    NSIndexPath *normalPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JGJCloseAccountBillNormalCell *normalCell = [self.settlementBillTable cellForRowAtIndexPath:normalPath];
    [normalCell stopTwinkleAnimation];
    
    NSIndexPath *inputPath = [NSIndexPath indexPathForRow:0 inSection:3];
    JGJCloseAccountInputCell *inputCell = [self.settlementBillTable cellForRowAtIndexPath:inputPath];
    [inputCell stopTwinkleAnimation];
    
    [self.settlementBillTable reloadData];
}

#pragma mark - method
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    
    self.addForemanModel.telph = billModel.phone_num;
    
    self.addForemanModel.uid = billModel.uid;
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    
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
    
    accountingMemberVC.is_Home_Bill = self.is_Home_ComeIn;
    
    accountingMemberVC.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员,如果删除之后accoumtMember为nil
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {
        
        if (accoumtMember.isDelMember) {
            
            if (JLGisMateBool) {
                
                //删除最后一次记账的数据(工人记工头，删除同一个)
                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
                parmDic = [TYUserDefaults objectForKey:JLGLastRecordBillPeople];
                self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
                
                NSString *uid = [NSString stringWithFormat:@"%@", @(self.addForemanModel.uid)];
                
                if ([uid isEqualToString:accoumtMember.uid]) {
                    
                    [TYUserDefaults removeObjectForKey:JLGLastRecordBillPeople];
                }
                
            }
            
            
            if (!weakSelf.markBillMore) {
                
                weakSelf.settlementGetBillModel = [[YZGGetBillModel alloc] init];
                weakSelf.settlementGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
                
            }
            [self.settlementBillTable reloadData];
            
        }else{
            
            [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
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
    
    self.settlementGetBillModel.name = addForemanModel.name;
    self.settlementGetBillModel.uid = addForemanModel.uid;
    
    [self getOutstandingAmount];
    
    if (!_markBillMore) {
        
        if (self.settlementGetBillModel.uid) {
            
            [self JLGHttpRequest_LastproWithUid: self.settlementGetBillModel.uid];
        }
    }
}

#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":@"4",
                 @"group_id":self.is_Home_ComeIn ? self.workProListModel.group_id ?:@"":@""
                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
        
        if ([NSString isEmpty: responseObject[@"pro_name"]]) {
            
            self.settlementGetBillModel.proname = self.workProListModel.all_pro_name;
            self.settlementGetBillModel.pid = 0;
            
        }else{
            
            if ([responseObject[@"pro_name"] length] < 2 && _is_Home_ComeIn) {
                
                self.settlementGetBillModel.proname = self.workProListModel.all_pro_name;
                self.settlementGetBillModel.pid = 0;
                
            }else{
                
                self.settlementGetBillModel.proname = responseObject[@"pro_name"]?:@"";
                self.settlementGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
            }
            
        }
        
        [self.settlementBillTable reloadData];
        
    }failure:^(NSError *error) {
        
    }];
}
#pragma mark - 工资结算获取未结算金额
- (void)getOutstandingAmount {
    
    NSString *markBillType;
    YZGGetBillModel *model = [[YZGGetBillModel alloc]init];
    markBillType = @"4";
    model = self.settlementGetBillModel;
    NSString *dateStr;
    if (![NSString isEmpty:model.date]) {
        if ([model.date containsString:@"(今天)"]) {
            dateStr = [model.date stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
        }else if ([model.date containsString:@"-"]){
            dateStr = [model.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(model.uid)?:@"" forKey:@"uid"];
    [dic setObject:markBillType?:@"" forKey:@"accounts_type"];
    [dic setObject:dateStr?:@"" forKey:@"date"];
    if (self.isAgentMonitor || self.getTpl) {
        
        [dic setObject:self.workProListModel.group_id forKey:@"group_id"];
        
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-unpaysalary-list-total" parameters:dic success:^(id responseObject) {
        JGJNoPayAmount *payModel = [JGJNoPayAmount mj_objectWithKeyValues:responseObject];
        
        self.settlementGetBillModel.balance_amount = payModel.balance_amount;
        self.settlementGetBillModel.salary = _markEditeMoney;
        self.settlementGetBillModel.un_salary_tpl = payModel.un_salary_tpl;
        self.settlementGetBillModel.salary_desc = payModel.salary_desc;
        self.settlementGetBillModel.bill_num = payModel.bill_num;
        self.settlementGetBillModel.bill_desc = payModel.bill_desc;
        
        // 清空补贴 奖励 罚款  抹零金额
        self.settlementGetBillModel.subsidy_amount = @"";
        self.settlementGetBillModel.reward_amount = @"";
        self.settlementGetBillModel.penalty_amount = @"";
        self.settlementGetBillModel.deduct_amount = @"";
        [self CalculationAmount];
        [self.settlementBillTable reloadData];
        
    }failure:^(NSError *error) {
        
    }];
    
    
}

- (void)CalculationAmount {
    
    double totalCalculation = [self.settlementGetBillModel.subsidy_amount doubleValue] + [self.settlementGetBillModel.reward_amount doubleValue] - [self.settlementGetBillModel.penalty_amount doubleValue];
    self.settlementGetBillModel.totalCalculation = [NSString stringWithFormat:@"%.2f",totalCalculation];
    
    
    self.settlementGetBillModel.settlementAmount =  [NSString stringWithFormat:@"%.2f",self.settlementGetBillModel.salary + [self.settlementGetBillModel.deduct_amount doubleValue] + [self.settlementGetBillModel.penalty_amount doubleValue] - [self.settlementGetBillModel.subsidy_amount doubleValue] - [self.settlementGetBillModel.reward_amount doubleValue]];
    
    self.settlementGetBillModel.remainingAmount = [NSString stringWithFormat:@"%.2f",[self.settlementGetBillModel.balance_amount doubleValue] + [self.settlementGetBillModel.subsidy_amount doubleValue] + [self.settlementGetBillModel.reward_amount doubleValue] - [self.settlementGetBillModel.penalty_amount doubleValue] - self.settlementGetBillModel.salary - [self.settlementGetBillModel.deduct_amount                                                                                                                                                                                                                                                                        doubleValue]];
    
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
    
    self.settlementGetBillModel.date = [NSString getWeekDaysString:date];
    _selectedDate = date;
    [_settlementBillTable reloadData];
}

#pragma mark - 未结工资说明弹窗
- (void)btnClick:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint cureentTouchPosition = [touch locationInView:self.settlementBillTable];
    cureentTouchPosition.y = cureentTouchPosition.y + 64 + 80 - self.settlementBillTable.contentOffset.y;
    UIButton *btn = (UIButton *)sender;
    CGPoint cureentTouchBtn = [touch locationInView:btn];
    cureentTouchPosition.x = cureentTouchPosition.x + (11.5 - cureentTouchBtn.x);
    cureentTouchPosition.y = cureentTouchPosition.y + (11.5 - cureentTouchBtn.y);
    JGJQuestionShowtype type;
    
    type = JGJBalanceAmountType;
    //得到cell中的IndexPath
    [JGJQustionShowView showQustionFromPoint:cureentTouchPosition FromShowType:type];
    
}
#pragma mark - 选择项目
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    
    if (_is_Home_ComeIn && JLGisLeaderBool) {
        
        return;
    }
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    projectVC.isMarkSingleBillComeIn = YES;
    projectVC.projectListVCDelegate = self;
    projectVC.billModel = self.settlementGetBillModel;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.settlementGetBillModel.proname = projectModel.pro_name;
    self.settlementGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.settlementBillTable reloadData];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.settlementGetBillModel.proname = @"";
    self.settlementGetBillModel.pid     = 0;
    [self.settlementBillTable reloadData];
    
}

#pragma mark - 备注
- (void)markBillRemark{
    
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    self.settlementGetBillModel.accounts_type.code = 3;
    otherInfoVc.yzgGetBillModel = self.settlementGetBillModel;
    
    otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
    otherInfoVc.yzgGetBillModel.role = JLGisLeaderBool ? 1:2;
    otherInfoVc.imagesArray = self.remarkImagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.remarkImagesArray = images;
    self.settlementGetBillModel.notes_img = images.copy;
    self.settlementGetBillModel.notes_txt = remarkText;
    [self.settlementBillTable reloadData];
}

#pragma mark - 输入补贴 奖励 罚款 本次实收实付金额  抹零金额
- (void)JGJCloseAccountInputTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag {
    
    NSInteger section = cellTag / 10;
    NSInteger row = cellTag % 10;
    if (section == 2) {
        
        if (row == 1) { //补贴金额
            
            if ([NSString isEmpty:text]) {

                self.settlementGetBillModel.subsidy_amount = @"";

            }else{
                
                self.settlementGetBillModel.subsidy_amount = text;
            }
        }else if (row == 2) { //奖励金额
            
            if ([NSString isEmpty:text]) {

                self.settlementGetBillModel.reward_amount = @"";
            }else{
                
                self.settlementGetBillModel.reward_amount = text;

            }
            
        }else if (row == 3) {//罚款金额
            
            if ([NSString isEmpty:text]) {

                self.settlementGetBillModel.penalty_amount = @"";

            }else{
                
                self.settlementGetBillModel.penalty_amount = text;

            }
        }
            
            
    }else if (section == 3) {
        
        if (row == 0) {//本次实收/付金额
            
            if ([NSString isEmpty:text]) {


                self.settlementGetBillModel.salary = 0.00;
                
            }else{

                self.settlementGetBillModel.salary = [text doubleValue];
            }
            _markEditeMoney = self.settlementGetBillModel.salary;
            
        }else if (row == 1) {//抹零金额
            
            if ([NSString isEmpty:text]) {
                

                self.settlementGetBillModel.deduct_amount = @"";
                
            }else{
                
                self.settlementGetBillModel.deduct_amount = text;
            }
        }
    }
    
    [self CalculationAmount];
}

- (void)inputTextFieldEndEditing {
    
    [_settlementBillTable reloadData];
    
}

#pragma mark - JGJWaringSuggustTableViewCellDelegate
- (void)clickLookforDetailBtn {
    
    JGJUnWagesShortWorkVc *shortWorkVc = [JGJUnWagesShortWorkVc new];
    
    shortWorkVc.uid = [NSString stringWithFormat:@"%ld", (long)self.settlementGetBillModel.uid];
    
    [self.navigationController pushViewController:shortWorkVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        if ([NSString isEmpty:self.settlementGetBillModel.name] || [self.settlementGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {

            return 0;
        }
        return 36;
        
    }else {
        
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0  || section == 3 || section == 4) {
    
        return 10;
        
    }else if (section == 1) {
        
        if ([NSString isEmpty:self.settlementGetBillModel.name]) {
            
            return 0.01;
            
        }else {
            
            return 10;
        }
    }else {
        
        return 0.01;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc]init];
    [footerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    
    UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewTap)];
    footerView.userInteractionEnabled = YES;
    [footerView addGestureRecognizer:gestur];
    
    
    if (section == 0 || section == 3 || section == 4) {
        
        return footerView;
        
    }else if (section == 1) {
        
        if ([NSString isEmpty:self.settlementGetBillModel.name]) {
            
            return footerView;
            
        }else {

            return nil;
        }
    }else {
        
        return nil;
    }
    
}

- (void)footerViewTap {
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    [JGJQustionShowView removeQustionView];
}

#pragma mark - 提交结算记账数据到服务器
- (void)pushTinyAmountBillDataToServer {
    
    [self.view endEditing:YES];
    if ([NSString isEmpty: self.settlementGetBillModel.name]) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
        
    }else if ([NSString isEmpty:self.settlementGetBillModel.date]) {
        
        [TYShowMessage showPlaint:@"请先选择记账日期"];
        return;
        
    }else if ([NSString isEmpty:self.settlementGetBillModel.subsidy_amount]
              && [NSString isEmpty:self.settlementGetBillModel.reward_amount]
              && [NSString isEmpty:self.settlementGetBillModel.penalty_amount]
              && self.settlementGetBillModel.salary == 0){

        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3];
        [self startInputCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    
    self.yzgGetBillModel = self.settlementGetBillModel;
    
    self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
    
    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
    
    //只获取日期
    if ([NSString isEmpty:self.yzgGetBillModel.date]) {
        
        self.yzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
    }
    
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    
    self.parametersDic[@"accounts_type"] = @4;
    self.parametersDic[@"salary"] = @(self.yzgGetBillModel.salary?:0);
    self.parametersDic[@"balance_amount"] = self.yzgGetBillModel.balance_amount?:@"0";//未结
    self.parametersDic[@"subsidy_amount"] = self.yzgGetBillModel.subsidy_amount?:@"0";//补贴
    self.parametersDic[@"reward_amount"]  = self.yzgGetBillModel.reward_amount?:@"0";//奖金
    self.parametersDic[@"penalty_amount"] = self.yzgGetBillModel.penalty_amount?:@"0";//惩罚
    self.parametersDic[@"deduct_amount"]  = self.yzgGetBillModel.deduct_amount?:@"0";//抹零
    
    if (_is_Home_ComeIn) {
        
        [self.parametersDic setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [self.parametersDic setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [self.parametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
    
    __weak typeof(self) weakSelf = self;
    JGJCloseAnAccountInfoAlertView *accountInfoAlertView = [[JGJCloseAnAccountInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    [accountInfoAlertView setCurrentCloseAnCountMoney:weakSelf.settlementGetBillModel.settlementAmount leftMoney:weakSelf.settlementGetBillModel.remainingAmount];
    [accountInfoAlertView show];
    
    // 修改
    accountInfoAlertView.modify = ^{
        
        return;
    };
    
    accountInfoAlertView.submit = ^{
        
        [weakSelf submitDateToServerWithParametersDicRelase:self.parametersDic dataArray:self.settlementGetBillModel.dataArr dataNameArray:self.settlementGetBillModel.dataNameArr];
        
    };
    
}

- (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray {
    
    NSString *jesonPa = [@[parametersDicRelase] mj_JSONString];
    NSMutableDictionary *parameDic = [[NSMutableDictionary alloc] init];
    
    [parameDic setObject:jesonPa forKey:@"info"];
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];
    }
    
    if (![NSString isEmpty:self.agency_uid]) {
        
        [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
    }
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parameDic imagearray:self.remarkImagesArray otherDataArray:[self.yzgGetBillModel.dataArr copy] dataNameArray:[self.yzgGetBillModel.dataNameArr copy] success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self JGJModifyCloseBill];
        
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
                
                if (!_oneDayAttendanceComeIn) {
                    
                    _selectedDate = nil;
                }
                
                _markEditeMoney = 0.0;
                _is_unfold_subsidyCell = NO;
                YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
                oldBillModel.proname = self.yzgGetBillModel.proname;
                oldBillModel.pid = self.yzgGetBillModel.pid;
                oldBillModel.name = self.yzgGetBillModel.name;
                oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
                oldBillModel.unit_quan_tpl = self.yzgGetBillModel.unit_quan_tpl;
                
                //如果是从聊天进入  则荏苒要默认工头名字
                if (_is_Home_ComeIn) {
                    
                    self.settlementGetBillModel = [[YZGGetBillModel alloc] init];
                    self.settlementGetBillModel.proname = self.workProListModel.all_pro_name?:@"";
                    self.settlementGetBillModel.pid = [self.workProListModel.pro_id?:@"0"  longLongValue];
                    
                    self.settlementGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
                    
                    if (!JLGisLeaderBool) {
                        
                        self.settlementGetBillModel.uid = [self.workProListModel.creater_uid?:@"0"  longLongValue];
                        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
                        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
                        [self mainGoinGetTPL];
                        [self getOutstandingAmount];
                    }

                }else{
                    
                    self.settlementGetBillModel = [[YZGGetBillModel alloc]init];
                    
                    if (_markBillMore) {
                        
                        self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
                        self.yzgGetBillModel.pid = oldBillModel.pid;
                    }
                    self.settlementGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
                    [self.settlementBillTable reloadData];
                    
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
    //如果是从聊天进入  则要默认工头名字
    if (_markBillMore) {
        
        _markEditeMoney = 0.0;
        _is_unfold_subsidyCell = NO;
        self.settlementGetBillModel = [[YZGGetBillModel alloc] init];
        self.settlementGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.settlementGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        self.settlementGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.settlementBillTable reloadData];
        
    }else if (_is_Home_ComeIn) {
        
        self.settlementGetBillModel = [[YZGGetBillModel alloc] init];
        self.settlementGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.settlementGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        [self.settlementBillTable reloadData];
    }else{
        
        _markEditeMoney = 0.0;
        _is_unfold_subsidyCell = NO;
        self.settlementGetBillModel = [[YZGGetBillModel alloc]init];
        self.settlementGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        [self.settlementBillTable reloadData];
        
    }
    if (self.remarkImagesArray) {
        
        [self.remarkImagesArray removeAllObjects];
    }
}

#pragma mark - 首页进入记账获取薪资模板
- (void)mainGoinGetTPL {
    
    NSString *postApi = @"workday/fm-list";
    
    NSDictionary *parameters = @{@"uid":self.workProListModel.creater_uid?:@"",
                                 @"group_id":self.workProListModel.group_id?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:postApi parameters:parameters success:^(NSArray *responseObject) {
        
        self.settlementGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.settlementGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        self.settlementGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.settlementGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        [self.settlementBillTable reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}
#pragma mark - 提交数据后走这里，刷新未结工资页面数据
- (void)JGJModifyCloseBill
{
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJUnWagesVc")]) {
            
            JGJUnWagesVc *unWagesVc = (JGJUnWagesVc *)curVc;
            
            [unWagesVc refreshUnWagesData];
            
            break;
        }
        
        
    }
    
}

#pragma getter/setter
- (UITableView *)settlementBillTable {
    
    if (!_settlementBillTable) {
        
        _settlementBillTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _settlementBillTable.backgroundColor = AppFontf1f1f1Color;
        _settlementBillTable.showsVerticalScrollIndicator = NO;
        _settlementBillTable.delegate = self;
        _settlementBillTable.dataSource = self;
        _settlementBillTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settlementBillTable.tableFooterView = [[UIView alloc] init];
        _settlementBillTable.rowHeight = 55;
        _settlementBillTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        _settlementBillTable.bounces = NO;
        
    }
    return _settlementBillTable;
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

- (YZGGetBillModel *)settlementGetBillModel{
    
    if (!_settlementGetBillModel) {
        
        _settlementGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _settlementGetBillModel;
}

- (NSMutableDictionary *)parametersDic {
    
    if (!_parametersDic) {
        
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}
@end
