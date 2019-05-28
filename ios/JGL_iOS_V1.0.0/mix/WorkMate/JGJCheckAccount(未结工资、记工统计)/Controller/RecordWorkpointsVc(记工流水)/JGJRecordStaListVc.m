//
//  JGJRecordStaListVc.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListVc.h"

#import "JGJUnWagesShortWorkCell.h"

#import "JGJRecordWorkpointsAllTypeMoneyCell.h"

#import "JGJUnWageAllMoneyCell.h"

#import "JGJCheckAccountHeaderView.h"

#import "JGJRecordWorkpointTypeCountCell.h"

#import "JGJCusActiveSheetView.h"

#import "JGJRecordStaListCell.h"

#import "JGJRecordStaListHeaderView.h"

#import "SMCustomSegment.h"

#import "JGJRecordStaListDetailVc.h"

#import "MJRefresh.h"

#import "CFRefreshStatusView.h"

#import "JLGCustomViewController.h"

#import "NSDate+Extend.h"

#import "JGJCheckStaListCell.h"

#import "JGJCheckStaTimeSectionPopView.h"

#import "JGJAccountShowTypeVc.h"

#import "JGJFilterSideView.h"

#import "JGJRecordStaListVc+filterService.h"

#import "JGJRecordStaListMidVc.h"

#import "JGJRecordTool.h"

#import "JGJRecordStaDownLoadVc.h"

@interface JGJRecordStaListVc () <UITableViewDelegate, UITableViewDataSource, SMCustomSegmentDelegate,UIDocumentInteractionControllerDelegate> {
    
    UIDocumentInteractionController *_documentInteraction;
}

@property (nonatomic, strong) SMCustomSegment *segment;

@property (weak, nonatomic) IBOutlet JGJRecordStaFilterView *filterView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) JGJCheckStaListCellModel *desInfoModel;

@property (nonatomic, strong) JGJContractorTypeChoiceHeaderView *headerView;

@property (nonatomic, strong) JGJCheckStaTimeSectionPopView *popView;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

//第一层请求模型用于第二层点击返回，初始用的值
@property (strong, nonatomic) JGJRecordWorkStaRequestModel *fir_request;

//第一层请求模型用于第三层点击返回，初始用的值
@property (strong, nonatomic) JGJRecordWorkStaRequestModel *sec_request;

//下载文件3.4.1
@property (nonatomic, strong) JGJRecordWorkDownLoadModel *downLoadModel;

@end

@implementation JGJRecordStaListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记工统计";
    
    BOOL is_first_vc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    TYWeakSelf(self);
    
    if (![self checkIsRealName]) {

        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {

            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;

            customVc.customVcCancelButtonBlock = ^(id response) {

                [weakself.navigationController popViewControllerAnimated:YES];
            };

            customVc.customVcBlock = ^(id response) {

                [weakself loadRecordStaNetData];
            };
        }

    }else {
        
        if (is_first_vc) {
         
            [weakself loadRecordStaNetData];
            
        }
        
    }
    
    
    self.filterView.recordStaFilterViewBlock = ^(NSString *stTime, NSString *endTime, BOOL isReset) {
      
        TYLog(@"stTime====%@ endTime===%@ ====== %@", stTime, endTime, @(isReset));
        
        weakself.request.start_time = stTime;
        
        weakself.request.end_time = endTime;
        
        [weakself loadRecordStaNetData];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.filterView.staFilterButtonBlock = ^(JGJRecordStaFilterView *filterView) {
      
        TYLog(@"搜索按钮按钮按下");
        
        //第三层详情页不能点击
        
        if ([weakself isMemberOfClass:NSClassFromString(@"JGJRecordStaListDetailVc")]) {
            
            return ;
        }
        
        [weakself filterButtonPressed];
    };
    
    self.filterView.staTimeBlock = ^(JGJRecordStaFilterView *filterView) {
      
        [weakself checkStaTimeSection];
    };
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    if (!searchTool.staInitialModel) {
        
        JGJRecordStaInitialModel *staInitialModel = [[JGJRecordStaInitialModel alloc] init];
        
        staInitialModel.stTime = weakself.request.start_time;
        
        staInitialModel.endTime = weakself.request.end_time;
        
        staInitialModel.proName = AllProName;
        
        staInitialModel.proId = AllProId;
        
        staInitialModel.memberUid = MemberId;
        
        staInitialModel.memberName = MemberDes;
        
        //全部记账类型
        staInitialModel.account_types = @"";
        
        //全部选择后的记账类型
        staInitialModel.sel_account_types = @"";
        
        staInitialModel.sel_stTime = weakself.request.start_time;
        
        staInitialModel.sel_endTime = weakself.request.end_time;
        
        staInitialModel.sel_proName = AllProName;
        
        staInitialModel.sel_proId = AllProId;
        
        staInitialModel.sel_memberUid = MemberId;
        
        staInitialModel.sel_memberName = MemberDes;
        
        staInitialModel.sel_account_types = @"";
        
        searchTool.staInitialModel = staInitialModel;
    }
    
    if (searchTool.staInitialModel) {
        
        NSMutableString *vcs = @"".mutableCopy;
        
        for (JGJRecordStaListVc *vc in searchTool.staInitialModel.subVcs) {
            
            NSString *cl_name = NSStringFromClass([vc class]);
            
            [vcs appendFormat:@"%@,", [NSString stringWithFormat:@"%@",  cl_name]];
            
        }
        
        NSString *cur_cl_name = NSStringFromClass([self class]);
        
        if (![vcs containsString:cur_cl_name]) {
            
            [searchTool.staInitialModel.subVcs addObject:self];
            
        }
        
    }
    
    //加载班组人员和项目
    [self loadData];
    
    [self setLeftBatButtonItem];
    
    if (is_first_vc) {
        
//        //默认按项目统计
        self.staType = JGJRecordStaProjectType;
        
        if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
            
            self.firStaType = JGJRecordStaProjectType;
            
            self.request.class_type = @"project";
            
            self.headerView.selType = JGJRecordSelLeftBtnType;
            
        }
        
    }
    
    //禁止点击时间
    self.filterView.is_unCan_click = YES;
    
    //其他页面进入隐藏搜索按钮
    self.filterView.is_hidden_searchBtn = self.is_hidden_searchBtn;
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
        
        self.filterViewH.constant = [self.filterView staFilterViewHeight];
        
    }
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    BOOL is_SecVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
    
    if (is_firVc || is_SecVc) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordBillChangeSuccess) name:@"recordBillChangeSuccess" object:nil];
    }
    
}

