
//  JGJQualityFilterVc.m
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityFilterVc.h"
#import "JGJCustomLable.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "ATDatePicker.h"

#import "JGJCreatTeamCell.h"

#import "JGJTaskPrincipalVc.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "JGJTaskLevelSelVc.h"

#import "JGJFilterBottomButtonView.h"

@interface JGJQualityFilterVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJTaskLevelSelVcDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *secSectionInfos;

@property (nonatomic, strong) NSMutableArray *thirdSectionInfos;

@property (nonatomic, strong) JGJFilterBottomButtonView *buttonView;

//是否是重置状态
@property (nonatomic, assign) BOOL isReset;

@end

@implementation JGJQualityFilterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"筛选记录";
    
    [self initialSubView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    switch (section) {
        case 0:{
            
            count = self.firstSectionInfos.count;
        }
            break;
            
        case 1:{
            
            count = self.secSectionInfos.count;
        }
            break;
            
        case 2:{
            
            count = self.thirdSectionInfos.count;
        }
            break;
            
        case 3:{
            
            count = self.fourSectionInfos.count;
        }
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    
    switch (indexPath.section) {
        case 0:{
            
            cell.creatTeamModel = self.firstSectionInfos[indexPath.row];
            cell.lineView.hidden = indexPath.row == self.firstSectionInfos.count - 1;
            
        }
            break;
            
        case 1:{
            
            cell.creatTeamModel = self.secSectionInfos[indexPath.row];
            
            cell.lineView.hidden = indexPath.row == self.secSectionInfos.count - 1;
        }
            
            break;
            
        case 2:{

            cell.creatTeamModel = self.thirdSectionInfos[indexPath.row];
            
            cell.lineView.hidden = indexPath.row == self.thirdSectionInfos.count - 1;
        }
            
            break;
            
        case 3:{
            
            cell.creatTeamModel = self.fourSectionInfos[indexPath.row];
            
            cell.lineView.hidden = indexPath.row == self.fourSectionInfos.count - 1;
            
            //我提交的 、待我复查、待我整改 去掉问题提交人
            if (self.filterType == QuaSafeFilterMyCommitType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterMyReviewType) {
                
                cell.lineView.hidden = indexPath.row == self.fourSectionInfos.count - 2;
            }
        }
            
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 45.0;
    
    switch (indexPath.section) {
            
        case 0:{
            
            if (indexPath.row == 0) {
                
                //待整改、待复查去掉、待我复查、待我整改去掉 已完成 问题状态
                if (self.filterType == QuaSafeFilterWaitModifyType || self.filterType == QuaSafeFilterMyReviewType || self.filterType == QuaSafeFilterReviewType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterCompletedType) {
                    
                    height = CGFLOAT_MIN;
                }
            }
            
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == self.fourSectionInfos.count - 1) {
                
                //我提交的 、待我复查、待我整改 去掉问题提交人
                if (self.filterType == QuaSafeFilterMyCommitType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterMyReviewType) {
                    
                    height = CGFLOAT_MIN;
                }
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
    return  height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, 30)];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    switch (section) {
            
        case 1:{
            
            headerLable.text = @"提交日期";
            
        }
            
            break;
        
        case 2:{
            
            headerLable.text = @"整改期限";
            
        }
            
            break;
            
        default:
            break;
    }
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    return headerLable;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 10.0;
    
    if (section == 1 || section == 2) {
        
        height = 36;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0:{
            
            if (indexPath.row == 0) {
                
                JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
                
                taskLevelSelVc.levelSelType = JGJTaskLevelStatusType;
                
                JGJCreatTeamModel *stausModel = self.firstSectionInfos[0];
                
                taskLevelSelVc.selLevel = stausModel.detailTitle;
                
//                taskLevelSelVc.lastIndexPath = self.lastIndexPath;
//                
//                taskLevelSelVc.dataSource = self.qualityStatusModels;
                
                [self.navigationController pushViewController:taskLevelSelVc animated:YES];
                
            }else if (indexPath.row == 1) {
            
                JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
                
                taskLevelSelVc.levelSelType = JGJTaskLevelFilterSeriousType;
                
                JGJCreatTeamModel *stausModel = self.firstSectionInfos[1];
                
                taskLevelSelVc.selLevel = stausModel.detailTitle;
                
                [self.navigationController pushViewController:taskLevelSelVc animated:YES];
            }
            
        }
            
            break;
            
        case 1:{
            
            if (indexPath.row == 0) {
                
                JGJCreatTeamModel *timeModel = self.secSectionInfos[0];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    timeModel.detailTitle = dateString;
                    
                    [weakSelf freshIndexSection:1 row:0];
                    
                    TYLog(@"%@", dateString);
                }];
                
                JGJCreatTeamModel *maxTimeModel = self.secSectionInfos[1];
                
                if (![NSString isEmpty:maxTimeModel.detailTitle] && ![maxTimeModel.detailTitle isEqualToString:@""]) {
                
                    datePicker.maximumDate = [NSDate dateFromString:maxTimeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                if (![NSString isEmpty:timeModel.detailTitle] && ![timeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                [datePicker show];
                
            }else if (indexPath.row == 1) {
            
            
                JGJCreatTeamModel *timeModel = self.secSectionInfos[1];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    timeModel.detailTitle = dateString;
                    
                    [weakSelf freshIndexSection:1 row:1];
                    
                    TYLog(@"%@", dateString);
                }];
                
                JGJCreatTeamModel *minTimeModel = self.secSectionInfos[0];
                
                if (![NSString isEmpty:minTimeModel.detailTitle] && ![minTimeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.minimumDate = [NSDate dateFromString:minTimeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                
                if (![NSString isEmpty:timeModel.detailTitle] && ![timeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                [datePicker show];
            }
        }
            
            break;
            
        case 2:{
            
            if (indexPath.row == 0) {
                
                JGJCreatTeamModel *timeModel = self.thirdSectionInfos[0];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    timeModel.detailTitle = dateString;
                    
                    [weakSelf freshIndexSection:2 row:0];
                    
                    TYLog(@"%@", dateString);
                }];
                
                JGJCreatTeamModel *maxTimeModel = self.thirdSectionInfos[1];
                
                if (![NSString isEmpty:maxTimeModel.detailTitle] && ![maxTimeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.maximumDate = [NSDate dateFromString:maxTimeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                if (![NSString isEmpty:timeModel.detailTitle] && ![timeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                [datePicker show];
                
            }else if (indexPath.row == 1) {
                
                
                JGJCreatTeamModel *timeModel = self.thirdSectionInfos[1];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    timeModel.detailTitle = dateString;
                    
                    [weakSelf freshIndexSection:2 row:1];
                    
                    TYLog(@"%@", dateString);
                }];
                
                JGJCreatTeamModel *minTimeModel = self.thirdSectionInfos[0];
                
                if (![NSString isEmpty:minTimeModel.detailTitle] && ![minTimeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.minimumDate = [NSDate dateFromString:minTimeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                
                if (![NSString isEmpty:timeModel.detailTitle] && ![timeModel.detailTitle isEqualToString:@""]) {
                    
                    datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                [datePicker show];
            }
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
                
                taskLevelSelVc.levelSelType = JGJTaskLevelTimelyModifyType;
                
                JGJCreatTeamModel *desModel = self.fourSectionInfos[0];
                
                taskLevelSelVc.selLevel = desModel.detailTitle;
                
//                taskLevelSelVc.lastIndexPath = self.lastIndexPath;
//                
//                taskLevelSelVc.dataSource = self.qualityLevelModels;
                
                [self.navigationController pushViewController:taskLevelSelVc animated:YES];
                
            }else if (indexPath.row == 1) {
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.proListModel = self.proListModel;
                
                //3.3.3添加
                JGJCreatTeamModel *desModel = self.fourSectionInfos[1];
                
                JGJSynBillingModel *principalModel = [JGJSynBillingModel new];
                
                principalModel.uid = desModel.detailTitlePid;
                
                principalVc.principalModel = principalModel;
                
                principalVc.memberSelType = JGJMemberFilterRecirdMemeberType;
                
                principalVc.principalModels = self.principalModels;
                
                [self.navigationController pushViewController:principalVc animated:YES];
                
            }else if (indexPath.row == 2) {
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.proListModel = self.proListModel;
                
                //3.3.3添加
                JGJCreatTeamModel *desModel = self.fourSectionInfos[2];
                
                JGJSynBillingModel *principalModel = [JGJSynBillingModel new];
                
                principalModel.uid = desModel.detailTitlePid;
                
                principalVc.principalModel = principalModel;
                
                principalVc.memberSelType = JGJMemberCommitMemeberType;
                
                principalVc.principalModels = self.commitModels;
                
//                principalVc.lastIndexPath = self.lastIndexPath;
                
                [self.navigationController pushViewController:principalVc animated:YES];

            }
            
        }
            
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - 确定按钮按下
- (void)confirmButtonPressed {
    
    //待整改、待复查、待我复查、待我整改去掉  已完成 问题状态
    if ((self.filterType == QuaSafeFilterWaitModifyType || self.filterType == QuaSafeFilterMyReviewType || self.filterType == QuaSafeFilterReviewType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterCompletedType)) {
        
        JGJCreatTeamModel *levelModel = self.firstSectionInfos[1];
        
        self.requestModel.severity = levelModel.detailTitlePid;
        
        self.requestModel.severity_name = levelModel.detailTitle;
        
    }else {
        
        JGJCreatTeamModel *stausModel = self.firstSectionInfos[0];
        
        self.requestModel.status = stausModel.detailTitlePid;
        
        self.requestModel.status_name = stausModel.detailTitle;
        
        if (self.firstSectionInfos.count > 1) {
            
            JGJCreatTeamModel *levelModel = self.firstSectionInfos[1];
            
            self.requestModel.severity = levelModel.detailTitlePid;
            
            self.requestModel.severity_name = levelModel.detailTitle;
        }
        
    }
    
    JGJCreatTeamModel *comStModel = self.secSectionInfos[0];
    
    self.requestModel.send_stime = comStModel.detailTitle;
    
    JGJCreatTeamModel *comEnModel = self.secSectionInfos[1];
    
    self.requestModel.send_etime = comEnModel.detailTitle;
    
    
    JGJCreatTeamModel *modifyStModel = self.thirdSectionInfos[0];
    
    self.requestModel.modify_stime = modifyStModel.detailTitle;
    
    JGJCreatTeamModel *modifyEnModel = self.thirdSectionInfos[1];
    
    self.requestModel.modify_etime = modifyEnModel.detailTitle;
    
    
    JGJCreatTeamModel *timelyModifyModel = self.fourSectionInfos[0];
    
//    self.requestModel.in_time = timelyModifyModel.detailTitlePid;
    
    //2.3.2添加
    self.requestModel.question_status = timelyModifyModel.detailTitlePid;
    
    self.requestModel.question_name = timelyModifyModel.detailTitle;
    
    JGJCreatTeamModel *modifyMemberModel = self.fourSectionInfos[1];
    
    self.requestModel.principal_uid = modifyMemberModel.detailTitlePid;
    
    //名字用户回传
    self.requestModel.principal_name = modifyMemberModel.detailTitle;
    
    //问题提交人是否有
    if (self.fourSectionInfos.count > 2) {
        
        JGJCreatTeamModel *commitMemberModel = self.fourSectionInfos[2];
        
        self.requestModel.send_uid = commitMemberModel.detailTitlePid;
        
        self.requestModel.send_name = commitMemberModel.detailTitle;
    }
    
    if (self.filterType == QuaSafeFilterMyCommitType) {
        
        self.requestModel.is_my_offer = @"1";
        
    }else {
        
        self.requestModel.is_my_offer = nil;
    }
    
    self.isReset = NO;
    
    [self popVc];
    
}

#pragma makr - 重置
- (void)resetButtonPressed {
    
    self.isReset = YES;
    
    [self popVc];
    
}

- (void)popVc {
    
    if ([self.delegate respondsToSelector:@selector(qualityFilterVc:)]) {
        
        [self.delegate qualityFilterVc:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row {
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

- (NSMutableArray *)firstSectionInfos {
    
    if (!_firstSectionInfos) {
        
        _firstSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"问题状态", @"隐患级别"];
        
        NSArray *detailTitles = @[self.requestModel.status_name?:@"", self.requestModel.severity_name?:@""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            //待整改、待复查去掉、待我复查、待我整改去掉 问题状态
            if (self.filterType == QuaSafeFilterWaitModifyType || self.filterType == QuaSafeFilterMyReviewType || self.filterType == QuaSafeFilterReviewType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterCompletedType) {
                
                desModel.isHiddenArrow = indx == 0;
                
                //去掉问题状态
                if (indx == 0) {
                    
                    desModel.title = @"";
                }

            }
            
            [_firstSectionInfos addObject:desModel];
        }
    }
    
    return _firstSectionInfos;
    
}

- (NSMutableArray *)secSectionInfos {
    
    if (!_secSectionInfos) {
        
        _secSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"开始", @"结束"];
        
        NSArray *detailTitles = @[self.requestModel.send_stime?:@"", self.requestModel.send_etime?:@""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            [_secSectionInfos addObject:desModel];
            
        }
        
    }
    
    return _secSectionInfos;
    
}

- (NSMutableArray *)thirdSectionInfos{
    
    if (!_thirdSectionInfos) {
        
        _thirdSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"开始", @"结束"];
        
        NSArray *detailTitles = @[self.requestModel.modify_stime?:@"", self.requestModel.modify_etime?:@""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            [_thirdSectionInfos addObject:desModel];
            
        }
        
    }
    
    return _thirdSectionInfos;
    
}

- (NSMutableArray *)fourSectionInfos {
    
    if (!_fourSectionInfos) {
        
        _fourSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"整改情况", @"整改负责人", @"问题提交人"];
        
        NSArray *detailTitles = @[self.requestModel.question_name?:@"", self.requestModel.principal_name?:@"", self.requestModel.send_name?:@""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            //我提交的 、待我复查、待我整改 去掉问题提交人
            if (self.filterType == QuaSafeFilterMyCommitType || self.filterType == QuaSafeFilterMyModifyType || self.filterType == QuaSafeFilterMyReviewType) {
                
                desModel.isHiddenArrow = indx == titles.count - 1;
                
                if (indx == titles.count - 1) {
                    
                    desModel.title = @"";
                    
                }

            }
            
            [_fourSectionInfos addObject:desModel];
            
            
        }
        
    }
    
    return _fourSectionInfos;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        
        footerView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.tableFooterView = footerView;
    }
    
    return _tableView;
    
}

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.buttonView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);

        make.bottom.mas_equalTo(self.buttonView.mas_top);
        
    }];
    
    TYWeakSelf(self);
    
    self.buttonView.bottomButtonBlock = ^(JGJFilterBottomButtonType buttonType) {
        
        switch (buttonType) {
                
            case JGJFilterBottomResetButtonype:{
                
                [weakself resetButtonPressed];
            }
                
                break;
                
                
            case JGJFilterBottomConfirmButtonType:{
                
                [weakself confirmButtonPressed];
            }
                
                break;
                
            default:
                break;
        }
    };
    
}

- (JGJFilterBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = (TYIST_IPHONE_X ? JGJ_IphoneX_BarHeight : 0) + 60;
        
        _buttonView = [[JGJFilterBottomButtonView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT,  TYGetUIScreenWidth, height)];
    }
    
    return _buttonView;
}

@end
