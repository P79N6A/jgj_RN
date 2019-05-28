//
//  JGJUnWagesShortWorkVc.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWagesShortWorkVc.h"

#import "JGJCheckAccountHeaderView.h"

#import "JGJUnWagesShortWorkCell.h"

#import "CFRefreshStatusView.h"

#import "JGJRecordBillDetailViewController.h"

#import "JGJSurePoorBillShowView.h"

#import "JGJModifyBillListViewController.h"

#import "JGJCusActiveSheetView.h"

#import "JGJAccountShowTypeVc.h"

#import "JGJCusBottomSelBtnView.h"

#import "JGJCusSetTinyPopView.h"
#import "JYSlideSegmentController.h"

@interface JGJUnWagesShortWorkVc () <UITableViewDelegate, UITableViewDataSource, JGJSurePoorBillShowViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *contentTopView;

@property (nonatomic, strong) UIButton *desButton;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *sortDataSource;

@property (strong, nonatomic) JGJRecordWorkPointRequestModel *request;

@property (nonatomic, strong) JGJPageSizeModel *pageSizeModel;

//是否刷新数据
@property (nonatomic, assign) BOOL is_can_fresh;

//是否显示选中按钮

@property (nonatomic, assign) BOOL is_show_selBtn;

//选择的批量设置工资金额

@property (nonatomic, strong) NSMutableArray *selListModels;

@property (nonatomic, strong) JGJCusBottomSelBtnView *bottomView;

//总列表数量

@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, strong) JGJCusSetTinyPopView *cusSetTinyPopView;

@end

@implementation JGJUnWagesShortWorkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"无金额点工";
    
    [self createRightItem];
    
    [self.view addSubview:self.contentTopView];
    
    [self.view addSubview:self.tableView];
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];

    self.is_can_fresh = YES;
    
    [self.view addSubview:self.bottomView];
    
    self.bottomView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.is_can_fresh) {
        
        [self beginFresh];
    }
    
    //默认显示方式
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    [self.tableView reloadData];
}

- (void)beginFresh {
    
    self.allCount = 0;
    
    self.request.pg = 1;
    
    [self loadNetData];
}

