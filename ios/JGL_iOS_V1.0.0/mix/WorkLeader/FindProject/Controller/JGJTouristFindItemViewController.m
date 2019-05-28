//
//  JGJTouristFindItemViewController.m
//  mix
//
//  Created by celion on 16/4/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTouristFindItemViewController.h"
#import "JGJFindJobAndProTableViewCell.h"
#import "JGJNewWorkItemDetailVC.h"
#import "JLGFHLeaderModel.h"
#import "MJRefresh.h"
#import "JLGCitysListView.h"
#import "JGJWorkTypeCollectionView.h"
#import "JGJFindJobAndProViewController.h"
@interface JGJTouristFindItemViewController ()<UITableViewDataSource, UITableViewDelegate,JLGCitysListViewDelegate>

@property (nonatomic,strong) JLGCitysListView *jlgCitysListView;
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger pageNum;
@property (assign, nonatomic) NSInteger excludeContentH;
@property (copy,   nonatomic) NSString *cityCode;
@property (copy,   nonatomic) NSString *workTypeID;
@property (copy,   nonatomic) NSString *workTypeName;
@property (weak,   nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@end

@implementation JGJTouristFindItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJFindJobAndProTableViewCell *cell = [JGJFindJobAndProTableViewCell cellWithTableView:tableView];
    
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row];
    cell.jlgFindProjectModel = jlgFindProjectModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row];
    return self.excludeContentH + jlgFindProjectModel.strViewH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return;
    }
    
    JGJNewWorkItemDetailVC *newWorkItemDetailVC = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewWorkItemDetailVC"];
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row];
    newWorkItemDetailVC.isShowSkill = NO;//未联系只显示打电话按钮
    [newWorkItemDetailVC setValue:jlgFindProjectModel forKey:@"jlgFindProjectModel"];
    newWorkItemDetailVC.workTypeID = self.workTypeID;
    [self.navigationController pushViewController:newWorkItemDetailVC animated:YES];
}

