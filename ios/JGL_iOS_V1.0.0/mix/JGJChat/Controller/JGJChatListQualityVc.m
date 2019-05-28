//
//  JGJChatListQualityVc.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListQualityVc.h"
#import "JGJChatNoticeVc.h"

#import "JGJQualityRecordVc.h"

#import "JGJQualityMsgListCell.h"

#import "JGJQualitySafeModel.h"

#import "JGJQualityTopFilterView.h"

#import "JGJQualityFilterVc.h"

#import "JGJQualityMsgReplyListVc.h"

#import "JGJQualityDetailVc.h"

#import "CFRefreshStatusView.h"

#import "UILabel+GNUtil.h"

#import "JGJQuaSafeCheckVc.h"

#import "UIView+Extend.h"

#import "JGJWebAllSubViewController.h"

#import "JGJWebUnSeniorPayVc.h"

#import "UIButton+JGJUIButton.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJNoDataDefultView.h"

#import "JGJQualityRecordVc.h"

#import "JGJChatMsgDBManger+JGJIndexDB.h"
#define PageSize 20

@interface JGJChatListQualityVc () <

JGJQualityFilterVcDelegate

>

//保存重置前的状态
@property (nonatomic, strong) JGJQualitySafeListRequestModel *lastRequestModel;

@property (nonatomic, strong) JGJQualitySafeModel *qualitySafeModel;

@property (nonatomic, strong) NSMutableArray *qualityList;


//上次选中的类型
@property (nonatomic, assign) TopFilterViewType lastFilterType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFilterViewH;

//显示自定义筛选View
@property (strong, nonatomic) UIView *contentTopView;

//顶部筛选数据
@property (strong, nonatomic) UILabel *contentLable;

@end

@implementation JGJChatListQualityVc

- (void)dataInit{
    
    [super dataInit];
    
    [self commonSet];
    
    // 清除质量未读数
    [self delUnread_Quality_work_count];
    [self freshTableView];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self contentTopView];
    
    UITapGestureRecognizer *cusFilterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cusFilterVc)];
    
    cusFilterTap.numberOfTapsRequired = 1;
    
    [self.contentTopView addGestureRecognizer:cusFilterTap];
    
    self.topFilterViewH.constant = 0;
    
    self.isFreshTabView = YES;
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.workProListModel.class_type isClose:self.workProListModel.isClosedTeamVc];
    
    JGJQualitySafeListRequestModel *request = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.requestModel]];
    
    self.lastRequestModel = request;
    
}

- (void)delUnread_Quality_work_count {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_quality_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
}

