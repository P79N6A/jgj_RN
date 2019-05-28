//
//  JGJQuaSafeCheckVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckVc.h"

#import "JGJQuaSafeCheckCell.h"

#import "JGJQualitySafeModel.h"

#import "JGJQualityTopFilterView.h"

#import "CFRefreshStatusView.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

#import "MJRefresh.h"

#import "JGJQualitySafeCheckFiliterVc.h"

#import "JGJPubQuaSafeCheckVc.h"

#import "JGJQuaSafeCheckPlanVc.h"

#import "JGJQuaSafeOrderDefaultView.h"

#import "JGJSureOrderListViewController.h"

#import "JGJWebAllSubViewController.h"

#import "JGJGroupMangerTool.h"

#define PageSize 20

@interface JGJQuaSafeCheckVc () <

    JGJQualitySafeCheckFiliterVcDelegate

>

@property (nonatomic, strong) NSMutableArray *qualityList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *releaseQualityButton;

@property (weak, nonatomic) IBOutlet JGJQualityTopFilterView *topFilterView;

//上次选中的类型
@property (nonatomic, assign) TopFilterViewType lastFilterType;

@property (nonatomic, strong) JGJQuaSafeCheckModel *qualitySafeModel;

//显示自定义筛选View
@property (strong, nonatomic) UIView *contentTopView;

//顶部筛选数据
@property (strong, nonatomic) UILabel *contentLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFilterViewH;

@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;

//保存重置前的状态
@property (nonatomic, strong) JGJQualitySafeListRequestModel *lastRequestModel;

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *orderDefaultView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@end

@implementation JGJQuaSafeCheckVc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    
    if (self.workProListModel.isClosedTeamVc) {
        
        self.bottomView.hidden = YES;
        
        self.bottomViewH.constant = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)dataInit{

    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.releaseQualityButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadUpData)];
    
    __weak typeof(self) weakSelf = self;
    
    self.topFilterView.topFilterViewCusCheckType = TopFilterViewCheckType;
    
    self.topFilterView.topFilterViewBlock = ^(TopFilterViewType type) {
        
        if (type != TopFilterViewCusModifyType) {
            
            weakSelf.lastFilterType = type;
            
        }
        
        [weakSelf.qualityList removeAllObjects];
        
        [weakSelf handleFilterQuality:type];
    };
    
    self.topFilterView.lastFilterType = weakSelf.lastFilterType;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self contentTopView];

    if ([self.proListModel.is_senior isEqualToString:@"0"]) {
        
        [self.view addSubview:self.orderDefaultView];
        
    }else {
    
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (self.proListModel.isClosedTeamVc) {
        
        UIImageView *clocedImageView = [[UIImageView alloc] init];
        clocedImageView.image = [UIImage imageNamed:@"Chat_closedGroup"];
        [self.view addSubview:clocedImageView];
        
        [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-30);
            make.width.mas_equalTo(126);
            make.height.mas_equalTo(71);
        }];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.qualityList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQuaSafeCheckCell *cell = [JGJQuaSafeCheckCell cellWithTableView:tableView];
    
    if (self.qualityList.count > 0) {
        
        cell.listModel = self.qualityList[indexPath.row];
        
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.qualityList.count == 0) {
        
        return;
    }
    
    
    JGJQuaSafeCheckPlanVc *planVc = [[UIStoryboard storyboardWithName:@"JGJQuaSafeCheck" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJQuaSafeCheckPlanVc"];    
    
    planVc.proListModel = self.proListModel;
    
    planVc.commonModel = self.commonModel;
    
    JGJQuaSafeCheckListModel *listModel = self.qualityList[indexPath.row];
    
    planVc.listModel = listModel;
    
    [self.navigationController pushViewController:planVc animated:YES];
    
}

- (void)chatListLoadData{
    
    if (self.proListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_header = nil;
    }else{
        
        self.requestModel.msg_type = self.commonModel.msg_type;
        
        self.requestModel.class_type = self.proListModel.class_type;
        
        self.requestModel.group_id = self.proListModel.group_id;
        
        self.requestModel.pg = 1;
        
        NSDictionary *parameters = [self.requestModel mj_keyValues];
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getPubInspectList" parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            self.qualitySafeModel = [JGJQuaSafeCheckModel mj_objectWithKeyValues:responseObject];
            
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
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
            [TYLoadingHub hideLoadingView];
        }];
        
    }
    
}

