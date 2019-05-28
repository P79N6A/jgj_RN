//
//  JGJCheckTheItemViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckTheItemViewController.h"

#import "JGJCheckItemTableViewCell.h"

#import "JGJCreatPlansView.h"

#import "JGJNoDataDefultView.h"

#import "JGJCreatCheackContentViewController.h"

#import "JGJNewCreteCheckItemViewController.h"

#import "JGJCheckContentDetailViewController.h"

#import "JGJCheckItemLookForDetailViewController.h"

#import "MJRefreshAutoNormalFooter.h"

#import "MJRefreshHeader.h"

#import "MJRefresh.h"

#import "JGJQuaSafeCheckHomeVc.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJBottomBtnView.h"
#define pageSize 20 //分页的每页条数

@interface JGJCheckTheItemViewController ()
<
clickLogTopButtondelegate,
UITableViewDataSource,
UITableViewDelegate,
JGJBottomBtnViewDelegate
>
@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (strong ,nonatomic)JGJNodataDefultModel *defultDataModel;//迎来显示默认页显示模型

@property (strong ,nonatomic)JGJNodataDefultModel *creatDataModel;//用来显示创建按钮下面的文字的模型

@property (strong ,nonatomic)JGJNoDataDefultView *noDataDefultView;

@property (strong ,nonatomic)JGJCreatPlansView *creatPlanView;

@property (assign ,nonatomic)int pageNum;

@property (strong ,nonatomic)JGJCheckItemMainListModel *listModel;//检查想和检查内容mg列表

@property (strong ,nonatomic)JGJCheckItemMainListModel *PGlistModel;//检查想和检查内容mg列表


@property (strong, nonatomic) IBOutlet JGJBottomBtnView *BottomBtnView;

@property (strong, nonatomic) UIView *itemHeaderView;

@end

@implementation JGJCheckTheItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    _logQuestType = allLogtype;
    
    if (_logQuestType == allLogtype) {
        
        self.defultDataModel.helpTitle = @"查看帮助";
        self.defultDataModel.pubTitle = @"新建检查项";
        self.defultDataModel.contentStr = @"暂无检查项";
        self.creatDataModel.contentStr = @"新建检查项";
    }
    
    self.tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(JGJHttpRequest)];

    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(JGJHttpLoadMoreRequst)];
    
    self.BottomBtnView.delegate = self;
    
    self.BottomBtnView.defultModel = self.creatDataModel;


    self.BottomBtnView.hidden = YES;
    
    self.tableview.tableHeaderView = self.itemHeaderView;
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
}

