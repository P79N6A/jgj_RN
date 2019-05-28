//
//  JGJUnWagesVc.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWagesVc.h"

#import "JGJUnWagesTopCell.h"

#import "JGJUnSetFormCell.h"

#import "JGJUnWagesMemberCell.h"

#import "JGJCustomLable.h"

#import "JGJUnWagesShortWorkVc.h"

#import "JLGCustomViewController.h"

#import "JGJRecordStaListDetailVc.h"

#import "JGJCusBottomButtonView.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJMarkBillViewController.h"

#import "JGJCustomPopView.h"

#import "JGJCommonDesCell.h"

#import "UILabel+GNUtil.h"

#import "JGJRecordStaListMidVc.h"

#import "NSDate+Extend.h"

#import "JGJRecordHeader.h"
#import "JYSlideSegmentController.h"
@interface JGJUnWagesVc () <UITableViewDelegate, UITableViewDataSource, JGJUnSetFormCellDelegate, JGJUnWagesMemberCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJRecordUnWageModel *recordUnWageModel;

//是否是批量结算
@property (nonatomic, assign) BOOL isBatch;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

//选中未结工资模型
@property (nonatomic, strong) NSMutableArray *selUnWageModels;

@property (nonatomic, strong) JGJCommonDesCellModel *desModel;

@property (strong, nonatomic) JGJRecordWorkPointRequestModel *request;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JGJUnWagesVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"未结工资";

    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.buttonView];
    
    TYWeakSelf(self);
    
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        [weakself popViewConfirm];
    };
    
    if (![self checkIsRealName]) {
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;

            customVc.customVcCancelButtonBlock = ^(id response) {
              
                [weakself.navigationController popViewControllerAnimated:YES];
                
            };
            
        }
        
        return;
    }

//批量结算去掉
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"批量结算" style:UIBarButtonItemStylePlain target:self action:@selector(batchItemPressed:)];
//
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    
    [self refreshUnWagesData];
}

- (void)popViewConfirm {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"你确定要对选中的人设置为结清吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    desModel.messageFont = FONT(AppFont28Size);
    
    desModel.contentViewHeight = 160;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentCenter;
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf requestSettleData];
    };
    
}