- (void)commonSet {
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadUpData)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"custom_filter_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(customFilterVc)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_isFreshTabView) {
        
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 进入筛选页面
- (void)cusFilterVc {
    
    JGJQualityFilterVc *qualityFilterVc = [JGJQualityFilterVc new];
    
    qualityFilterVc.filterType = self.filterType;
    
    qualityFilterVc.delegate = self;
    
    qualityFilterVc.requestModel = self.requestModel;
    
    //保存初始的筛选值，重置使用
    qualityFilterVc.lastRequestModel = self.lastRequestModel;
    
    qualityFilterVc.proListModel = self.workProListModel;
    
    [self.navigationController pushViewController:qualityFilterVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.qualityList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityMsgListCell *replyListCell = [JGJQualityMsgListCell cellWithTableView:tableView];
    
    if (self.qualityList.count > 0) {
        
        replyListCell.listModel = self.qualityList[indexPath.row];
        
    }
    
    return replyListCell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (self.qualityList.count > 0) {
        
        JGJQualitySafeListModel *listModel = self.qualityList[indexPath.row];
        
        height = listModel.cellHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.qualityList.count == 0) {
        
        return;
    }
    
    JGJQualitySafeListModel *listModel = self.qualityList[indexPath.row];
    
    JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
    
    detailVc.proListModel = self.workProListModel;
    
    detailVc.commonModel = self.commonModel;
    
    detailVc.listModel = listModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
    TYLog(@"点击进质量详情页");
    
    
}

#pragma mark - 子类使用
- (void)subLoadNetData {
    
    [self chatListLoadData];
}

- (void)chatListLoadData{
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_header = nil;
    }else{
        
        self.requestModel.msg_type = self.commonModel.msg_type;
        
        self.requestModel.class_type = self.workProListModel.class_type;
        
        self.requestModel.group_id = self.workProListModel.group_id;
        
        self.requestModel.pg = 1;
        
        NSDictionary *parameters = [self.requestModel mj_keyValues];
        
        //        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeList" parameters:parameters success:^(id responseObject) {
            
            //            [TYLoadingHub hideLoadingView];
            
            self.qualitySafeModel = [JGJQualitySafeModel mj_objectWithKeyValues:responseObject];
            
            if (self.qualityList.count > 0) {
                
                [self.qualityList removeAllObjects];
            }
            
            if (self.qualitySafeModel.list.count > 0) {
                
                self.requestModel.pg ++;
                
                NSRange range = NSMakeRange(0, self.qualitySafeModel.list.count);
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                
                [self.qualityList insertObjects:self.qualitySafeModel.list atIndexes:indexSet];
                
            }
            
            //判断是否有数据
            
            [self showDefaultNoDataArray:self.qualityList];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
            _isFreshTabView = NO;
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
            //            [TYLoadingHub hideLoadingView];
        }];
        
    }
    
}

- (void)chatListLoadUpData{
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_header = nil;
    }else{
        
        NSDictionary *parameters = [self.requestModel mj_keyValues];
        
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeList" parameters:parameters success:^(id responseObject) {
            
            self.qualitySafeModel = [JGJQualitySafeModel mj_objectWithKeyValues:responseObject];
            
            if (self.qualitySafeModel.list.count > 0) {
                
                [self.qualityList addObjectsFromArray:self.qualitySafeModel.list];
                
                self.requestModel.pg ++;
                
                [self.tableView reloadData];
            }
            
            [self.tableView.mj_footer endRefreshing];
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }
    
}

- (void)freshTableView {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNoDataArray:(NSArray *)dataArray {
    
    if ((dataArray.count == 0 && self.filterType != QuaSafeFilterMyCommitType)) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
    } else if (self.filterType == QuaSafeFilterMyCommitType && dataArray.count == 0) {
        
        [self myCreatDefaultWithDataSource:dataArray];
        
    } else {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
        
    }
}

#pragma mark -我创建的任务缺省页
- (void)myCreatDefaultWithDataSource:(NSArray *)dataSource {
    
    if (dataSource.count == 0 && self.filterType == QuaSafeFilterMyCommitType) {

        JGJHelpCenterTitleViewType titleViewType = JGJHelpCenterTitleViewQualityType;

        NSString *msgType = @"质量";

        if ([self.commonModel.msg_type isEqualToString:@"safe"]) {

            titleViewType = JGJHelpCenterTitleViewSafeType;

            msgType = @"安全";
        }

        JGJNodataDefultModel *defultModel = [JGJNodataDefultModel new];

        defultModel.helpTitle = @"查看帮助";

        defultModel.pubTitle = @"立即发布";


        defultModel.contentStr = [NSString stringWithFormat:@"暂无提交的%@问题", msgType];

        __weak typeof(self) weakSelf = self;

        JGJNoDataDefultView *defultView = [[JGJNoDataDefultView alloc] initWithFrame:CGRectMake(0, 64, TYGetUIScreenWidth, TYGetUIScreenHeight - 64) andSuperView:nil andModel:defultModel helpBtnBlock:^(NSString *title){

            JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView new];
            
            titleView.titleViewType = titleViewType;
            
            titleView.proListModel = self.proListModel;
            
            [titleView helpCenterActionWithTitleViewType:titleViewType target:weakSelf];

        } pubBtnBlock:^(NSString *title) {

            if (weakSelf.workProListModel.isClosedTeamVc) {
                
                [JGJComTool showCloseProPopViewWithClasstype:weakSelf.workProListModel.class_type];
                
                return ;
            }
            
            [weakSelf handlePushAction];
        }];

        self.tableView.tableHeaderView = defultView;
    }
    
}

