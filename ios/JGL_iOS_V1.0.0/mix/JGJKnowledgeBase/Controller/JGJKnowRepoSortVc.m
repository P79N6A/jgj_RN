//
//  JGJKnowRepoSortVc.m
//  mix
//
//  Created by yj on 17/4/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowRepoSortVc.h"
#import "JGJknowRepoChildVcCell.h"
#import "JGJKonwRepoWebViewVc.h"
#import "NSString+Extend.h"
#import "UIView+GNUtil.h"
#import "MJRefresh.h"
#import "CFRefreshStatusView.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJCustomPopView.h"

#import "JGJknowledgeDownloadTool.h"

#define SearchbarHeight 48

@interface JGJKnowRepoSortVc () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGJSearchResultViewdelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;
@property (strong ,nonatomic) JGJSearchResultView *searchResultView;
@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseRequestModel;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) JGJKnowBaseGetFileRequestModel *knowBaseGetFileRequestModel;

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseCollecRequestModel;//知识库收藏，取消搜藏模型

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseFileModel;

@property (nonatomic, strong) JGJKnowBaseRequestModel *searchRequestModel; //搜索请求模型

@property (nonatomic, assign) BOOL isSearchStatus; //当前是搜索状态

@property (nonatomic, strong) JGJKnowBaseModel *cancelCollknowBaseModel; //保存取消收藏的知识库模型，只要已取消,这边就刷新状态
@end

@implementation JGJKnowRepoSortVc

@synthesize knowRepos = _knowRepos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self commonSet];
    
    [self initialSet];
}

#pragma makr - 子类重写
- (void)initialSet {
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    [self loadNetData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)commonSet {

    self.title = self.knowBaseModel.file_name;
    
    [self searchbar];
    
    [self.view addSubview:self.tableView];
    
    [TYNotificationCenter addObserver:self selector:@selector(handleClickedCancelKnowBase:) name:@"ClickedCancelKnowBase" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    //回复原状
    [self handleSearchBarViewMoveDown];
}

#pragma mark - 取消了保存的数据
- (void)handleClickedCancelKnowBase:(NSNotification *)notification {
    
    self.cancelCollknowBaseModel = notification.object;
    
    [self knowRepoChildVcFreshCurrentData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.knowRepos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self registerCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)registerCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JGJknowRepoChildVcCell *cell = [JGJknowRepoChildVcCell cellWithTableView:tableView];
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    knowBaseModel.knowBaseIndexPath = indexPath;
    
    cell.knowBaseModel = knowBaseModel;
    
    cell.lineView.hidden = indexPath.row == self.knowRepos.count - 1;
    
    //左滑按钮
    
    if (![knowBaseModel.file_type isEqualToString:@"dir"]) {
        
        cell.rightUtilityButtons = [self handleCollecFileWithKnowBaseModel:knowBaseModel];
        
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self registerCellTableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

- (void)registerCellTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    JGJKnowRepoSortVc *knowRepoSortVc = [JGJKnowRepoSortVc new];
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    self.selectedIndexPath = indexPath;
    
    if (knowBaseModel.isDownLoadSuccess) { //下载完成的进入下级页面查看
        
        JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
        
        webViewVc.isHiddenColleclBtn = [self isHiddenColleclBtn];
        
        webViewVc.title = knowBaseModel.file_name;
        
        webViewVc.knowBaseModel = knowBaseModel;
        
        [self.navigationController pushViewController:webViewVc animated:YES];
        
    }else if ([knowBaseModel.file_type isEqualToString:@"dir"]) { //文件夹进入下级页面
        
        knowRepoSortVc.knowBaseModel = knowBaseModel;
        
        [self.navigationController pushViewController:knowRepoSortVc animated:YES];
        
    }else { //没下载的和文件类型进入下载页面
        
        //下载中
        if (knowBaseModel.progress > 0 && knowBaseModel.progress < 1) {
            
            return;
        }
        
        [self checkNetStatusGetFilePath:knowBaseModel];
        
        
    }
}

#pragma mark - 子类使用下载列表进入不显示收藏按钮
-(BOOL)isHiddenColleclBtn{
    
    return NO;
}

- (void)checkNetStatusGetFilePath:(JGJKnowBaseModel *)knowBaseModel {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            
            TYLog(@"AFNetworkReachabilityStatusUnknown");
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            
            [TYShowMessage showPlaint:@"当前网络不可用"];
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popDetail = @"你现在没有连接WiFi，查看文档会消耗较多流量。你确定要继续查看文档吗？";
            desModel.popTextAlignment = NSTextAlignmentLeft;
            
            __weak typeof(self) weakSelf = self;
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.onOkBlock = ^{
                
                [weakSelf getFilePath:knowBaseModel];
                
            };
        }
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            
            [self getFilePath:knowBaseModel];
        }
            
            break;
        default:
            break;
    }
    
}