- (void)recordBillChangeSuccess {
    
    [self freshTableView];
}


- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
        
        searchTool.staInitialModel = nil;
    }
    
    //主要处理第二层锁定问题
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")]) {
        
        JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
        searchTool.staInitialModel.is_lock_proname = NO;
    
        searchTool.staInitialModel.is_lock_name = NO;
        
    }

    [searchTool.staInitialModel.subVcs removeObject:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];;

    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setTintColor:AppFontEB4E4EColor];
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //页面显示的时候在第一层清除之前选择的项目和人
    if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
        
        
        //3.4.1添加，修复在第一层选了项目之后。再选记工分类跳转问题
        self.searchType = JGJRecordStaSearchMainType;
        
        [self setInitialFirRequst];
        
        [self handleSearchTypeRequest];
        
    }
    
    //赋值选择的时间
    
    if (![NSString isEmpty:staInitialModel.sel_stTime]) {
        
        self.filterView.startTimeStr = staInitialModel.sel_stTime;
    }
    
    
    if (![NSString isEmpty:staInitialModel.sel_endTime]) {
        
        self.filterView.endTimeStr = staInitialModel.sel_endTime;
    }
    
    [self subWillViewWillAppear:animated];
}

#pragma mark - 根据搜索类型发起请求

- (void)handleSearchTypeRequest {
    
    if (self.firStaType == JGJRecordStaProjectType) {
        
        self.request.class_type = @"project";
        
        self.headerView.selType = JGJRecordSelLeftBtnType;
        
    }else {
        
        self.request.class_type = @"person";
        
        self.headerView.selType = JGJRecordSelRightBtnType;
        
    }
}