#pragma mark - 发布按钮按下
- (void)handlePushAction {
    
    JGJQualityRecordVc *qualityRecordVc = [JGJQualityRecordVc new];
    
    qualityRecordVc.proListModel = self.workProListModel;
    
    qualityRecordVc.commonModel = self.commonModel;
    
    [self.navigationController pushViewController:qualityRecordVc animated:YES];
}

- (void)setQualitySafeModel:(JGJQualitySafeModel *)qualitySafeModel {
    
    _qualitySafeModel = qualitySafeModel;
    
    [self setSubQualitySafeModel:_qualitySafeModel];
    
    self.contentLable.text = [NSString stringWithFormat:@"共筛选出 %@ 条记录",_qualitySafeModel.list_counts?:@"0"];
    
    if (![NSString isEmpty:_qualitySafeModel.list_counts]) {
        
        [self.contentLable markText:_qualitySafeModel.list_counts withColor:AppFontd7252cColor];
    }
    
}

#pragma mark - 子类使用
- (void)setSubQualitySafeModel:(JGJQualitySafeModel *)qualitySafeModel {
    
    
    
}

#pragma mark - 筛选类型
- (void)handleFilterQuality:(TopFilterViewType) type {
    
//    self.requestModel.is_special = @"0";
    
    [self cusFilterVc];
    
    if (type != TopFilterViewCusModifyType) {
        
        [self.qualityList removeAllObjects];
        
        [self.tableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - JGJQualityFilterVcDelegate

- (void)qualityFilterVc:(JGJQualityFilterVc *)filterVc {
    
    [self.qualityList removeAllObjects];
    
    if (filterVc.isReset) {
        
        [self resetBtnAction:nil];
        
    }else {
        
        [self cusFilterVcWithFilterVc:filterVc];
    }
    
}

- (void)cusFilterVcWithFilterVc:(JGJQualityFilterVc *)filterVc {
    
    self.requestModel.is_special = @"1";
    
    self.contentTopView.hidden = NO;
    
    self.topFilterViewH.constant = TYGetViewH(self.contentTopView);
    
    self.requestModel = filterVc.requestModel;
    
    self.contentLable.text = @"共筛选出";
    
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)releaseQualityButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    //    JGJChatNoticeVc *qualityVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
    //    qualityVc.pro_name = self.workProListModel.pro_name;
    //    qualityVc.chatListType = JGJChatListQuality;
    //    qualityVc.workProListModel = self.workProListModel;
    //
    //    [self.navigationController pushViewController:qualityVc animated:YES];
    
    JGJQualityRecordVc *qualityRecordVc = [JGJQualityRecordVc new];
    
    qualityRecordVc.proListModel = self.workProListModel;
    
    qualityRecordVc.commonModel = self.commonModel;
    
    [self.navigationController pushViewController:qualityRecordVc animated:YES];
    
}

- (JGJQualitySafeListRequestModel *)requestModel {
    
    if (!_requestModel) {
        
        _requestModel = [JGJQualitySafeListRequestModel new];
        
        _requestModel.pg = 1;
        
        _requestModel.pagesize = PageSize;
    }
    
    return _requestModel;
    
}

- (JGJQualitySafeListRequestModel *)lastRequestModel {
    
    if (!_lastRequestModel) {
        
        _lastRequestModel = [JGJQualitySafeListRequestModel new];
        
        _lastRequestModel.pg = 1;
        
        _lastRequestModel.pagesize = PageSize;
    }
    
    return _lastRequestModel;
}

- (NSMutableArray *)qualityList {
    
    if (!_qualityList) {
        
        _qualityList = [NSMutableArray new];
        
    }
    
    return _qualityList;
}

- (UIView *)contentTopView {
    
    if (!_contentTopView) {
        
        _contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
        
        _contentTopView.backgroundColor = [UIColor whiteColor];
        
        _contentTopView.hidden = YES;
        
        [self.view addSubview:_contentTopView];
        
        UIButton *resetBtn = [UIButton new];
        
        [_contentTopView addSubview:resetBtn];
        
        [resetBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
        
        resetBtn.frame = CGRectMake(TYGetUIScreenWidth - 50, 12.5, 40, 20);
        
        [resetBtn.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
        
        [resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
        
        self.contentLable = [UILabel new];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCusFilter)];
        
        tap.numberOfTapsRequired = 1;
        
        [self.contentLable addGestureRecognizer:tap];
        
        self.contentLable.text = @"共筛选出 0 条记录";
        
        [self.contentLable markText:@"0" withColor:AppFontd7252cColor];
        
        self.contentLable.frame = CGRectMake(10, 12.5, TYGetUIScreenWidth - 100, 20);
        
        [_contentTopView addSubview:self.contentLable];
        
        self.contentLable.font = [UIFont systemFontOfSize:AppFont28Size];
        
        self.contentLable.textColor = AppFont999999Color;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, TYGetUIScreenWidth, 15)];
        
        lineView.backgroundColor = AppFontf1f1f1Color;
        
        [_contentTopView addSubview:lineView];
    }
    
    return _contentTopView;
}

#pragma mark - 点击筛选结果进入筛选页面
- (void)handleTapCusFilter {
    
    [self handleFilterQuality:TopFilterViewCusModifyType];
}

#pragma mark - 重置按钮按下
- (void)resetBtnAction:(UIButton *)sender {
    
    self.contentTopView.hidden = YES;
    
    self.topFilterViewH.constant = 0;
    
    self.requestModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.lastRequestModel]];
    
    self.requestModel.is_special = @"0";
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 统计按钮按下
- (void)staButtonClick:(UIButton *)sender {
    
    //普通版付费，高级版查看
    
    if ([self.proListModel.is_senior isEqualToString:@"0"]) {
        
        [self staButtonClickWebPay];
        
    }else {
        
        
        [self staButtonClickWebVc];
    }
    
    
    
}

