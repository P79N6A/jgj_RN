//
//  JGJFindJobAndProViewController.m
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFindJobAndProViewController.h"

#import "YZGRecordWorkpointTool.h"
#import "JGJNewWorkItemDetailVC.h"
#import "JGJFindJobAndProTableViewCell.h"
#import "JGJFilterTypeContentButtonView.h"
#import "JGJAlreadyContactedViewController.h"
#import "NSString+Extend.h"

#ifdef DEBUG
#import "YYTextExampleHelper.h"
#endif
#define JGJFindJobTopViewY 1

@interface JGJFindJobAndProViewController ()
<
    JLGCitysListViewDelegate,
    JGJFilterTypeContentButtonViewDelegate
>
@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) CityMenuView *cityMenuView;
@property (strong, nonatomic) JGJWorkTypeCollectionView *workTypeView;
@property (strong, nonatomic) JGJWorkTypeSelectedView *workTypeSelectedView;
@property (nonatomic,strong)  JGJFilterTypeContentButtonView *filterTypeContentView;

@property (nonatomic,assign) CGFloat excludeContentH;//除了中间需要根据内容变化的高度
@property (weak, nonatomic) IBOutlet UIButton *alreadyContactedButton;
@property (nonatomic,strong) NSMutableArray <Type_list *> *typelistArr;
@property (nonatomic,  copy) NSString *typelistStr;
@property (nonatomic, strong) NSArray *cityPros;//存储城市项目
@property (nonatomic, assign) BOOL isShowCitysListView;//拦截push用没有数据时，当返回时显示CitysListView
@property (nonatomic,copy) NSString *showCityButtonCitytitle;//无数据时城市的名字
@property (nonatomic,copy) NSString *showCityButtonCityID;
@property (nonatomic,copy) NSString *showCityButtonWorkTypetitle;//无数据时工种类型

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@end

@implementation JGJFindJobAndProViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self commonSet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    
    //加到tabar上面
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.alreadyContactedButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    //tabar移除
//    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count?self.dataSource.count + 1:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJFindJobAndProTableViewCell *cell = [JGJFindJobAndProTableViewCell cellWithTableView:tableView];
    if (self.dataSource.count == 0) {
        return cell;
    }

    if (indexPath.row == 0) {
        UITableViewCell *tipCell = [YZGRecordWorkpointTool getJGJTipCell:tableView];
        tipCell.textLabel.text = [NSString stringWithFormat:@"以下是 %@ 相关的项目",self.typelistStr];
        tipCell.textLabel.hidden = [self.workTypeModel.workTypeID isEqualToString:@"-1"];
        return tipCell;
    }
    
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row - 1];
    cell.jlgFindProjectModel = jlgFindProjectModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return 0;
    }
    
    if (indexPath.row == 0) {
//        全部工种不显示提示信息
        return self.workTypeModel.type_id == -1 ? 0 : 40;
    }
    
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row - 1];
    return self.excludeContentH + jlgFindProjectModel.strViewH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return ;
    }
    
    if ((indexPath.row - 1) > self.dataSource.count) {
        return ;
    }
    
    JGJNewWorkItemDetailVC *newWorkItemDetailVC = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewWorkItemDetailVC"];
    JLGFindProjectModel *jlgFindProjectModel = self.dataSource[indexPath.row - 1];
    newWorkItemDetailVC.isShowSkill = NO;//未联系只显示打电话按钮
    [newWorkItemDetailVC setValue:jlgFindProjectModel forKey:@"jlgFindProjectModel"];
    newWorkItemDetailVC.workTypeID = self.workTypeModel.workTypeID;
    [self.navigationController pushViewController:newWorkItemDetailVC animated:YES];
}

- (void)JLGHttpRequest{
    NSDictionary *parameters = @{@"role_type" :  self.workTypeModel.roleStr ?:[NSNull null],
                                 @"city_no" : self.workTypeModel.cityNameID?:[NSNull null],
                                 @"work_type" : self.workTypeModel.workTypeID?:[NSNull null],
                                 @"contacted" : @(0),
                                 @"pg" : @(self.pageNum),
                                 @"is_all_area" : self.workTypeModel.is_all_area?:[NSNull null]
                                 };

    [TYShowMessage showHUDWithMessage:@"数据查询中，请稍后！"];
    [JLGHttpRequest_AFN PostWithApi:@"jlforemanwork/findjobactive" parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.jlgCitysListView) {//去掉城市选择,如果需要显示再显示，避免出现显示延迟的问题
            [self.jlgCitysListView hidden];
            
            self.jlgCitysListView.delegate = nil;
            self.jlgCitysListView = nil;
        }
        
        self.typelistArr = [Type_list mj_objectArrayWithKeyValuesArray:responseObject[@"type_list"]];
        
        __block NSMutableArray *typeListStrArr = [NSMutableArray array];
        [self.typelistArr enumerateObjectsUsingBlock:^(Type_list * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [typeListStrArr addObject:obj.type_name ?:@""];
        }];
        self.typelistStr = [typeListStrArr componentsJoinedByString:@","];
        
        NSArray *dataArray = [JLGFindProjectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data_list"]];
        
        [dataArray enumerateObjectsUsingBlock:^(JLGFindProjectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.maxWidth = TYGetUIScreenWidth;
        }];
        
        if (dataArray.count == 0 && self.dataSource.count == 0) {
            self.tableView.hidden = YES;
            self.showCityButtonWorkTypetitle = self.workTypeModel.type_name;//存储无数据时按钮内容
            self.showCityButtonCitytitle = self.workTypeModel.cityName;
            self.showCityButtonCityID = self.workTypeModel.cityNameID;
            [self getCityslist];
        }else{
            ++self.pageNum;
            self.tableView.hidden = NO;
            [self.dataSource addObjectsFromArray:dataArray];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [TYShowMessage hideHUD];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [TYShowMessage hideHUD];
    }];
}