- (void)createRightItem {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 44);
    rightBtn.titleLabel.font = FONT(JGJNavBarFont);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    NSString *title = self.is_show_selBtn ? @"取消" : @"更多";
    
    if (self.is_show_selBtn) {
        
        [rightBtn addTarget:self action:@selector(rightCancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.tableView.height -= self.bottomView.height;
        
        self.bottomView.hidden = NO;
        
    }else {
        
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (_bottomView) {
            
            self.tableView.height += self.bottomView.height;
            
            self.bottomView.hidden = YES;
        }
        
    }
    
    [rightBtn setTitle:title forState:UIControlStateNormal];
//    [rightBtn setImage:IMAGE(@"more_red") forState:(UIControlStateNormal)];
//    [rightBtn setImage:IMAGE(@"more_red") forState:(UIControlStateSelected)];
    [rightBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightItemStatus {
    
    [self createRightItem];
}

- (void)rightCancelBtnClick {
    
    self.is_show_selBtn = NO;
    
    [self setRightItemStatus];
    
    if (self.selListModels.count > 0) {
        
        for (JGJRecordWorkPointListModel *listModel in self.selListModels) {
            
            listModel.isSel = NO;
        }
        
        [self.selListModels removeAllObjects];
        
    }
    
    self.bottomView.leftBtn.selected = NO;
    
    [self bottomLeftBtnStatus:self.bottomView.leftBtn.selected];
    
    [self.tableView reloadData];
    
}

- (void)bottomLeftBtnStatus:(BOOL)isSel {
 
    if (isSel) {
        
        [self.bottomView.leftBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        
    }else {
        
        [self.bottomView.leftBtn setTitle:@"全选本页" forState:UIControlStateNormal];
    }
    
}

- (void)rightBtnClick {
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel,@"批量设置工资金额",@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
            
            weakSelf.is_can_fresh = NO;
            
        }else if (buttonIndex == 1) {
            
            //显示批量设置工资金额按钮
            
            if (self.sortDataSource.count > 0) {
                
                weakSelf.is_show_selBtn = YES;
                
                [weakSelf setRightItemStatus];
                
            }else {
                
                [TYShowMessage showPlaint:@"没有点工可设置工资金额"];
            }
            
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
    [sheetView showView];
}

-  (void)setIsMarkBillGoIn:(BOOL)isMarkBillGoIn {
    
    _isMarkBillGoIn = isMarkBillGoIn;
}

- (void)setIs_show_selBtn:(BOOL)is_show_selBtn {
    
    _is_show_selBtn = is_show_selBtn;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    JGJUnsetSalaryTplByUidListModel *listModel = self.list[section];
    
    NSArray *workdays = self.sortDataSource[section];
    
    return workdays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJUnWagesShortWorkCell *cell = [JGJUnWagesShortWorkCell cellWithTableView:tableView];
    
//    JGJUnsetSalaryTplByUidListModel *listModel = self.list[indexPath.section];
    
    NSArray *list = self.sortDataSource[indexPath.section];
    
    cell.showType = self.selTypeModel.type;
    
    cell.isBatchDel = self.is_show_selBtn;
    
    cell.listModel = list[indexPath.row];
    
    cell.isHiddenLineView = (list.count - 1 == indexPath.row) && (self.sortDataSource.count - 1 != indexPath.section);
    
    cell.isScreenShowLine = self.list.count - 1 == indexPath.section;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *resueId = @"JGJUnWagesShortWorkFooterView";
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    UIView *bottomLineView = [UIView new];
    
    if (!footerView) {
        
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:resueId];
        
//        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
//
//        topLineView.backgroundColor = AppFontdbdbdbColor;
        
        bottomLineView.frame = CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5);
        
        bottomLineView.backgroundColor = AppFontdbdbdbColor;
        
        [footerView addSubview:bottomLineView];
    }
    
    footerView.contentView.backgroundColor = AppFontf1f1f1Color;
    
    footerView.hidden = self.sortDataSource.count - 1 == section;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCheckAccountHeaderView *headerView = [JGJCheckAccountHeaderView checkAccountHeaderViewWithTableView:tableView];
    
    NSArray *list = self.sortDataSource[section];
    
    if (list.count > 0) {
        
        JGJUnsetSalaryTplByUidListModel *listModel = list[0];
        
        headerView.time = listModel.date;
    }
    
    return headerView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *workdays = self.sortDataSource[indexPath.section];
    
    JGJRecordWorkPointListModel *listModel = workdays[indexPath.row];
    
    if (self.is_show_selBtn) {
        
        JGJUnWagesShortWorkCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [self batchSetWageWithListModel:listModel cell:cell];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
//        [self.tableView reloadData];
        
    }else {
        
        //有查账弹除差账弹框
        if (listModel.amounts_diff) {
            
            [self existDiffRecordWithListModel:listModel];
            
        }else {
            
            [self checkRecordWithListModel:listModel];
        }
        
        self.is_can_fresh = YES;
        
    }
    
}

#pragma mark - 批量设置工资金额
- (void)batchSetWageWithListModel:(JGJRecordWorkPointListModel *)listModel cell:(JGJUnWagesShortWorkCell *)cell{
    
    listModel.isSel = !listModel.isSel;
    
    cell.listModel = listModel;
    
    if (listModel.isSel) {
        
        [self.selListModels addObject:listModel];
        
    }else {
        
        [self.selListModels removeObject:listModel];
        
    }
    
    self.bottomView.leftBtn.selected = self.selListModels.count == self.allCount && self.allCount > 0;
    
    [self bottomLeftBtnStatus:self.bottomView.leftBtn.selected];
    
    [self showSelCnt];
    
}

#pragma mark - 选中的数量

- (void)showSelCnt {
    
    self.bottomView.rightTitle = @"批量设置工资金额";
    
    if (self.selListModels.count > 0) {
        
       self.bottomView.rightTitle = [NSString stringWithFormat:@"批量设置工资金额(%@)",@(self.selListModels.count)];
    }
    
}

#pragma mark - 存在差账弹框
- (void)existDiffRecordWithListModel:(JGJRecordWorkPointListModel *)dayListModel {
    
    TYLog(@"记账id=====%@ 项目id====== %@", dayListModel.recordId, dayListModel.pid);
    
    JGJPoorBillListDetailModel *model = [[JGJPoorBillListDetailModel alloc]init];
    model.id = dayListModel.recordId;
    model.accounts_type = dayListModel.accounts_type;
    [JGJSurePoorBillShowView showPoorBillAndModel:model AndDelegate:self andindexPath:nil andHidenismine:YES];
    
}

#pragma mark - 查看记账
- (void)checkRecordWithListModel:(JGJRecordWorkPointListModel *)dayListModel {

    YZGGetBillModel *billModel = [YZGGetBillModel new];
    
    billModel.id = dayListModel.recordId;
    
    billModel.accounts_type.code = [dayListModel.accounts_type integerValue];
    
    billModel.working_hours = dayListModel.manhour;
    billModel  .overtime_hours = dayListModel.overtime;
    [self modifyBillWithBillModel:billModel];
    
}

- (MateWorkitemsItems *)TransformModel:(JGJRecordWorkPointListModel *)wageBestDetailWorkday {
    
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.uid = [wageBestDetailWorkday.uid?:@"0" longLongValue];
    mateWorkitemsItem.accounts_type.txt = wageBestDetailWorkday.accounts_type;
    mateWorkitemsItem.id =  [wageBestDetailWorkday.recordId?:@"0" longLongValue];
    mateWorkitemsItem.accounts_type.code = [wageBestDetailWorkday.accounts_type integerValue];
    return mateWorkitemsItem;
}
#pragma mark - 是否显示缺省页面
- (void)showDefaultNoDataArray:(NSArray *)dataArray {
    
    self.contentTopView.hidden = dataArray.count == 0;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    CGFloat height = rectStatus.size.height + rectNav.size.height;
    
    if (dataArray.count == 0) {
        
//        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"工资标准中未设置金额的点工\n已处理完毕"];
//错误 #19467改为暂无数据哦~
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无数据哦~"];
        
        statusView.frame = self.view.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
        self.tableView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
        
    }  else {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
        
        CGRect rect = CGRectMake(0, TYGetMaxY(self.desButton), TYGetUIScreenWidth, TYGetUIScreenHeight - height - TYGetMaxY(self.contentTopView));
        
        self.tableView.frame = rect;
    }
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        
        CGRect rectNav = self.navigationController.navigationBar.frame;
        
        CGFloat height = rectStatus.size.height + rectNav.size.height;
        
        CGRect rect = CGRectMake(0, TYGetMaxY(self.desButton), TYGetUIScreenWidth, TYGetUIScreenHeight - height - TYGetMaxY(self.contentTopView));
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;

        self.view.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (UIButton *)desButton {
    
    if (!_desButton) {
        
        _desButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth - 24, 60)];
        
        _desButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        
        _desButton.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont28Size];
        
        _desButton.backgroundColor = AppFontFEF1E1Color;
        
        [_desButton setTitleColor:AppFontFF6600Color forState:UIControlStateNormal];
        
        _desButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        [_desButton setImage:[UIImage imageNamed:@"check_account_icon"] forState:UIControlStateNormal];
        
        _desButton.titleLabel.numberOfLines = 0;

        [_desButton setTitle:@"点击以下记工可设置每天的工资金额\n 或者点击右上角的“更多”，批量设置工资金额" forState:UIControlStateNormal];
        
        _desButton.adjustsImageWhenHighlighted = NO;
    }
    
    return _desButton;
}

