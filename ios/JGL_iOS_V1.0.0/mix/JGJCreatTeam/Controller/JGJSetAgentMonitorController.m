//
//  JGJSetAgentMonitorController.m
//  mix
//
//  Created by Tony on 2018/7/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSetAgentMonitorController.h"
#import "JGJSetAgentMonitorCell.h"
#import "JGJSetAgentExplainCell.h"
#import "JGJTaskPrincipalVc.h"
#import "ATDatePicker.h"
#import "NSDate+Extend.h"
#import "JGJRequestModel.h"
#import "UIImage+Color.h"
#import "JGJHelpCenterTitleView.h"
@interface JGJSetAgentMonitorController ()<UITableViewDelegate,UITableViewDataSource,JGJTaskPrincipalVcDelegate>
{
    JGJSetAgentMonitorCell *_cell;
    JGJSetAgentExplainCell *_explainCell;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *contentArr;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, copy) NSArray *explainInfoContentArr;

//选择的代理人员
@property (nonatomic, strong) JGJSynBillingModel *agencyMemberModel;

//缓存选择的班组人员
@property (nonatomic, strong) NSArray *agencyMemberModels;
@property (nonatomic, strong) JGJSetAgentMonitorRequest *requestModel;

@end

@implementation JGJSetAgentMonitorController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self initializeAppearance];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterSetAgencyType;
    
    titleView.title = @"设置代班长";
    
    self.navigationItem.titleView = titleView;
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.table];
}

- (UITableView *)table {
    
    if (!_table) {
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 10) style:(UITableViewStylePlain)];
        _table.backgroundColor = AppFontf1f1f1Color;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        _table.scrollEnabled = NO;
    }
    return _table;
}

- (NSMutableArray *)titleArr {
    
    if (!_titleArr) {
        
        _titleArr = [[NSMutableArray alloc] initWithArray:@[@[@"设置代班长"],@[@"开始时间",@"结束时间"]]];
    }
    return _titleArr;
}

- (NSMutableArray *)contentArr {
    
    if (!_contentArr) {
        
        NSString *st_time = self.agency_group_user.start_time;
        
        NSString *en_time = self.agency_group_user.end_time;
        
        NSString *name = self.agency_group_user.real_name?:@"";
        
        _contentArr = [[NSMutableArray alloc] initWithArray:@[@[name],@[st_time?:@"",en_time?:@""]]];
    }
    return _contentArr;
}