#pragma mark - 获取文件路径
- (void)getFilePath:(JGJKnowBaseModel *)knowBaseModel {
    
    self.knowBaseGetFileRequestModel.file_id = knowBaseModel.knowBaseId;
    
    NSDictionary *parameter = [self.knowBaseGetFileRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getFileContent" parameters:parameter success:^(id responseObject) {
        
        NSArray *downFiles = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (downFiles.count > 0) {
            
            JGJKnowBaseModel *getFileknowBaseModel = [downFiles firstObject];
            
            knowBaseModel.file_path = getFileknowBaseModel.file_path;
            
            self.knowBaseFileModel = knowBaseModel;
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)swipeableTableViewCell:(JGJknowRepoChildVcCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (![self checkIsLogin]) {
        
        return ;
    }
    
    self.knowBaseCollecRequestModel.id = cell.knowBaseModel.knowBaseId;
    
    //已经是收藏的情况，点击取消收藏，否则就是搜藏 @"2" 取消收藏 @"1"收藏
    self.knowBaseCollecRequestModel.class_type = cell.knowBaseModel.is_collection ? @"2" : @"1";
    
    NSDictionary *parameters = [self.knowBaseCollecRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/handleCollectionFile" parameters:parameters success:^(id responseObject) {
        
        NSString *tips = cell.knowBaseModel.is_collection ? @"已从资料收藏夹移除" : @"已加入到资料收藏夹";
        
        cell.knowBaseModel.is_collection = !cell.knowBaseModel.is_collection;
        
//        NSIndexPath *indxPath = [self.tableView indexPathForCell:cell];
//        
//        [self.tableView beginUpdates];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[indxPath] withRowAnimation:UITableViewRowAnimationNone];
//        
//        [self.tableView endUpdates];
        
        [TYShowMessage showSuccess:tips];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(JGJknowRepoChildVcCell *)cell didScroll:(UIScrollView *)scrollView {
    
    BOOL isHiddenLeftButton = cell.knowBaseModel.progress > 0 && cell.knowBaseModel.progress < 1;
    
    if (isHiddenLeftButton) {
        
        scrollView.contentOffset = CGPointMake(0, 0);
        
        return;
    }
    
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(JGJknowRepoChildVcCell *)cell {
    
    return  YES;
}

#pragma mark - 收藏、取消收藏
- (NSArray *)handleCollecFileWithKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    NSString *collecStr = knowBaseModel.is_collection ? @"取消收藏" : @"收藏";
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    UIColor *rightButtonColor = knowBaseModel.is_collection ? AppFontC7C7CBColor : AppFontF1A039Color;
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     rightButtonColor title:collecStr];
    
    return rightUtilityButtons;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

   return [self registerCellTableView:tableView heightForRowAtIndexPath:indexPath];
    
}

- (CGFloat)registerCellTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    return knowBaseModel.cellHeight;

}


- (void)setKnowBaseFileModel:(JGJKnowBaseModel *)knowBaseFileModel {
    
    _knowBaseFileModel = knowBaseFileModel;
    
    if (![NSString isEmpty:knowBaseFileModel.file_path]) {
        
        [self handleCheckFileDidSelectRowAtIndexPath:knowBaseFileModel.knowBaseIndexPath knowBaseModel:knowBaseFileModel];
    }
    
}

- (void)handleCheckFileDidSelectRowAtIndexPath:(NSIndexPath *)indexPath knowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        __weak typeof(self) weakSelf = self;
        
        [JLGHttpRequest_AFN downloadWithUrl:knowBaseModel.file_path saveToPath:filePath downModel:knowBaseModel progress:^(int64_t bytesRead, int64_t totalBytesRead) {
            
            CGFloat progress = 1.0 * bytesRead / totalBytesRead;
            
            knowBaseModel.progress = progress;
            
            if (progress == 1 && !knowBaseModel.isDownLoadSuccess) {
                
                [TYShowMessage showSuccess:[NSString stringWithFormat:@"%@读取完毕",knowBaseModel.file_name]];
                
                knowBaseModel.isDownLoadSuccess = YES;
                
                knowBaseModel.localFilePath = filePath;
                
                JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
                
                webViewVc.title = knowBaseModel.file_name;
                
                webViewVc.knowBaseModel = knowBaseModel;
                
                [weakSelf.navigationController pushViewController:webViewVc animated:YES];
            }
            
            if (self.searchResultView.results.count > 0) {
                
                [weakSelf.searchResultView.tableView beginUpdates];
                
                [weakSelf.searchResultView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [weakSelf.searchResultView.tableView endUpdates];
                
            }else {
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [weakSelf.tableView endUpdates];
            }

            
        } success:^(id response) {
            
            TYLog(@"response======%@", response);
            
        } failure:^(NSError *error) {
           
            TYLog(@"error======%@", error);
        }];
        
    }else {
        
        TYLog(@"已经有该文件了");
    }
    
}

- (JGJCustomSearchBar *)searchbar {

    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        _searchbar.hidden = [self isHiddenSearch];
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchbar.searchBarTF.delegate = self;
        _searchbar.searchBarTF.returnKeyType = UIReturnKeySearch;
        __weak typeof(self) weakSelf = self;
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
        
            [weakSelf searchValueChange:value];
        };
    
        _searchbar.handleButtonPressedBlcok = ^(JGJCustomSearchBar *searchBar){
        
            [weakSelf handleSearchBarViewMoveDown];
            
        };
        _searchbar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_searchbar];
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.right.equalTo(self.view);
            
            make.height.mas_equalTo(SearchbarHeight);
        }];
        
    }
    
    return _searchbar;

}