- (UIView *)contentTopView {
    
    if (!_contentTopView) {
        
        _contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetViewH(self.desButton))];
        
        _contentTopView.backgroundColor = AppFontfdf1e0Color;
        
        [_contentTopView addSubview:self.desButton];
    }
    
    return _contentTopView;
}

- (void)setList:(NSArray *)list {
    
    _list = list;
    
    [self showDefaultNoDataArray:list];
    
    [self.tableView reloadData];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = nil;
    
    if (![NSString isEmpty:self.uid]) {
        
        self.request.uid = self.uid;
        
    }
    
    parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-unset-salarytpl-by-uid-list" parameters:parameters success:^(id responseObject) {
        
        //        JGJRecordWorkPointListModel *recordWorkPointModel = [JGJRecordWorkPointListModel mj_objectWithKeyValues:responseObject];
        
        //        self.recordWorkPointModel = recordWorkPointModel;
        
        self.is_can_fresh = YES;
        
        NSArray *dataSurce = [JGJRecordWorkPointListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.allCount += dataSurce.count;
        
        //初始筛选前的数据
        if (!_dataSource || self.request.pg == 1) {
            
            self.sortDataSource = [NSMutableArray array];
            
            self.dataSource = [NSMutableArray array];
            
        }
        
        if (dataSurce.count > 0) {
            
            [self.dataSource addObjectsFromArray:dataSurce];
            
            self.request.pg++;
            
            if (self.bottomView.leftBtn.selected) {
                
                self.bottomView.leftBtn.selected = NO;
                
                [self bottomLeftBtnStatus:self.bottomView.leftBtn.selected];
                
            }
            
        }
        
        [self sortDataSource:self.dataSource];
        
        if (self.dataSource.count == 0) {
            
            self.tableView.frame = self.view.bounds;
            
            self.tableView.tableHeaderView = [self setHeaderDefaultView];
            
            self.contentTopView.height = 0;
            
            self.contentTopView.hidden = YES;
            
        }else {
            
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
            
            self.contentTopView.height = TYGetViewH(self.desButton);
            
            self.contentTopView.hidden = NO;
            
        }
        
        if (dataSurce.count >= self.request.pagesize) {
            
            if (!self.tableView.mj_footer){
                
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
                
            }
            
        }else {
            
            self.tableView.mj_footer = nil;
            
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [TYLoadingHub hideLoadingView];

        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)onFooterRereshing {
    
    [self loadNetData];
    
}

#pragma mark - YQ差账功能

#pragma mark - 点击差账弹框跳转到修改界面
-(void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [JGJSurePoorBillShowView removeView];
    JGJUnsetSalaryTplByUidListModel *listModel = self.list[indexpath.section];
    JGJRecordWorkPointListModel *pointModel = listModel.date_list[indexpath.row];
    model.working_hours = pointModel.manhour;
    model.overtime_hours = pointModel.overtime;
    [self modifyBillWithBillModel:model];
    
}

#pragma mark - 修改记账
- (void)modifyBillWithBillModel:(YZGGetBillModel *)model {
    
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    
    ModifyBillListVC.billModify = YES;
    MateWorkitemsItems *mateWorkModel = [[MateWorkitemsItems alloc]init];
    mateWorkModel.accounts_type.code =  model.accounts_type.code;
    mateWorkModel.id = [model.id?:@"0" longLongValue];
    mateWorkModel.record_id = model.id;
    ModifyBillListVC.mateWorkitemsItems = mateWorkModel;
//    [ModifyBillListVC setOriginalWorkTime:[model.working_hours floatValue] overTime:[model.overtime_hours floatValue]];
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
    
}

-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [JGJSurePoorBillShowView removeView];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:@{@"id":model.id?:@""} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self loadNetData];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 排序
- (void)sortDataSource:(NSArray *)dataSource{
    
    self.sortDataSource = [self.pageSizeModel sortDataSource:dataSource];
    
}

- (JGJRecordWorkPointRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJRecordWorkPointRequestModel new];
        
        _request.pg = 1;
        
        _request.pagesize = 20;
        
    }
    
    return _request;
}