- (void)refreshUnWagesData {
    
    self.request.pg = 1;
    
    [self loadNetData];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    switch (section) {
            
        case 0:{
            
            count = 3;
            
            CGFloat un_salary_count = [[NSString stringWithFormat:@"%@", self.recordUnWageModel.un_salary_tpl] floatValue];
            
            if ([NSString isFloatZero:un_salary_count]) {
                
                count = 2;
            }
            
        }
            break;
            
        case 1:{
            
            count = self.recordUnWageModel.list.count;
            
        }
            break;
            
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
           
            cell = [self registerDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }else if (indexPath.row == 1) {
            
            cell = [self registerUnWagesTopCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        
        else {
            
            cell = [self registerUnSetFormCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        
    }else {
        
        cell = [self registerUnWagesMemberCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 60;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        height = 95.0;
        
    }else if (indexPath.section == 0 && indexPath.row == 0 && self.recordUnWageModel.list.count == 0) {
        
        height = CGFLOAT_MIN;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (section == 1) {
        
        height = self.recordUnWageModel.list.count == 0 || !self.isBatch ? CGFLOAT_MIN : 30.0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (section == 0) {
        
        height = self.recordUnWageModel.list.count == 0 ? CGFLOAT_MIN : 30.0;
    }
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.recordUnWageModel.list.count == 0) {
        
        return nil;
    }
    
    CGFloat height = 30.0;
    
    JGJCustomLable *memberTitleLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    NSString *des = @"(点击工人名字，可查看工人记工统计详情)";
    
    if (!JLGisLeaderBool) {
        
        des = @"(点击班组长名字，可查看班组长记工统计详情)";
    }
    
    memberTitleLable.text = JLGisLeaderBool ? [NSString stringWithFormat:@"工人%@", des] : [NSString stringWithFormat:@"班组长%@", des];
    
    memberTitleLable.textColor = AppFont999999Color;
    
    JGJCustomLable *moneyTitleLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - 262, 0, 250, height)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, TYGetUIScreenWidth, 0.5)];
    
    lineView.hidden = self.isBatch && self.recordUnWageModel.list.count > 0;
    
    lineView.backgroundColor = AppFontdbdbdbColor;
    
    moneyTitleLable.text = @"未结工资";
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    contentView.backgroundColor = AppFontf1f1f1Color;
    
    [contentView addSubview:memberTitleLable];
    
    [contentView addSubview:moneyTitleLable];
    
    [contentView addSubview:lineView];
    
    moneyTitleLable.textAlignment = NSTextAlignmentRight;
    
    moneyTitleLable.backgroundColor = [UIColor clearColor];
    
    moneyTitleLable.textColor = AppFont999999Color;
    
    moneyTitleLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    memberTitleLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    memberTitleLable.backgroundColor = AppFontf1f1f1Color;
    
    memberTitleLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    if (TYIS_IPHONE_5_OR_LESS) {
        
        [memberTitleLable markText:des withFont:[UIFont systemFontOfSize:AppFont20Size] color:AppFont999999Color];
        
    }else {
        
        [memberTitleLable markText:des withFont:[UIFont systemFontOfSize:AppFont24Size] color:AppFont999999Color];
    }
    
    return section == 0 ? contentView : nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 30.0;
    
    JGJCustomLable *titleLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    titleLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    titleLable.text = @"本次批量结算会将选中的对象未结工资清零";
    
    titleLable.textColor = AppFontEE8215Color;
    
    titleLable.backgroundColor = AppFontfdf1e0Color;
    
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    return section == 1 && self.isBatch && self.recordUnWageModel.list.count > 0 ? titleLable : nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
    }
  
    if (self.isBatch) {
        
        [self batchSelUnWageModelWithIndexPath:indexPath];
        
    }else {
        
//        [self staListDetailVcWithIndexPath:indexPath];
        
        [self registerStaWithTableView:tableView didSelectRowAtIndexPath:indexPath];

    }
    
}

#pragma mark - 批量选中
- (void)batchSelUnWageModelWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordUnWageListModel *listModel = self.recordUnWageModel.list[indexPath.row];
    
    listModel.isSel = !listModel.isSel;
    
    if (listModel.isSel) {
        
        [self.selUnWageModels addObject:listModel];
        
    }else {
        
        [self.selUnWageModels removeObject:listModel];
    }
    
    self.buttonView.actionButton.enabled = self.selUnWageModels.count > 0;
    
    self.buttonView.actionButton.alpha = self.selUnWageModels.count > 0 ? 1 : 0;
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

#pragma mark - 人员统计
- (void)staListDetailVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListDetailVc *detailVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListDetailVc"];
    
    JGJRecordUnWageListModel *listModel = self.recordUnWageModel.list[indexPath.row];
    
    JGJRecordWorkStaListModel *staListModel = [JGJRecordWorkStaListModel new];
    
    NSString *remark = JLGisLeaderBool ? @"" : @" 处";
    
    staListModel.nameDes = [NSString stringWithFormat:@"%@ %@%@的记工", JLGisLeaderBool ? @"工人" :@"我在班组长", listModel.user_info.real_name, remark];
    
    JGJRecordWorkStaRequestModel *request = [JGJRecordWorkStaRequestModel new];
    
    request.class_type_id = listModel.user_info.uid?:@"";
    
    staListModel.class_type_id = request.class_type_id;
    
    staListModel.class_type = @"person";
    
    request.class_type = @"person";
    
    detailVc.staListModel = staListModel;
    
    request.is_day = nil;//默认月统计
    
    detailVc.request = request;
    
    detailVc.request.class_type_id = staListModel.class_type_id;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)registerStaWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordUnWageListModel *listModel = self.recordUnWageModel.list[indexPath.row];
    
    JGJRecordWorkStaListModel *staListModel = [JGJRecordWorkStaListModel new];

    JGJRecordWorkStaRequestModel *request = [JGJRecordWorkStaRequestModel new];
    
    request.class_type_id = listModel.user_info.uid?:@"";
    
    staListModel.class_type_id = request.class_type_id;
    
    staListModel.name = listModel.user_info.name;
    
    staListModel.class_type = @"person";
    
    request.class_type = @"person";

    request.is_day = nil;//默认月统计
    
    staListModel.is_lock_name = YES;
    
//    staListModel.isForbidSkipWorkpoints = YES;
    
    [JGJRecordStaSearchTool skipVcWithVc:self staListModel:staListModel user_info:listModel.user_info];
    
}

- (UITableViewCell *)registerUnWagesTopCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    JGJUnWagesTopCell *cell = [JGJUnWagesTopCell cellWithTableView:tableView];
    
    cell.recordUnWageModel = self.recordUnWageModel;
    
    return cell;
}

- (UITableViewCell *)registerDesCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCommonDesCell *cell = [JGJCommonDesCell cellWithTableView:tableView];
    
    cell.desModel = self.desModel;
    
    return cell;
}

