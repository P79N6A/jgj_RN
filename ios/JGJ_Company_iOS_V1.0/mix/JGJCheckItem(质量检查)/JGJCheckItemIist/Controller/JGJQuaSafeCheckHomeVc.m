//
//  JGJQuaSafeHomeVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckHomeVc.h"

#import "JGJQuaSafeHomeTopCell.h"

#import "JGJQuaSafeAboutMeCell.h"

#import "JGJCreatPlansView.h"

#import "JGJQuaSafeCheckListVc.h"

#import "JGJCheckTheItemViewController.h"

#import "FDAlertView.h"

#import "JGJCheckPlanViewController.h"

#import "JGJNewCreteCheckItemViewController.h"

#import "JGJHelpCenterTitleView.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJQuaSafeCheckHomeVc () <UITableViewDataSource, UITableViewDelegate,FDAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong ,nonatomic)JGJNodataDefultModel *creatDataModel;//用来显示创建按钮下面的文字的模型

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) JGJInspectHomeModel *inspectHomeModel;

@property (strong ,nonatomic)JGJCheckItemMainListModel *listModel;//检查想和检查内容mg列表

@end

@implementation JGJQuaSafeCheckHomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self commonSetUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self delUnread_inspectwork_count];
    [self loadNetData];
}
- (void)delUnread_inspectwork_count {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_inspect_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        JGJQuaSafeHomeTopCell *topCell = [JGJQuaSafeHomeTopCell cellWithTableView:tableView];
        
        topCell.topInfos = self.dataSource[0];
        
        __weak typeof(self) weakSelf = self;
        
        topCell.quaSafeHomeTopCellBlock = ^(NSInteger indx) {
            
            JGJQuaSafeCheckSelType selType = (JGJQuaSafeCheckSelType) indx;
            
            [weakSelf selCheckType:selType];
        };
        
        cell = topCell;
        
    }else {
        
        JGJQuaSafeAboutMeCell *aboutMeCell = [JGJQuaSafeAboutMeCell cellWithTableView:tableView];
        
        aboutMeCell.typeModel = self.dataSource[indexPath.row];
        
        cell = aboutMeCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return indexPath.row == 0 ? [JGJQuaSafeHomeTopCell JGJQuaSafeHomeTopCellHeight] :[JGJQuaSafeAboutMeCell JGJQuaSafeAboutMeCellHeight];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    JGJQuaSafeCheckSelType selType = JGJQuaSafeCheckSelWaitMeExecuteType;
    if (indexPath.row == 1) {
        
        selType = JGJQuaSafeCheckSelWaitMeExecuteType;
        
    }else if (indexPath.row == 2) {
        
        selType = JGJQuaSafeCheckSelMyCreatType;
    }
    
        [self selCheckType:selType];
}

- (void)selCheckType:(JGJQuaSafeCheckSelType)type {
    
//    JGJQuaSafeCheckSelCheckItemType, //检查项
//    JGJQuaSafeCheckSelAllCheckPlanType, //所有计划
//    JGJQuaSafeCheckSelCompletedPlanType, //已完成
//    JGJQuaSafeCheckSelWaitMeExecuteType, //待我执行
//    JGJQuaSafeCheckSelMyCreatType //我创建的
    
    NSString *title = @"所有计划";
    
    switch (type) {
        case JGJQuaSafeCheckSelCheckItemType:{
            
            
            [self checkItemType];
            
            return;
        }
            
            break;
            
        case JGJQuaSafeCheckSelAllCheckPlanType:{
            
            title = @"所有计划";
        }
            
            break;
            
        case JGJQuaSafeCheckSelCompletedPlanType:{
            
            title = @"已完成";
        }
            
            break;
            
        case JGJQuaSafeCheckSelWaitMeExecuteType:{
            
            title = @"待我执行";
        }
            
            break;
            
        case JGJQuaSafeCheckSelMyCreatType:{
            
            title = @"我创建的";
        }
            
            break;
            
        default:
            break;
    }
    
    JGJQuaSafeCheckListVc *checkListVc = [JGJQuaSafeCheckListVc new];
    
    checkListVc.proListModel = self.proListModel;
    
    checkListVc.selType = type;
    
    checkListVc.title = title;
    
    [self.navigationController pushViewController:checkListVc animated:YES];
}