- (UIView *)itemHeaderView
{
    if (!_itemHeaderView) {
        _itemHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        _itemHeaderView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _itemHeaderView;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
}
- (void)newCreateButton
{

#pragma mark - 新建按钮
    typeof(self) weakSelf = self;
    if (self.creatPlanView) {
        [self.creatPlanView removeFromSuperview];
    }
    self.creatPlanView = [JGJCreatPlansView showView:self.view andModel:self.creatDataModel  andBlock:^(NSString *title) {
        
        if (_logQuestType == meLogTYpe) {
            JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
            WorkReportVC.WorkproListModel = self.WorkproListModel;
            
            [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
        }else{
            
            JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
            
            WorkReportVC.WorkproListModel = self.WorkproListModel;
            
            [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
            
        }
        
        
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
    
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

//    [self JGJHttpRequest];
    
}
-(JGJNodataDefultModel *)defultDataModel
{

    if (!_defultDataModel) {
        
        _defultDataModel = [JGJNodataDefultModel new];
        
    }
    return _defultDataModel;
}


-(JGJNodataDefultModel *)creatDataModel
{
    if (!_creatDataModel) {
        
        _creatDataModel = [JGJNodataDefultModel new];
        
    }
    return _creatDataModel;

}

-(JGJLogHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JGJLogHeaderView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
        _headerView.backgroundColor = AppFontffffffColor;
        _headerView.delegate = self;
        
        JGJNodataDefultModel *model = [JGJNodataDefultModel new];
        model.helpTitle = @"检查项";
        model.pubTitle = @"检查内容";
        _headerView.defultModel = model;
    }
    return _headerView;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
    

-(void)initView{
    self.title = @"检查项";
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteCheckItem)];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = barButton;
    [self.view addSubview:self.headerView];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJCheckItemTableViewCell *cell = [JGJCheckItemTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listModel.list[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listModel.list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_logQuestType == meLogTYpe) {
        JGJCheckContentDetailViewController *contenVC = [[UIStoryboard storyboardWithName:@"JGJCheckContentDetailViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckContentDetailVC"];
        contenVC.WorkproListModel = self.WorkproListModel;

        contenVC.listModel = self.listModel.list[indexPath.row];
        [self.navigationController pushViewController:contenVC animated:YES];
    }else{
        
        JGJCheckItemLookForDetailViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckItemLookForDetailViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckItemLookForDetailVC"];
        
        WorkReportVC.lookForCheckItem = YES;
        
        WorkReportVC.mainCheckListModel = self.listModel.list[indexPath.row];
        
        WorkReportVC.WorkproListModel = self.WorkproListModel;
        
        [self.navigationController pushViewController:WorkReportVC animated:YES];
    
    }

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.listModel.list removeObjectAtIndex:indexPath.row];
//    
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    if (_logQuestType == meLogTYpe) {
        [self deleteCheckContentAndIndextpath:indexPath];
    }else{
        [self deleteCheckItemAndIndextpath:indexPath];
    }
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[self.listModel.list[indexPath.row] is_operate]?:@"0" intValue]) {
//        return nil;
//    }
    return @"删除";
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    NSIndexPath * indexP =[NSIndexPath indexPathForRow:0 inSection:0];
//    
//    if (indexP == indexPath) {
//        
//        return NO;
//        
//    }
//    
//    return YES;
//    
//}

#pragma mark - 点击头部
-(void)clickLogTopButtonWithType:(logClickType)type
{
    
    self.BottomBtnView.hidden = YES;

    [TYLoadingHub showLoadingWithMessage:nil];
    
    _logQuestType = type;
    
    if(type == allLogtype){//第一个按钮
        
        self.defultDataModel.helpTitle = @"查看帮助";
        
        self.defultDataModel.pubTitle = @"新建检查项";
        
        self.defultDataModel.contentStr = @"暂无检查项";
        
        self.creatDataModel.contentStr = @"新建检查项";

    }else if (type == meLogTYpe){//第二个按钮
        self.defultDataModel.helpTitle = @"查看帮助";
        
        self.defultDataModel.pubTitle = @"新建检查内容";

        self.defultDataModel.contentStr = @"暂无检查内容";
        
        self.creatDataModel.contentStr = @"新建检查内容";
        
    }
    
    [self JGJHttpRequest];

    _noDataDefultView.defultModel = self.defultDataModel;

//    _creatPlanView.defultModel = self.creatDataModel;
    self.BottomBtnView.defultModel = self.creatDataModel;
    
}


-(void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel){
        
        _WorkproListModel = [JGJMyWorkCircleProListModel new];
    
    }
    _WorkproListModel = WorkproListModel;
}

#pragma mark - 获取检查项列表
- (void)JGJHttpRequest
{
    _pageNum = 1;
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:_logQuestType==allLogtype?@"pro":@"content" forKey:@"type"];
    
    [paramDic setObject:@(_pageNum) forKey:@"pg"];
    
    [paramDic setObject:@(pageSize) forKey:@"pagesize"];
    
    typeof(self) weakSelf = self;
    
    if (_noDataDefultView) {
        
        [_noDataDefultView removeFromSuperview];
    }
    
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
        
        
        weakSelf.listModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        [weakSelf.tableview reloadData];
        

        [weakSelf initDeflutView];
        
        [self.tableview.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        
        [self.tableview.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];


    }];
    
}

-(void)JGJHttpLoadMoreRequst
{

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:_logQuestType==allLogtype?@"pro":@"content" forKey:@"type"];
    
    _pageNum ++;
    
    [paramDic setObject:@(_pageNum) forKey:@"pg"];

    [paramDic setObject:@(pageSize) forKey:@"pagesize"];

    typeof(self) weakSelf = self;
    
    if (_noDataDefultView) {
        
        [_noDataDefultView removeFromSuperview];
        
    }
    [self.tableview.mj_footer beginRefreshing];
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
        [self.tableview.mj_footer endRefreshing];

        weakSelf.PGlistModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        if (weakSelf.PGlistModel.list.count) {
            
            [weakSelf.listModel.list addObjectsFromArray:weakSelf.PGlistModel.list];
  
        }else{
        
//            weakSelf.tableview.mj_footer = nil;
        
        }
        
        [weakSelf.tableview reloadData];
        
        
        [weakSelf initDeflutView];
        
        
    }failure:^(NSError *error) {
        
        [self.tableview.mj_footer endRefreshing];
        
    }];


}

-(void)JGJHttpLoadMoreRequstNotUserFooterForIndexpath:(NSIndexPath *)indexpath
{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:_logQuestType == allLogtype?@"pro":@"content" forKey:@"type"];
    
//    _pageNum ++;
   