- (NSArray *)explainInfoContentArr {
    
    if (!_explainInfoContentArr) {
        
        _explainInfoContentArr = @[@"说明信息:",@"代班长可以代替班组长记工记账及管理班组成员;",@"代班长在代班时间内，可以修改、删除自己代班记的账也可以修改班组长记得账;",@"代班长只能记代班时间内的账;",@"代班长不能看到代班时间以外的班组长的记工;",@"代班长修改记账时，不能修改项目名称;"];
    }
    return _explainInfoContentArr;
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(15, 25, TYGetUIScreenWidth - 30, 40);
        _saveBtn.backgroundColor = AppFontEB4E4EColor;
        [_saveBtn setTitle:@"保存设置" forState:(UIControlStateNormal)];
        [_saveBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _saveBtn.titleLabel.font = FONT(AppFont30Size);
        _saveBtn.layer.cornerRadius = 5;
        
        if (_agency_group_user.uid != nil) {
            
            _saveBtn.selected = YES;
            _saveBtn.backgroundColor = AppFontffffffColor;
            [_saveBtn setTitle:@"取消代班长设置" forState:(UIControlStateNormal)];
//            [_saveBtn setTitle:@"取消代班长设置" forState:(UIControlStateNormal)];
            [_saveBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
            _saveBtn.layer.borderColor = AppFontEB4E4EColor.CGColor;
            _saveBtn.layer.borderWidth = 1;
            
        }else {
            
            _saveBtn.selected = NO;
        }
        [_saveBtn addTarget:self action:@selector(saveTheAgentMonitorInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}

- (void)setSaveBtnStateWithIsChanged:(BOOL)isChanged {
    
    // 有改变
    if (isChanged) {
        
        _saveBtn.backgroundColor = AppFontEB4E4EColor;
        [_saveBtn setTitle:@"保存设置" forState:(UIControlStateNormal)];
        [_saveBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _saveBtn.selected = NO;
    }
}

- (void)saveTheAgentMonitorInfo:(UIButton *)sender {
    
    // 取消设置代理班长
    if (sender.selected) {
        
        _requestModel = [[JGJSetAgentMonitorRequest alloc] init];
        _requestModel.group_id = self.proListModel.group_id;
        _requestModel.class_type = self.proListModel.class_type;
        _requestModel.uid = self.agencyMemberModel.uid;
        _requestModel.start_time = self.agency_group_user.start_time;
        _requestModel.end_time = self.agency_group_user.end_time;
        _requestModel.is_cancel = 1;
        [TYLoadingHub showLoadingWithMessage:@""];
        
        [JLGHttpRequest_AFN PostWithNapi:@"workday/set-proxy-grouper" parameters:[_requestModel mj_keyValues] success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
           
            [TYShowMessage showSuccess:@"代班长取消成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        
    }else {// 设置代理班长
        
        _requestModel = [[JGJSetAgentMonitorRequest alloc] init];
        _requestModel.group_id = self.proListModel.group_id;
        _requestModel.class_type = self.proListModel.class_type;
        _requestModel.uid = self.agencyMemberModel.uid;
        _requestModel.start_time = self.agency_group_user.start_time;
        _requestModel.end_time = self.agency_group_user.end_time;
        _requestModel.is_cancel = 0;
        if (_requestModel.uid == nil) {
            
            [TYShowMessage showPlaint:@"请选择代班长"];
            return;
        }
        [TYLoadingHub showLoadingWithMessage:@""];
        
        [JLGHttpRequest_AFN PostWithNapi:@"workday/set-proxy-grouper" parameters:[_requestModel mj_keyValues] success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            if (self.setAgentMonSuccessBlock) {
                
                self.agency_group_user.name = self.agencyMemberModel.name;
                self.setAgentMonSuccessBlock(self.agency_group_user);
            }
            
            [TYShowMessage showSuccess:@"代班长设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
}

- (void)setAgency_group_user:(JGJSynBillingModel *)agency_group_user {
    
    _agency_group_user = agency_group_user;
    self.agencyMemberModel = [[JGJSynBillingModel alloc] init];
    self.agencyMemberModel.uid = agency_group_user.uid;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setSaveBtnStateWithIsChanged:YES];
    if (indexPath.section < 2) {
        
        if (indexPath.section == 0) {
            
            [self selPrinMember];
            
        }else {
            
            if (indexPath.row == 0) {
                
                [self setSt_time];
                
            }else {
                
                [self setEn_time];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < 2) {
        
        return 45;
        
    }else {
        
        if (indexPath.section == 2 && indexPath.row == 2) {
            
            return 44;
            
        }else {
            
            return 26;
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1){
        
        return 2;
        
    }else {
        
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section < 2) {
        
        NSString *ID = NSStringFromClass([JGJSetAgentMonitorCell class]);
        _cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!_cell) {
            
            _cell = [[JGJSetAgentMonitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        _cell.tag = indexPath.section * 10 + indexPath.row;
        _cell.titleArr = self.titleArr;
        _cell.contentArr = self.contentArr;
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _cell;
    }else {
        
        NSString *ID = NSStringFromClass([JGJSetAgentExplainCell class]);
        _explainCell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!_explainCell) {
            
            _explainCell = [[JGJSetAgentExplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        _explainCell.tag = indexPath.section * 10 + indexPath.row;
        _explainCell.contentArr = self.explainInfoContentArr;
        _explainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _explainCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 90;
    }else {
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 90)];
    backView.backgroundColor = AppFontf1f1f1Color;
    
    [backView addSubview:self.saveBtn];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 30;
    }else {
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = AppFontf1f1f1Color;
    backView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    
    UILabel *title = [[UILabel alloc] init];
    title.font = FONT(AppFont26Size);
    title.backgroundColor = AppFontf1f1f1Color;
    title.textColor = AppFont999999Color;
    title.text = @"代班时间";
    [backView addSubview:title];
    
    title.sd_layout.leftSpaceToView(backView, 15).centerYEqualToView(backView).widthIs(100).heightIs(10);
    
    return backView;
}

#pragma mark - 选择代班长
- (void)selPrinMember {
    
    JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
    
    principalVc.delegate = self;
    
    principalVc.memberSelType = JGJAgencySelMemberType;
    
    principalVc.proListModel = self.proListModel;
    
    if (![NSString isEmpty:self.agencyMemberModel.uid]) {
        
        principalVc.principalModel = self.agencyMemberModel;
        
    }else if (![NSString isEmpty:self.agency_group_user.uid]) {
        
        principalVc.principalModel = self.agency_group_user;
        
    }
    
    principalVc.principalModels = self.agencyMemberModels;
    
    [self.navigationController pushViewController:principalVc animated:YES];
    
}

#pragma mark - 设置开始时间
- (void)setSt_time {
    
    
    TYWeakSelf(self);
    
    ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate ATDatePickerType:ATDatePickerCusBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        weakself.agency_group_user.start_time = dateString?:@"";
        
        NSArray *times = @[weakself.agency_group_user.start_time?:@"", weakself.agency_group_user.end_time?:@""];

        [_contentArr replaceObjectAtIndex:1 withObject:times];
        
       [weakself.table reloadData];
        
        TYLog(@"%@", dateString);
    }];
    
    if (![NSString isEmpty:self.agency_group_user.end_time]) {
        
        datePicker.maximumDate = [NSDate dateFromString:self.agency_group_user.end_time withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![NSString isEmpty:self.agency_group_user.start_time]) {
        
        datePicker.date = [NSDate dateFromString:self.agency_group_user.start_time withDateFormat:@"yyyy-MM-dd"];
    }
    
     [datePicker show];
}

#pragma mark - 设置结束时间
- (void)setEn_time {
    
    TYWeakSelf(self);
    
    ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate  ATDatePickerType:ATDatePickerCusBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        weakself.agency_group_user.end_time = dateString?:@"";
        
        NSArray *times = @[weakself.agency_group_user.start_time?:@"", weakself.agency_group_user.end_time?:@""];
        
        [_contentArr replaceObjectAtIndex:1 withObject:times];
        
        [weakself.table reloadData];
        
        TYLog(@"%@", dateString);
    }];
    
    if (![NSString isEmpty:self.agency_group_user.end_time]) {
        
        datePicker.date = [NSDate dateFromString:self.agency_group_user.end_time withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![NSString isEmpty:self.agency_group_user.start_time]) {
        
        datePicker.minimumDate = [NSDate dateFromString:self.agency_group_user.start_time withDateFormat:@"yyyy-MM-dd"];
    }
    
    [datePicker show];
}

#pragma mark - JGJTaskPrincipalVcDelegate
- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {
    
    TYLog(@"设置的代班长人员---------%@", memberModel.name);
    
    self.agencyMemberModels = principalVc.cacheSortContactsModels;
    
    self.agencyMemberModel = memberModel;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *agencys = @[memberModel.name?:@""];
    
    [_contentArr replaceObjectAtIndex:0 withObject:agencys];
    
    [self.table reloadData];
    
}

@end
