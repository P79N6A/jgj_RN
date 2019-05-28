//
//  JGJUnhandleSourceListVC.m
//  JGJCompany
//
//  Created by YJ on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUnhandleSourceListVC.h"
#import "JGJNotifyJoinExistTeamCell.h"
#import "JGJCreatProAddDataSourceVC.h"
#import "UILabel+GNUtil.h"
@interface JGJUnhandleSourceListVC () <
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *proNumLable;
@property (strong, nonatomic) NSString *is_demand;//是否要求同步
@property (weak, nonatomic) IBOutlet UIButton *demandButton;
@property (weak, nonatomic) IBOutlet UIView *containDemanButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDemandViewHeight;
@end

@implementation JGJUnhandleSourceListVC

@synthesize selectedPros = _selectedPros;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

- (void)commonSet {
    //JGJUnHandleSourceTeamType = 1, //未处理数据源类型
    //JGJExistSourceTeamType //现有数据源类型
    self.title = self.sourceTeamType == JGJUnHandleSourceTeamType ? @"未处理数据源类型" :@"现成数据源列表";
    if (self.sourceTeamType == JGJExistSourceTeamType) {
        self.containDemanButtonView.hidden = NO;
        self.containDemandViewHeight.constant = 63;
    }else {
        self.containDemanButtonView.hidden = YES;
        self.containDemandViewHeight.constant = 0;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];//设计师要求改的颜色//AppFontf1f1f1Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.confirmButton.layer setLayerCornerRadius:JGJCornerRadius];
    [self setTableHeaderView];
    [self showBottomSelelctedProInfo];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.synProFirstModel.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JGJSourceSynProSeclistModel *prosecListModel = self.synProFirstModel.list[section];
    return prosecListModel.sync_unsource.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJNotifyJoinExistTeamCell *proCell = [JGJNotifyJoinExistTeamCell cellWithTableView:tableView];
    JGJSourceSynProSeclistModel *prosecListModel = self.synProFirstModel.list[indexPath.section];
    proCell.prolistModel = prosecListModel.sync_unsource.list[indexPath.row];
    return proCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.backgroundColor = AppFontf1f1f1Color;
    headerTitle.font = [UIFont systemFontOfSize:AppFont30Size];
    headerTitle.frame = CGRectMake(12, 0, TYGetUIScreenWidth, 40.0);
    headerTitle.textColor = AppFont666666Color;
    JGJSourceSynProSeclistModel *prosecListModel = self.synProFirstModel.list[section];
    headerTitle.text = [NSString stringWithFormat:@"%@ (%@)",prosecListModel.real_name, prosecListModel.telephone];
    [headerView addSubview:headerTitle];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    JGJSourceSynProSeclistModel *prosecListModel = self.synProFirstModel.list[section];
    NSUInteger count = prosecListModel.sync_unsource.list.count;
    return count > 0 ? 40 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJExistTeamInfoModel *teamInfoModel = [JGJExistTeamInfoModel new];
    teamInfoModel = self.dataSource[indexPath.row];
    teamInfoModel.isSelected = !teamInfoModel.isSelected;
    if (self.dataSource.count > 0) {
        if (teamInfoModel.isSelected) {
            [self.selectedPros addObject:teamInfoModel];
        } else {
            [self.selectedPros removeObject:teamInfoModel];
        }
    }
    
    if (self.synProFirstModel) {
        JGJSourceSynProSeclistModel *prosecListModel = self.synProFirstModel.list[indexPath.section];
        JGJSyncProlistModel *prolistModel = prosecListModel.sync_unsource.list[indexPath.row];
        prolistModel.isSelected = !prolistModel.isSelected;
        if (prolistModel.isSelected) {
            [self.selectedPros addObject:prolistModel];
        } else {
            [self.selectedPros removeObject:prolistModel];
        }
    }
    [self showBottomSelelctedProInfo];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSMutableArray *)selectedPros {
    if (!_selectedPros) {
        _selectedPros = [NSMutableArray array];
    }
    return _selectedPros;
}

- (void)showBottomSelelctedProInfo {
    NSString *countStr = [NSString stringWithFormat:@"%@", @(self.selectedPros.count)];
    self.proNumLable.text = [NSString stringWithFormat:@"已选中 %@ 个项目", countStr];
    [self.proNumLable markText:countStr withColor:AppFontd7252cColor];
}

- (void)setSynProFirstModel:(JGJSourceSynProFirstModel *)synProFirstModel {
    _synProFirstModel = synProFirstModel;
    //已选中项目和人
    [synProFirstModel.list enumerateObjectsUsingBlock:^(JGJSourceSynProSeclistModel * _Nonnull seclistModel, NSUInteger idx, BOOL * _Nonnull stop) {
        for (JGJSyncProlistModel *prolistModel in seclistModel.sync_unsource.list) {
            if (prolistModel.isSelected) {
                [self.selectedPros addObject:prolistModel];
            }
        }
    }];
    [self showBottomSelelctedProInfo];
}

#pragma mark - 确认按钮按下
- (IBAction)handleConfirmButtonPressedAction:(UIButton *)sender {
    if (self.selectedPros.count == 0) {
        [TYShowMessage showError:@"请选择你要同步的项目"];
        return;
    }
    NSMutableString *mergeProInfoStr = [NSMutableString string];
    for (JGJSyncProlistModel *syncProlistModel in self.selectedPros) {
        [mergeProInfoStr appendFormat:@"%@,",syncProlistModel.pid];
    }
    //    删除末尾的分号
    if (mergeProInfoStr.length > 0 && mergeProInfoStr != nil) {
        [mergeProInfoStr deleteCharactersInRange:NSMakeRange(mergeProInfoStr.length - 1, 1)];
    }
    self.teamMemberModel.source_pro_id = mergeProInfoStr;
    self.teamMemberModel.is_demand = [NSString stringWithFormat:@"%@", @(self.demandButton.selected)];
    self.synProFirstModel.is_demand = [NSString stringWithFormat:@"%@", @(self.demandButton.selected)];
    if ([self.delegate respondsToSelector:@selector(JGJUnhandleSourceListVcConfirmButtonPressed:)]) {
        [self.delegate JGJUnhandleSourceListVcConfirmButtonPressed:self];
    }
}

- (IBAction)handleDemandSynProButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)setTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 33.0)];
    self.tableView.tableHeaderView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"可选择以下项目作为数据源";
    titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = AppFont999999Color;
    [headerView addSubview:titleLable];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = TYColorHex(0xdbdbdb);
    [headerView addSubview:bottomLineView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView).with.insets(padding);
    }];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView).offset(12);
        make.right.mas_equalTo(headerView).offset(-12);
        make.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
}
@end
