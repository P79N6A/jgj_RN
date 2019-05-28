//
//  JGJQuaSafeCheckListVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckListVc.h"

#import "JGJCheckListCell.h"

#import "JGJQuaSafeCheckPlanDetailVc.h"

#import "MJRefresh.h"

#import "CFRefreshStatusView.h"

#import "JGJNoDataDefultView.h"

#import "JGJHelpCenterTitleView.h"

#import "FDAlertView.h"

#import "JGJCheckPlanViewController.h"

#import "JGJNewCreteCheckItemViewController.h"
@interface JGJQuaSafeCheckListVc () <UITableViewDataSource, UITableViewDelegate, FDAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJQuaSafeInspectListRequset *inspectListRequset;

@property (nonatomic, strong) NSMutableArray *inspectList;//检查计划列表

@property (strong ,nonatomic)JGJNodataDefultModel *defultDataModel;//显示默认页显示模型

@property (strong, nonatomic) JGJCheckItemMainListModel *listModel;
@end

@implementation JGJQuaSafeCheckListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInspectNetData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInspectNetData)];
    
    [self setBackButton];
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    
    for (UIViewController *quaSafeHomeVc in self.navigationController.viewControllers) {
        
        if ([quaSafeHomeVc isKindOfClass:NSClassFromString(@"JGJQuaSafeCheckHomeVc")]) {
            
            [self.navigationController popToViewController:quaSafeHomeVc animated:YES];
            
            break;
        }
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.inspectList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckListCell *cell = [JGJCheckListCell cellWithTableView:tableView];
    
    cell.inspectListModel = self.inspectList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 202;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJQuaSafeCheckPlanDetailVc *detailVc = [JGJQuaSafeCheckPlanDetailVc new];
    
    detailVc.proListModel = self.proListModel;
    
    detailVc.inspectListModel = self.inspectList[indexPath.row];
    
    [self.navigationController pushViewController:detailVc animated:YES];

}