- (void)staButtonClickWebVc {
    
    NSString *statisticsStr = [NSString stringWithFormat:@"%@stcharts?group_id=%@&class_type=%@&&msg_type=%@&close=%@",JGJWebDiscoverURL, self.workProListModel.group_id, self.workProListModel.class_type,self.commonModel.msg_type, @(self.workProListModel.isClosedTeamVc)];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
    
    //    if (self.workProListModel.isClosedTeamVc) {
    //
    //        UIImageView *clocedImageView = [[UIImageView alloc] init];
    //        clocedImageView.image = [UIImage imageNamed:@"Chat_closedGroup"];
    //        [webVc.view addSubview:clocedImageView];
    //
    //        [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.center.mas_equalTo(webVc.view);
    //            make.width.mas_equalTo(126);
    //            make.height.mas_equalTo(70);
    //        }];
    //
    //    }
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}

- (void)staButtonClickWebPay {
    
    JGJWebUnSeniorPayVc *payVc = [JGJWebUnSeniorPayVc new];
    
    payVc.proListModel = self.proListModel;
    
    if ([self.commonModel.msg_type isEqualToString:@"quality"]) {
        
        payVc.title = @"质量统计";
        
        payVc.webUnSeniorPayVcType = JGJWebUnSeniorPayVcQualityStaType;
        
    }else if ([self.commonModel.msg_type isEqualToString:@"safe"]) {
        
        payVc.title = @"安全统计";
        
        payVc.webUnSeniorPayVcType = JGJWebUnSeniorPayVcSafeStaType;
    }
    
    [self.navigationController pushViewController:payVc animated:YES];
    
}

#pragma mark - 自定义筛选
- (void)customFilterVc {
    
    [self handleFilterQuality:TopFilterViewCusModifyType];
}

@end