- (BOOL)isHiddenSearch {
    
    return YES;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, SearchbarHeight, TYGetUIScreenWidth, TYGetUIScreenHeight - SearchbarHeight - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (void)searchValueChange:(NSString *)value {
    
    [self handleSearchBarMoveTop];
    
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        
        [self.view addSubview:self.searchResultView];
        
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        
        [self.searchResultView removeFromSuperview];
    }

    self.searchResultView.searchValue = value; //需要变色的文字
    
    self.searchResultView.resultViewType = JGJSearchKnowBaseNoRusultFileType;
    
    self.searchResultView.searchResultDefaultCellType = JGJKnowBaseSearchingResultDefaultCellType;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self handleSearchBarMoveTop];
    
    return YES;
}
- (void)handleSearchBarMoveTop {
    
    [self.view addSubview:self.searchResultView];
    
    [self.searchResultView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.searchbar.mas_bottom).mas_offset(0);
        make.right.bottom.left.mas_equalTo(self.view);
    }];
    
    CGFloat offsetY = TYIST_IPHONE_X ? 44 : 20;
    
    [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).mas_offset(offsetY);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.searchbar.isShowSearchBarTop = YES;
        


        //上移_searchbar的问题
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.searchbar.mas_bottom).mas_offset(0);
            make.right.bottom.left.mas_equalTo(self.view);
        }];
        
        [self.view layoutIfNeeded];
    }];
}

