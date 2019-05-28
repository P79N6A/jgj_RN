//
//  JGJKnowRepoChildVc.m
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowRepoChildVc.h"
#import "JGJknowRepoChildVcCell.h"
#import "JGJKonwRepoWebViewVc.h"
#import "JGJKnowRepoSortVc.h"
#import "NSString+Extend.h"
#import "MJRefresh.h"
#import "CFRefreshStatusView.h"

#import "JGJCustomPopView.h"

#import "AFNetworkReachabilityManager.h"

@interface JGJKnowRepoChildVc () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJKnowBaseGetFileRequestModel *knowBaseGetFileRequestModel;

@property (nonatomic, strong) NSMutableArray *knowRepos;

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseFileModel;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseCollecRequestModel;//知识库收藏，取消搜藏模型

@property (nonatomic, strong) JGJKnowBaseModel *cancelCollknowBaseModel; //保存取消收藏的知识库模型，只要已取消,这边就刷新状态

@end

@implementation JGJKnowRepoChildVc

@synthesize knowRepos = _knowRepos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    [TYNotificationCenter addObserver:self selector:@selector(handleClickedCancelKnowBase:) name:@"ClickedCancelKnowBase" object:nil];
    
    [self knowRepoChildVcFreshNetData];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //回来刷新的目的是进入查看页面可能改变了收藏状态
    [self.tableView reloadData];
    
    self.view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);

}

#pragma mark - 取消了保存的数据
- (void)handleClickedCancelKnowBase:(NSNotification *)notification {
    
    self.cancelCollknowBaseModel = notification.object;
    
    [self knowRepoChildVcFreshCurrentData];
    
}

- (void)knowRepoChildVcFreshNetData {
    
    self.knowBaseRequestModel.id = self.knowBaseModel.knowBaseId;
    
    if (self.knowRepos.count > 0) {
        
        JGJKnowBaseModel *knowBaseModel = [self.knowRepos lastObject];
        
        self.knowBaseRequestModel.last_file_id = knowBaseModel.knowBaseId;
    }
    
    if (!self.isRepeatClickChildVc) {
        
         [self loadNetData];   
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.knowRepos.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJknowRepoChildVcCell *cell = [JGJknowRepoChildVcCell cellWithTableView:tableView];
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
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
    
    JGJKnowRepoSortVc *knowRepoSortVc = [JGJKnowRepoSortVc new];
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    self.selectedIndexPath = indexPath;
    
    if (knowBaseModel.isDownLoadSuccess) { //下载完成的进入下级页面查看
        
        JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
        
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

- (void)setKnowBaseFileModel:(JGJKnowBaseModel *)knowBaseFileModel {

    _knowBaseFileModel = knowBaseFileModel;
    
    if (![NSString isEmpty:knowBaseFileModel.file_path]) {
        
        [self handleCheckFileDidSelectRowAtIndexPath:self.selectedIndexPath knowBaseModel:knowBaseFileModel];
    }
    
}

#pragma amrk - 加载网络数据
- (void)loadNetData {
    
    if (self.knowRepos.count > 0) {
        
        JGJKnowBaseModel *knowBaseModel = [self.knowRepos lastObject];
        
        self.knowBaseRequestModel.last_file_id = knowBaseModel.knowBaseId;
    }

    NSDictionary *parameter = [self.knowBaseRequestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getColumnList" parameters:parameter success:^(id responseObject) {
       
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
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }

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

- (void)setKnowRepos:(NSMutableArray *)knowRepos {

    _knowRepos = knowRepos;
    
    self.knowBaseRequestModel.pg++; //增加分页数
    
    [self knowRepoChildVcFreshCurrentData];
    
}

- (NSMutableArray *)knowRepos {

    if (!_knowRepos) {
        
        _knowRepos = [NSMutableArray new];
    }
    
    return _knowRepos;

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

- (void)handleCheckFileDidSelectRowAtIndexPath:(NSIndexPath *)indexPath knowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    

    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

    __weak typeof(self) weakSelf = self;
        
    TYLog(@"下载开始------------");
    [JLGHttpRequest_AFN downloadWithUrl:knowBaseModel.file_path saveToPath:filePath downModel:knowBaseModel progress:^(int64_t bytesRead, int64_t totalBytesRead){
        
        JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
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

        [weakSelf.tableView beginUpdates];
    
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
        [weakSelf.tableView endUpdates];
    
        
        } success:^(id response) {
            
             TYLog(@"下载结束------------");
            
            TYLog(@"response======%@", response);
            
        } failure:^(NSError *error) {
            
            
            TYLog(@"error======%@", error);
        }];
    
    }else {
        
        TYLog(@"已经有该文件了");
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    return [JGJknowRepoChildVcCell knowRepoChildVcCellHeight];
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    return knowBaseModel.cellHeight;

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

- (JGJKnowBaseGetFileRequestModel *)knowBaseGetFileRequestModel {

    
    if (!_knowBaseGetFileRequestModel) {
        
        _knowBaseGetFileRequestModel = [JGJKnowBaseGetFileRequestModel new];
    }

    return _knowBaseGetFileRequestModel;
}

- (JGJKnowBaseRequestModel *)knowBaseCollecRequestModel {


    if (!_knowBaseCollecRequestModel) {
        
        _knowBaseCollecRequestModel = [JGJKnowBaseRequestModel new];
        
    }
    
    return _knowBaseCollecRequestModel;
}

- (void)dealloc {

    [TYNotificationCenter removeObserver:self];
    
}

@end