- (void)commonSet {
#ifdef DEBUG
//    [YYTextExampleHelper addDebugOptionToViewController:self];
//    [YYTextExampleHelper setDebug:YES];
#endif
    self.typelistArr = [NSMutableArray array];

    //    添加顶部选择按钮
    JGJFilterTypeContentButtonView *filterTypeContentView = [[JGJFilterTypeContentButtonView alloc] initWithFrame:CGRectMake(0, JGJFindJobTopViewY, TYGetViewW(self.view), 40)];
    self.filterTypeContentView = filterTypeContentView;
    filterTypeContentView.delegate = self;
    filterTypeContentView.cityName.text = @"全国";
    filterTypeContentView.workTypeName.text = self.workTypeModel.type_name;
    [self.view addSubview:filterTypeContentView];
    
    //    初始化分页为第一页
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNetMoreData)];

    self.title = JLGisLeaderBool?@"找项目":@"找工作";
    self.workTypeModel.roleStr = JLGisLeaderBool?@"2":@"1";
    JGJFindJobAndProTableViewCell *cell = [JGJFindJobAndProTableViewCell cellWithTableView:self.tableView];
    self.excludeContentH = cell.excludeContentH;
    
    [self.alreadyContactedButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
    
    self.workTypeModel.currentPageType = FindJodType;//当前页面类型为找工作
    self.alreadyContactedButton.hidden = !JLGisLoginBool || (JLGisMateBool && !JLGMateIsInfoBool) || (JLGisLeaderBool &&!JLGLeaderIsInfoBool);
}

- (void)backAction:(UIButton *)sender {

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[JLGCitysListView class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }

    if (self.isShowCitysListView) {
        self.tableView.hidden = YES;
        self.isShowCitysListView = NO;//点击返回城市列表时，改变状态不显示
        self.filterTypeContentView.cityName.text = self.showCityButtonCitytitle; //显示为当前无数据时的城市
        self.workTypeModel.cityName = self.showCityButtonCitytitle;
        self.workTypeModel.cityNameID = self.showCityButtonCityID;
        self.filterTypeContentView.workTypeName.text = self.showCityButtonWorkTypetitle;
        [self showCitysListViewDataSource:self.cityPros];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNetMoreData {
    //1.4.4该界面如果没有登录就直接弹出登录框
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (func(self.navigationController, checkIsLogin)) {
        [self JLGHttpRequest];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)loadNetData {
    self.pageNum = 1;
    [self.dataSource removeAllObjects];
    [self JLGHttpRequest];
}

- (IBAction)alreadyContactedBtnClick:(UIButton *)sender {
    JGJAlreadyContactedViewController *newWorkItemDetailVC = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"alreadyContacted"];
    newWorkItemDetailVC.workTypeID = self.workTypeModel.workTypeID;
    [self.navigationController pushViewController:newWorkItemDetailVC animated:YES];
}

#pragma Mark - JGJFilterTypeContentButtonViewDelegate

- (void)filterCityTypeMenuButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.filterTypeContentView.workTypeButton.selected = NO;
    }
    CGRect rect = CGRectMake(0, TYGetViewH(sender)  + JGJFindJobTopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetViewH(sender) - 64 - 49);
    __weak typeof(self) weakSelf = self;
    if (sender.selected || self.filterTypeContentView.workTypeButton.selected) {
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"up_press"];
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
        CityMenuView *cityMenuView = [[CityMenuView alloc] initWithFrame:rect cityName:^(JLGCityModel *cityModel) {
            weakSelf.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
            weakSelf.filterTypeContentView.cityButton.selected = NO;
            weakSelf.filterTypeContentView.cityName.text = cityModel.city_name;
            weakSelf.workTypeModel.cityNameID = cityModel.city_code;
            weakSelf.workTypeModel.cityName = cityModel.city_name;
            weakSelf.workTypeModel.is_all_area = cityModel.is_all_area;
            [weakSelf loadNetData];
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
        }];
        self.cityMenuView = cityMenuView;
        [self.view addSubview:cityMenuView];
    } else {
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
    }
}