- (UITableViewCell *)registerUnSetFormCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJUnSetFormCell *cell = [JGJUnSetFormCell cellWithTableView:tableView];
    
    cell.recordUnWageModel = self.recordUnWageModel;
    
    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell *)registerUnWagesMemberCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJUnWagesMemberCell *cell = [JGJUnWagesMemberCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.isScreenShowLine = self.recordUnWageModel.list.count - 1 == indexPath.row;
    
    cell.isBatch = self.isBatch;
    
    cell.listModel = self.recordUnWageModel.list[indexPath.row];
    
    return cell;
}

- (void)unSetFormCell:(JGJUnSetFormCell *)cell checkButton:(UIButton *)checkButton {
    
    JGJUnWagesShortWorkVc *shortWorkVc = [JGJUnWagesShortWorkVc new];
    
    TYWeakSelf(self);
    
    shortWorkVc.modifyTinySuccessBlock = ^{
      
        [weakself refreshUnWagesData];
    };
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:shortWorkVc animated:YES];
                
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:shortWorkVc animated:YES];
    }

}

#pragma mark - JGJUnWagesMemberCellDelegate
- (void)unWagesMemberCellWithCell:(JGJUnWagesMemberCell *)cell buttonType:(JGJUnWagesMemberCellButtonType)buttonType {
    
    switch (buttonType) {
        case JGJUnWagesMemberCellSelButtonType:{
            
            [self selButtonPressedWithCell:cell];
        }
            
            break;
        case JGJUnWagesMemberCellSettleButtonType:{
            
            [self settButtonPressedWithCell:cell];
        }
            
            break;
        default:
            break;
    }
    
    
}

#pragma mark - 选择按钮按下
- (void)selButtonPressedWithCell:(JGJUnWagesMemberCell *)cell {
    
    
}

#pragma mark - 结算按钮按下
- (void)settButtonPressedWithCell:(JGJUnWagesMemberCell *)cell {
    
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.closeUserInfo = cell.listModel.user_info;
    slideSegmentVC.defultSelectedIndex = 1;
    slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
    slideSegmentVC.title = @"记工记账";
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
    
}

- (void)batchItemPressed:(UIBarButtonItem *)item {
    
    self.isBatch = !self.isBatch;
    
    //取消批量选中
    if (!self.isBatch) {
        
        [self batchSelAction];
        
    }else {
        
        self.selUnWageModels = [NSMutableArray array];
    }
}

- (void)setIsBatch:(BOOL)isBatch {
    
    _isBatch = isBatch;
    
    self.navigationItem.rightBarButtonItem.title = _isBatch ? @"取消结算" : @"批量结算";
    
    CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 63;
    
    _buttonView.frame = CGRectMake(0, buttonViewY, TYGetUIScreenWidth, _isBatch ? 63 : 0);
    
    _buttonView.hidden = !_isBatch;

    CGRect frame = CGRectMake(0, 0, TYGetUIScreenWidth, _isBatch ? TYGetUIScreenHeight - JGJ_NAV_HEIGHT - _buttonView.height : TYGetUIScreenHeight - JGJ_NAV_HEIGHT);

    _tableView.frame =  frame;
    
    [self.tableView reloadData];
    
}

#pragma mark - 取消批量选中
- (void)batchSelAction {
    
    if (!self.isBatch) {
        
        for (JGJRecordUnWageListModel *listModel in self.selUnWageModels) {
            
            listModel.isSel = NO;
        }
    }
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - self.buttonView.height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.tableView.hidden = YES;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, 0)];
        
        _buttonView.hidden = YES;
        
        [_buttonView.actionButton setTitle:@"提交" forState:UIControlStateNormal];
        
        _buttonView.actionButton.enabled = NO;
        
        _buttonView.actionButton.alpha = 0.5;
    }
    return _buttonView;
}