- (void)chatListLoadUpData{
    
    if (self.proListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_header = nil;
    }else{
        
        NSDictionary *parameters = [self.requestModel mj_keyValues];
        
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getPubInspectList" parameters:parameters success:^(id responseObject) {
            
            self.qualitySafeModel = [JGJQuaSafeCheckModel mj_objectWithKeyValues:responseObject];
            
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
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }else {
        
        self.tableView.tableHeaderView = nil;
    }
}

- (void)setQualitySafeModel:(JGJQuaSafeCheckModel *)qualitySafeModel {
    
    _qualitySafeModel = qualitySafeModel;
    
    self.topFilterView.quaSafeCheckModel = _qualitySafeModel;
    
    if (![_qualitySafeModel.allnum isEqualToString:@"0"] && ![NSString isEmpty:_qualitySafeModel.allnum]) {
        
        self.contentLable.text = [NSString stringWithFormat:@"共筛选出 %@ 条记录",_qualitySafeModel.allnum?:@""];
        
        [self.contentLable markText:_qualitySafeModel.allnum withColor:AppFontd7252cColor];
    }
    
    if (self.handleTopViewFlagBlock) {
        
        self.handleTopViewFlagBlock(_qualitySafeModel);
    }
}

#pragma mark - 筛选类型
- (void)handleFilterQuality:(TopFilterViewType) type {
    
    self.requestModel.is_special = @"0";
    
    //1：待检查，3：完成
    
    switch (type) {
            
            //全部不传uid
        case 0:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = nil;
        }
            
            break;
        
        //待检查
        case 1:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = @"1";
        }
            
            
            break;
        //已完成
        case 2:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = @"3";
        }
            break;
            
            //我提交的传uid
        case 3:{
            
            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
            
            self.requestModel.uid = uid;
            
            self.requestModel.status = nil;
        }
            
            break;
            
       //待我检查
        case 4:{
            
            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
            
            self.requestModel.uid = uid;
            
            self.requestModel.status = @"1";
            
        }
            break;