- (void)JLGHttpRequest:(BOOL )isLoadNewData {
    NSDictionary *parameters = @{@"role_type" : JLGisMateBool ? @"1" : @"2",
                                 @"city_no" : self.cityCode ? :[NSNull null],
                                 @"work_type" : self.workTypeID ? :[NSNull null],
                                 @"pg" : @(self.pageNum),
                                 @"contacted" : @(0),     
                                 @"pagesize" : @"10",
                                 @"is_all_area" : @(1)?:[NSNull null]
                                 };
    
    [TYShowMessage showHUDWithMessage:@"数据查询中，请稍后！"];
    [JLGHttpRequest_AFN PostWithApi:@"jlforemanwork/findjobactive" parameters:parameters success:^(NSDictionary *responseObject) {
        NSArray *dataArray = [JLGFindProjectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data_list"]];
        
        [dataArray enumerateObjectsUsingBlock:^(JLGFindProjectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.maxWidth = TYGetUIScreenWidth;
        }];
        
        //如果是下拉刷新，清空之前数据
        isLoadNewData?[self.dataSource removeAllObjects]:nil;
        
        if (dataArray.count == 0 && self.dataSource.count == 0) {
//            [self getCityslist];//1.4.4该界面没有数据的时候不用显示城市列表
        }else{
            ++self.pageNum;
            [self.dataSource addObjectsFromArray:dataArray];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [TYShowMessage hideHUD];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [TYShowMessage hideHUD];
    }];
}

- (void)loadNetMoreData {
    //1.4.4该界面如果没有登录就直接弹出登录框
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (func(self.navigationController, checkIsLogin)) {
        [self JLGHttpRequest:NO];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)loadNetData {
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}

- (void)setWorkTypeID:(NSString *)workTypeID{
    //1.4.4该界面获取的都是全部工种
    _workTypeID = workTypeID;
    _workTypeID = @"0";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (TYIS_IPHONE_4_OR_LESS) {
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (TYIS_IPHONE_4_OR_LESS) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)commonSet {
    self.cityCode = [TYUserDefaults objectForKey:JLGSelectCityNo];
    //    初始化分页为第一页
    self.navigationItem.title = JLGisLeaderBool?@"新项目":@"找工作";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNetMoreData)];
    
    JGJFindJobAndProTableViewCell *cell = [JGJFindJobAndProTableViewCell cellWithTableView:self.tableView];
    self.excludeContentH = cell.excludeContentH;
    self.tableView.hidden = YES;
    CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
    __weak typeof(self) weakSelf = self;
    JGJWorkTypeCollectionView *workTypeView = [[JGJWorkTypeCollectionView alloc] initWithFrame:rect workType:^(FHLeaderWorktype *workTypeModel) {
        JGJFindJobAndProViewController *findJobAndProVC = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"findJobAndPro"];
        findJobAndProVC.workTypeModel.type_id = workTypeModel.type_id;
        findJobAndProVC.workTypeModel.type_name = workTypeModel.type_name;
        findJobAndProVC.workTypeModel.workTypeID = [NSString stringWithFormat:@"%@",@(workTypeModel.type_id)];
        
        weakSelf.workTypeName = workTypeModel.type_name;
        weakSelf.workTypeID = [NSString stringWithFormat:@"%@",@(workTypeModel.type_id)];

        [weakSelf.navigationController pushViewController:findJobAndProVC animated:YES];
        
        [weakSelf.jlgCitysListView hidden];
        [weakSelf loadDataAgain];
    }];

    workTypeView.isOpen = NO;//设置是否展开
    workTypeView.limitCount = 12;//默认显示12个类型
    
    self.tableViewTop.constant = workTypeView.workTypeHeight + 0;
    [self.view addSubview:workTypeView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 登录以后所在城市没有工种的数据
- (void)getCityslist{
    if (self.jlgCitysListView) {
        [self.jlgCitysListView removeFromSuperview];
    }
    self.jlgCitysListView = [[JLGCitysListView alloc] initWithFrame:self.tableView.frame];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    parametersDic[@"pg"] = @(1);
    parametersDic[@"cityno"] = self.cityCode;
    parametersDic[@"worktype"] = self.workTypeID;
    parametersDic[@"role_type"] = @(JLGisMateBool?1:2);
    
    //解析数据
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/cityprocounts" parameters:parametersDic success:^(NSArray *responseObject) {
        NSMutableArray *workTypeArr = [NSMutableArray array];
        if ([self.workTypeID integerValue] != -1) {
            workTypeArr = @[@{@"name":self.workTypeName,@"code":self.workTypeID}].mutableCopy;
        }
        
        NSArray *dataArr = [JLGCitysListModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (dataArr) {
            self.jlgCitysListView = [[JLGCitysListView alloc] initWithFrame:self.tableView.frame dataArr:dataArr];
            
            self.jlgCitysListView.worktypeArr = workTypeArr;
        }

        [self.jlgCitysListView showInView:self];
        self.jlgCitysListView.delegate = self;
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 没工种的时候选择的城市
- (void)selectedCity:(NSString *)cityCode cityName:(NSString *)cityName{
    self.cityCode = cityCode;

    [self loadDataAgain];
}

- (void)loadDataAgain{
    [self.tableView.mj_header beginRefreshing];

    self.jlgCitysListView.delegate = nil;
    self.jlgCitysListView = nil;
}


#pragma mark - 点击了选择框的更多
- (void)didClickedMoreButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView{
    if (!self.jlgCitysListView) {
        return;
    }
    
    //添加选择的列表
    CGRect cityListFrame = self.tableView.frame;
    CGFloat workTypeheight = workTypeCollectionView.workTypeHeight;
    cityListFrame.origin.y += workTypeheight;
    cityListFrame.size.height -= workTypeheight;
    self.jlgCitysListView.frame = cityListFrame;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
