//
//  JGJProiCloudTransferListVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudTransferListVc.h"

#import "JGJProiCloudTransListTopView.h"

#import "JGJQuaSafeOrderDefaultView.h"

#import "JGJProiCloudCreatFileView.h"

#import "JGJProiCloudTool.h"

#import "JGJProiCloudTransListCell.h"

#import "JGJProiCloud.h"

#import "JGJProiCloudShareVc.h"

#import "NSString+Extend.h"

#import "MJPhotoBrowser.h"

#import "MJPhoto.h"

#import "JGJProiCloudTool.h"

#import "JGJProiCloudDeleteTransferLIstVc.h"

#import "JGJProiCloudMediaVc.h"

typedef void(^HandleTaskProgressTimerBlock)();

@interface JGJProiCloudTransferListVc () <UITableViewDelegate, UITableViewDataSource, JGJProiCloudTransListCellDelegate,UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) JGJProiColoudGetTransFileListRequestModel *requestModel;

//中间数据库模型
@property (strong ,nonatomic) JGJProicloudModel *icloudModel;

//上传数据库模型
@property (strong ,nonatomic) JGJProicloudModel *upLoadicloudModel;

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *defaultView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (weak, nonatomic) IBOutlet JGJProiCloudTransListTopView *contentTopView;

//保存上传模型数组
@property (nonatomic, strong) NSMutableArray *taskLoadFileModels;

@property (nonatomic, strong) NSTimer *taskProgressTimer;

@property (nonatomic, copy) HandleTaskProgressTimerBlock handleTaskProgressTimerBlock;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, assign) ProiCloudDataBaseType baseType;


@end

@implementation JGJProiCloudTransferListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSekf = self;
    
    self.contentTopView.proiCloudTransListTopViewBlock = ^(ProiCloudTransListTopViewButtonType buttonType) {
      
        [weakSekf proiCloudTransListTopViewButtonType:buttonType];
    };
    
    self.baseType = ProiCloudDataBaseDownLoadType;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    JGJProicloudModel *icloudModel = [JGJProicloudModel new];
    
    JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
    
    icloudListModel.group_id = self.proListModel.group_id;
    
    icloudModel.list = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:self.baseType];
   
//    ProiCloudDataBaseDownLoadType = 0, //下载类型
//    
//    ProiCloudDataBaseUpLoadType = 1 //上传类型
    
    if (self.baseType == ProiCloudDataBaseUpLoadType) {
        
        
    }
    
    self.icloudModel = icloudModel;
    
    [TYNotificationCenter addObserver:self selector:@selector(proiCloudDownNotification:) name:JGJProiCloudDownFilesNotification object:nil];
    
    [TYNotificationCenter addObserver:self selector:@selector(proiCloudUpLoadNotification:) name:JGJProiCloudUpLoadFilesNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.icloudModel.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProiCloudTransListCell *cloudListCell = [JGJProiCloudTransListCell cellWithTableView:tableView];
    
    cloudListCell.delegate = self;
    
    JGJProicloudListModel *cloudListModel = self.icloudModel.list[indexPath.row];
    
    cloudListModel.indexPath = indexPath;
    
    cloudListModel.cloudListCellType = ProicloudListDefaultCellType;
    
    cloudListCell.baseType = self.baseType;

    cloudListCell.cloudListModel = cloudListModel;
    
    return cloudListCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProicloudListModel *cloudListModel = self.icloudModel.list[indexPath.row];
        
    return cloudListModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJProicloudListModel *cloudListModel = self.icloudModel.list[indexPath.row];
    
    if (cloudListModel.finish_status != JGJProicloudSuccessStatusType) {
        
        return;
    }
    
    NSString *filePath = FILE_PATH(cloudListModel.file_name);
    
    if (self.baseType == ProiCloudDataBaseUpLoadType) {
        
        filePath = UPLoad_FILE_PATH(cloudListModel.file_name);
    }
    
    cloudListModel.file_path = filePath;
    
    if ([cloudListModel.file_broad_type.lowercaseString isEqualToString:@"pic"] || [cloudListModel.belong_file.lowercaseString isEqualToString:@"picture"]) {
        
        [self browsePhotoImageViewWithCloudListModel:cloudListModel];
        
    }else if ([cloudListModel.file_broad_type.lowercaseString isEqualToString:@"video"] || [cloudListModel.belong_file.lowercaseString isEqualToString:@"video"] ) {
    
        [self playVideoWithCloudListModel:cloudListModel];
    }else if ([cloudListModel.file_broad_type.lowercaseString isEqualToString:@"document"] || [cloudListModel.belong_file.lowercaseString isEqualToString:@"document"]) {
        
        [self openDocumentWithCloudListModel:cloudListModel];
        
    }else {
        
        NSString * cacheFileUrl = FILE_PATH(cloudListModel.file_name);
        
        [self shareBtnClickWithFileUrl:cacheFileUrl];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    CGFloat height = 30;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];

    headerView.backgroundColor = AppFontf1f1f1Color;
    
    UILabel *contentlable = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth - 24, height)];
    
    contentlable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    contentlable.textColor = AppFont999999Color;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finish_status=%@", @(JGJProicloudSuccessStatusType)];
    
    NSInteger transSuccessCount = [self.icloudModel.list filteredArrayUsingPredicate:predicate].count;
    
    if (self.baseType == ProiCloudDataBaseDownLoadType) {
        
        contentlable.text = [NSString stringWithFormat:@"下载完成(%@)", @(transSuccessCount)];
        
    }else if (self.baseType == ProiCloudDataBaseUpLoadType) {
    
        contentlable.text = [NSString stringWithFormat:@"上传完成(%@)", @(transSuccessCount)];
    }
    
    [headerView addSubview:contentlable];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30;
}

