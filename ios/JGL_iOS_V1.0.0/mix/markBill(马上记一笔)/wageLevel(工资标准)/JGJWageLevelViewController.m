//
//  JGJWageLevelViewController.m
//  mix
//
//  Created by Tony on 2018/1/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWageLevelViewController.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "JGJMarkBillViewController.h"

#import "JGJModifyBillListViewController.h"

#import "JGJManHourPickerView.h"

#import "JGJBottomBtnView.h"

#import "JGJModifyBillListViewController.h"

#import "JGJMorePeopleViewController.h"
#import "JGJCustomAlertView.h"
#import "JGJMoreDayViewController.h"

#import "JGJWageLevelInputAmountCell.h"
#import "JGJChoiceWorkOvertimeCalculateWay.h"
#import "UILabel+GNUtil.h"
@interface JGJWageLevelViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJManHourPickerViewDelegate,

JGJMarkBillTextFileTableViewCellDelegate
>
{
    
    CGFloat _editeMoney;
    CGFloat _overtimeWageOneHour;// 每小时加班工钱
    JGJWageLevelInputAmountCell *_inputAmountCell;
    BOOL _overtimeWageByTheHour;// YES -> 代表按小时算加班工资 NO -> 代表按工天算加班
}

@property (strong ,nonatomic) NSArray *titleArr;
@property (strong, nonatomic) UIButton *bottomBtnView;
@property (nonatomic, strong) UIView *footerView;

// 加班一小时标准system
@property (nonatomic, strong) UIView *moneyForOneHourOverBackView;
@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UILabel *overTimeLabel;
@property (nonatomic, strong) UILabel *moneyForOneHourOverTime;
@property (nonatomic, strong) UIView *moneyForOneHourOverLine;

@end

@implementation JGJWageLevelViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = (JLGisLeaderBool || self.isAgentMonitor)? @"工资标准":@"我的工资标准";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_wagesMembers.count > 0) {
        
        self.titleArr = @[@[@"上班标准",@"工资金额"],@[@"加班标准"]];
    }else {
        
        self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长"],@[@"上班标准",@"工资金额"],@[@"加班标准"]];
    }
    
    
    [self.footerView addSubview:self.bottomBtnView];
    [self.footerView addSubview:self.moneyForOneHourOverBackView];
    
    [self.moneyForOneHourOverBackView addSubview:self.systemLabel];
    [self.moneyForOneHourOverBackView addSubview:self.overTimeLabel];
    [self.moneyForOneHourOverBackView addSubview:self.moneyForOneHourOverTime];
    [self.moneyForOneHourOverBackView addSubview:self.moneyForOneHourOverLine];
    
    [self updateFooterViewWithYZGGetBillModel:self.yzgGetBillModel];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
}

- (void)updateFooterViewWithYZGGetBillModel:(YZGGetBillModel *)yzModel {
    
    if (_editeMoney > 0.0 && !_overtimeWageByTheHour) {
        
        _footerView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 156);
        _moneyForOneHourOverBackView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 50);
        _bottomBtnView.frame = CGRectMake(20, 90, TYGetUIScreenWidth - 40, 45);
        
        _moneyForOneHourOverBackView.hidden = NO;
        _systemLabel.hidden = NO;
        _overTimeLabel.hidden = NO;
        _moneyForOneHourOverTime.hidden = NO;
        _moneyForOneHourOverLine.hidden = NO;
        
        
        CGFloat over_time;
        if (yzModel.set_tpl.o_h_tpl == 0) {
            
            over_time = 6.0;
        }else {
            
            over_time = yzModel.set_tpl.o_h_tpl;
        }
        double moneyForOneHour = _editeMoney / over_time;
        self.moneyForOneHourOverTime.text = [NSString stringWithFormat:@"%.2f 元/小时",[NSString roundFloat:moneyForOneHour]];
        [self.moneyForOneHourOverTime markattributedTextArray:@[[NSString stringWithFormat:@"%.2f",[NSString roundFloat:moneyForOneHour]]] color:AppFontEB4E4EColor];
        
    }else {
        
        _footerView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 106);
        _moneyForOneHourOverBackView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0);
        _bottomBtnView.frame = CGRectMake(20, 40, TYGetUIScreenWidth - 40, 45);
        
        _moneyForOneHourOverBackView.hidden = YES;
        _systemLabel.hidden = YES;
        _overTimeLabel.hidden = YES;
        _moneyForOneHourOverTime.hidden = YES;
        _moneyForOneHourOverLine.hidden = YES;
        
    }
    
    self.tableView.tableFooterView = _footerView;
}


