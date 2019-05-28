//
//  JGJKnowRepoVc.m
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowRepoVc.h"
#import "JGJKnowRepoChildVc.h"
#import "TYTextField.h"
#import "UIView+GNUtil.h"
#import "JGJSearchResultView.h"
#import "NSString+Extend.h"
#import "JGJKnowRepoCollectionVc.h"
#import "JGJKonwRepoWebViewVc.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJCustomPopView.h"

#import "JGJKnowBaseTypeSelCell.h"

#import "JGJWebAllSubViewController.h"

#import "JGJKnowRepoSortVc.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJKnowRepoDownLoadVc.h"

#define TitleHeight 40.0

static NSString *const CellID = @"JGJKnowBaseTypeSelCell";

@interface JGJKnowRepoVc () <JGJSearchResultViewdelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *childs; //子控制器
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) UIButton *searchButton;
@property (weak, nonatomic) UIButton *collecButton;
@property (strong, nonatomic) UIView *rightNavView;
@property (strong, nonatomic) UIView *contentSearchBarView;
@property (strong ,nonatomic) JGJSearchResultView *searchResultView;

@property (strong, nonatomic) NSArray *knowRepos; //存储数据

@property (strong, nonatomic) NSArray *topTitleModels; //顶部标题模型

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseRequestModel;

@property (nonatomic, strong) JGJKnowBaseRequestModel *searchRequestModel; //搜索请求模型

@property (nonatomic, strong) JGJKnowBaseGetFileRequestModel *knowBaseGetFileRequestModel;

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseFileModel;

@property (nonatomic, strong) JGJKnowRepoChildVc *curSelChildVc; //当前选择的子控制器

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JGJKnowRepoVc

@synthesize topTitleModels = _topTitleModels;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"资料库";
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewDataBaseType;
    
    titleView.title = @"资料库";
    
    self.navigationItem.titleView = titleView;
    
    //设置导航栏
    [self setNavigationButtonItem];
    
    [self loadNetData];
    
    //搜索的文件和正在下载的文件显示进度
    [TYNotificationCenter addObserver:self selector:@selector(handleDownFile:) name:@"downFileNotification" object:nil];

    [self commonSet];
}


- (void)commonSet {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJKnowBaseTypeSelCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    
    CGFloat itemW = TYGetUIScreenWidth / 2.0;
    
    CGFloat itemH = 55.0;
    
    self.collectionViewLayout.itemSize = CGSizeMake(itemW, itemH);

    self.collectionViewLayout.minimumInteritemSpacing = 0;
    
    self.collectionViewLayout.minimumLineSpacing = 0;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self removeSearchResultView];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topTitleModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJKnowBaseTypeSelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    JGJKnowBaseModel *knowBaseModel = self.topTitleModels[indexPath.row];

    cell.knowBaseModel = knowBaseModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJKnowBaseModel *knowBaseModel = self.topTitleModels[indexPath.row];
    
    //下载列表
    if ([knowBaseModel.type isEqualToString:@"3"]) {
        
        JGJKnowRepoDownLoadVc *downloadVc = [[JGJKnowRepoDownLoadVc alloc] init];
        
        [self.navigationController pushViewController:downloadVc animated:YES];
        
    }else
    
    //0:文件；1：表示收藏夹；2：资料那些事
    if ([knowBaseModel.type isEqualToString:@"1"]) {
    
        knowBaseModel.knowBaseCellType = KnowBaseCollecCellType;
        
        [self handleCollecButtonPressed:nil];

    }else if ([knowBaseModel.type isEqualToString:@"2"]) {
    
        NSString *topic = [NSString stringWithFormat:@"dynamic/topic?topic_name=%@",knowBaseModel.file_name];
        
        NSString *dataStr = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL, topic];
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:dataStr];
        
        [webVc addTopCusNav];
        
        [self.navigationController pushViewController:webVc animated:YES];

    }else {
        
        //2.3.2 统一使用分类控制器
        JGJKnowRepoSortVc *knowRepoSortVc = [JGJKnowRepoSortVc new];
        
        knowRepoSortVc.knowBaseModel = knowBaseModel;
        
        [self.navigationController pushViewController:knowRepoSortVc animated:YES];
        
    }
    
}