#pragma mark - 查看文档

- (void)openDocumentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    JGJProiCloudShareVc *shareVc = [JGJProiCloudShareVc new];
    
    shareVc.cloudListModel = cloudListModel;
    
    [self.navigationController pushViewController:shareVc animated:YES];

}

#pragma mark - 查看照片
- (void)browsePhotoImageViewWithCloudListModel:(JGJProicloudListModel *)cloudListModel{
    
    NSMutableArray *photos = [NSMutableArray new];
    
    NSInteger selPhotoIndex = 0;
    
    BOOL isCount = YES;
    
    for (JGJProicloudListModel *listModel in self.icloudModel.list) {
        
        if ([listModel.file_broad_type isEqualToString:@"pic"]) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            NSString *filePath = FILE_PATH(listModel.file_name);
            
            if (![NSString isEmpty:cloudListModel.file_path]) {
                
                NSURL *filePathUrl = [NSURL URLWithString:cloudListModel.file_path]; // 图片路径
                
                photo.url = filePathUrl; // 图片路径
            }
            
            if (self.baseType == ProiCloudDataBaseUpLoadType) {
                
                filePath = UPLoad_FILE_PATH(listModel.file_name);
                
            }
            
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            
            listModel.imageView.image = image;
            
            photo.image = image;
            
            photo.srcImageView = listModel.imageView; // 来源于哪个UIImageView
            
            [photos addObject:photo];
            
            if (![listModel.fileId isEqualToString:cloudListModel.fileId] && isCount) {
                
                ++selPhotoIndex;
                
            }else {
            
                isCount = NO;
            }
        }
        
    }

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = selPhotoIndex; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
    
}


#pragma mark - 播放视频
- (void)playVideoWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    JGJProiCloudMediaVc *videoVc = [[JGJProiCloudMediaVc alloc] init];
    
    videoVc.cloudListModel = cloudListModel;
    
    [self presentViewController:videoVc animated:YES completion:nil];

}