//空白暂没使用
//        case 5:{
//            
//            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
//            
//            self.requestModel.uid = uid;
//            
//            self.requestModel.status = @"1";
//            
//        }
//            break;
      
        //自定义筛选
        case 6:{
            
            JGJQualitySafeCheckFiliterVc *qualityFilterVc = [JGJQualitySafeCheckFiliterVc new];
            
            qualityFilterVc.delegate = self;
            
            qualityFilterVc.requestModel = self.requestModel;
            
            qualityFilterVc.proListModel = self.proListModel;
            
            [self.navigationController pushViewController:qualityFilterVc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    if (type != TopFilterViewCusModifyType) {
        
        [self.qualityList removeAllObjects];
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    self.lastRequestModel.class_type = self.requestModel.class_type;
    
    self.lastRequestModel.group_id = self.requestModel.group_id;
    
    self.lastRequestModel.is_special = @"0";
    
    self.lastRequestModel.uid = self.requestModel.uid;
    
    self.lastRequestModel.status = self.requestModel.status;
    
    self.lastRequestModel.msg_type = self.requestModel.msg_type;
    
    self.lastRequestModel.pagesize = PageSize;
    
    self.lastRequestModel.pg = 1;
}

#pragma mark - JGJQualityFilterVcDelegate

- (void)qualityFilterVc:(JGJQualitySafeCheckFiliterVc *)filterVc {
    
    [self.qualityList removeAllObjects];
    
    self.requestModel.is_special = @"1";
    
    self.topFilterView.hidden = YES;
    
    self.contentTopView.hidden = NO;
    
    self.topFilterViewH.constant = TYGetViewH(self.contentTopView);
    
    self.requestModel = filterVc.requestModel;
    
    self.contentLable.text = @"共筛选出";
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (IBAction)releaseQualityButtonClicked:(UIButton *)sender {
    
    if (self.proListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.proListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    JGJPubQuaSafeCheckVc *pubQuaSafeCheckVc = [JGJPubQuaSafeCheckVc new];
    
    pubQuaSafeCheckVc.proListModel = self.proListModel;
    
    pubQuaSafeCheckVc.commonModel = self.commonModel;
    
    [self.navigationController pushViewController:pubQuaSafeCheckVc animated:YES];
//
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
        
        [self.contentTopView addGestureRecognizer:tap];
        
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
    
    self.topFilterView.hidden = NO;
    
    self.contentTopView.hidden = YES;
    
    self.topFilterViewH.constant = 103;
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    self.requestModel = self.lastRequestModel;
    
    if (self.lastFilterType == TopFilterViewReviewType || self.lastFilterType == TopFilterViewMyReviewType) {
        
        self.requestModel.status = @"2"
        ;
        self.requestModel.uid = nil;
    }else if (self.lastFilterType == TopFilterViewWaitModifyType || self.lastFilterType == TopFilterViewMyModifyType) {
        
        self.requestModel.status = @"1";
        
        self.requestModel.uid = uid;
        
    }else if(self.lastFilterType == TopFilterViewAllType) {
        
        self.requestModel.status = nil;
        
        self.requestModel.uid = nil;
    }else if(self.lastFilterType == TopFilterViewMyCommitType) {
        
        self.requestModel.status = nil;
        
        self.requestModel.uid = uid;
    }
    
    self.requestModel.is_special = @"0";
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (JGJQuaSafeOrderDefaultView *)orderDefaultView {

    if (!_orderDefaultView) {
        
        _orderDefaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"点击了解该功能";
        
        infoModel.desInfo = @"如需使用该功能，请点击申请，\n我们的客服将尽快与你联系";
        
        infoModel.actionButtonTitle = @"申请";
        
        infoModel.desInfoFontColor = AppFont999999Color;
        
        _orderDefaultView.infoModel = infoModel;
        
        //获取当前项目有没有购买过
        _orderDefaultView.workProListModel = self.proListModel;
        
        __weak typeof(self) weakSelf = self;
        _orderDefaultView.handleQuaSafeOrderDefaultViewBlock = ^(JGJQuaSafeOrderDefaultViewButtonType buttonType, JGJQuaSafeOrderDefaultView *defaultView) {
            
            [weakSelf handleDefaultAction:buttonType];
        };
    }

    return _orderDefaultView;
}

#pragma mark - 处理缺省页事件订购
- (void)handleDefaultAction:(JGJQuaSafeOrderDefaultViewButtonType)buttonType {
    
    switch (buttonType) {
            
        case QuaSafeOrderDefaultViewDesButtonType:{
            
            NSString *classtypeId = [self.commonModel.msg_type isEqualToString:@"quality"] ? @"99": @"100";
            
            NSString *tipStr = [NSString stringWithFormat:@"%@help/hpDetail?id=%@",JGJWebDiscoverURL, classtypeId];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:tipStr];
            
            [self.navigationController pushViewController:webVc animated:YES];
        }
            
            break;
         
        case QuaSafeOrderDefaultViewActionButtonType:{
            
            [self handleOrderVcWithBuyGoodType:VIPServiceType];
        }
            
            break;
            
        case QuaSafeOrderDefaultViewTryUseActionButtonType:{
            
            if (self.orderDefaultView) {
                
                [self.orderDefaultView removeFromSuperview];
            }
            
            [self.tableView.mj_header beginRefreshing];
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 进入购买页面
- (void)handleOrderVcWithBuyGoodType:(BuyGoodType)buyGoodType {
    
    JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];
    
    request.group_id = self.proListModel.group_id;
    
    request.class_type = self.proListModel.class_type;
    
    request.server_type = @"1";
    
    [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {
        
        
    }];
    
//    JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
//    
//    SureOrderListVC.GoodsType = buyGoodType;
//    
//    JGJOrderListModel *orderListModel = [JGJOrderListModel new];
//    
//    orderListModel.group_id = self.proListModel.group_id;
//    orderListModel.upgrade = YES;
//    orderListModel.class_type = self.proListModel.class_type;
//    
//    orderListModel.goodsType = VipListType;
//    
//    SureOrderListVC.orderListModel = orderListModel;
//    
//    [self.navigationController pushViewController:SureOrderListVC animated:YES];
    
}

@end