#pragma mark - 设置导航栏按钮
- (void)setNavigationButtonItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"knowBase_Search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSearchButtonPressed:)];
}

- (void)setLeftBatButtonItem {


    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

#pragma mark - 隐藏导航栏，显示搜索栏
- (void)setAddSearchBarItem {
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)searchValueChange:(NSString *)value {

    self.searchResultView.searchValue = value; //需要变色的文字
    
    self.searchResultView.resultViewType = JGJSearchKnowBaseNoRusultFileType;
    
    self.searchResultView.searchResultDefaultCellType = JGJKnowBaseSearchingResultDefaultCellType;
    
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

#pragma mark - 收藏按钮按下
- (void)handleCollecButtonPressed:(UIButton *)button {
    
    if (![self checkIsLogin]) {
        
        return;
    }
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;

    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
    }

    JGJKnowRepoCollectionVc *collecVc = [JGJKnowRepoCollectionVc new];
    
    [self.navigationController pushViewController:collecVc animated:YES];

}



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

#pragma mark - 搜索按钮按下
- (void)handleSearchButtonPressed:(UIButton *)button {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
    }

    [self setAddSearchBarItem];
    
    self.searchResultView.results = @[];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    if (![self.view.subviews containsObject:self.searchResultView]) {
        
        [self.view addSubview:self.searchResultView];
    }

}

#pragma mark - 取消按钮按下
- (void)handleCancelButtonPressedAction {
    
    [self setNavigationButtonItem];
    
    [self setLeftBatButtonItem];
    
    [self.curSelChildVc knowRepoChildVcFreshNetData];
    
   [self removeSearchResultView];
    
    self.searchResultView = nil;
}

- (void)removeSearchResultView {
    
    if([self.view.subviews containsObject:self.searchResultView]){
        [self.searchResultView removeFromSuperview];
    }
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)backButtonPressed:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopTitleModels:(NSArray *)topTitleModels {

    _topTitleModels = topTitleModels;
    
//    JGJKnowBaseModel *downloadModel = [JGJKnowBaseModel new];
//    
//    downloadModel.file_name = @"已下载资料";
//    
//    downloadModel.knowBaseCellType = KnowBaseCollecDownloadType;
//    
//    NSMutableArray *typeModels = [[NSMutableArray alloc] init];
//    
//    [typeModels addObjectsFromArray:topTitleModels];
//    
//    [typeModels addObject:downloadModel];
//    
//    _topTitleModels = typeModels;

    [self.collectionView reloadData];

}

- (NSMutableArray *)childVcRequestModels {

    if (!_childVcRequestModels) {
        
        _childVcRequestModels = [NSMutableArray new];
        
    }
    
    return _childVcRequestModels;

}

- (JGJSearchResultView *)searchResultView {
    
        CGFloat searchResultViewY = TYIST_IPHONE_X ? 22 : 0;
    
    if (!_searchResultView) {
        
       JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - searchResultViewY}} showSearchView:YES];
        
        searchResultView.resultViewType = JGJSearchKnowBaseFileType;
        
        searchResultView.delegate = self;
        
        self.searchResultView = searchResultView;
        
        searchResultView.searchbar.searchBarTF.returnKeyType = UIReturnKeySearch;
        
        searchResultView.searchbar.searchBarTF.delegate = self;
        
    }
    return _searchResultView;
}