#pragma mark - 子类重写
- (void)subWillViewWillAppear:(BOOL)animated {
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        BOOL is_secVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
        
        count = is_secVc ? 1 : 0;
        
    }else {
        
        count = _recordWorkStaModel.list.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell = [self registerRecordWorkpointsAllTypeMoneyCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
        
    }else {
        
        cell = [self registerRecordStaListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
    return cell;
}

//- (UITableViewCell *)registerRecordWorkpointsAllTypeMoneyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    JGJRecordWorkpointsAllTypeMoneyCell *cell = [JGJRecordWorkpointsAllTypeMoneyCell cellWithTableView:tableView];
//
//    cell.showType = self.selTypeModel.type;
//
//    cell.recordWorkStaModel = self.recordWorkStaDetailModel;
//
//    return cell;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    switch (indexPath.section) {
        case 0:{
            
            BOOL is_secVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
            
            if (indexPath.row == 0 && is_secVc) {
                
                height = [JGJRecordWorkpointsAllTypeMoneyCell cellHeight];
                
            }
            
        }
            
            break;
            
        case 1:{
            
            height = [JGJRecordStaListCell cellHeight];
            
            if (![NSString isEmpty:self.request.accounts_type]) {
                
                NSArray *account_types = [self.request.accounts_type componentsSeparatedByString:@","];
                
                NSInteger account_type = [account_types.firstObject integerValue];
                
                if (account_types.count == 1) {
                    
                    height = 45;
                    
                    if (account_type == 1 || account_type == 5 ) {
                        
                        height = 60;
                        
                    }else if (account_type == 2 && JLGisLeaderBool) {
                        
                        height = 55;
                    }
                    
                }
                
            }
            
            JGJRecordWorkStaListModel *staListModel = self.recordWorkStaModel.list[indexPath.row];
            
            if (staListModel.height > height) {
                
//                height = staListModel.height;
                
//                staListModel.height = height;
                
                height = staListModel.height;
                
            }else {
                
                staListModel.height = height;
            }

        }
            
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 30;
    
    if (self.recordWorkStaModel.list.count == 0 || section == 0) {
        
        height = CGFLOAT_MIN;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [self registerStaWithTableView:tableView viewForFooterInSection:section];
}

- (UIView *)registerStaWithTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *resueId = @"JGJUnWagesShortWorkFooterView";
    
    if (section == 0) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 55)];
        
        headView.backgroundColor = AppFontf1f1f1Color;
        
        [headView addSubview:self.headerView];
        
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(headView).mas_offset(-50);
            
            make.left.mas_equalTo(headView).mas_offset(50);
            
            make.top.mas_equalTo(headView).mas_offset(10);
            
            make.height.mas_equalTo(35);
        }];
        
//        return self.recordWorkStaModel.list.count > 0 ? headView : nil;
        
        return headView;
        
    }else {
        
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
        
        UIView *bottomLineView = [UIView new];
        
        if (!footerView) {
            
            footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:resueId];
            
            bottomLineView.frame = CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5);
            
            bottomLineView.backgroundColor = AppFontdbdbdbColor;
            
            if (self.recordWorkStaModel.list.count > 0) {
                
                [footerView addSubview:bottomLineView];
            }
            
        }
        
        footerView.contentView.backgroundColor = AppFontf1f1f1Color;
        
        footerView.hidden = section != 0;
        
        return footerView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
         return 55.0;
        
    }else {
        
        return self.recordWorkStaModel.list.count == 0 ? CGFLOAT_MIN : 10.0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    JGJRecordStaListHeaderView *headerView = [[JGJRecordStaListHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    if (is_firVc && [self.request.class_type isEqualToString:@"project"]) {
        
        self.staType = JGJRecordStaProjectType;
    }
    
    if (is_firVc) {
        
        headerView.staType = self.firStaType;
        
    }else {
        
        headerView.staType = self.staType;
        
    }
    
    headerView.recordWorkStaModel = self.recordWorkStaModel;
    
    headerView.topLineView.hidden = NO;
    
    return (section == 1 && self.recordWorkStaModel.list.count != 0) ? headerView : nil;
    
}

- (UITableViewCell *)registerRecordWorkpointsAllTypeMoneyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointsAllTypeMoneyCell *cell = [JGJRecordWorkpointsAllTypeMoneyCell cellWithTableView:tableView];
    
    cell.showType = self.selTypeModel.type;
    
    cell.recordWorkStaModel = self.recordWorkStaModel;
    
    return cell;
    
}

- (UITableViewCell *)registerRecordWorkpointTypeCountCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointTypeCountCell *cell = [JGJRecordWorkpointTypeCountCell cellWithTableView:tableView];
    
    cell.showType = self.selTypeModel.type;
    
    cell.recordWorkStaModel = self.recordWorkStaModel;
    
    return cell;
    
}

- (UITableViewCell *)registerUnWageAllMoneyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaListCell *cell = [JGJCheckStaListCell cellWithTableView:tableView];
    
    cell.desInfoModel = self.desInfoModel;
    
    return cell;
    
}

- (UITableViewCell *)registerRecordStaListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListCell *cell = [JGJRecordStaListCell cellWithTableView:tableView];
    
//    cell.showType = self.showType;
    
    //根据搜索的类型修改样式
    cell.accounts_type = self.request.accounts_type;
    
    cell.showType = self.selTypeModel.type;
    
    cell.maxTrail = self.maxTrail;
    
    JGJRecordWorkStaListModel *staListModel = self.recordWorkStaModel.list[indexPath.row];
    
    //是否改变顶部距离，主要是项目名字比较多的时候用
    
    [self changeWorkTopConstantWithstaListModel:staListModel];
    
    staListModel.class_type = self.recordWorkStaModel.class_type;
    
    cell.des = [self registerNameShowTypeWithStaListModel:staListModel];
    
    cell.staListModel = staListModel;
    
//    cell.lineView.hidden = (self.recordWorkStaModel.list.count - 1 == indexPath.row);
    
    cell.lineView.hidden = NO;
    
    cell.isScreenShowLine = self.recordWorkStaModel.list.count - 1 == indexPath.row;
    
    return cell;
    
}

- (void)changeWorkTopConstantWithstaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    CGFloat height = [JGJRecordStaListCell cellHeight];
    
    NSString *type = self.request.accounts_type;
    
    if (![NSString isEmpty:type]) {
        
        NSArray *account_types = [type componentsSeparatedByString:@","];
        
        NSInteger account_type = [account_types.firstObject integerValue];
        
        if (account_types.count == 1) {
            
            height = 45;
            
            if (account_type == 1 || account_type == 5) {
                
                height = 60;
            }
            
        }
        
    }
    
    if (staListModel.height > height) {
        
        staListModel.is_change_workTop = YES;
        
    }else {
        
        staListModel.height = height;
    }
    
}

//子类重写使用
- (NSString *)registerNameShowTypeWithStaListModel:(JGJRecordWorkStaListModel *)staListModel{

    NSString *des = staListModel.name;
    
    return des;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    //其他页面进入第一层数据，清除class_type_target_id,class_type_id
    if (is_firVc) {
        
        self.request.class_type_target_id = nil;
        
        self.request.class_type_id = nil;
    }
    
    [self registerSubClassWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

- (void)registerSubClassWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //工人按项目
    
    BOOL is_first_vc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    if ((JLGisMateBool && [self.request.class_type isEqualToString:@"project"])) {
        
        [self registerStaDetailWithTableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }else if(((self.staType == JGJRecordStaProjectType || self.staType == JGJRecordStaNormalWorkerType) && JLGisLeaderBool) || (self.staType == JGJRecordStaWorkLeaderType && JLGisMateBool)) {
        
        [self registerStaWithTableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }else if(((self.firStaType == JGJRecordStaProjectType || self.firStaType == JGJRecordStaNormalWorkerType) && JLGisLeaderBool) || (self.firStaType == JGJRecordStaWorkLeaderType && JLGisMateBool)) {
        
        [self registerStaWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

- (void)registerStaWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListMidVc *staListMidVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListMidVc"];
    
    //这里有个问题date被改成uid了
    JGJRecordWorkStaListModel *staListModel = self.recordWorkStaModel.list[indexPath.row];
    
    //target_name是空的第一层，后台兼容了安卓。安卓一层取的是target_name
    staListModel.target_name = nil;
    
    staListMidVc.staListModel = staListModel;
    
    //第一步考虑班组长情况
    if (JLGisLeaderBool && [self.request.class_type isEqualToString:@"project"]) {
        
        if ([self.request.class_type isEqualToString:@"project"]) {
            
            self.staType = JGJRecordStaNormalWorkerType;
            
        }else {
            
            self.staType = JGJRecordStaMonthType;
        }
        
    }else if (!JLGisLeaderBool && [self.request.class_type isEqualToString:@"person"]) { //工人角色，按班组长查看进入是月统计
        
        staListMidVc.staType = JGJRecordStaMonthType;
    }
    
    //搜索显示统一用单例处理，避免多层传值
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    if ([self.request.class_type isEqualToString:@"project"]) {
        
        staInitialModel.sel_proId = staListModel.class_type_id;
        
        staInitialModel.sel_proName = staListModel.name;
        
    }else if (JLGisLeaderBool && [self.request.class_type isEqualToString:@"person"]) {
        
        staInitialModel.sel_memberUid = staListModel.class_type_id;
        
        staInitialModel.sel_memberName = staListModel.name;
        
    }else if (!JLGisLeaderBool && [self.request.class_type isEqualToString:@"person"]) {
        
        staInitialModel.sel_memberUid = staListModel.class_type_id;
        
        staInitialModel.sel_memberName = staListModel.name;
    }
    
    [self.navigationController pushViewController:staListMidVc animated:YES];
}

- (void)registerStaDetailWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListDetailVc *detailVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListDetailVc"];
    
    //是否能够进入流水
    detailVc.isForbidSkipWorkpoints = self.isForbidSkipWorkpoints;
    
    detailVc.proListModel = self.proListModel;
    
    JGJRecordWorkStaListModel *staListModel = self.recordWorkStaModel.list[indexPath.row];
    
    if ([self isMemberOfClass:[JGJRecordStaListMidVc class]]) {
        
        JGJRecordStaListMidVc *midStaVc = (JGJRecordStaListMidVc *)self;
        
        staListModel.is_sync = midStaVc.staListModel.is_sync;
        
        detailVc.isForbidSkipWorkpoints = midStaVc.staListModel.isForbidSkipWorkpoints;
        
        staListModel.isForbidSkipWorkpoints = midStaVc.staListModel.isForbidSkipWorkpoints;
    }
    
    if (JLGisLeaderBool) {
        
        staListModel.nameDes = staListModel.name;
        
        if ([self.request.class_type isEqualToString:@"person"]) {
            
            staListModel.nameDes = [NSString stringWithFormat:@"工人 %@ 的记工", staListModel.name];
        }
    }else {
        
        staListModel.nameDes = [NSString stringWithFormat:@"我在 %@ 的记工", staListModel.name];
        
        if ([self.request.class_type isEqualToString:@"person"]) {
            
            staListModel.nameDes = [NSString stringWithFormat:@"我在班组长 %@ 处的记工", staListModel.name];
        }
    }
    
    BOOL is_secVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
    
    if (is_secVc) {
        
        self.request.class_type_target_id = staListModel.class_type_target_id;
    }
    
    detailVc.oriDesInfos = self.oriDesInfos;
    
    detailVc.staListModel = staListModel;
    
    self.request.is_day = nil;//默认月统计
    
    detailVc.request = self.request;
    
    detailVc.request.class_type_id = staListModel.class_type_id;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)setInitialFirRequst {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //复制选择的数据
    
    staInitialModel.sel_stTime = self.fir_request.start_time;
    
    staInitialModel.sel_endTime = self.fir_request.end_time;
    
    staInitialModel.sel_proName = AllProName;
    
    staInitialModel.sel_proId = AllProId;
    
    staInitialModel.sel_memberUid = MemberId;
    
    staInitialModel.sel_memberName = MemberDes;
    
    //记账类型
    staInitialModel.sel_account_types = self.fir_request.accounts_type;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    //  显示方式
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel,@"下载", @"取消"];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
                        
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
            
        }else if (buttonIndex == 1) {
            
            if (_recordWorkStaModel.list.count > 0) {
                
//                JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordTool downFileExistWithRecordDownLoadModel:self.downLoadModel request:self.request];
                
//                if (downLoadModel.isExistDifFile) {
//
//                    [weakSelf shareFormWithFileUrl:downLoadModel.allFilePath];
//
//                }else {
//
//                    [weakSelf loadDownLoadFile];
//                }
                
                [weakSelf loadDownLoadFile];
                
            }else {
                
                [TYShowMessage showPlaint:@"没有可下载的数据"];
            }
            
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    [sheetView showView];
}

#pragma mark - SMCustomSegmentDelegate
- (void)customSegmentSelectIndex:(NSInteger)selectIndex {
    
    [self filterSelIndex:selectIndex];
}

- (void)filterSelIndex:(NSInteger)selIndex {
    
    self.request.class_type = selIndex == 0 ? @"project" : @"person";
    
    self.staType = selIndex == 0 ? JGJRecordStaProjectType : (JLGisLeaderBool ?JGJRecordStaNormalWorkerType : JGJRecordStaWorkLeaderType);
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
        
       self.firStaType = selIndex == 0 ? JGJRecordStaProjectType : (JLGisLeaderBool ?JGJRecordStaNormalWorkerType : JGJRecordStaWorkLeaderType);
        
    }
    
    [self freshTableView];
}

//刷新网络数据
-(void)freshTableView {
    
    [self loadRecordStaNetData];
}

#pragma mark - 加载记工统计
- (void)loadRecordStaNetData {
    
    NSDictionary *parameters = [self requestParameter];
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        JGJRecordWorkStaModel *recordWorkStaModel = [JGJRecordWorkStaModel mj_objectWithKeyValues:responseObject];
        
        self.recordWorkStaModel = recordWorkStaModel;
        
//        //顶部统计
//        [recordWorkStaModel handleTopContractorSta];
        
        //顶部筛选高度调整
        
        TYWeakSelf(self);
        
        [self.filterView setFilterRecordWorkStaModel:recordWorkStaModel staFilterAccountypesBlock:^(JGJRecordWorkStaModel *recordWorkStaModel, CGFloat height) {
            
            weakself.filterViewH.constant = height;
            
        }];
        
//        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
       
//        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

//子类重写参数
- (NSDictionary *)requestParameter {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    if (is_firVc) {
        
        JGJRecordWorkStaRequestModel *initialRequest = [JGJRecordWorkStaRequestModel mj_objectWithKeyValues:[self.request mj_keyValues]];
        
        self.fir_request = initialRequest;
        
    }
    
    return parameters;
}

//子类重写参数
- (NSString *)requestApi {
    
    return @"workday/get-work-record-statistics";
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    [self showDefaultNodataArray:_recordWorkStaModel.list];

    self.maxTrail = [JGJRecordStaListCell maxWidthWithStaList:_recordWorkStaModel.list];
    
    [self.tableView reloadData];
    
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"未搜索到相关内容"];
        
        statusView.frame = self.view.bounds;
        
        self.tableView.tableFooterView = statusView;
        
        self.tableView.scrollEnabled = NO;
        
    }else {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
        
        self.tableView.scrollEnabled = YES;
    }
    
}



- (void)initialSubView {
    
    CGRect rect = CGRectMake(0, 0, 155, 30);
    
    NSArray *titles = @[@"按班组长" ,@"按项目"];
    
    if (JLGisLeaderBool) {
        
        titles = @[@"按项目" ,@"按工人"];
    }
    
    SMCustomSegment *segment = [[SMCustomSegment alloc] initWithFrame:rect titleArray:titles];
    
    [segment.layer setLayerCornerRadius:3];
    
    self.segment = segment;
    
    self.segment.selectIndex = 0;
    
    self.segment.delegate = self;
    
    self.segment.normalBackgroundColor = [UIColor whiteColor];
    
    self.segment.selectBackgroundColor = AppFontEB4E4EColor;
    
    self.segment.titleNormalColor = AppFontEB4E4EColor;
    
    self.segment.titleSelectColor = [UIColor whiteColor];
    
    self.segment.normalTitleFont = AppFont30Size;
    
    self.segment.selectTitleFont = AppFont30Size;
    
    self.navigationItem.titleView = self.segment;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;

//    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordStaNetData)];
    
}

#pragma makr - 查看时间段统计
- (void)checkStaTimeSection {
    
    _popView = [[JGJCheckStaTimeSectionPopView alloc] initWithFrame:TYKey_Window.bounds];
    
    self.recordWorkStaModel.startTime = self.filterView.startTimeStr;
    
    self.recordWorkStaModel.lunarStTime = self.filterView.lunarStTime;
    
    self.recordWorkStaModel.endTime =  self.filterView.endTimeStr;
    
    self.recordWorkStaModel.lunarEnTime = self.filterView.lunarEnTime;
    
    _popView.recordWorkStaModel = self.recordWorkStaModel;
}

- (JGJRecordWorkStaRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJRecordWorkStaRequestModel new];
        
//        _request.uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        self.request.class_type = @"project";
        
        //农历正月初一2018-01-01
        
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
        
        if (![NSString isEmpty:self.stTime]) {
            
            NSDate *selDate = [NSDate dateFromString:self.stTime withDateFormat:@"yyyy-MM"];
            
            start_time = [NSString stringWithFormat:@"%@-%@-%@", @(selDate.components.year), @(selDate.components.month), @"01"];
            
            NSDate *start_Date = [NSDate dateFromString:start_time withDateFormat:format];
            
            start_time = [NSDate stringFromDate:start_Date format:format];
            
            
            NSDate *stDate = [NSDate dateFromString:start_time withDateFormat:format];
            
            start_time = [NSDate stringFromDate:stDate format:format];
            
            NSInteger monthLength = [NSDate numberOfDatesInMonthOfDate:stDate];
            
            
            end_time = [NSString stringWithFormat:@"%@-%@",self.stTime, @(monthLength)];
            
            
            NSDate *end_date = [NSDate dateFromString:end_time withDateFormat:format];
            
            end_time = [NSDate stringFromDate:end_date format:format];
            
        }
        
        self.request.start_time = start_time;
        
        self.filterView.startTimeStr = self.request.start_time;
        
        self.request.end_time = end_time;
        
        self.filterView.endTimeStr = self.request.end_time;
        
        self.request.group_id = self.proListModel.group_id;
        
        self.request.agency_uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
        
        //统计用统一的时间
        if (![NSString isEmpty:searchTool.staInitialModel.sel_stTime]) {
            
            self.request.start_time = searchTool.staInitialModel.sel_stTime;
        }
        
        if (![NSString isEmpty:searchTool.staInitialModel.sel_endTime]) {
            
            self.request.end_time = searchTool.staInitialModel.sel_endTime;
        }
        
    }
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    _request.accounts_type = searchTool.staInitialModel.sel_account_types?:@"";
    
    if (![NSString isEmpty:searchTool.staInitialModel.sel_stTime]) {
        
        _request.start_time = searchTool.staInitialModel.sel_stTime;
        
    }
    
    if (![NSString isEmpty:searchTool.staInitialModel.sel_endTime]) {
        
        _request.end_time = searchTool.staInitialModel.sel_endTime;
    }
    
    return _request;
}