- (void)handleSearchBarViewMoveDown {
    
    self.searchResultView.results = @[]; //恢复原状时清楚数据
    
    self.searchbar.searchBarTF.text = nil;
    [self.searchbar.searchBarTF resignFirstResponder];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = NO;
    self.searchbar.cancelButton.hidden = YES;
    
    self.searchbar.isShowSearchBarTop = NO;
    
    [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).mas_offset(0);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.searchResultView removeFromSuperview];
        
        [self.view layoutIfNeeded];
        
    }];
}

- (JGJSearchResultView *)searchResultView {
    CGFloat searchResultViewY = 0;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - 64}}];
        searchResultView.resultViewType = JGJSearchKnowBaseFileType;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

#pragma amrk - 加载网络数据
- (void)loadNetData {
    
    self.knowBaseRequestModel.id = self.knowBaseModel.knowBaseId;
    
    if (self.knowRepos.count > 0) {
        
        JGJKnowBaseModel *knowBaseModel = [self.knowRepos lastObject];
        
        self.knowBaseRequestModel.last_file_id = knowBaseModel.knowBaseId;
        
    }
    
    NSDictionary *parameter = [self.knowBaseRequestModel mj_keyValues];
    
    TYLog(@"11111上传参数===%@", parameter);
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getColumnList" parameters:parameter success:^(id responseObject) {
        
        TYLog(@"=========%@", responseObject);
        
        NSArray *knowRepos = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (knowRepos.count > 0) {
            
            [self.tableView.mj_footer endRefreshing];
            
            [self.knowRepos addObjectsFromArray:knowRepos];
            
            self.knowBaseRequestModel.pg++;
            
            [self knowRepoChildVcFreshCurrentData];
            
            [self.tableView reloadData];
            
        }
        
        if (knowRepos.count < 20) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.tableView.mj_footer = nil;
        }
        [TYLoadingHub hideLoadingView];
        //是否显示缺省页
        [self showDefaultNoKnowBase:self.knowRepos];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNoKnowBase:(NSArray *)knowBases {
    
    if (knowBases.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.view.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.equalTo(self.view);
            
            make.height.mas_equalTo(0);
        }];
        
        _tableView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
        
    }else {
    
        _searchbar.hidden = NO;
    }
    
}

#pragma mark - JGJSearchResultViewdelegate
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    [self.view endEditing:YES];
    
    if (searchResultView.resultViewType == JGJSearchKnowBaseNoRusultFileType) {
        
        TYLog(@"点击输入的文字");
        
        [self handleSearchFile:searchResultView.searchValue];
        
    }else if (searchResultView.resultViewType == JGJSearchKnowBaseFileType || searchResultView.resultViewType == JGJSearchKnowBaseDownloadType) {
        
        TYLog(@"点击搜索结果");
        
        if (knowBaseModel.isDownLoadSuccess) {
            
            //搜索结果点击回复原状
            [self handleSearchBarViewMoveDown];
            
            JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
            
            webViewVc.isHiddenColleclBtn = [self isHiddenColleclBtn];
            
            webViewVc.title = knowBaseModel.file_name;
            
            webViewVc.knowBaseModel = knowBaseModel;
            
            [self.navigationController pushViewController:webViewVc animated:YES];
            
            
        }else {
            
            //下载中
            if (knowBaseModel.progress > 0 && knowBaseModel.progress < 1) {
                
                return;
            }
            
            [self getFilePath:knowBaseModel];
        }
    }

    
}