- (void)clickSureBtn {
    
    [self.view endEditing:YES];
    
    if (self.yzgGetBillModel.set_tpl.w_h_tpl <= 0) {
        
        self.yzgGetBillModel.set_tpl.w_h_tpl = 8;
    }
    if (self.yzgGetBillModel.set_tpl.o_h_tpl <= 0) {
        
        self.yzgGetBillModel.set_tpl.o_h_tpl = 6;
    }
    
    // 当前选择的是 按每小时计算加班费
    if (_overtimeWageByTheHour) {
        
        if (_editeMoney == 0) {
            
            [TYShowMessage showPlaint:@"请输入工资金额"];
            return;
        }
        
        if (_overtimeWageOneHour == 0) {
            
            [TYShowMessage showPlaint:@"请输入加班一小时的工资金额"];
            return;
        }
    }
    
    //选择的是 按工天算加班
    if (_overtimeWageByTheHour == 0) {
        
        self.yzgGetBillModel.set_tpl.hour_type = 0;
        
    }else {
        
        self.yzgGetBillModel.set_tpl.hour_type = 1;
    }
    self.yzgGetBillModel.set_tpl.s_tpl = _editeMoney;
    self.yzgGetBillModel.set_tpl.o_s_tpl = _overtimeWageOneHour;
    NSMutableArray *tpl_arr = [[NSMutableArray alloc] init];
    
    if (self.wagesMembers.count > 0) {
        
        for (JGJSynBillingModel * model in self.wagesMembers) {
            
            NSDictionary *parame = @{@"uid":model.uid,
                                     @"salary_tpl":@(_yzgGetBillModel.set_tpl.s_tpl),
                                     @"work_hour_tpl":@(self.yzgGetBillModel.set_tpl.w_h_tpl),
                                     @"overtime_hour_tpl":@(self.yzgGetBillModel.set_tpl.o_h_tpl),
                                     @"overtime_salary_tpl":@(self.yzgGetBillModel.set_tpl.o_s_tpl),
                                     @"hour_type":@(self.yzgGetBillModel.set_tpl.hour_type),
                                     @"accounts_type":@"1"};
            [tpl_arr addObject:parame];
        }
        
    }else {
        
        NSDictionary *parame = @{@"uid":@(_yzgGetBillModel.uid),
                                 @"salary_tpl":@(_yzgGetBillModel.set_tpl.s_tpl),
                                 @"work_hour_tpl":@(self.yzgGetBillModel.set_tpl.w_h_tpl),
                                 @"overtime_hour_tpl":@(self.yzgGetBillModel.set_tpl.o_h_tpl),
                                 @"overtime_salary_tpl":@(self.yzgGetBillModel.set_tpl.o_s_tpl),
                                 @"hour_type":@(self.yzgGetBillModel.set_tpl.hour_type),
                                 @"accounts_type":@"1"};
        [tpl_arr addObject:parame];
    }
    
    NSString *paramStr = [tpl_arr mj_JSONString];
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/set-workday-tpl" parameters:@{@"params":paramStr} success:^(id responseObject) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJMarkBillViewController class]]) {
                
                JGJMarkBillViewController *markBillVC = (JGJMarkBillViewController *)vc;
                markBillVC.tinyYzgGetBillModel = self.yzgGetBillModel;
                if (self.yzgGetBillModel.manhour == 0 && !self.yzgGetBillModel.isRest) {
                    
                    markBillVC.tinyYzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;
                }
                if (self.yzgGetBillModel.overtime == 0 && !self.yzgGetBillModel.isOverWork) {
                    
                    markBillVC.tinyYzgGetBillModel.overtime = 0;
                }
                
                [markBillVC getSalary];
                [markBillVC.mainCollectionview reloadData];
                
            }else if ([vc isKindOfClass:[JGJModifyBillListViewController class]]){
                
                JGJModifyBillListViewController *markBillVC = (JGJModifyBillListViewController *)vc;
                markBillVC.yzgGetBillModel = self.yzgGetBillModel;
                
            }else if ([vc isKindOfClass:[JGJMorePeopleViewController class]]){
                
                JGJMorePeopleViewController *markBillVC = (JGJMorePeopleViewController *)vc;
                markBillVC.yzgGetBillModel = self.yzgGetBillModel;
                
            }else if ([vc isKindOfClass:[JGJMoreDayViewController class]]){
                
                JGJMoreDayViewController *moreDayBillVC = (JGJMoreDayViewController *)vc;
            }
            
        }
        
        
        if (self.wagesMembers.count > 0) {
            
            NSString *alertString;
            if (JLGisLeaderBool) {
                
                alertString = @"设置成功，快去为工人记工吧！";
                
            }else {
                
                alertString = @"设置成功，快去为班组长记工吧！";
            }
            JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithMessage:alertString];
            alertView.message.textAlignment = NSTextAlignmentCenter;
            
            alertView.message.font = [UIFont systemFontOfSize:AppFont30Size];
            
            [alertView.confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
            [alertView.confirmButton setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
            alertView.confirmButton.backgroundColor = AppFontfafafaColor;
            __weak typeof(self) weakSelf = self;
            
            alertView.onClickedBlock = ^{
                
                if (self.setWageLevelSuccess) {
                    
                    self.setWageLevelSuccess();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            };
        }else {
            
            if (self.setWageLevelSuccessWithBillModel) {
                
                self.setWageLevelSuccessWithBillModel(self.yzgGetBillModel);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.wagesMembers.count > 0) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 1) {
                
                _inputAmountCell = [JGJWageLevelInputAmountCell cellWithTableView:tableView];
                _inputAmountCell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
                _inputAmountCell.inputTextField.placeholder = @"请输入工资金额";
                _inputAmountCell.inputTextField.digit = 7;
                _inputAmountCell.unitsLabel.text = @"元/个工";
                _inputAmountCell.inputTextField.tag = 100;
                _inputAmountCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                if (_editeMoney > 0) {
                    
                    _inputAmountCell.inputTextField.text = [NSString stringWithFormat:@"%.2f",_editeMoney];
                    
                }else {
                    
                    _inputAmountCell.inputTextField.text = @"";
                }
                
                [_inputAmountCell.inputTextField addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
                
                
                return _inputAmountCell;
                
            }else {
                
                JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
                [self setDataWithCell: cell FromIndexPath:indexPath];
                return cell;
            }
        }else if (indexPath.section == 1) {
            
            if (_overtimeWageByTheHour) {
                
                _inputAmountCell = [JGJWageLevelInputAmountCell cellWithTableView:tableView];
                //                _inputAmountCell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
                _inputAmountCell.titleLabel.text = @"加班一小时";
                _inputAmountCell.inputTextField.placeholder = @"请输入加班一小时的工资";
                _inputAmountCell.inputTextField.digit = 7;
                _inputAmountCell.unitsLabel.text = @"元/小时";
                _inputAmountCell.inputTextField.tag = 101;
                _inputAmountCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                if (_overtimeWageOneHour > 0) {
                    
                    _inputAmountCell.inputTextField.text = [NSString stringWithFormat:@"%.2f",_overtimeWageOneHour];
                }else {
                    
                    _inputAmountCell.inputTextField.text = @"";
                }
                
                [_inputAmountCell.inputTextField addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
                return _inputAmountCell;
                
            }else {
                
                JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
                [self setDataWithCell: cell FromIndexPath:indexPath];
                return cell;
            }
        }
        
    }else {
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 1) {
                
                _inputAmountCell = [JGJWageLevelInputAmountCell cellWithTableView:tableView];
                _inputAmountCell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
                _inputAmountCell.inputTextField.placeholder = @"请输入工资金额";
                _inputAmountCell.inputTextField.digit = 7;
                _inputAmountCell.unitsLabel.text = @"元/个工";
                _inputAmountCell.inputTextField.tag = 100;
                _inputAmountCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                if (_editeMoney > 0) {
                    
                    _inputAmountCell.inputTextField.text = [NSString stringWithFormat:@"%.2f",_editeMoney];
                    
                }else {
                    
                    _inputAmountCell.inputTextField.text = @"";
                }
                
                [_inputAmountCell.inputTextField addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
                return _inputAmountCell;
                
            }else {
                
                JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
                [self setDataWithCell: cell FromIndexPath:indexPath];
                return cell;
            }
        }else if (indexPath.section == 2) {
            
            if (_overtimeWageByTheHour) {
                
                _inputAmountCell = [JGJWageLevelInputAmountCell cellWithTableView:tableView];
                //                _inputAmountCell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
                _inputAmountCell.titleLabel.text = @"加班一小时";
                _inputAmountCell.inputTextField.placeholder = @"请输入加班一小时的工资";
                _inputAmountCell.inputTextField.digit = 7;
                _inputAmountCell.unitsLabel.text = @"元/小时";
                _inputAmountCell.inputTextField.tag = 101;
                _inputAmountCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                if (_overtimeWageOneHour > 0) {
                    
                    _inputAmountCell.inputTextField.text = [NSString stringWithFormat:@"%.2f",_overtimeWageOneHour];
                }else {
                    
                    _inputAmountCell.inputTextField.text = @"";
                }
                
                [_inputAmountCell.inputTextField addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
                return _inputAmountCell;
                
            }else {
                
                JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
                [self setDataWithCell: cell FromIndexPath:indexPath];
                return cell;
            }
        }
        else {
            
            JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
            [self setDataWithCell: cell FromIndexPath:indexPath];
            return cell;
        }
    }
    
    return nil;
}

static LengthLimitTextField * extracted(JGJMarkBillTextFileTableViewCell *cell) {
    
    return cell.textfiled;
}

- (void)setDateFromTextFiled:(JGJMarkBillTextFileTableViewCell *)cell andIndexpath:(NSIndexPath *)indexpath
{
    cell.textfiled.placeholder = @"请输入工资金额";
    cell.titleLable.text = self.titleArr[indexpath.section][indexpath.row];
    cell.headImageView.hidden = YES;
    cell.titleLable.font = [UIFont systemFontOfSize:14];
    cell.textfiled.font = (JLGisLeaderBool || self.isAgentMonitor) ? [UIFont systemFontOfSize:14]:FONT(AppFont26Size);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftConstance.constant = -23;
    cell.delegate = self;
    cell.maxLength = 6;
    cell.numberType = JGJNumberKeyBoardType;
    cell.leftLineConstance.constant = 15;
    cell.rightLineConstance.constant = 15;
    if (_editeMoney > 0) {
        
        extracted(cell).text = [NSString stringWithFormat:@"%.2f",_editeMoney];
    }
}

- (void)setDataWithCell:(JGJMarkBillTinyTableViewCell *)cell FromIndexPath:(NSIndexPath *)indexpath
{
    cell.titleLable.text = self.titleArr[indexpath.section][indexpath.row];
    cell.titleLable.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLable.font = [UIFont systemFontOfSize:14];
    
    cell.headImageView.hidden = YES;
    cell.leftConstance.constant = -23;
    cell.leftLineConstance.constant = 15;
    cell.rightLineConstance.constant = 15;
    
    if (self.wagesMembers.count > 0) {
        
        if (indexpath.row == 0 && indexpath.section == 0) {
            
            if (self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
                
                cell.contentLable.text = [[NSString stringWithFormat:@"%.1f小时算1个工", self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
            }else{
                
                cell.contentLable.text = @"8小时算1个工";
                self.yzgGetBillModel.set_tpl.w_h_tpl = 0;
            }
            
            cell.contentLable.textColor = AppFontEB4E4EColor;
            
        }else if (indexpath.row == 0 && indexpath.section == 1){
            
            if (self.yzgGetBillModel.set_tpl.o_h_tpl > 0) {
                
                cell.contentLable.text = [[NSString stringWithFormat:@"%.1f小时算1个工", self.yzgGetBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
            }else{
                
                cell.contentLable.text = @"6小时算1个工";
                self.yzgGetBillModel.set_tpl.o_h_tpl = 0;
            }
            
            cell.contentLable.textColor = AppFontEB4E4EColor;
        }
    }else {
        
        if (indexpath.section == 0 && indexpath.row == 0) {
            
            cell.contentLable.text = self.yzgGetBillModel.name?:@"";
            cell.contentLable.textColor = AppFont333333Color;
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = -8;
            cell.lineView.hidden = YES;
            
        }else if (indexpath.section == 1 && indexpath.row == 0){
            
            if (self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
                
                cell.contentLable.text = [[NSString stringWithFormat:@"%.1f小时算1个工", self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
            }else{
                
                cell.contentLable.text = @"8小时算1个工";
                self.yzgGetBillModel.set_tpl.w_h_tpl = 0;
            }
            
            cell.contentLable.textColor = AppFontEB4E4EColor;
            
        }else if (indexpath.section == 2 && indexpath.row == 0){
            if (self.yzgGetBillModel.set_tpl.o_h_tpl > 0) {
                
                cell.contentLable.text = [[NSString stringWithFormat:@"%.1f小时算1个工", self.yzgGetBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
            }else{
                
                cell.contentLable.text = @"6小时算1个工";
                self.yzgGetBillModel.set_tpl.o_h_tpl = 0;
            }
            
            cell.contentLable.textColor = AppFontEB4E4EColor;
        }
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titles = self.titleArr[section];
    return titles.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (self.wagesMembers.count > 0) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:YES andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:NO];
            
        }else if (indexPath.section == 1 && indexPath.row == 0){
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:YES andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:NO];
        }
        
    }else {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:YES andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:NO];
            
        }else if (indexPath.section == 2 && indexPath.row == 0){
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:YES andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:NO];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 60;
        
    }else if (section == 2 || (self.wagesMembers.count > 0 && section == 1)) {
        
        return 60;
    }
    else {
        
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *headerBack = [[UIView alloc]init];
        [headerBack setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
        headerBack.backgroundColor = AppFontEBEBEBColor;
        
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
        promptLabel.backgroundColor = AppFontFDF1E0Color;
        promptLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
        promptLabel.textColor = AppFontFF6600Color;
        promptLabel.numberOfLines = 0;
        promptLabel.textAlignment = NSTextAlignmentCenter;
        
        if (_yzgGetBillModel.set_tpl.w_h_tpl > 0.0 || self.wagesMembers.count > 0) {
            
            promptLabel.text = @"修改工资标准后，记工将使用最新的工资标准，\n同时不会更改之前已记工的标准";
            
        }else {
            
            promptLabel.text = @"工资标准设置完成后，记工将一直使用该标准,\n如工资变化请重新设置";
        }
        
        [headerBack addSubview:promptLabel];
        
        UIView *headerViewTopLine = [[UIView alloc]init];
        [headerViewTopLine setFrame:CGRectMake(0, 51, TYGetUIScreenWidth, 1)];
        headerViewTopLine.backgroundColor = AppFontdbdbdbColor;// AppFontf1f1f1Color
        [headerBack addSubview:headerViewTopLine];
        
        UIView *headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, TYGetUIScreenWidth, 1)];
        headerViewBottomLine.backgroundColor = AppFontdbdbdbColor;
        [headerBack addSubview:headerViewBottomLine];
        
        
        return headerBack;
        
    }else if (section == 2 || (self.wagesMembers.count > 0 && section == 1)) {
        
        UIView *headerBack = [[UIView alloc]init];
        [headerBack setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
        headerBack.backgroundColor = AppFontEBEBEBColor;
        
        UIView *headerViewTopLine = [[UIView alloc]init];
        [headerViewTopLine setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 1)];
        headerViewTopLine.backgroundColor = AppFontdbdbdbColor;// AppFontf1f1f1Color
        [headerBack addSubview:headerViewTopLine];
        
        UIView *headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 9, TYGetUIScreenWidth, 1)];
        headerViewBottomLine.backgroundColor = AppFontdbdbdbColor;
        [headerBack addSubview:headerViewBottomLine];
        
        JGJChoiceWorkOvertimeCalculateWay *calculateWay = [[JGJChoiceWorkOvertimeCalculateWay alloc] init];
        calculateWay.overtimeWageByTheHour = _overtimeWageByTheHour;
        calculateWay.backgroundColor = [UIColor whiteColor];
        [headerBack addSubview:calculateWay];
        
        [calculateWay mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(10);
        }];
        
        TYWeakSelf(self);
        TYStrongSelf(self);
        calculateWay.clickTheOvertimeWageByWay = ^{
            
            [weakself.view endEditing:YES];
        };
        
        calculateWay.theOvertimeWageByWay = ^(NSInteger btnIndex) {
            
            [weakself.view endEditing:YES];
            if (btnIndex == 1) {
                
                strongself -> _overtimeWageByTheHour = NO;
                strongself -> _overtimeWageOneHour = 0.0;
                
            }else if (btnIndex == 2) {
                
                strongself -> _overtimeWageByTheHour = YES;
                weakself.yzgGetBillModel.set_tpl.o_h_tpl = 6.0;
            }
            
            [weakself.tableView reloadData];
            [weakself updateFooterViewWithYZGGetBillModel:weakself.yzgGetBillModel];
        };
        
        return headerBack;
        
    }else {
        
        UIView *headerBack = [[UIView alloc]init];
        [headerBack setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
        headerBack.backgroundColor = AppFontEBEBEBColor;
        
        UIView *headerViewTopLine = [[UIView alloc]init];
        [headerViewTopLine setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 1)];
        headerViewTopLine.backgroundColor = AppFontdbdbdbColor;//AppFontf1f1f1Color
        [headerBack addSubview:headerViewTopLine];
        
        UIView *headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 9, TYGetUIScreenWidth, 1)];
        headerViewBottomLine.backgroundColor = AppFontdbdbdbColor;
        [headerBack addSubview:headerViewBottomLine];
        return headerBack;
    }
}