- (void)proicloudListCell:(JGJProiCloudTransListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel {

    NSIndexPath *temp = self.lastIndexPath;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (temp && temp != indexPath) {
        
        JGJProicloudListModel *lastListModel = self.icloudModel.list[self.lastIndexPath.row];
        
        lastListModel.isExpand = NO;
        
//        [self.tableView beginUpdates];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [self.tableView endUpdates];
    }
    
//    [self.tableView beginUpdates];
//    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    [self.tableView endUpdates];
//

//    JGJProicloudListModel *selCloudListModel = self.icloudModel.list[indexPath.row];
    
    self.lastIndexPath = indexPath;
    
    [self.tableView reloadData];
    
}

- (void)setIcloudModel:(JGJProicloudModel *)icloudModel {
    
    _icloudModel = icloudModel;
    
    [self showDefaultViewWithIcloudModel:icloudModel];
    
}

#pragma mark - 下载、分享、重命名
- (void)proicloudListCell:(JGJProiCloudTransListCell *)cell buttonType:(JGJProicloudListCellButtonType)buttonType {
    
    cell.cloudListModel.buttonType = buttonType;
    
    switch (buttonType) {
            
        case JGJProicloudListCellStartButtonType:
        case JGJProicloudListCellDownloadButtonType:{
            
            NSDictionary *parameters = @{@"file_id" : cell.cloudListModel.fileId?:@"",
                                         
                                         @"path" : cell.cloudListModel.file_path?:@""};
            
            [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/downFile" parameters:parameters success:^(id responseObject) {
                
                JGJProiCloudUploadFilesModel *downloadFilesModel = [JGJProiCloudUploadFilesModel mj_objectWithKeyValues:responseObject];
                
                downloadFilesModel.fileName = cell.cloudListModel.file_name;
                
                downloadFilesModel.Bucketname = cell.cloudListModel.bucket_name;
                
#warning cell.cloudListModel.file_name改为oss_file_name
                downloadFilesModel.objectKey = [NSString stringWithFormat:@"%@", cell.cloudListModel.oss_file_name];//合并的路径,用新模型。每个页面单独保存路径
                
                //保存下载任务模型，下载完移除
                
                downloadFilesModel.cloudListModel = cell.cloudListModel;
                
                
                [JGJProiCloudTool proiCloudToolDownObjectAsync:nil downObjectModel:downloadFilesModel proiCloudToolDownloadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, BOOL isSuccess) {
                    
                    TYLog(@"======= %lld, %lld, %lld, %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, isSuccess);
                    
                }];
                
            } failure:^(NSError *error) {
                
                
            }];
            
            
        }
            
            
            break;
            
        case JGJProicloudListCellShareButtonType:{
            
            NSString *filePath = FILE_PATH(cell.cloudListModel.file_name);
            
            if (self.baseType == ProiCloudDataBaseUpLoadType) {
                
                filePath = UPLoad_FILE_PATH(cell.cloudListModel.file_name);
            }
            
            [self shareBtnClickWithFileUrl:filePath];
        }
            
            break;
            
            
        case JGJProicloudListCellRenameButtonType:{

            
            
        }
            
            break;
        
        case JGJProicloudListCellStartUpLoadButtonType:{
            
            //然后请求获取key
            [JGJProiCloudTool requestUpLoadWithUpLoadCloudListModel:cell.cloudListModel image:nil];
            
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 刷新进度
- (void)refreshIndexPathWithicloudModel:(JGJProiCloudUploadFilesModel *)downloadRequest {
    
    __weak typeof(self) weakSelf = self;
    
    self.handleTaskProgressTimerBlock = ^{
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *visCells = [weakSelf.tableView visibleCells];
            
            BOOL isEqual = NO;
            
            for (JGJProiCloudTransListCell *listCell in visCells) {
                
//                NSIndexPath *indexPath = [self.tableView indexPathForCell:listCell];
                
                //上传唯一标识iCloudUniqueId下载用id
                if (downloadRequest.cloudListModel.is_upload == ProiCloudDataBaseUpLoadType) {
                    
                    isEqual = [listCell.cloudListModel.fileId isEqualToString:downloadRequest.cloudListModel.fileId?:@""];
                    
                }else if (downloadRequest.cloudListModel.is_upload == ProiCloudDataBaseDownLoadType) {
                    
                    isEqual = [listCell.cloudListModel.fileId isEqualToString:downloadRequest.cloudListModel.fileId?:@""];
                }
                
                if (isEqual) {
                    
                    listCell.transRequestModel = downloadRequest;
                    
                    //先赋值位置才赋值模型，展开使用
                    downloadRequest.cloudListModel.indexPath = listCell.cloudListModel.indexPath;
                    
                    //替换状态和数据
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileId=%@",downloadRequest.cloudListModel.fileId];
                    
                    NSArray *cloudList = [weakSelf.icloudModel.list filteredArrayUsingPredicate:predicate];
                    
                    if (cloudList.count > 0) {
                        
                        NSMutableArray *icloudList = weakSelf.icloudModel.list.mutableCopy;
                        
                        JGJProicloudListModel *icloudListModel = cloudList.firstObject;
                        
                        icloudListModel.progress = downloadRequest.cloudListModel.progress;
                        
                        icloudListModel.finish_status = downloadRequest.cloudListModel.finish_status;
                        
                        icloudListModel.totalBytes = downloadRequest.cloudListModel.totalBytes;
                        
                        icloudListModel.totalBytesExpected = downloadRequest.cloudListModel.totalBytesExpected;
                        
                        NSInteger index = [weakSelf.icloudModel.list indexOfObject:icloudListModel];
                        
                        [icloudList replaceObjectAtIndex:index withObject:icloudListModel];
                        
                        weakSelf.icloudModel.list = icloudList;
                        
                    }
                    
                    listCell.cloudListModel = downloadRequest.cloudListModel;
                    
                    //数据改变后更新数据库
                    [JGJProiCloudDataBaseTool updateicloudListModel:downloadRequest.cloudListModel];
                    
                    break;
                }
                
            }

            //传输完成刷新页面
            if (downloadRequest.cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
                
                [weakSelf.taskProgressTimer invalidate];
                
                weakSelf.taskProgressTimer = nil;
                
                [weakSelf.tableView reloadData];
            }
            
        });
        
    };
    
}

#pragma mark-是否显示默认页
- (void)showDefaultViewWithIcloudModel:(JGJProicloudModel *)icloudModel{
    
    if (icloudModel.list.count == 0) {
        
        [self.view addSubview:self.defaultView];
        
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.mas_equalTo(0);
            
            make.top.mas_equalTo(self.contentTopView.mas_bottom);
        }];

    }else {
        
        [self.defaultView removeFromSuperview];
        

    }
    
    [self.tableView reloadData];
    
}

- (JGJQuaSafeOrderDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"暂无记录哦~";
        
        infoModel.actionButtonTitle = @"";
        
        infoModel.desInfo = @"";
        
        infoModel.isHiddenActionButton = YES;
        
        infoModel.isHiddenlineView = YES;
        
        infoModel.desButtonFontColor = AppFont999999Color;
        
        infoModel.desButtonFontSize = AppFont34Size;
        
        infoModel.isCenter = YES;
        
        _defaultView.infoModel = infoModel;
        
    }
    
    return _defaultView;
}

#pragma mark - 删除文件按钮按下
- (IBAction)handleDelFileButtonPressed:(UIBarButtonItem *)sender {
    
    JGJProiCloudDeleteTransferLIstVc *delTransferLIstVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProiCloudDeleteTransferLIstVc"];
        
    delTransferLIstVc.baseType = self.baseType;
    
    delTransferLIstVc.proListModel = self.proListModel;
    
    [self.navigationController pushViewController:delTransferLIstVc animated:YES];
}

- (void)proiCloudDownNotification:(NSNotification *)notification {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        //开启定时器
        [self taskProgressTimer];
        
    });
    
    JGJProiCloudUploadFilesModel *upLoadCloudModel = notification.object;
    
    [self refreshIndexPathWithicloudModel:upLoadCloudModel];
    
}

#pragma mark - 上传刷新进度
- (void)proiCloudUpLoadNotification:(NSNotification *)notification {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        //开启定时器
        [self taskProgressTimer];
        
    });
    
    JGJProiCloudUploadFilesModel *upLoadCloudModel = notification.object;
    
    [self refreshIndexPathWithicloudModel:upLoadCloudModel];
    
}

#pragma mark - 顶部上传、下载列表按钮按下
- (void)proiCloudTransListTopViewButtonType:(ProiCloudTransListTopViewButtonType)buttonType {

    switch (buttonType) {
        
        case ProiCloudTransListTopViewUploadButtonType:{
            
            self.baseType = ProiCloudDataBaseUpLoadType;
            
            JGJProicloudModel *icloudModel = [JGJProicloudModel new];
                        
            JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
            
            icloudListModel.group_id = self.proListModel.group_id;
            
            icloudModel.list = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:ProiCloudDataBaseUpLoadType];
            
            self.icloudModel = icloudModel;
        }
            
            break;
            
        case ProiCloudTransListTopViewDownloadButtonType:{
            
            self.baseType = ProiCloudDataBaseDownLoadType;
            
            JGJProicloudModel *icloudModel = [JGJProicloudModel new];
            
            JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
            
            icloudListModel.group_id = self.proListModel.group_id;
            
            icloudModel.list = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:ProiCloudDataBaseDownLoadType];
            
            self.icloudModel = icloudModel;
            
        }
            
            break;
            
        default:
            break;
    }
    

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.taskProgressTimer invalidate];
    
    self.taskProgressTimer = nil;
    
}

- (JGJProiColoudGetTransFileListRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJProiColoudGetTransFileListRequestModel new];
        
        _requestModel.group_id = self.proListModel.group_id;
        
        _requestModel.class_type = self.proListModel.class_type;
        
    }

    return _requestModel;
}

- (NSTimer *)taskProgressTimer {
    
    if (!_taskProgressTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        _taskProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(taskFreshProgress:) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_taskProgressTimer forMode:NSRunLoopCommonModes];
    }
    
    return _taskProgressTimer;
}

- (void)taskFreshProgress:(NSTimer *)timer {
    
    if (self.handleTaskProgressTimerBlock) {
        
        self.handleTaskProgressTimerBlock();
    }
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finish_status = %@", @(JGJProicloudSuccessStatusType)];
//    
//    NSArray *successTasks = [self.icloudModel.list filteredArrayUsingPredicate:predicate];
//    
//    if (successTasks.count == self.icloudModel.list.count) {
//        
//        [self.taskProgressTimer invalidate];
//        
//        self.taskProgressTimer = nil;
//    }
}

- (void)shareBtnClickWithFileUrl:(NSString *)fileUrl {
    
    if (![NSString isEmpty:fileUrl]) {
        
        NSString *filePath = [fileUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
        
        self.documentController.delegate = self;
        
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
        
        [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
        
    }
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    self.documentController = nil;
}


@end
