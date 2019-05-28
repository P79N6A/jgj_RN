//
//  JGJWorkerHeaderListVC.m
//  mix
//
//  Created by celion on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerHeaderListVC.h"
#import "JGJWorkerHeaderListCell.h"
#import "JGJWorkerheaderDetailVC.h"
#import "JLGFHLeaderModel.h"
#import "JGJNoManageProDefaultTableViewCell.h"

@implementation FHLeaderWorktypeCity

- (void)setCityNameID:(NSString *)cityNameID{
    _cityNameID = cityNameID;
}
@end

#define Roles @[@"2", @"1"] //2表示班组长 1表示工人 


@interface JGJWorkerHeaderListVC ()
<
    JGJNoManageProDefaultTableViewCellDelegate
>

@property (strong, nonatomic) CityMenuView *cityMenuView;
@property (strong, nonatomic) JGJWorkTypeSelectedView *workTypeSelectedView;
@property (weak, nonatomic) IBOutlet UIImageView *cityFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *workTypeFlagImageView;

@end

@implementation JGJWorkerHeaderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataSource.count?:1;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count == 0 && indexPath.row == 0) {
        JGJNoManageProDefaultTableViewCell *noManageProDefaultCell = [JGJNoManageProDefaultTableViewCell cellWithTableView:tableView];
        NSString *role = [self.workTypeModel.roleStr isEqualToString:@"2"] ? @"班组长" : @"工人";
        noManageProDefaultCell.titleProLabel.text = [NSString stringWithFormat:@"该区域还没有%@", role];
        noManageProDefaultCell.subTitleLabel.text = @"去其它城市看看吧";
        noManageProDefaultCell.findJobButton.hidden = YES;
        noManageProDefaultCell.delegate = self;
        return noManageProDefaultCell;
    }
    
    JGJWorkerHeaderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGJWorkerHeaderListCell" forIndexPath:indexPath];
    JLGFHLeaderDetailModel *jlgFHLeaderDetailModel = self.dataSource[indexPath.row];
    jlgFHLeaderDetailModel.roleType = self.workTypeModel.roleStr;
    cell.jlgFHLeaderDetailModel = jlgFHLeaderDetailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0 && indexPath.row == 0) {
        return  TYGetViewH(tableView);
    }
    
    if (self.dataSource.count == 0) {
        return  TYGetViewH(tableView);
    }
    
    if (indexPath.row > self.dataSource.count) {
        return 0;
    }
    
    JLGFHLeaderDetailModel *leaderDetailModel = self.dataSource[indexPath.row];
    CGFloat rowHeight =  [leaderDetailModel.roleType isEqualToString:@"1"] ? 130 : 120;
    return rowHeight+ leaderDetailModel.worktypeViewH - ( leaderDetailModel.friendcount == 0 ? 33 : 0) - ( [leaderDetailModel.roleType isEqualToString:@"1"] ? 20 : 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJWorkerheaderDetailVC *deatilVC = [[UIStoryboard storyboardWithName:@"WorkerheaderDetailStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWorkerheaderDetailVC"];
    deatilVC.jlgFHLeaderDetailModel = self.dataSource[indexPath.row];
    deatilVC.roletype = self.workTypeModel.roleStr;
    if (self.delegate && [self.delegate respondsToSelector:@selector(WorkerHeaderList:pushVc:)]) {
        [self.delegate WorkerHeaderList:self pushVc:deatilVC];
    }else{
        [self.navigationController pushViewController:deatilVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)loadNetMoreData {
    [self JLGHttpRequest];
}

- (void)loadNetData {
    self.pageNum = 1;
    [self.dataSource removeAllObjects];
    [self JLGHttpRequest];
}

- (void)JLGHttpRequest{
    NSDictionary *parameters = @{
                                 @"role_type" : self.workTypeModel.roleStr?:[NSNull null],
                                 @"cityno" : self.workTypeModel.cityNameID?:[NSNull null],
                                 @"worktype" : self.workTypeModel.workTypeID?:[NSNull null],
                                 @"pg" : @(self.pageNum),
                                 @"pagesize" : @"10"
                                 };
    
//    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/findworker" parameters:parameters success:^(NSArray *responseObject) {
        CGFloat lineMaxWidth = TYGetUIScreenWidth - 24;
        NSMutableArray <JLGFHLeaderDetailModel *>*dataArr = [JLGFHLeaderDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [dataArr enumerateObjectsUsingBlock:^(JLGFHLeaderDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.lineMaxWidth = lineMaxWidth;
        }];
        
        if (dataArr.count > 0) {
            ++self.pageNum;
            [self.dataSource addObjectsFromArray:dataArr];
        }

        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
//        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
//        [TYLoadingHub hideLoadingView];
    }];
}
- (void)commonSet {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNetMoreData)];

    [self.workTypeButton setTitle:self.workTypeModel.type_name forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.workTypeModel.roleStr) {
        self.workTypeModel.roleStr = Roles[self.view.tag - 1];
    }
    [self.tableView.mj_header beginRefreshing];
}

//#pragma Mark - JGJWorkTypeCollectionViewDelegate
//- (void)didClickedCancelButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView {
    //    self.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
//}

#pragma mark - 查看新项目
- (void )noManageProFindPro:(JGJNoManageProDefaultTableViewCell *)noManageProDefaultCell{
    UIViewController *findProVc = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"findJobAndPro"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(WorkerHeaderList:pushVc:)]) {
        [self.delegate WorkerHeaderList:self pushVc:findProVc];
    }else{
        [self.navigationController pushViewController:findProVc animated:YES];
    }
}

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
        _workTypeModel.type_name = @"全部工种";
        _workTypeModel.type_id = 0;

        _workTypeModel.workTypeID = [NSString stringWithFormat:@"%@",@(self.workTypeModel.type_id)];
    }
    return _workTypeModel;
}

@end