#pragma mark - 处理搜索文件
- (void)handleSearchFile:(NSString *)value {
    
    self.searchRequestModel.file_name = value; //文件名字
    
    NSDictionary *parameters = [self.searchRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/searchFile" parameters:parameters success:^(id responseObject) {
        
        NSArray *results = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (results.count == 0) {
            
            //搜索知识库网络请求没有数据
            
            self.searchResultView.searchResultDefaultCellType = JGJKnowBaseNoResultDefaultCellType;
            
            //默认没有数据
            self.searchResultView.resultViewType = JGJSearchKnowBaseNoRusultFileType;
            
        }else {
            
            //有结果时
            
            self.searchResultView.resultViewType = JGJSearchKnowBaseFileType;
            
            for (JGJKnowBaseModel *knowBaseModel in results) {
                
                NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
                
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    
                    knowBaseModel.progress = 1;
                    
                    knowBaseModel.localFilePath = filePath;
                    
                    knowBaseModel.isDownLoadSuccess = YES;
                }
            }
            
            self.searchResultView.results = results;
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}



- (void)setKnowRepos:(NSMutableArray *)knowRepos {
    
    _knowRepos = knowRepos;
    
    self.knowBaseRequestModel.pg++; //增加分页数
    
    [self knowRepoChildVcFreshCurrentData];
    
}

#pragma mark - 知识库刷新现有数据
- (void)knowRepoChildVcFreshCurrentData {
    
    for (JGJKnowBaseModel *knowBaseModel in _knowRepos) {
        
        NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            knowBaseModel.progress = 1;
            
            knowBaseModel.localFilePath = filePath;
            
            knowBaseModel.isDownLoadSuccess = YES;
        }
        
        if ([self.cancelCollknowBaseModel.knowBaseId isEqualToString:knowBaseModel.knowBaseId]) {
            
            knowBaseModel.is_collection = self.cancelCollknowBaseModel.is_collection; //当前的收藏状态
        }
    }
    
    [self.tableView reloadData];
    
}

- (NSMutableArray *)knowRepos {
    
    if (!_knowRepos) {
        
        _knowRepos = [NSMutableArray new];
    }
    
    return _knowRepos;
    
}

- (JGJKnowBaseRequestModel *)knowBaseRequestModel {
    
    if (!_knowBaseRequestModel) {
        
        _knowBaseRequestModel = [JGJKnowBaseRequestModel new];
        _knowBaseRequestModel.pg = 1;
        _knowBaseRequestModel.pagesize = 20;
    }
    
    return _knowBaseRequestModel;
}

- (JGJKnowBaseGetFileRequestModel *)knowBaseGetFileRequestModel {
    
    
    if (!_knowBaseGetFileRequestModel) {
        
        _knowBaseGetFileRequestModel = [JGJKnowBaseGetFileRequestModel new];
    }
    
    return _knowBaseGetFileRequestModel;
}

- (JGJKnowBaseRequestModel *)searchRequestModel {
    
    if (!_searchRequestModel) {
        
        _searchRequestModel = [JGJKnowBaseRequestModel new];
    }
    
    return _searchRequestModel;
    
}

#pragma mark - 判断是否登录
-(BOOL)checkIsLogin{
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self handleSearchFile:self.searchResultView.searchValue];
    
    return YES;
}

- (void)handleDownFile:(NSNotification *)notification {
    
    JGJKnowBaseModel *downingknowBaseModel = notification.object;
    
    JGJKnowBaseModel *sameknowBaseModel = nil;
    
    if (self.searchResultView.results > 0) {
        
        for (JGJKnowBaseModel *knowBaseModel in self.searchResultView.results) {
            
            if ([knowBaseModel.knowBaseId isEqualToString:downingknowBaseModel.knowBaseId]) {
                
                knowBaseModel.progress = downingknowBaseModel.progress;
                
                knowBaseModel.isDownLoadSuccess = downingknowBaseModel.isDownLoadSuccess;
                
                sameknowBaseModel = knowBaseModel;
                
                break;
            }
            
        }
        
    }
    
    if (sameknowBaseModel) {
        
        [self.searchResultView.tableView beginUpdates];
        
        [self.searchResultView.tableView reloadRowsAtIndexPaths:@[sameknowBaseModel.knowBaseIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.searchResultView.tableView endUpdates];
    }
    
    
    TYLog(@"file_name========%@", downingknowBaseModel.file_name);
    
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

- (JGJKnowBaseRequestModel *)knowBaseCollecRequestModel {
    
    
    if (!_knowBaseCollecRequestModel) {
        
        _knowBaseCollecRequestModel = [JGJKnowBaseRequestModel new];
        
    }
    
    return _knowBaseCollecRequestModel;
}


@end
