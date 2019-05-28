//
//  JGJBrrowBillController.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJBrrowBillController.h"

#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJMarkBillRemarkViewController.h"
#import "JGJPackNumViewController.h"

#import "JGJMarkBillBottomSaveView.h"
#import "JGJNewSelectedDataPickerView.h"

#import "JGJBrrowBillNormalCell.h"
#import "JGJBrrowBillInputCell.h"
#import "TYTextField.h"
#import "JGJCusSeniorPopView.h"
#import "JGJCreatTeamVC.h"
#import "JGJCusAlertView.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "JGJLeaderRecordsViewController.h"

#import "JGJGroupChatSelelctedMembersVc.h"

@interface JGJBrrowBillController ()
<UITableViewDelegate,UITableViewDataSource,JGJNewSelectedDataPickerViewDelegate,JGJNewMarkBillChoiceProjectViewControllerDelgate,JGJMarkBillRemarkViewControllerDelegate,JGJBrrowBillInputCellDelegate>
{
    JGJBrrowBillNormalCell *_normalCell;
    JGJBrrowBillInputCell *_inputCell;
    YZGAddForemanModel *_selectedForemanModel;
}
@property (nonatomic, strong) UITableView *brrowBillTable;// 包工记账列表
@property (nonatomic, strong) JGJMarkBillBottomSaveView *bottomSaveView;// 底部保存按钮

@property (nonatomic,strong) NSMutableArray *remarkImagesArray;// 备注图片数组

@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;// 日期选择器

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;

//选择的记账人员

@property (nonatomic, strong) NSArray *selMembers;

@end

@implementation JGJBrrowBillController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self initializeAppearance];
    
    self.brrowGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomSaveView];
    [self.view addSubview:self.brrowBillTable];
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
    
    [_brrowBillTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_bottomSaveView.mas_top).offset(0);
        make.left.right.top.mas_equalTo(0);
    }];
    
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    
    if (_is_Home_ComeIn) {// 首页进入借支
        
        self.brrowGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.brrowGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        if (!JLGisLeaderBool) {
            
            self.brrowGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
            id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
            [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
            [self mainGoinGetTPL];
        }
        
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
        
        return 1;
        
    }else {
        
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0 || indexPath.section == 2) {
        
        _normalCell = [JGJBrrowBillNormalCell cellWithTableViewNotXib:tableView];
        _normalCell.is_Home_ComeIn = self.is_Home_ComeIn;
        _normalCell.cellTag = indexPath.section * 10 + indexPath.row;
        _normalCell.yzgGetBillModel = self.brrowGetBillModel;
        [_normalCell stopTwinkleAnimation];
        return _normalCell;
        
    }else {
        
        if (indexPath.row == 0) {
            
            _inputCell = [JGJBrrowBillInputCell cellWithTableViewNotXib:tableView];
            _inputCell.cellTag = indexPath.section * 10 + indexPath.row;
            _inputCell.yzgGetBillModel = self.brrowGetBillModel;
            _inputCell.delegate = self;
            return _inputCell;
            
        }
        
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 1) {
        
        if ([NSString isEmpty:self.brrowGetBillModel.name]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
        }
    }else if (section == 1){
        
        if ([NSString isEmpty: self.brrowGetBillModel.name]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startCellTwinkleAnimationWithIndexPath:path];
            return;
            
        }
        
    }else if (section == 2){
        
        if (row == 0) {
            
            if (_is_Home_ComeIn && JLGisLeaderBool) {
                
                return;
            }
        }
        if (!self.brrowGetBillModel.name) {
            
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
            
            //班组内的“借支/结算”，借支增加一天记多人（只有班组长有此功能
            
            if (JLGisLeaderBool && _is_Home_ComeIn) {
                
                [self handleSelMembers];
                
            }else {
                
               [self handleAddForemanAdnMateVcWithModel:self.brrowGetBillModel];
                
            }
            
        }else if (row == 1) {
            
            [self showDatePickerByIndexPath:indexPath];
        }
        
    }else if (section == 2) {
        
        if (row == 0) {
            
            [self showProjectPickerByIndexPath:indexPath];
            
        }else {
            
            [self markBillRemark];
        }
    }
}