//    [paramDic setObject:@(_pageNum) forKey:@"pg"];
    
    [paramDic setObject:@(indexpath.row/20 +1) forKey:@"pg"];

    [paramDic setObject:@(pageSize) forKey:@"pagesize"];
    
    typeof(self) weakSelf = self;
    
    if (_noDataDefultView) {
        
        [_noDataDefultView removeFromSuperview];
        
    }
//    [self.tableview.mj_footer beginRefreshing];
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
//        [self.tableview.mj_footer endRefreshing];
        
        weakSelf.PGlistModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        
        NSMutableArray *idArr = [NSMutableArray array];
        for (int i = 0; i < weakSelf.listModel.list.count; i ++) {
            [idArr addObject:[weakSelf.listModel.list[i] id]];
        }

        
        if (weakSelf.PGlistModel.list.count) {
            
            for (int i = 0; i < weakSelf.PGlistModel.list.count; i ++) {
                if (![idArr containsObject:[weakSelf.PGlistModel.list[i] id]]) {
                [weakSelf.listModel.list addObject:weakSelf.PGlistModel.list[i]];
                    }

            }
        }
        
        [weakSelf.tableview reloadData];
        
        
        [weakSelf initDeflutView];
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        
    }];
    
    
}

-(void)initDeflutView{
    
    typeof(self) weakSelf = self;

    if (weakSelf.listModel.list.count <= 0) {
    _noDataDefultView = [[JGJNoDataDefultView alloc]initWithFrame:CGRectMake(0, 50, TYGetUIScreenWidth, TYGetUIScreenHeight - 50) andSuperView:self.view andModel:weakSelf.defultDataModel helpBtnBlock:^(NSString *title){
        
        JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView new];
        
        titleView.titleViewType = JGJHelpCenterTitleViewCheckType;
        
        titleView.proListModel = self.WorkproListModel;
        
         [titleView helpCenterActionWithTitleViewType:JGJHelpCenterTitleViewCheckType target:self];
           
        } pubBtnBlock:^(NSString *title) {
            
            if (_logQuestType == meLogTYpe) {
                JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
                WorkReportVC.WorkproListModel = self.WorkproListModel;
                
                [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
            }else{
                
                JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
                
                WorkReportVC.WorkproListModel = self.WorkproListModel;
                
                [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
                
            }

            
 
        }];
    }else{
        self.BottomBtnView.hidden = NO;

//        [self newCreateButton];
        
    }
}

#pragma mark - 删除检查项
- (void)deleteCheckItemAndIndextpath:(NSIndexPath *)indexpath
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:[self.listModel.list[indexpath.row] id]?:@"" forKey:@"pro_id"];
    typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/delInspecPro" parameters:paramDic success:^(id responseObject) {
        
        [weakSelf.listModel.list removeObjectAtIndex:indexpath.row];
        
        [weakSelf.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationTop];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableview reloadData];
            [TYLoadingHub hideLoadingView];
            
//            if (!weakSelf.listModel.list.count) {
//                [weakSelf.tableview.mj_footer beginRefreshing];
                [self JGJHttpLoadMoreRequstNotUserFooterForIndexpath:indexpath];
//            }
            [weakSelf initDeflutView];

        });
        
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
  
    }];
    

}


#pragma mark - 删除检查内容

- (void)deleteCheckContentAndIndextpath:(NSIndexPath *)indexpath{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:[self.listModel.list[indexpath.row] id]?:@"" forKey:@"content_id"];
    typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/delInspectContent" parameters:paramDic success:^(id responseObject) {
        
        [self.listModel.list removeObjectAtIndex:indexpath.row];
        
        [weakSelf.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationTop];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableview reloadData];
            [TYLoadingHub hideLoadingView];
            [weakSelf initDeflutView];
            [self JGJHttpLoadMoreRequstNotUserFooterForIndexpath:indexpath];

        });
        
        

    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];

    }];
}

-(void)backButtonPressed
{
    if (_backMain) {
        
//        for (UIViewController *vc in self.navigationController.viewControllers) {
        
    
            JGJQuaSafeCheckHomeVc *homesVC = (JGJQuaSafeCheckHomeVc *)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
            
            [self.navigationController popToViewController:homesVC animated:YES];

//            break;
//        }
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)clickJGJBottomBtnViewBtn
{
    
    if (_logQuestType == meLogTYpe) {
        JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
        WorkReportVC.WorkproListModel = self.WorkproListModel;
        
        [self.navigationController pushViewController:WorkReportVC animated:YES];
    }else{
        
        JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
        
        WorkReportVC.WorkproListModel = self.WorkproListModel;
        
        [self.navigationController pushViewController:WorkReportVC animated:YES];
        
    }
    
}
@end
