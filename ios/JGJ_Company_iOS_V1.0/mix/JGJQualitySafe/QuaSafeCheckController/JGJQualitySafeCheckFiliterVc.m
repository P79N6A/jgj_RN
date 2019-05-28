//
//  JGJQualitySafeCheckFiliterVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualitySafeCheckFiliterVc.h"

#import "JGJCustomLable.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "ATDatePicker.h"

#import "JGJCreatTeamCell.h"

#import "JGJTaskPrincipalVc.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "JGJTaskLevelSelVc.h"

@interface JGJQualitySafeCheckFiliterVc () <

    UITableViewDelegate,

    UITableViewDataSource

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *secSectionInfos;

@property (nonatomic, strong) NSMutableArray *thirdSectionInfos;

@end

@implementation JGJQualitySafeCheckFiliterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"筛选记录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    [self initialSubView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 2;
    
    if (section == 0) {
        
        count = 1;
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
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  45.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, 30)];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    switch (section) {
            
        case 1:{
            
            headerLable.text = @"检查计划添加日期";
            
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
    
    if (section == 1 ) {
        
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
                
                taskLevelSelVc.levelSelType = JGJTaskLevelCheckStatusType;
                
                JGJCreatTeamModel *stausModel = self.firstSectionInfos[0];
                
                taskLevelSelVc.selLevel = stausModel.detailTitle;
                
//                taskLevelSelVc.lastIndexPath = self.lastIndexPath;
//                
//                taskLevelSelVc.dataSource = self.qualityStatusModels;
                
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
            
            
             if (indexPath.row == 0) { //检查执行人
                
                 JGJCreatTeamModel *desModel = self.thirdSectionInfos[0];
                 
                 JGJSynBillingModel *principalModel = [JGJSynBillingModel new];
                 
                 principalModel.uid = desModel.detailTitlePid;
                 
                 JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                 
                 principalVc.principalModel = principalModel;
                 
                principalVc.proListModel = self.proListModel;
                
                principalVc.memberSelType = JGJMemberCheckExecMemeberType;
                
                principalVc.principalModels = self.principalModels;
                
//                principalVc.lastIndexPath = self.lastIndexPath;
                
                [self.navigationController pushViewController:principalVc animated:YES];
                
            }else if (indexPath.row == 1) { //检查计划提交人
                
                JGJCreatTeamModel *desModel = self.thirdSectionInfos[1];
                
                JGJSynBillingModel *principalModel = [JGJSynBillingModel new];
                
                principalModel.uid = desModel.detailTitlePid;
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.principalModel = principalModel;
                
                
                principalVc.proListModel = self.proListModel;
                
                principalVc.memberSelType = JGJMemberCheckPlanCommitMemeberType;
                
                principalVc.principalModels = self.principalModels;
                
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
- (void)rightItemPressed:(UIButton *)sender {
    
    //检查状态
    JGJCreatTeamModel *stausModel = self.firstSectionInfos[0];

    if ([stausModel.detailTitlePid isEqualToString:@"2"]) {
        
        //转成3表示已完成
        self.requestModel.status = @"3";
        
    }else {

        self.requestModel.status = stausModel.detailTitlePid;
    }

    JGJCreatTeamModel *comStModel = self.secSectionInfos[0];
    
    self.requestModel.send_stime = comStModel.detailTitle;
    
    JGJCreatTeamModel *comEnModel = self.secSectionInfos[1];
    
    self.requestModel.send_etime = comEnModel.detailTitle;
    
    //计划人和提交人
    JGJCreatTeamModel *modifyMemberModel = self.thirdSectionInfos[0];
    
    self.requestModel.principal_uid = modifyMemberModel.detailTitlePid;
    
    JGJCreatTeamModel *commitMemberModel = self.thirdSectionInfos[1];
    
    self.requestModel.uid = commitMemberModel.detailTitlePid;;
    
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
        
        NSArray *titles = @[@"检查状态"];
        
        NSArray *detailTitles = @[@""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            [_firstSectionInfos addObject:desModel];
        }
    }
    
    return _firstSectionInfos;
    
}

- (NSMutableArray *)secSectionInfos {
    
    if (!_secSectionInfos) {
        
        _secSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"开始", @"结束"];
        
        NSArray *detailTitles = @[@"", @""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            [_secSectionInfos addObject:desModel];
            
        }
        
    }
    
    return _secSectionInfos;
    
}

- (NSMutableArray *)thirdSectionInfos {
    
    if (!_thirdSectionInfos) {
        
        _thirdSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"检查执行人", @"检查计划提交人"];
        
        NSArray *detailTitles = @[@"", @"", @""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            [_thirdSectionInfos addObject:desModel];
            
        }
        
    }
    
    return _thirdSectionInfos;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
}

@end