- (void)loadInspectNetData {
    
    self.inspectListRequset.pg = 1;
    
    NSDictionary *parameter = [self.inspectListRequset mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectPlanList" parameters:parameter success:^(id responseObject) {
        
        self.inspectList = [JGJInspectListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView.mj_header endRefreshing];
        
        if (self.inspectList.count > 0) {
            
            self.tableView.tableHeaderView = nil;
            
            self.inspectListRequset.pg++;
            
            [self.tableView reloadData];
            
        }
        
        //是否显示缺省页
        [self showDefaultNoKnowBase:self.inspectList];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreInspectNetData {
    
    NSDictionary *parameter = [self.inspectListRequset mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectPlanList" parameters:parameter success:^(id responseObject) {
        
        
        NSArray *inspectList = [JGJInspectListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView.mj_footer endRefreshing];
        
        if (inspectList.count > 0) {
            
            self.tableView.tableHeaderView = nil;
            
            [self.inspectList addObjectsFromArray:inspectList];
            
            self.inspectListRequset.pg++;
            
        }
        
        if (inspectList.count < JGJPageSize) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.tableView.mj_footer = nil;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNoKnowBase:(NSArray *)dataSource {
    
    if (dataSource.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }
    
    if (self.selType == JGJQuaSafeCheckSelMyCreatType && dataSource.count == 0) {
        
        [self myCreatCheckPalnWithDataSource:dataSource];
    }
}

#pragma mark -我创建的检查项缺省页
- (void)myCreatCheckPalnWithDataSource:(NSArray *)dataSource {
    
    if (dataSource.count == 0 && self.selType == JGJQuaSafeCheckSelMyCreatType) {
        
        self.defultDataModel.helpTitle = @"查看帮助";
        
        self.defultDataModel.pubTitle = @"立即创建";
        
        self.defultDataModel.contentStr = @"暂无创建的计划";
        
        __weak typeof(self) weakSelf = self;
        
        JGJNoDataDefultView *defultView = [[JGJNoDataDefultView alloc] initWithFrame:CGRectMake(0, 64, TYGetUIScreenWidth, TYGetUIScreenHeight - 64) andSuperView:nil andModel:self.defultDataModel helpBtnBlock:^(NSString *title){
            
            [weakSelf checkHelpCenter];
            
        } pubBtnBlock:^(NSString *title) {
            
            if (weakSelf.proListModel.isClosedTeamVc) {
                
                [JGJComTool showCloseProPopViewWithClasstype:weakSelf.proListModel.class_type];
                
                return ;
            }
            
            [weakSelf creatCheckPlan];
            
        }];
        
        self.tableView.tableHeaderView = defultView;
    }
    
}

#pragma mark - 创建检查计划
- (void)creatCheckPlan {
    
    TYLog(@"立即创建计划");
    [self JGJHttpRequest];
}

#pragma mark - 查看帮组中心
- (void)checkHelpCenter {
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView new];
    
    titleView.titleViewType = JGJHelpCenterTitleViewCheckType;
    
    titleView.proListModel = self.proListModel;
    
    [titleView helpCenterActionWithTitleViewType:JGJHelpCenterTitleViewCheckType target:self];
}

-(JGJNodataDefultModel *)defultDataModel
{
    
    if (!_defultDataModel) {
        
        _defultDataModel = [JGJNodataDefultModel new];
        
    }
    return _defultDataModel;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (JGJQuaSafeInspectListRequset *)inspectListRequset {
    
    if (!_inspectListRequset) {
        
        _inspectListRequset = [JGJQuaSafeInspectListRequset new];
        
//        _inspectListRequset.group_id = @"60";
        
        _inspectListRequset.group_id = self.proListModel.group_id;
        
        _inspectListRequset.class_type = self.proListModel.class_type;
        
        _inspectListRequset.pagesize = JGJPageSize;
    }
    
    return _inspectListRequset;
    
}

- (void)setSelType:(JGJQuaSafeCheckSelType)selType {
    
    _selType = selType;
    
    self.inspectListRequset.status = nil;
    
    self.inspectListRequset.my_creater = nil;
    
    self.inspectListRequset.my_oper = nil;
    
    switch (selType) {
        case JGJQuaSafeCheckSelCheckItemType:{
            
        }
            break;
            
        case JGJQuaSafeCheckSelAllCheckPlanType:{
            
            self.inspectListRequset.status = nil;
            
            self.inspectListRequset.my_creater = nil;
            
            self.inspectListRequset.my_oper = nil;

        }
            
            break;
            
        case JGJQuaSafeCheckSelCompletedPlanType:{
            
            self.inspectListRequset.status = @"3";
            
        }
            break;
            
        case JGJQuaSafeCheckSelWaitMeExecuteType:{
            
            self.inspectListRequset.my_oper = @"1";

        }
            
            break;
            
        case JGJQuaSafeCheckSelMyCreatType:{
            
            self.inspectListRequset.my_creater = @"1";
            
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)JGJHttpRequest
{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.proListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.proListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@"pro" forKey:@"type"];
    
    typeof(self) weakSelf = self;
    
    
    //    [TYLoadingHub showLoadingWithMessage:nil];
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
        
        weakSelf.listModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        if (weakSelf.listModel.list.count <= 0) {
            
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"暂无检查项，请先设置检查项" delegate:self buttonTitles:@"暂不考虑",@"去设置", nil];
            [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
            
            [alert show];
        }else{
            
            JGJCheckPlanViewController *planVC = [[UIStoryboard storyboardWithName:@"JGJCheckPlanViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckPlanVC"];
            
            planVC.WorkproListModel = self.proListModel;
            
            [self.navigationController pushViewController:planVC animated:YES];
        }
        
        [TYLoadingHub hideLoadingView];
        
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}
-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
        WorkReportVC.checkItemNodata = YES;
        
        WorkReportVC.WorkproListModel = self.proListModel;
        
        [self.navigationController pushViewController:WorkReportVC animated:YES];
        
    }
    


}
@end
