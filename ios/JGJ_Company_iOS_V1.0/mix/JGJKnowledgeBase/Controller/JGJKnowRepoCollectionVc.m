//
//  JGJKnowRepoCollectionVc.m
//  mix
//
//  Created by yj on 17/4/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowRepoCollectionVc.h"
#import "JGJknowRepoChildVcCell.h"
#import "JGJKonwRepoWebViewVc.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJCustomPopView.h"

#import "CFRefreshStatusView.h"

@interface JGJKnowRepoCollectionVc () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *knowRepos;

//@property (nonatomic, strong) JGJKnowBaseCollecRequestModel *collecRequestModel;

@property (nonatomic, strong) JGJKnowBaseGetFileRequestModel *knowBaseGetFileRequestModel;

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseFileModel;

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseCollecRequestModel;//知识库收藏，取消搜藏模型

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation JGJKnowRepoCollectionVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonSet];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadNetData];
    
}

- (void)commonSet {
    
    self.title = @"资料收藏夹";
    self.view.backgroundColor = AppFontf1f1f1Color;
    [self.view addSubview:self.tableView];
    
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
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    self.selectedIndexPath = indexPath;
    
    if (knowBaseModel.isDownLoadSuccess) { //下载完成的进入下级页面查看
        
        JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
        
        webViewVc.title = knowBaseModel.file_name;
        
        webViewVc.knowBaseModel = knowBaseModel;
        
        [self.navigationController pushViewController:webViewVc animated:YES];
        
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


- (void)swipeableTableViewCell:(JGJknowRepoChildVcCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    self.knowBaseCollecRequestModel.id = cell.knowBaseModel.knowBaseId;
    
    //已经是收藏的情况，点击取消收藏，否则就是搜藏 @"2" 取消收藏 @"1"收藏
    self.knowBaseCollecRequestModel.class_type = @"2";
    
    NSDictionary *parameters = [self.knowBaseCollecRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/handleCollectionFile" parameters:parameters success:^(id responseObject) {
        
        NSString *tips = cell.knowBaseModel.is_collection ? @"已从资料收藏夹移除" : @"已加入到资料收藏夹";
        
        cell.knowBaseModel.is_collection = !cell.knowBaseModel.is_collection;
        
        if (!cell.knowBaseModel.is_collection) {
            
             [TYNotificationCenter postNotificationName:@"ClickedCancelKnowBase" object:cell.knowBaseModel];
            
            [self.knowRepos removeObject:cell.knowBaseModel];
            
            [self showDefaultNoKnowBase:self.knowRepos];
            
//            NSIndexPath *indxPath = [self.tableView indexPathForCell:cell];
//            
//            [self.tableView beginUpdates];
//            
//            [self.tableView deleteRowsAtIndexPaths:@[indxPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//            [self.tableView endUpdates];
        }
        
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

- (void)handleCheckFileDidSelectRowAtIndexPath:(NSIndexPath *)indexPath knowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        __weak typeof(self) weakSelf = self;
        
        [JLGHttpRequest_AFN downloadWithUrl:knowBaseModel.file_path saveToPath:filePath downModel:knowBaseModel progress:^(int64_t bytesRead, int64_t totalBytesRead) {
            
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
            
            
            TYLog(@"response======%@", response);
            
        } failure:^(NSError *error) {
            
            
            TYLog(@"error======%@", error);
        }];
        
    }else {
        
        TYLog(@"已经有该文件了");
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
            
            self.knowBaseFileModel = [downFiles firstObject];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    return knowBaseModel.cellHeight;
    
}

#pragma amrk - 加载网络数据
- (void)loadNetData {
    
    NSDictionary *parameter = [self.knowBaseCollecRequestModel mj_keyValues];
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/getCollectionFile" parameters:parameter success:^(id responseObject) {
        
        TYLog(@"=========%@", responseObject);
        
        self.knowRepos = [JGJKnowBaseModel mj_objectArrayWithKeyValuesArray:responseObject];
        [TYLoadingHub hideLoadingView];
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

- (void)setKnowRepos:(NSMutableArray *)knowRepos {
    
    _knowRepos = knowRepos;
    
    if (_knowRepos.count == 0) {
        
        [self showDefaultNoKnowBase:_knowRepos];
    }
    
    for (JGJKnowBaseModel *knowBaseModel in _knowRepos) {
        
        knowBaseModel.is_collection = YES; //收藏列表全部是收藏状态
        
        knowBaseModel.knowBaseCellType = KnowBaseCollecCellType; //当前类型是收藏
        
        NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",knowBaseModel.file_name, knowBaseModel.file_type];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            knowBaseModel.progress = 1;
            
            knowBaseModel.localFilePath = filePath;
            
            knowBaseModel.isDownLoadSuccess = YES;
        }
    }
    
    [self.tableView reloadData];

}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

//- (JGJKnowBaseCollecRequestModel *)collecRequestModel {
//
//    if (!_collecRequestModel) {
//        
//        _collecRequestModel = [JGJKnowBaseCollecRequestModel new];
//        
//        _collecRequestModel.timestamp = [NSDate date].timestamp;
//    }
//    
//    return _collecRequestModel;
//
//}

- (JGJKnowBaseGetFileRequestModel *)knowBaseGetFileRequestModel {
    
    
    if (!_knowBaseGetFileRequestModel) {
        
        _knowBaseGetFileRequestModel = [JGJKnowBaseGetFileRequestModel new];
    }
    
    return _knowBaseGetFileRequestModel;
}

- (JGJKnowBaseRequestModel *)knowBaseCollecRequestModel {
    
    if (!_knowBaseCollecRequestModel) {
        
        _knowBaseCollecRequestModel = [JGJKnowBaseRequestModel new];
        
        _knowBaseCollecRequestModel.pg = 1;
        
        _knowBaseCollecRequestModel.pagesize = 20;
    }
    
    return _knowBaseCollecRequestModel;
}



@end