#pragma mark - 检查项类型
- (void)checkItemType {
    
    JGJCheckTheItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckTheItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckTheItemVC"];
    
    WorkReportVC.WorkproListModel = self.proListModel;
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];
    
}

#pragma mark - 新建计划
- (void)creatCheckItemPlan {
    
    [self JGJHttpRequest];

    
}

#pragma mark - 帮助中心
- (void)helpCenterPressed:(UIButton *)pressed {
    
    
    
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

- (void)commonSetUI {
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];

    titleView.titleViewType = JGJHelpCenterTitleViewCheckType;
    
    titleView.title = @"检查";

    self.navigationItem.titleView = titleView;

    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.proListModel.isClosedTeamVc) {
        
        JGJNodataDefultModel *creatDataModel = [JGJNodataDefultModel new];
        
        creatDataModel.contentStr = @"新建检查计划";
        
        [JGJCreatPlansView showView:self.view andModel:creatDataModel  andBlock:^(NSString *title) {
            
            TYLog(@"新建计划");
            
            [weakSelf creatCheckItemPlan];
        }];
    }
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.proListModel.class_type?:@"",
                                 
                                 @"group_id" : self.proListModel.group_id?:@""
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectIndex" parameters:parameters success:^(id responseObject) {
       
        TYLog(@"responseObject ==== %@", responseObject);
        
        self.inspectHomeModel = [JGJInspectHomeModel mj_objectWithKeyValues:responseObject];
        
    }failure:^(NSError *error) {
        
        
    }];
    
}

- (void)setInspectHomeModel:(JGJInspectHomeModel *)inspectHomeModel {
    
    _inspectHomeModel = inspectHomeModel;
    
    NSArray *redFlags = @[inspectHomeModel.inspect_my_oper_red, @"0"];
    
    for (NSInteger indx = 0; indx < self.dataSource.count; indx++) {
        
        NSArray *topInfos = self.dataSource[0];
        
        if (indx == 0) {
            
            for (NSInteger subIndex = 0; subIndex < topInfos.count; subIndex++) {
                
                JGJQuaSafeHomeModel *topModel = topInfos[subIndex];
                
                topModel.title = inspectHomeModel.topTitles[subIndex];
                
            }
            
        }else {
            
            JGJQuaSafeHomeModel *topModel = self.dataSource[indx];
            
            topModel.unReadMsgCount = redFlags[indx - 1];
            
            topModel.title = inspectHomeModel.aboutMeTitles[indx - 1];
        }
        
    }
    
    [self.tableView reloadData];
    
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray new];
        
        NSMutableArray *topDataSource = [NSMutableArray new];
        
        NSArray *topTitles = @[@"检查项", @"所有计划", @"已完成"];
        
        NSArray *topIcons = @[@"check_item_icon", @"all_plan_icon", @"complete_check_icon"];
        
        NSArray *typeTitles = @[@"待我执行", @"我创建的"];
        
        NSArray *typeIcons = @[@"wait_me_ execute_icon", @"my_creat_check_icon"];
        
        for (NSInteger index = 0; index < topTitles.count; index++) {
            
            JGJQuaSafeHomeModel *topModel = [JGJQuaSafeHomeModel new];
            
            topModel.title = topTitles[index];
            
            topModel.icon = topIcons[index];
            
            [topDataSource addObject:topModel];
        }
        
        [_dataSource addObject:topDataSource];
        
        for (NSInteger index = 0; index < typeTitles.count; index++) {
            
            JGJQuaSafeHomeModel *typeModel = [JGJQuaSafeHomeModel new];
            
            typeModel.title = typeTitles[index];
            
            typeModel.icon = typeIcons[index];
            
            [_dataSource addObject:typeModel];
        }
        
    }
    
    return _dataSource;
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
//        JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
//        WorkReportVC.checkItemNodata = YES;
//        
//        WorkReportVC.WorkproListModel = self.proListModel;
//        
//        [self.navigationController pushViewController:WorkReportVC animated:YES];

        
        
        JGJCheckTheItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckTheItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckTheItemVC"];
        
        WorkReportVC.WorkproListModel = self.proListModel;
        
        [self.navigationController pushViewController:WorkReportVC animated:YES];

    }

}
@end