- (void)selectManHourTime:(NSString *)Manhour {
    
    self.yzgGetBillModel.set_tpl.w_h_tpl = [Manhour floatValue];
    [self.tableView reloadData];
    
}
- (void)selectOverHour:(NSString *)overTime {
    
    self.yzgGetBillModel.set_tpl.o_h_tpl = [overTime floatValue];
    [self.tableView reloadData];
    
    [self updateFooterViewWithYZGGetBillModel:self.yzgGetBillModel];
    
}
- (void)selectManHourTime:(NSString *)Manhour andOverHour:(NSString *)overTime {
    
    
}
#pragma mark - 编辑金额
- (void)searchTextFieldChangeAction: (UITextField *)sender {
    
    if (sender.tag == 100) {
        
        _editeMoney = [sender.text?:@"0" doubleValue];
        [self updateFooterViewWithYZGGetBillModel:self.yzgGetBillModel];
        
    }else if (sender.tag == 101) {
        
        _overtimeWageOneHour = [sender.text?:@"0" doubleValue];
        
    }
    
}


- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    _editeMoney = self.yzgGetBillModel.set_tpl.s_tpl;
    _overtimeWageOneHour = self.yzgGetBillModel.set_tpl.o_s_tpl;
    
    if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
        
        _overtimeWageByTheHour = NO;
        
    }else {
        
        _overtimeWageByTheHour = YES;
    }
    // 非 工人管理/班组长管理进入i且从修改记账进入，请求一次模板接口，因为 修改记账里面的 o_s_tpl 和 o_h_tpl可能相同有问题
    if (self.wagesMembers.count == 0 && _isModifyTinyAmountBillComeIn) {
        
        // 获取模板
        NSDictionary *param = @{@"accounts_type":@"1",
                                @"uid":@(self.yzgGetBillModel.uid)
                                };
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
            
            if (_isChoiceOtherPartyTemplate) {
                
                self.yzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
            }else {
                
                self.yzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
            }
            
            TYLog(@"工资标准里面的工资模板 = %@",responseObject);
            [self updateFooterViewWithYZGGetBillModel:self.yzgGetBillModel];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
            [self updateFooterViewWithYZGGetBillModel:self.yzgGetBillModel];
            [self.tableView reloadData];
        }];
    }
    
    
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 210)];
    }
    return _footerView;
}