- (void)filterWorkTypeButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.filterTypeContentView.cityButton.selected = NO;
    }
    CGRect rect = CGRectMake(0, TYGetViewH(sender)  + JGJFindJobTopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetViewH(sender) - 64 - 49);
    if ( sender.selected  || self.filterTypeContentView.cityButton.selected)  {
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"up_press"];
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
        
        __weak typeof(self) weakSelf = self;
        JGJWorkTypeSelectedView *workTypeSelectedView = [[JGJWorkTypeSelectedView alloc] initWithFrame:rect workType:weakSelf.workTypeModel blockWorkType:^(FHLeaderWorktypeCity *workTypeModel) {
            weakSelf.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
            weakSelf.workTypeModel.workTypeID = [NSString stringWithFormat:@"%@",@(workTypeModel.type_id)];
            weakSelf.filterTypeContentView.workTypeButton.selected = NO;
            weakSelf.filterTypeContentView.workTypeName.text = workTypeModel.type_name;
            workTypeModel.is_all_area = weakSelf.workTypeModel.is_all_area; //保存之前的查看全国数据
            weakSelf.workTypeModel = workTypeModel;
            [weakSelf loadNetData];
        }];
        self.workTypeSelectedView = workTypeSelectedView;
        [self.view addSubview:workTypeSelectedView];
    } else {
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
    }
}


- (void)removeCurrentView {
    if (self.workTypeSelectedView) {
        [self.workTypeSelectedView removeFromSuperview];
    }
    
    if (self.cityMenuView) {
        [self.cityMenuView removeFromSuperview];
    }
}

#pragma mark - 登录以后所在城市没有工种的数据
- (void)getCityslist{
    if (self.jlgCitysListView) {
        [self.jlgCitysListView removeFromSuperview];
    }
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];

    parametersDic[@"pg"] = @(1);
    parametersDic[@"role_type"] = @(JLGisMateBool?1:2);
    parametersDic[@"cityno"] = self.workTypeModel.cityNameID;
    parametersDic[@"worktype"] = @(self.workTypeModel.type_id);
    
    [TYLoadingHub showLoadingWithMessage:@"当前城市未找到适合你的工种，正在为你筛选其他城市中!"];
    
    //解析数据
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/cityprocounts" parameters:parametersDic success:^(NSArray *responseObject) {
        
        NSArray *dataArr = [JLGCitysListModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self showCitysListViewDataSource:dataArr];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)showCitysListViewDataSource:(NSArray *)dataSource {
    NSMutableArray *workTypeArr = [NSMutableArray array];
    if (self.workTypeModel.type_id != -1) {
        workTypeArr = @[@{@"name":self.workTypeModel.type_name,@"code":[NSString stringWithFormat:@"%@",@(self.workTypeModel.type_id)]}].mutableCopy;
    }
    self.cityPros = dataSource;
    
    self.jlgCitysListView = [[JLGCitysListView alloc] initWithFrame:self.tableView.frame dataArr:dataSource];
    self.jlgCitysListView.worktypeArr = workTypeArr;
    [self.jlgCitysListView showInView:self];
    self.jlgCitysListView.delegate = self;
}

#pragma mark - 没工种的时候选择的城市
- (void)selectedCity:(NSString *)cityCode cityName:(NSString *)cityName{
    self.workTypeModel.cityNameID = cityCode;
    self.workTypeModel.cityName = cityName;
    self.showCityButtonWorkTypetitle = self.workTypeModel.type_name;//存储无数据时按钮内容
    self.filterTypeContentView.cityName.text =   self.workTypeModel.cityName;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.jlgCitysListView.delegate = nil;
    self.jlgCitysListView = nil;
    self.isShowCitysListView = YES;//点击之后返回到城市列表
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (FHLeaderWorktypeCity *)workTypeModel
{
    if (!_workTypeModel) {
        //    初始化城市编码为当前定位位置
        _workTypeModel  = [[FHLeaderWorktypeCity alloc] init];
        NSString *selectCityNo   = [TYUserDefaults objectForKey:JLGSelectCityNo];
        NSString *selecCityName = [TYUserDefaults objectForKey:JLGSelectCityName];
        
        _workTypeModel.cityNameID = selectCityNo;
        _workTypeModel.cityName = selecCityName;
        
        //    首次为我的工种
        _workTypeModel.type_name = @"我的工种";
        _workTypeModel.type_id = 0;
        _workTypeModel.is_all_area = @"1";//首次进来查看全国数据
        _workTypeModel.workTypeID = [NSString stringWithFormat:@"%@",@(self.workTypeModel.type_id)];
    }
    return _workTypeModel;
}
//
//- (void)setPageNum:(NSInteger)pageNum {
//    _pageNum = pageNum;
//    if (_pageNum == 3) {
//        //1.4.4该界面如果没有登录就直接弹出登录框
//        SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
//        IMP imp = [self.navigationController methodForSelector:checkIsLogin];
//        BOOL (*func)(id, SEL) = (void *)imp;
//        if (func(self.navigationController, checkIsLogin)) {
//           [self.tableView.mj_footer endRefreshing];
//        }
//    }
//}

@end