- (JGJCheckStaListCellModel *)desInfoModel {
    
    if (!_desInfoModel) {
        
        _desInfoModel = [[JGJCheckStaListCellModel alloc] init];
        
        _desInfoModel.title = @"查看该时间段总的统计";
        
        _desInfoModel.topLineHeight = 10;
        
        _desInfoModel.bottomLineHeight = 0.5;
        
        _desInfoModel.nextImageStr = @"check_red_right_icon";
        
        _desInfoModel.bottomLineColor = AppFontdbdbdbColor;
    }
    
    return _desInfoModel;
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

- (JGJContractorTypeChoiceHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[JGJContractorTypeChoiceHeaderView alloc] init];
        
        _headerView.cornerRad = 5;
        
//        [_headerView changeleftBtnWithNormalImage:@"leftwhiteNormal" leftSelectedImage:@"leftRedSelected" rightNormalImage:@"rightwhiteNormal" rightSelectedImage:@"rightRedSelected"];
        
        [self selBtnImage];
        
        TYWeakSelf(self);
        
        _headerView.contractorHeaderBlcok = ^(NSInteger index) {
          
            [weakself filterSelIndex:index];
        };
        
    }
    
    _headerView.btTileArr = [self titles];
    
    return _headerView;
}

- (void)selBtnImage {
    
     [_headerView changeleftBtnWithNormalImage:@"leftwhiteNormal" leftSelectedImage:@"leftRedSelected" rightNormalImage:@"rightwhiteNormal" rightSelectedImage:@"rightRedSelected"];
}