- (UIView *)moneyForOneHourOverBackView {
    
    if (!_moneyForOneHourOverBackView) {
        
        _moneyForOneHourOverBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
        _moneyForOneHourOverBackView.backgroundColor = [UIColor whiteColor];
        
    }
    return _moneyForOneHourOverBackView;
}

- (UILabel *)systemLabel {
    
    if (!_systemLabel) {
        
        _systemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 200, 12)];
        _systemLabel.text = @"系统根据加班标准自动计算的";
        _systemLabel.font = FONT(AppFont24Size);
        _systemLabel.textColor = AppFont666666Color;
    }
    return _systemLabel;
}

- (UILabel *)overTimeLabel {
    
    if (!_overTimeLabel) {
        
        _overTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 26, 100, 14)];
        _overTimeLabel.text = @"加班一小时";
        _overTimeLabel.font = FONT(AppFont28Size);
        _overTimeLabel.textColor = AppFont333333Color;
    }
    return _overTimeLabel;
}

- (UILabel *)moneyForOneHourOverTime {
    
    if (!_moneyForOneHourOverTime) {
        
        _moneyForOneHourOverTime = [[UILabel alloc] initWithFrame:CGRectMake(200, 19, TYGetUIScreenWidth - 200 - 38, 12)];
        _moneyForOneHourOverTime.font = FONT(AppFont28Size);
        _moneyForOneHourOverTime.textColor = AppFont333333Color;
        _moneyForOneHourOverTime.textAlignment = NSTextAlignmentRight;
    }
    return _moneyForOneHourOverTime;
}

- (UIView *)moneyForOneHourOverLine {
    
    if (!_moneyForOneHourOverLine) {
        
        _moneyForOneHourOverLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, TYGetUIScreenWidth, 1)];
        _moneyForOneHourOverLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _moneyForOneHourOverLine;
}


- (UIButton *)bottomBtnView{
    
    if (!_bottomBtnView) {
        
        _bottomBtnView = [[UIButton alloc] initWithFrame:CGRectMake(20, 165, TYGetUIScreenWidth - 40, 45)];
        _bottomBtnView.backgroundColor = AppFontEB4E4EColor;
        _bottomBtnView.layer.masksToBounds = YES;
        [_bottomBtnView setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomBtnView setTitleColor:AppFontffffffColor forState:UIControlStateNormal];
        _bottomBtnView.layer.cornerRadius = 5;
        [_bottomBtnView addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtnView;
}

@end