- (void)setRecordUnWageModel:(JGJRecordUnWageModel *)recordUnWageModel {
    
    _recordUnWageModel = recordUnWageModel;
    
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-unpaysalary-list" parameters:parameters success:^(id responseObject) {
        
        TYLog(@"走接口没有");
        JGJRecordUnWageModel *unWageStaModel = nil;
        
        if (self.request.pg == 1) {
            
            unWageStaModel = [JGJRecordUnWageModel mj_objectWithKeyValues:responseObject];
            
        }
        
        NSArray *dataSource = [JGJRecordUnWageListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [TYLoadingHub hideLoadingView];
        
        //初始数据
        //筛选前的数据
        if (!_dataSource || self.request.pg == 1) {
            
            self.dataSource = [NSMutableArray array];
            
        }
        
        if (!self.recordUnWageModel) {
            
            self.recordUnWageModel = [JGJRecordUnWageModel new];
        }
        
        if (unWageStaModel) {
            
            self.recordUnWageModel.total_amount = unWageStaModel.total_amount;
            
            self.recordUnWageModel.un_salary_tpl = unWageStaModel.un_salary_tpl;
            
            self.recordUnWageModel.amounts = unWageStaModel.amounts;
            
            self.recordUnWageModel.allnum = unWageStaModel.allnum;
            
        }
        
        if (dataSource.count > 0) {
            
            [self.dataSource addObjectsFromArray:dataSource];
            
            self.request.pg++;
        }

        self.recordUnWageModel.list = self.dataSource;
        
        if (dataSource.count >= self.request.pagesize) {
            
            if (!self.tableView.mj_footer){
                
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
                
            }
            
        }else {
            
            self.tableView.mj_footer = nil;
            
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}


- (void)onFooterRereshing {
    
    [self loadNetData];
    
}

- (JGJRecordWorkPointRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJRecordWorkPointRequestModel new];
        
        _request.pg = 1;
        
        _request.pagesize = 20;
        
    }
    
    return _request;
}

#pragma mark - 提交结算数据
- (void)requestSettleData {
    
    NSMutableString *selUids = [NSMutableString string];
    
    for (JGJRecordUnWageListModel *listModel in self.selUnWageModels) {
        
        [selUids appendFormat:@"%@," ,listModel.user_info.uid];
    }
    
    NSDictionary *parameters = @{@"uids" : selUids?:@""};
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/batchBalance" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self loadNetData];
        
        [TYShowMessage showSuccess:@"已为你生成结算记账记录"];
        
        self.isBatch = !self.isBatch;
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
        
    }];
    

}

- (JGJCommonDesCellModel *)desModel {
    
    if (!_desModel) {
        
        _desModel = [[JGJCommonDesCellModel alloc] init];
        
        NSString *leaderDes = @"有往年未结算的工资，点击对应工人的“去结算”，在本次实付金额栏输入以往未结金额即可完成老账结算";
        
        NSString *workerDes = @"有往年未结算的工资，点击对应班组长的“去结算”，在本次实收金额栏输入以往未结金额即可完成老账结算";
        
        _desModel.title = JLGisLeaderBool ? leaderDes : workerDes;
    }
    
    return _desModel;
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 保存初始数据、人员和时间
- (void)getInitialTimeWithListModel:(JGJRecordUnWageListModel *)listModel {
    
    //搜索显示统一用单例处理，避免多层传值
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //获取初始时间保存初始值
    NSString *format = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    
    NSString *start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @"01", @"01"]];
    
    NSDate *start_Date = [NSDate dateFromString:start_time withDateFormat:format];
    
    start_time = [NSDate stringFromDate:start_Date format:format];
    
    NSString *end_time = [NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @(date.components.month), @(date.components.day)];
    
    NSDate *end_date = [NSDate dateFromString:end_time withDateFormat:format];
    
    end_time = [NSDate stringFromDate:end_date format:format];
    
    //判断时间问题
    NSInteger stYear = start_Date.components.year;
    
    NSInteger stMonth = start_Date.components.month;
    
    NSInteger stDay = start_Date.components.day;
    
    
    NSInteger enYear = end_date.components.year;
    
    NSInteger enMonth = end_date.components.month;
    
    NSInteger enDay = end_date.components.day;
    
    BOOL is_cover = (stYear > enYear) || (stYear <= enYear && stMonth > enMonth) || (stYear <= enYear && stMonth <= enMonth && stDay > enDay);
    
    if (stYear > enYear) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth > enMonth) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth == enMonth && stDay > enDay) {
        
        is_cover = YES;
        
    }else {
        
        is_cover = NO;
        
    }
    
    if (is_cover) {
        
        NSInteger minYear = enYear-1;
        
        start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(minYear), @"01", @"01"]];
        
        if (![NSString isEmpty:start_time]) {
            
            start_Date = [NSDate dateFromString:start_time withDateFormat:format];
            
            start_time = [NSDate stringFromDate:start_Date format:format];
        }
        
    }
    
    staInitialModel.stTime = start_time;
    
    staInitialModel.endTime = end_time;
    
    staInitialModel.memberUid = listModel.user_info.uid;
    
    staInitialModel.memberName = listModel.user_info.real_name;
        
    staInitialModel.proName = AllProName;
    
    staInitialModel.proId = AllProId;
    ;
    ;
    ;
}

@end