#pragma mark - 子类重写标题
- (NSArray *)titles {
    
    NSArray *titles = @[@"按项目查看",@"按姓名查看"];
    
    if (JLGisLeaderBool) {
        
//        titles = @[@"按项目查看" ,@"按工人查看"];
        
        titles = @[@"按项目查看" ,@"按姓名查看"];
    }
    
    return titles;
}

- (void)filterButtonPressed {
    
    [self handleFilterAction];
        
}

- (NSMutableArray *)oriDesInfos {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    NSString *role = JLGisLeaderBool ? @"选择工人" : @"选班组长";
    
    NSString *lineDes = @"(可多选)";
    
    NSString *recordType = [NSString stringWithFormat:@"记工分类\n%@", lineDes];
    
    NSArray *titles = @[@[@"开始时间", @"结束时间"],@[@"选择项目"], @[role],@[recordType, @""]];
    
    NSString *st_time = [NSString stringWithFormat:@"%@",staInitialModel.sel_stTime?:@""];
    
    NSString *en_time = [NSString stringWithFormat:@"%@",staInitialModel.sel_endTime?:@""];
    
    NSString *proname = AllProName;
    
    if (![NSString isEmpty:staInitialModel.sel_proName]) {
        
        proname = staInitialModel.sel_proName;
    }
    
    NSString *proid = staInitialModel.sel_proId?:@"0";
    
     NSString *name = MemberDes;
    
    if (![NSString isEmpty:staInitialModel.sel_memberName]) {
        
        name = staInitialModel.sel_memberName;
    }
    
    NSString *uid = staInitialModel.sel_memberUid?:@"";
    
    NSString *accounts_type = @"";
    
    if (![NSString isEmpty:staInitialModel.sel_account_types]) {
        
        accounts_type = staInitialModel.sel_account_types;
    }
    
    NSArray *des = @[@[st_time, en_time],@[proname], @[name],@[@"", @""]];
    
    NSArray *tyIds = @[@[st_time, en_time],@[proid], @[uid],@[@"", accounts_type]];
    
    if (!_oriDesInfos) {
        
        _oriDesInfos = [NSMutableArray array];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            NSArray *subTitles = titles[index];
            
            NSArray *subDes = des[index];
            
            NSArray *subTyIds = tyIds[index];
            
            NSMutableArray *subArr = [NSMutableArray array];
            
            for (NSInteger subIndex = 0; subIndex < subTitles.count; subIndex++) {
                
                JGJComTitleDesInfoModel *desInfoModel = [[JGJComTitleDesInfoModel alloc] init];
                
                desInfoModel.title = subTitles[subIndex];
                
                desInfoModel.des = subDes[subIndex];
                
                desInfoModel.typeId = subTyIds[subIndex];
                
                desInfoModel = [self setDesInfo:desInfoModel index:index];
                
                desInfoModel.lineDes = index == 3 ? lineDes : @"";
                
                desInfoModel.desColor = AppFontEB4E4EColor;
                
                if (index == 3) {
                    
                    desInfoModel.desTrail = 10;
                }
                
                [subArr addObject:desInfoModel];
            }
            
            [_oriDesInfos addObject:subArr];
        }
        
    }else {
        
        //记账类型
        staInitialModel.account_types = accounts_type;
        
        //原数据
        NSArray *oriInfos = _oriDesInfos;
        
        NSArray *oritimes = oriInfos[0];
        
        NSArray *oriproModels = oriInfos[1];
        
        NSArray *orimemberModels = oriInfos[2];
        
        NSArray *oriAccounts_types = oriInfos[3];
        
        JGJComTitleDesInfoModel *ori_st_time = oritimes[0];
        
        if (![NSString isEmpty:st_time]) {
            
           ori_st_time.des = st_time;
        }
        
        JGJComTitleDesInfoModel *ori_en_time = oritimes[1];
        
        if (![NSString isEmpty:en_time]) {
            
            ori_en_time.des = en_time;
        }

        JGJComTitleDesInfoModel *ori_proModel = oriproModels[0];
        
        JGJComTitleDesInfoModel *ori_memberModel = orimemberModels[0];
        
        JGJComTitleDesInfoModel *ori_accounttypeModel = oriAccounts_types[1];
        
        ori_accounttypeModel.typeId = accounts_type;
        
    }
    
    return _oriDesInfos;
}