- (void)startCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJBrrowBillNormalCell *cell = [self.brrowBillTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)startInputCellTwinkleAnimationWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJBrrowBillInputCell *cell = [self.brrowBillTable cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [AppFontEB4E4EColor colorWithAlphaComponent:0.2];
    [cell startTwinkleAnimation];
}

- (void)stopCellTwinkleAnimation {
    
    NSIndexPath *normalPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JGJBrrowBillNormalCell *normalCell = [self.brrowBillTable cellForRowAtIndexPath:normalPath];
    [normalCell stopTwinkleAnimation];
    
    NSIndexPath *inputPath = [NSIndexPath indexPathForRow:0 inSection:1];
    JGJBrrowBillInputCell *inputCell = [self.brrowBillTable cellForRowAtIndexPath:inputPath];
    [inputCell stopTwinkleAnimation];
    
    [_brrowBillTable reloadData];
}

#pragma mark - method
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    
    self.addForemanModel.telph = billModel.phone_num;
    
    self.addForemanModel.uid = billModel.uid;
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //返回的时候用
    
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
                
                weakSelf.brrowGetBillModel = [[YZGGetBillModel alloc] init];
                weakSelf.brrowGetBillModel.date = [NSString getWeekDaysString:_selectedDate ? : [NSDate date]];
                
            }
            [self.brrowBillTable reloadData];
            
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
    
    self.selMembers = @[accoumtMember];
    
    [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
}

- (void)reqeustAccountInfoWithAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    self.addForemanModel = addForemanModel;
    
    self.brrowGetBillModel.name = addForemanModel.name;
    self.brrowGetBillModel.uid = addForemanModel.uid;
    
    [self.brrowBillTable reloadData];
    
    if (!_markBillMore) {
        
        if (self.brrowGetBillModel.uid) {
            
            [self JLGHttpRequest_LastproWithUid: self.brrowGetBillModel.uid];
        }
    }
}


#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":@"3",
                 @"group_id":self.is_Home_ComeIn ? self.workProListModel.group_id ?:@"":@""
                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
        
        if ([NSString isEmpty: responseObject[@"pro_name"]]) {
            
            self.brrowGetBillModel.proname = self.workProListModel.all_pro_name;
            self.brrowGetBillModel.pid = 0;
            
        }else{
            
            if ([responseObject[@"pro_name"] length] < 2 && _is_Home_ComeIn) {
                
                self.brrowGetBillModel.proname = self.workProListModel.all_pro_name;
                self.brrowGetBillModel.pid = 0;
                
            }else{
                
                self.brrowGetBillModel.proname = responseObject[@"pro_name"]?:@"";
                self.brrowGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
            }
            
        }
        
        [self.brrowBillTable reloadData];
        
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
    
    self.brrowGetBillModel.date = [NSString getWeekDaysString:date];
    _selectedDate = date;
    [_brrowBillTable reloadData];
}

#pragma mark - 选择项目
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    
    if (_is_Home_ComeIn && JLGisLeaderBool) {
        
        return;
    }
    
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    projectVC.isMarkSingleBillComeIn = YES;
    projectVC.projectListVCDelegate = self;
    projectVC.billModel = self.brrowGetBillModel;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.brrowGetBillModel.proname = projectModel.pro_name;
    self.brrowGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.brrowBillTable reloadData];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.brrowGetBillModel.proname = @"";
    self.brrowGetBillModel.pid     = 0;
    [self.brrowBillTable reloadData];
    
}

#pragma mark - 备注
- (void)markBillRemark{
    
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    self.brrowGetBillModel.accounts_type.code = 3;
    otherInfoVc.yzgGetBillModel = self.brrowGetBillModel;
    
    otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
    otherInfoVc.yzgGetBillModel.role = JLGisLeaderBool ? 1:2;
    otherInfoVc.imagesArray = self.remarkImagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.remarkImagesArray = images;
    self.brrowGetBillModel.notes_img = images.copy;
    self.brrowGetBillModel.notes_txt = remarkText;
    [self.brrowBillTable reloadData];
}