#pragma mark - JGJSearchResultViewDelegate
- (void)searchResultView:(JGJSearchResultView *)searchResultView clickedCancelButtonWithSearchBar:(JGJCustomSearchBar *)searchBar {
    
    [self handleCancelButtonPressedAction];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 搜索的文字改变
- (void)searchResultView:(JGJSearchResultView *)searchResultView searchBarWithChangeText:(NSString *)searchText {
    
    [self searchValueChange:searchText];
}

- (void)handleSelectedVc:(NSNotification *)notification {

    JGJKnowRepoChildVc *childVc = (JGJKnowRepoChildVc *)notification.object;
    
    self.curSelChildVc = childVc;
    
    TYLog(@"-------%@  knowBaseId======%@   childVcIndex ===%ld", notification.object, childVc.knowBaseModel.knowBaseId, childVc.knowBaseModel.childVcIndex);
    
    JGJKnowBaseRequestModel *knowBaseRequestModel = self.childVcRequestModels[childVc.knowBaseModel.childVcIndex];
    
    childVc.knowBaseRequestModel = knowBaseRequestModel;
        
    [childVc knowRepoChildVcFreshNetData];
    
}

- (void)handleRepeatSelectedVc:(NSNotification *)notification {

    JGJKnowRepoChildVc *childVc = (JGJKnowRepoChildVc *)notification.object;
    
    childVc.isRepeatClickChildVc = YES;

}

#pragma mark - JGJSearchResultViewdelegate
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    [self.view endEditing:YES];
    
    if (searchResultView.resultViewType == JGJSearchKnowBaseNoRusultFileType) {
        
        TYLog(@"点击输入的文字");
        
        [self handleSearchFile:searchResultView.searchValue];
        
    }else if (searchResultView.resultViewType == JGJSearchKnowBaseFileType) {
    
        TYLog(@"点击搜索结果");
        
        if (knowBaseModel.isDownLoadSuccess) {
            
            [self handleCancelButtonPressedAction];
            
            JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
            
            webViewVc.title = knowBaseModel.file_name;
            
            webViewVc.knowBaseModel = knowBaseModel;
            
            [self.navigationController pushViewController:webViewVc animated:YES];

            
        }else {
            
            //下载中
            if (knowBaseModel.progress > 0 && knowBaseModel.progress < 1) {
                
                return;
            }
        
//            [self getFilePath:knowBaseModel];
            
            [self checkNetStatusGetFilePath:knowBaseModel];
            
        }
    }

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
    
    TYLog(@"11111上传参数===%@", parameter);
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getFileContent" parameters:parameter success:^(id responseObject) {
        
        TYLog(@"=========%@", responseObject);
        
        NSArray *downFiles = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (downFiles.count > 0) {
            
            JGJKnowBaseModel *downknowBaseModel = [downFiles firstObject];
            
            knowBaseModel.file_path = downknowBaseModel.file_path;
            
            self.knowBaseFileModel = knowBaseModel;
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
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
        
        TYLog(@"下载开始------------");
        
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
                
                [self.navigationController pushViewController:webViewVc animated:YES];
            }
            
            if (self.searchResultView.results.count > 0) {
                
                [self.searchResultView.tableView beginUpdates];
                
                [self.searchResultView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.searchResultView.tableView endUpdates];
                
            }
            
            
//            [self.searchResultView.tableView reloadData];
        } success:^(id response) {
            
            TYLog(@"下载结束------------");
            
            TYLog(@"response======%@", response);
            
            knowBaseModel.isDownLoadSuccess = YES;
            
            
        } failure:^(NSError *error) {
            
            
            TYLog(@"error======%@", error);
        }];
        
    }else {
        
        TYLog(@"已经有该文件了");
    }
    
}

- (void)loadNetData {
    
    NSDictionary *parameter = [self.knowBaseRequestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getColumnList" parameters:parameter success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        self.topTitleModels = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (JGJKnowBaseRequestModel *)knowBaseRequestModel {
    
    if (!_knowBaseRequestModel) {
        
        _knowBaseRequestModel = [JGJKnowBaseRequestModel new];
        _knowBaseRequestModel.pg = 1;
        _knowBaseRequestModel.pagesize = 10;
        _knowBaseRequestModel.id = @"0";
    }
    
    return _knowBaseRequestModel;
}

- (JGJKnowBaseRequestModel *)searchRequestModel {

    if (!_searchRequestModel) {
        
        _searchRequestModel = [JGJKnowBaseRequestModel new];
    }

    return _searchRequestModel;

}

- (JGJKnowBaseGetFileRequestModel *)knowBaseGetFileRequestModel {
    
    
    if (!_knowBaseGetFileRequestModel) {
        
        _knowBaseGetFileRequestModel = [JGJKnowBaseGetFileRequestModel new];
    }
    
    return _knowBaseGetFileRequestModel;
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

@end