- (JGJComTitleDesInfoModel *)setDesInfo:(JGJComTitleDesInfoModel *)desInfoModel index:(NSInteger)index {
    
    desInfoModel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    desInfoModel.desColor = AppFontEB4E4EColor;
    
    if (index == 3) {
        
        CGFloat top = index == 3 ? 12 : 22;
        
        desInfoModel.textInsets = UIEdgeInsetsMake(top, 0, 0, 0);
        
        desInfoModel.isHiddenBottomLine = YES;
        
        desInfoModel.isHiddenArrow = YES;
    }
    
    return desInfoModel;
}

#pragma mark - 筛选条件改变颜色
- (void)setFilterButtonStatus:(BOOL)isNormal {
    
    UIColor *color = !isNormal ? AppFont333333Color :AppFontEB4E4EColor;
    
    [self.filterView.filterButton setImage:[UIImage imageNamed:!isNormal ? @"un_filter_icon" : @"filtered_icon" ] forState:UIControlStateNormal];
    
    [self.filterView.filterButton setTitleColor:color forState:UIControlStateNormal];
    
    [self.filterView.filterButton.layer setLayerBorderWithColor:color width:1 radius:3];
    
}

#pragma mark - 下载文件
- (void)loadDownLoadFile {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    if ([self.request.class_type isEqualToString:@"person"]) {
        
        self.downLoadModel.uid = self.request.class_type_id;
        
        self.downLoadModel.pid = self.request.class_type_target_id;
    }
    
    if ([self.request.class_type isEqualToString:@"project"]) {
        
        self.downLoadModel.uid = self.request.class_type_target_id;
        
        self.downLoadModel.pid = self.request.class_type_id;
        
    }

    NSMutableDictionary *muParameters = [NSMutableDictionary dictionary];
    
    [muParameters addEntriesFromDictionary:parameters];
    
    [muParameters setObject:@"1" forKey:@"is_down"];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:muParameters success:^(id responseObject) {
        
        JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordWorkDownLoadModel mj_objectWithKeyValues:responseObject];
        
        self.downLoadModel = downLoadModel;
        
        [self downRecordForm]; //下载
        
         [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 下载账单表格
- (void)downRecordForm {
    
    //方式一：进入页面打开
    
    JGJRecordStaDownLoadVc *downLoadVc = [[JGJRecordStaDownLoadVc alloc] init];
    
//    self.downLoadModel.file_path = @"http://test.cdn.jgjapp.com/download/knowledges/20180715/17_1028204947.docx";
//    
//    self.downLoadModel.file_type = @"docx";
//    
//    self.downLoadModel.file_name = @"tuum啊五+20190220131651.xls";
    
    downLoadVc.downLoadModel = self.downLoadModel;
    
    [self.navigationController pushViewController:downLoadVc animated:YES];
    
//    return;
    
//    //方式二：直接分享
//    
//    JGJRecordTool *tool = [[JGJRecordTool alloc] init];
//    
//    JGJRecordToolModel *toolModel = [JGJRecordToolModel new];
//    
//    //    //测试数据开始---
//    //    toolModel.url = @"http://test.cdn.jgjapp.com//download//knowledges//20170910//14_1332129075.xlsx";
//    //
//    //    toolModel.type = @"xlsx";
//    //
//    //    toolModel.name = @"1.分项工程质量检验评定汇总表(一)—【吉工宝APP】";
//    //    //测试数据结束---
//    
//    toolModel.url = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, self.downLoadModel.file_path];
//    
//    toolModel.type = self.downLoadModel.file_type?:@"";
//    
//    toolModel.name = self.downLoadModel.file_name?:@"";
//    
//    toolModel.curVc = self;
//    
//    tool.toolModel = toolModel;
//    
//    TYWeakSelf(self);
//    
//    tool.recordToolBlock = ^(BOOL isSucess, NSURL *localFilePath) {
//        
//        [TYLoadingHub hideLoadingView];
//        
//        [weakself shareFormWithFileUrl:localFilePath];
//        
//    };
    
}

- (void)shareFormWithFileUrl:(NSURL *)fileUrl {
    
    _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
    
    _documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
    
    [_documentInteraction presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    _documentInteraction = nil;
}

@end