- (JGJPageSizeModel *)pageSizeModel {
    
    if (!_pageSizeModel) {
        
        _pageSizeModel = [JGJPageSizeModel new];
        
    }
    
    return _pageSizeModel;
}

#pragma mark -设置缺省页
- (UIView *)setHeaderDefaultView {
    
    JGJComDefaultView *defaultView = [[JGJComDefaultView alloc] initWithFrame:CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - 10)];
    
    JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
    
    defaultViewModel.lineSpace = 5;
    
    defaultViewModel.des = @"暂无数据哦~";
    
    defaultViewModel.isHiddenButton = YES;
    
    defaultView.defaultViewModel = defaultViewModel;
    
    return defaultView;
}

#pragma mark - 全选本页按钮按下

- (void)allSelBtnPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [self.selListModels removeAllObjects];
    
    for (NSArray *workdays in self.sortDataSource) {
        
        for (JGJRecordWorkPointListModel *listModel in workdays) {
            
            listModel.isSel = sender.selected;
            
            if (sender.selected) {
                
                [self.selListModels addObject:listModel];
                
            }
            
        }
        
    }
    
    [self.tableView reloadData];
    
    [self showSelCnt];
}

#pragma mark - 批量修改点工

- (void)batchModifyTinyWage:(UIButton *)sender {
    
    if (self.selListModels.count == 0) {
        
        [TYShowMessage showPlaint:@"请选择要设置工资金额的点工账"];
        
        return;
    }
    
    JGJCusSetTinyPopView *cusSetTinyPopView = [[JGJCusSetTinyPopView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    NSString *cnt = [NSString stringWithFormat:@"%@", @(self.selListModels.count)];
    
    cusSetTinyPopView.selCntsDes.text = [NSString stringWithFormat:@"本次共选中 %@笔 点工", cnt];
    
    [cusSetTinyPopView.selCntsDes markText:cnt withColor:AppFontEB4E4EColor];
    
    cusSetTinyPopView.money.placeholder = [NSString stringWithFormat:@"请输入与%@协商的金额", JLGisLeaderBool ? @"工人" : @"班组长"];
    
    self.cusSetTinyPopView = cusSetTinyPopView;
    
    TYWeakSelf(self);
    
    self.cusSetTinyPopView.confirmBlock = ^(JGJCusSetTinyPopView *popView) {
        
        double salary = [weakself.cusSetTinyPopView.money.text doubleValue];
        
        if ([NSString isFloatZero:salary] || [NSString isEmpty:weakself.cusSetTinyPopView.money.text]) {
            
            [TYShowMessage showPlaint:@"请设置工资金额"];
            
            return;
        }
      
        [weakself requestSetBatchSalaryTpl];
        
    };
    
}

- (void)requestSetBatchSalaryTpl {
    
    NSMutableArray *record_ids = [[NSMutableArray alloc] init];
    
    for (JGJRecordWorkPointListModel *listModel in self.selListModels) {
        
        if (![NSString isEmpty:listModel.recordId]) {
            
           [record_ids addObject:listModel.recordId];
        }
    }
    
    NSString *record_id = [record_ids componentsJoinedByString:@","];
    
    JGJSetBatchSalaryTplRequestModel *requestModel = [[JGJSetBatchSalaryTplRequestModel alloc] init];
    
    requestModel.salary = self.cusSetTinyPopView.money.text;

    requestModel.record_id = record_id;
    
    TYWeakSelf(self);
    
    [requestModel requstSetBatchSalaryTplSuccess:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"工资金额设置成功！"];
        
        weakself.is_show_selBtn = NO;
        
        [weakself.selListModels removeAllObjects];
        
        [weakself setRightItemStatus];
        
        [weakself beginFresh];
        
        for (UIViewController *curVc in self.navigationController.viewControllers) {
            
            
            if ([curVc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
                
                JYSlideSegmentController *slideVc = (JYSlideSegmentController *)curVc;
                
                [slideVc refreshGetOutstandingAmount];
                
                break;
            }
            
            
        }
        
        if (weakself.modifyTinySuccessBlock) {
            
            weakself.modifyTinySuccessBlock();
        }
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

- (NSMutableArray *)selListModels {
    
    if (!_selListModels) {
        
        _selListModels = [NSMutableArray array];
    }
    
    return _selListModels;
}

- (JGJCusBottomSelBtnView *)bottomView {
    
    if (!_bottomView) {
        
        CGFloat height = [JGJCusBottomSelBtnView bottomSelBtnViewHeight] + JGJ_IphoneX_BarHeight;
        
        _bottomView = [[JGJCusBottomSelBtnView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT, TYGetUIScreenWidth, height)];
        
        TYWeakSelf(self);
        
        _bottomView.leftBlock = ^(UIButton *sender) {
          
            [weakself allSelBtnPressed:sender];
            
            [weakself bottomLeftBtnStatus:sender.selected];
            
        };
        
        _bottomView.rightBlock = ^(UIButton *sender){
          
            [weakself batchModifyTinyWage:sender];
            
        };
        
    }
    
    return _bottomView;
}

@end