#pragma mark - 输入单价和分项名称 JGJContractorMakeAttendanceInputCellDelegate
- (void)JGJBrrowBillInputTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag {
    
    NSInteger section = cellTag / 10;
    NSInteger row = cellTag % 10;
    if (section == 1) {
        
        if (row == 0) {
            
            // 借支金额
            self.brrowGetBillModel.browNum = text?:@"0";
            
        }
    }
}

- (void)inputTextFieldEndEditing {

    [_brrowBillTable reloadData];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.brrowBillTable reloadData];
    [self.view endEditing:YES];
}

#pragma mark - 提交借支记账数据到服务器
- (void)pushTinyAmountBillDataToServer {
    
    [self.view endEditing:YES];
    if ([NSString isEmpty:self.brrowGetBillModel.name ]) {

        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self startCellTwinkleAnimationWithIndexPath:path];
        return;
    }
    else if (!self.brrowGetBillModel.browNum ||[self.brrowGetBillModel.browNum doubleValue] == 0) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [self startInputCellTwinkleAnimationWithIndexPath:path];
        
        return;
    }
    self.yzgGetBillModel = self.brrowGetBillModel;
    
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
    
    
    //只获取日期
    if ([NSString isEmpty:self.yzgGetBillModel.date]) {
        
        self.yzgGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
    }
    
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    
    self.parametersDic[@"accounts_type"] = @3;
    self.parametersDic[@"salary"] = self.yzgGetBillModel.browNum;
    
    if (_is_Home_ComeIn) {
        
        [self.parametersDic setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [self.parametersDic setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [self.parametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
    [self submitDateToServerWithParametersDicRelase:self.parametersDic dataArray:self.brrowGetBillModel.dataArr dataNameArray:self.brrowGetBillModel.dataNameArr];
    
}

- (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray {
    
    NSMutableArray *parametersArrayRelase = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selMembers.count; i ++) {
        
        JGJSynBillingModel *billingModel = self.selMembers[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parametersDicRelase];
        [dic setObject:billingModel.uid forKey:@"uid"];
        [dic setObject:billingModel.name forKey:@"name"];
        
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
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parameDic imagearray:self.remarkImagesArray otherDataArray:[self.yzgGetBillModel.dataArr copy] dataNameArray:[self.yzgGetBillModel.dataNameArr copy] success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
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
                
                YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
                oldBillModel.proname = self.yzgGetBillModel.proname;
                oldBillModel.pid = self.yzgGetBillModel.pid;
                oldBillModel.name = self.yzgGetBillModel.name;
                oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
                oldBillModel.unit_quan_tpl = self.yzgGetBillModel.unit_quan_tpl;
                
                //如果是从聊天进入  则荏苒要默认工头名字
                if (_is_Home_ComeIn) {
                    
                    self.brrowGetBillModel = [[YZGGetBillModel alloc] init];
                    self.brrowGetBillModel.proname = _workProListModel.all_pro_name?:@"";
                    self.brrowGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
                    
                    if (!JLGisLeaderBool) {
                        
                        self.brrowGetBillModel.uid = [_workProListModel.creater_uid?:@"0"  longLongValue];
                        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
                        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
                        [self mainGoinGetTPL];
                    }

                    
                }else{
                    
                    self.brrowGetBillModel = [[YZGGetBillModel alloc]init];
                    
                    if (_markBillMore) {
                        
                        self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
                        self.yzgGetBillModel.pid = oldBillModel.pid;
                    }
                    self.brrowGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
                    [self.brrowBillTable reloadData];
                    
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
    //如果是从聊天进入  则荏苒要默认工头名字
    if (_markBillMore) {
        
#pragma mark - 添加
        self.brrowGetBillModel = [[YZGGetBillModel alloc] init];
        
        self.brrowGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.brrowGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        self.brrowGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        [self.brrowBillTable reloadData];
        
    }else if (_is_Home_ComeIn) {
        
        self.brrowGetBillModel = [[YZGGetBillModel alloc] init];
        self.brrowGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.brrowGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        [self.brrowBillTable reloadData];
        
    }else{
        
        self.brrowGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.brrowGetBillModel.date = [NSString getWeekDaysString:_selectedDate?:[NSDate date]];
        
        [self.brrowBillTable reloadData];
        
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
        
        self.brrowGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.brrowGetBillModel.date = [NSString getWeekDaysString:[NSDate date]];
        self.brrowGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.brrowGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        JGJSynBillingModel *billingModel = [[JGJSynBillingModel alloc] init];
        billingModel.uid = responseObject[0][@"uid"];
        billingModel.name = responseObject[0][@"name"]?:@"";
        //self.selMembers[i];
        self.selMembers = @[billingModel];
        
        [self.brrowBillTable reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 班组长记借支选择多人

- (void)handleSelMembers {
    
    JGJGroupChatSelelctedMembersVc *membersVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatSelelctedMembersVc"];
    
    //获取从群添加人员的id 类型,当前组的信息
    
    membersVc.chatType = JGJGroupChatType;
    
    JGJMyWorkCircleProListModel *groupListModel = [JGJMyWorkCircleProListModel new];
    
    groupListModel.group_id = self.workProListModel.group_id;
    
    groupListModel.class_type = @"group";
    
    groupListModel.group_name = self.workProListModel.group_name;
    
    membersVc.contactedAddressBookVcType = JGJGroupMangerAddMembersVcType;
    
    membersVc.groupListModel = groupListModel;
    
    JGJTeamInfoModel *teamInfo = [JGJTeamInfoModel new];
    
    teamInfo.member_list = self.selMembers.mutableCopy;
    
    membersVc.teamInfo = teamInfo;
    
    //记多人标识
    membersVc.isRecordSelMembers = YES;
    
    
    [self.navigationController pushViewController:membersVc animated:YES];
    
    TYWeakSelf(self);
    
    membersVc.recordSelMembersVcBlock = ^(NSArray *members) {
        
        weakself.selMembers = members;
        
        [weakself handleMemberCallBack:members];
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    };
    
}

#pragma mark - 选多人回调参数处理

- (void)handleMemberCallBack:(NSArray *)members {
    
    NSMutableString *infos = [NSMutableString string];
  
    if (members.count == 1) {
        
        JGJSynBillingModel *memberModel = members[0];
        self.brrowGetBillModel.name = memberModel.name;
        
    }else {
        
        JGJSynBillingModel *firstMemberModel = members[0];
        JGJSynBillingModel *secondMemberModel = members[1];
        
        if (members.count == 2) {
            
            [infos appendFormat:@"%@、%@",firstMemberModel.name,secondMemberModel.name];
            
        }else {
            
            [infos appendFormat:@"%@、%@等%ld人",firstMemberModel.name,secondMemberModel.name,members.count];
        }
        
        self.brrowGetBillModel.name = infos;
    }
    
    [self.brrowBillTable reloadData];
}

#pragma getter/setter
- (UITableView *)brrowBillTable {
    
    if (!_brrowBillTable) {
        
        _brrowBillTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _brrowBillTable.backgroundColor = AppFontf1f1f1Color;
        _brrowBillTable.showsVerticalScrollIndicator = NO;
        _brrowBillTable.delegate = self;
        _brrowBillTable.dataSource = self;
        _brrowBillTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _brrowBillTable.tableFooterView = [[UIView alloc] init];
        _brrowBillTable.rowHeight = 55;
        _brrowBillTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        _brrowBillTable.bounces = NO;
        
    }
    return _brrowBillTable;
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


- (YZGGetBillModel *)brrowGetBillModel{
    
    if (!_brrowGetBillModel) {
        
        _brrowGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _brrowGetBillModel;
}

- (NSMutableDictionary *)parametersDic {
    
    if (!_parametersDic) {
        
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}

@end
