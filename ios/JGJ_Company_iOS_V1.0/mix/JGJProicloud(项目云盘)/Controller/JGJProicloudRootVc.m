//
//  JGJProicloudRootVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProicloudRootVc.h"

#import "JGJSearchResultView.h"

#import "TYTextField.h"

#import "JGJProicloudListCell.h"

#import "UIView+Extend.h"

#import "PopoverView.h"

#import "JGJProiCloudRecycleVc.h"

#import "JGJProiCloudTransferListVc.h"

#import "JGJProiCloudMoveFileVc.h"

#import "TZImagePickerController.h"

#import "JGJProiCloudTool.h"

#import "JGJProiCloudCreatFileView.h"

#import "NSString+Extend.h"

#import "TYUIImage.h"

#import <Photos/PHAssetResource.h>

#import "JGJQuaSafeOrderDefaultView.h"

#import "UILabel+GNUtil.h"

#import "JGJCustomPopView.h"

#import "TZImageManager.h"

#import "UIImageView+MJWebCache.h"

#import "MJPhotoBrowser.h"

#import "MJPhoto.h"

#import "JGJProiCloud.h"

#import "JGJKnowBaseDownLoadPopView.h"

#import "JGJProiCloudShareVc.h"

#import "JGJProiCloudMediaVc.h"

#import "JGJHelpCenterTitleView.h"

typedef enum : NSUInteger {
    
    DocumentDownSuccessedOpenType = 1, //当前文档下载完毕之后打开
    
    DocumentDownSuccessedShareType //当前文档下载完毕之后分享

} DocumentDownSuccessedType;

@interface JGJProicloudRootVc ()<

    UITableViewDelegate,

    UITableViewDataSource,

    UITextFieldDelegate,

    JGJSearchResultViewdelegate,

    JGJProicloudListCellDelegate,

    TZImagePickerControllerDelegate,

    UIDocumentInteractionControllerDelegate

>

typedef void(^HandleTaskProgressTimerBlock)();

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;

@property (strong, nonatomic) JGJSearchResultView *searchResultView;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@property (strong, nonatomic) NSArray *dataSource;

@property (nonatomic, assign) ProicloudListCellType cloudListCellType;

@property (weak, nonatomic) IBOutlet UIButton *transButton;

@property (weak, nonatomic) IBOutlet UIButton *creatButton;

@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatButtonW;

@property (assign, nonatomic) BOOL isCancelButton;

@property (weak, nonatomic) IBOutlet UIView *contentTopView;

@property (weak, nonatomic) IBOutlet UILabel *selNumLable;

@property (assign, nonatomic) ProicloudVcButtonType buttonType;

@property (strong, nonatomic) UIButton *allCancelButton;

@property (strong ,nonatomic) JGJProicloudModel *icloudModel;

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *orderDefaultView;

//选择要删除的文件
@property (nonatomic, strong) NSMutableArray *selFiles;

@property (strong, nonatomic) JGJProiCloudUploadFilesRequestModel *uploadFilesRequestModel;

@property (strong, nonatomic) JGJProiColoudCreateCloudDirRequestModel *createCloudDirRequest;

//目录请求
@property (strong, nonatomic) JGJProicloudRequestModel *requestModel;

//删除文件请求
@property (strong, nonatomic) JGJProiColoudDelFilesRequestModel *delFileRequestModel;

//搜索模型
@property (strong, nonatomic) JGJProiColoudSearchFileRequestModel *searchFileRequestModel;

//当前选中
@property (strong, nonatomic)  JGJProicloudListModel *selCloudListModel;

//搜索的文件
@property (strong, nonatomic) NSArray *searchFiles;

//当前搜索的文件
@property (strong, nonatomic) JGJProicloudModel *searchIcloudModel;

@property (assign, nonatomic) ProicloudRootVcType proicloudRootVcType;

//重命名
@property (strong, nonatomic) JGJProiColoudRenameFileRequestModel *renameFileRequestModel;

@property (nonatomic, strong) JGJKnowBaseDownLoadPopView *popView;

//文档下载模型
@property (nonatomic, strong) JGJKnowBaseModel *progressModel;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, assign) DocumentDownSuccessedType documentDownSuccessedType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

//打开文档
@property (assign, nonatomic) BOOL isOpenDocument;

@property (nonatomic, strong) NSTimer *taskProgressTimer;

@property (nonatomic, copy) HandleTaskProgressTimerBlock handleTaskProgressTimerBlock;

//当前分享的文件
//@property (strong, nonatomic)  JGJProicloudListModel *shareCloudListModel;

//下载类型当前不弹出分享菜单
@property (nonatomic, assign) JGJProicloudListCellButtonType curButtonType;
@end

@implementation JGJProicloudRootVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [TYLoadingHub showLoadingWithMessage:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //显示的时候情况搜索数据
    self.searchBarTF.text = nil;
    
    self.cloudListCellType = ProicloudListDefaultCellType;
    
    [self loadProiCloudList];

    [TYNotificationCenter addObserver:self selector:@selector(proiCloudUpLoadNotification:) name:JGJProiCloudUpLoadFilesNotification object:nil];
    
    [TYNotificationCenter addObserver:self selector:@selector(proiCloudDownNotification:) name:JGJProiCloudDownFilesNotification object:nil];
    
    [TYNotificationCenter addObserver:self selector:@selector(handleDelShareDownFileNotification:) name:@"handleDelDownFileNotification" object:nil];
    
    [self.selFiles removeAllObjects];
    
    self.selNumLable.text = @"已选中 0 个文件";
    
    [self.selNumLable markText:@"0" withColor:AppFontEB4E4EColor];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewCloudType;
    
    if ([NSString isEmpty:self.cloudListModel.file_name]) {
        
        titleView.title = @"项目云盘";
        
        titleView.iconHidden = NO;
    
    }else {
        
        titleView.title = self.cloudListModel.file_name;
        
        titleView.iconHidden = YES;
    }
    
    self.navigationItem.titleView = titleView;
}

#pragma mark - 上传数据
- (void)proiCloudUpLoadNotification:(NSNotification *)notification {
    
    JGJProiCloudUploadFilesModel *upLoadCloudModel = notification.object;
    
    if (upLoadCloudModel.cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
        
        [self loadProiCloudList];
    }
}

- (void)proiCloudDownNotification:(NSNotification *)notification {
    
    __weak typeof(self) weakSelf = self;
    
//    //不是分享按钮就不打开
//    if (self.curButtonType != JGJProicloudListCellShareButtonType) {
//        
//        return;
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        //开启定时器
        [weakSelf taskProgressTimer];
        
    });
    
    JGJProiCloudUploadFilesModel *iCloudModel = notification.object;
    
    if (![self.selCloudListModel.fileId isEqualToString:iCloudModel.cloudListModel.fileId?:@""]) {
        
        return;
        
    }
    
    self.handleTaskProgressTimerBlock = ^{
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //只有文档类型才需要
            //
            //        if (![iCloudModel.cloudListModel.belong_file isEqualToString:@"document"]) {
            //
            //            return;
            //        }
            
            weakSelf.progressModel.progress = iCloudModel.cloudListModel.progress;
            
            weakSelf.popView.knowBaseModel = weakSelf.progressModel;
            
            if (iCloudModel.cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
                
                [weakSelf.popView removeFromSuperview];
                
                NSString * downFileUrl = FILE_PATH(iCloudModel.cloudListModel.file_name);
                
                switch (weakSelf.documentDownSuccessedType) {
                        
                    case DocumentDownSuccessedOpenType:{
                        
                        //存在就打开
                        if ([JGJOSSCommonHelper isExistFile:downFileUrl] && _isOpenDocument) {
                            
                            JGJProiCloudShareVc *shareVc = [JGJProiCloudShareVc new];
                            
                            shareVc = [JGJProiCloudShareVc new];
                            
                            shareVc.cloudListModel = iCloudModel.cloudListModel;
                            
                            [weakSelf.navigationController pushViewController:shareVc animated:YES];
                            
                            _isOpenDocument = NO;
                            
                            [weakSelf.taskProgressTimer invalidate];
                            
                            weakSelf.taskProgressTimer = nil;
                            
                        }
                        
                    }
                        
                        break;
                        
                    case DocumentDownSuccessedShareType:{
                        
                        [weakSelf shareBtnClickWithFileUrl:downFileUrl];
                        
                        [weakSelf.taskProgressTimer invalidate];
                        
                        weakSelf.taskProgressTimer = nil;
                    }
                        
                        break;
                        
                    default:
                        break;
                }
                
            }

            weakSelf.popView.handleKnowBaseCancelDownLoadBlock = ^(JGJKnowBaseModel *infoModel) {
                
                [weakSelf.popView removeFromSuperview];
            };
            
        });
        
    };
    
}

#pragma mark - 通用设置
- (void)commonInit{
    
    for (UIButton *bottomButton in self.bottomView.subviews) {
        
        if ([bottomButton isKindOfClass:[UIButton class]]) {
            
            [bottomButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
            
            bottomButton.backgroundColor = AppFontd7252cColor;
        }
    }
    
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.contentSearchBarView.hidden = YES;
    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    self.searchBarTF.returnKeyType = UIReturnKeySearch;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.searchBarTF.leftView = searchIcon;
    
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        
        [weakSelf searchValueChange:value];
        
        if ([weakSelf.view.subviews containsObject:weakSelf.orderDefaultView]) {
            
            [weakSelf.orderDefaultView removeFromSuperview];
        }
        
    };

    self.contentTopView.backgroundColor = AppFontF9CCCEColor;
    
    self.selNumLable.textColor = AppFont999999Color;
    
    self.contentTopView.hidden = YES;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 0;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        count = self.searchIcloudModel.list.count;
        
    }else {
        
        count = self.icloudModel.list.count;
    }
    
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJProicloudListCell *cloudListCell = [JGJProicloudListCell cellWithTableView:tableView];
    
    cloudListCell.delegate = self;
    
    JGJProicloudListModel *cloudListModel = nil;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
    }else {
    
        cloudListModel = self.icloudModel.list[indexPath.row];
    }
    
    //更多操作隐藏底部和按钮
    if (self.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        cloudListCell.isHiddenButton = YES;
        
        cloudListModel.isExpand = NO;
        
    }else {
        
        cloudListCell.isHiddenButton = NO;
    }
    
    cloudListModel.cloudListCellType = self.cloudListCellType;
    
    //需要改变的颜色
    cloudListCell.searchValue = self.searchBarTF.text;
    
    cloudListCell.cloudListModel = cloudListModel;
        
    return cloudListCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJProicloudListModel *cloudListModel = nil;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
    }else {
        
        cloudListModel = self.icloudModel.list[indexPath.row];
    }
    
    CGFloat height = cloudListModel.cellHeight;

    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProicloudListModel *cloudListModel = nil;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
    }else {
        
        cloudListModel = self.icloudModel.list[indexPath.row];
    }
    
    //    除查看云盘文件（夹）列表和删除文件（夹）外
    if (![cloudListModel.type isEqualToString:@"dir"] && self.cloudListCellType == ProicloudListDefaultCellType) {
        
        if ([self cloudOverTimeTip]) {
            
            return;
        }
        
    }
    
    cloudListModel = [self iCloudFileTypeWithcloudListModel:cloudListModel];
    
    //查看照片用
    self.selCloudListModel = cloudListModel;
    
    if (self.cloudListCellType == ProicloudListDefaultCellType) {

        [self selectDirRowWithCloudListModel:cloudListModel];
        
    }else {
    
        //更多操作
        
        [self selDirWithCloudListModel:cloudListModel];
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
    
    }
    
}

- (void)selDirWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    cloudListModel.isSelected = !cloudListModel.isSelected;
    
    if (cloudListModel.isSelected) {
        
        [self.selFiles addObject:cloudListModel];
        
    }else {
    
        [self.selFiles removeObject:cloudListModel];
        
    }
    
    [self showSelFileNum];
}

#pragma mark - 顶部显示个数
- (void)showSelFileNum {

    NSString *selNum = [NSString stringWithFormat:@"%@", @(self.selFiles.count)];
    
    self.selNumLable.text = [NSString stringWithFormat:@"已选中 %@ 个文件", selNum];
    
    [self.selNumLable markText:selNum withColor:AppFontEB4E4EColor];
    
    if (self.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        self.bottomView.hidden = self.selFiles.count == 0;
        
        self.bottomViewH.constant = self.selFiles.count == 0 ? 0 : 63;
        
        self.allCancelButton.selected = (self.selFiles.count == self.icloudModel.list.count) && self.selFiles.count > 0;
        
        NSString *buttonTitle = self.allCancelButton.selected ? @"取消全选" : @"全选";
        
        [self.allCancelButton setTitle:buttonTitle forState:UIControlStateNormal];
        
    }else {
    
        self.bottomView.hidden = NO;
        
        self.bottomViewH.constant = 63;

    }

}

- (void)selectDirRowWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        JGJProicloudRootVc *cloudRootVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProicloudRootVc"];
        
        JGJProicloudListModel *listModel = [JGJProicloudListModel new];
        
        listModel.file_path = cloudListModel.file_path;
        
        listModel.fileId = cloudListModel.fileId;
        
        listModel.file_name = cloudListModel.file_name;
        
        listModel.parent_id = cloudListModel.parent_id;
        
        listModel.type = cloudListModel.type;
        
        NSString *fileName = [cloudListModel.file_name stringByReplacingOccurrencesOfString:@".dir" withString:@""];
        
        cloudRootVc.navigationItem.title = fileName;

        //合并的路径,用新模型。每个页面单独保存路径
        
        //上传的最后拼接上传的名字即可
        
        if ([NSString isEmpty:self.cloudListModel.file_merge_path]) {
            
            listModel.file_merge_path = [NSString stringWithFormat:@"%@/%@/", cloudListModel.object_name,cloudListModel.file_name];
            
        }else {
        
            listModel.file_merge_path = [NSString stringWithFormat:@"%@%@/", self.cloudListModel.file_merge_path, cloudListModel.file_name];
        }
        
//        listModel.file_merge_path = listModel.oss_file_name;
        
        cloudRootVc.cloudListModel = listModel;
        
        cloudRootVc.proListModel = self.proListModel;
        
        [self.navigationController pushViewController:cloudRootVc animated:YES];
        
    }else if ([cloudListModel.belong_file.lowercaseString isEqualToString:@"picture"]) {
    
        [self browsePhotoImageView];
        
    }else if ([cloudListModel.belong_file.lowercaseString isEqualToString:@"video"]) {
        
        JGJProiCloudMediaVc *videoVc = [[JGJProiCloudMediaVc alloc] init];
        
        videoVc.cloudListModel = cloudListModel;
        
        [self presentViewController:videoVc animated:YES completion:nil];
                
    }else if ([cloudListModel.belong_file.lowercaseString isEqualToString:@"document"] && ![cloudListModel.file_type isEqualToString:@"dwg"]) {
    
        [self openDocumentWithCloudListModel:cloudListModel];
        
    }else {
        
        NSString * cacheFileUrl = FILE_PATH(cloudListModel.file_name);
        
        [self shareBtnClickWithFileUrl:cacheFileUrl];
    
    }
}

- (void)openDocumentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    JGJProiCloudShareVc *shareVc = [JGJProiCloudShareVc new];
    
    shareVc.title = cloudListModel.file_name;
    
    NSString * downFileUrl = FILE_PATH(cloudListModel.file_name);
    
    //存在就打开
    if ([JGJOSSCommonHelper isExistFile:downFileUrl]) {
        
        shareVc = [JGJProiCloudShareVc new];
        
        shareVc.cloudListModel = cloudListModel;
        
        [self.navigationController pushViewController:shareVc animated:YES];
        
    }else {
        
//        //开启监听进度显示
//        [TYNotificationCenter addObserver:self selector:@selector(proiCloudDownNotification:) name:JGJProiCloudDownFilesNotification object:nil];
    
//打开文档开关避免成功开启多个页面
        self.isOpenDocument = YES;
        
        JGJProiCloudDataBaseTool *icloudDataBaseTool = [JGJProiCloudDataBaseTool shareProiCloudDataBaseTool];
        
        icloudDataBaseTool.isUnCanAdd = YES;
        
        //不存在就下载
        self.progressModel = [JGJKnowBaseModel new];
        
        self.progressModel.file_name = cloudListModel.file_name;

        self.popView = [JGJKnowBaseDownLoadPopView knowBaseDownLoadPopViewWithModel:self.progressModel];
        
        //不存在就下载
        [self handleClickedDownTransListUnExistFileWithCloudListModel:cloudListModel];
        //进度在通知回调里面写
        
        //存在就打开
        self.documentDownSuccessedType = DocumentDownSuccessedOpenType;
    }

}

#pragma mark - JGJProicloudListCellDelegate

- (void)proicloudListCell:(JGJProicloudListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if (temp && temp != indexPath) {
        
        JGJProicloudListModel *lastListModel = self.icloudModel.list[self.lastIndexPath.row];
        
        lastListModel.isExpand = NO;
        
//        [self.tableView beginUpdates];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        
//        [self.tableView endUpdates];
    }
    
    self.lastIndexPath = indexPath;
    
//    [self.tableView beginUpdates];
//    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//    [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
}

#pragma mark - 下载、分享、重命名
- (void)proicloudListCell:(JGJProicloudListCell *)cell buttonType:(JGJProicloudListCellButtonType)buttonType {

    JGJProiCloudDataBaseTool *icloudDataBaseTool = [JGJProiCloudDataBaseTool shareProiCloudDataBaseTool];
    
    icloudDataBaseTool.isUnCanAdd = NO;
    
    NSRange upperRange = [cell.cloudListModel.file_name rangeOfString:cell.cloudListModel.file_type.uppercaseString];
    
    NSRange lowerRange = [cell.cloudListModel.file_name rangeOfString:cell.cloudListModel.file_type.lowercaseString];
    
    if (upperRange.location == NSNotFound && lowerRange.location == NSNotFound) {
        
        cell.cloudListModel.file_name = [NSString stringWithFormat:@"%@.%@", cell.cloudListModel.file_name, cell.cloudListModel.file_type];
    }
    
    if ([self cloudOverTimeTip]) {
        
        return;
    }
    
    cell.cloudListModel.buttonType = buttonType;
    
    self.curButtonType = buttonType;
    
    __weak typeof(self) weakSelf = self;
    
    switch (buttonType) {
        case JGJProicloudListCellDownloadButtonType:{
            
            JGJProicloudListModel *cloudListModel = [JGJProiCloudDataBaseTool inquireicloudListModell:cell.cloudListModel];
            
            //获取当前信息的状态
            cell.cloudListModel.finish_status = cloudListModel.finish_status;
            
            if ([NSString isEmpty:cell.cloudListModel.file_merge_path]) {
                
                cell.cloudListModel.file_merge_path = cell.cloudListModel.file_name;
            }
            
            //存在的情况
            if (cloudListModel) {
                
                [self handleClickedDownTransListExistFileWithCell:cell];
                
            }else {
                
                //不存在的情况
                [TYShowMessage showPlaint:@"该文件正在下载,可在 传输列表 中找到此文件"];
                
                //首次点击下载 添加数据库
                [JGJProiCloudDataBaseTool addCollecticloudListModel:cell.cloudListModel];
                
                [self handleClickedDownTransListUnExistFileWithCloudListModel:cell.cloudListModel];
            }

        }
            
            break;
        
        case JGJProicloudListCellShareButtonType:{
            
            icloudDataBaseTool.isUnCanAdd = YES;
            
            NSString * downFileUrl = FILE_PATH(cell.cloudListModel.file_name);
            
            //存在就直接打开
            if ([JGJOSSCommonHelper isExistFile:downFileUrl]) {
                
                //存在就分享
                [self shareBtnClickWithFileUrl:downFileUrl];
                
            }else {
            
//                self.shareCloudListModel = cell.cloudListModel;
                
                self.selCloudListModel = cell.cloudListModel;
                //不存在就下载
                self.progressModel = [JGJKnowBaseModel new];
                
                self.progressModel.file_name = cell.cloudListModel.file_name;
                
                self.popView = [JGJKnowBaseDownLoadPopView knowBaseDownLoadPopViewWithModel:self.progressModel];
                
                self.popView.handleKnowBaseCancelDownLoadBlock = ^(JGJKnowBaseModel *model) {
                  
                    JGJProiCloudTool *iCloudTool = [JGJProiCloudTool shareProiCloudTool];
                    
                    [iCloudTool.transRequest.request cancel];
                    
                };
                
                //不存在就下载完分享
                [self handleClickedDownTransListUnExistFileWithCloudListModel:cell.cloudListModel];
                
                self.documentDownSuccessedType = DocumentDownSuccessedShareType;
                
//                //开启监听进度显示
//                [TYNotificationCenter addObserver:self selector:@selector(proiCloudDownNotification:) name:JGJProiCloudDownFilesNotification object:nil];
            }
            
        }
            break;
        
            
        case JGJProicloudListCellRenameButtonType:{
            
            JGJProiCloudCreatFileView *creatFileView = [JGJProiCloudCreatFileView proiCloudCreatFileView:cell.cloudListModel];
            
            creatFileView.onOkBlock = ^(JGJProiCloudCreatFileView *creatFileView) {
                
                weakSelf.renameFileRequestModel.file_id = cell.cloudListModel.fileId;
                
                weakSelf.renameFileRequestModel.type = cell.cloudListModel.type;
                
                weakSelf.renameFileRequestModel.file_name = creatFileView.fileNameTextField.text;
                
                [weakSelf handleRenameFileWithCell:cell];
            };
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 取消分享下载
- (void)handleDelShareDownFileNotification:(NSNotification *)notification {
    
    JGJProiCloudTool *iCloudTool = [JGJProiCloudTool shareProiCloudTool];
    
    [iCloudTool.transRequest.request cancel];
    
    NSString *filePath = FILE_PATH(iCloudTool.transRequest.cloudListModel.file_name);
    
    BOOL isDelSuccess = [JGJProiCloudDataBaseTool removeCollecticloudListModel:self.selCloudListModel];
    
    if (isDelSuccess) {
        
        TYLog(@"删除数据库成功");
    }
    
    BOOL isSuccess = [JGJOSSCommonHelper removeFileWithFilepath:filePath];
    
    if (isSuccess) {
      
        TYLog(@"删除成功");
        
    }
    
}

#pragma mark - 分享按钮按下
- (void)shareBtnClickWithFileUrl:(NSString *)fileUrl {
    
    if (![NSString isEmpty:fileUrl]) {
        
        if ([JGJOSSCommonHelper isExistFile:fileUrl]) {
            
            NSString *filePath = [fileUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
            
            self.documentController.delegate = self;
            
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
            
            [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
            
        }else {
        
            //不存在就下载
            self.progressModel = [JGJKnowBaseModel new];
            
            self.progressModel.file_name = self.selCloudListModel.file_name;
            
            self.popView = [JGJKnowBaseDownLoadPopView knowBaseDownLoadPopViewWithModel:self.progressModel];
            
            //不存在就下载
            [self handleClickedDownTransListUnExistFileWithCloudListModel:self.selCloudListModel];
            
            self.documentDownSuccessedType = DocumentDownSuccessedShareType;
        }
        
    }
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    self.documentController = nil;
}

#pragma mark - 点击传输列表没有的文件
- (void)handleClickedDownTransListUnExistFileWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

//    if ([NSString isEmpty:cell.cloudListModel.file_merge_path]) {
//        
//        cell.cloudListModel.file_merge_path = cell.cloudListModel.file_name;
//    }
//    
//    //点击下载添加数据库
//    [JGJProiCloudDataBaseTool addCollecticloudListModel:cell.cloudListModel];
    
    NSDictionary *parameters = @{@"file_id" : cloudListModel.fileId?:@"",
                                 
                                 @"path" : cloudListModel.file_merge_path?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/downFile" parameters:parameters success:^(id responseObject) {
        
        JGJProiCloudUploadFilesModel *downloadFilesModel = [JGJProiCloudUploadFilesModel mj_objectWithKeyValues:responseObject];
        
        downloadFilesModel.fileName = cloudListModel.file_name;
        
        downloadFilesModel.Bucketname = cloudListModel.bucket_name;
        
        //oss的路径

        downloadFilesModel.objectKey = [NSString stringWithFormat:@"%@", cloudListModel.oss_file_name];
        
        downloadFilesModel.cloudListModel = cloudListModel;
        
        [JGJProiCloudTool proiCloudToolDownObjectAsync:nil downObjectModel:downloadFilesModel proiCloudToolDownloadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, BOOL isSuccess) {
            
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];

}

#pragma mark - 点击传输列表存在的文件
- (void)handleClickedDownTransListExistFileWithCell:(JGJProicloudListCell *)cell {
    
    switch (cell.cloudListModel.finish_status) {
            
        case JGJProicloudLoadingStatusType:{
            
            [TYShowMessage showPlaint:@"该文件正在下载,可在 传输列表 中找到此文件"];
        }

            break;
        
        case JGJProicloudSuccessStatusType:{
            
            [TYShowMessage showPlaint:@"该文件已下载,不需要再次下载，可在 传输列表 中找到此文件"];
        }

            break;
        
        case JGJProicloudPauseStatusType:{
            
            [TYShowMessage showPlaint:@"该文件开始下载,可在 传输列表 中找到此文件"];
        }
            
            break;
            
        default:
            break;
    }
    
    
}

- (IBAction)handleMoreOperaButtonPressed:(UIButton *)sender {
    
    if (!self.isCancelButton) {
        
        PopoverView *popoverView = [PopoverView popoverView];
        
        popoverView.style = PopoverViewStyleDark;
        
        [popoverView showToView:sender withActions:[self JGJChatActions]];
        
    }else {
    
        self.cloudListCellType = ProicloudListDefaultCellType;
    }
    
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    
    __weak typeof(self) weakSelf = self;
    
    // 更多操作 action
    
    PopoverAction *moreOpearaAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"more_opera_icon"] title:@"更多操作" handler:^(PopoverAction *action) {

        weakSelf.cloudListCellType = ProicloudListMoreOperaCellType;
    }];
    
    // 回收站 action

    PopoverAction *recycleAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"cloud_recycle_icon"] title:@"回收站" handler:^(PopoverAction *action) {

        JGJProiCloudRecycleVc *recycleVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProiCloudRecycleVc"];
        
        recycleVc.proListModel = weakSelf.proListModel;
        
        [weakSelf.navigationController pushViewController:recycleVc animated:YES];
    }];

    return @[moreOpearaAction, recycleAction];
}

- (void)setCloudListCellType:(ProicloudListCellType)cloudListCellType {

    _cloudListCellType = cloudListCellType;
    
    [self.tableView reloadData];
    
    [self setTopViewHeightWithCloudListCellType:_cloudListCellType];
    
    [self setBottomButtonWithCloudListCellType:_cloudListCellType];
    
    [self setNavButtonWithCloudListCellType:_cloudListCellType];
    
    [self showSelFileNum];
    
}

- (void)setTopViewHeightWithCloudListCellType:(ProicloudListCellType)cloudListCellType {

    self.contentSearchbarViewH.constant = _cloudListCellType == ProicloudListMoreOperaCellType ? 35 : 48;

}

- (void)setBottomButtonWithCloudListCellType:(ProicloudListCellType)cloudListCellType {

    if (_cloudListCellType == ProicloudListMoreOperaCellType) {
        
        [self.transButton setTitle:@"将文件移动到..." forState:UIControlStateNormal];
        
        [self.upLoadButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [self.transButton setImage:nil forState:UIControlStateNormal];
        
        [self.creatButton setImage:nil forState:UIControlStateNormal];
        
        [self.upLoadButton setImage:nil forState:UIControlStateNormal];
        
        [self.moreButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [self.moreButton setImage:nil forState:UIControlStateNormal];
        
        self.isCancelButton = YES;
        
    }else {
        
        self.isCancelButton = NO;
        
        [self.transButton setTitle:@"传输列表" forState:UIControlStateNormal];
        
        [self.upLoadButton setTitle:@"新建文件夹" forState:UIControlStateNormal];
        
        [self.upLoadButton setTitle:@"上传文件" forState:UIControlStateNormal];
        
        [self.transButton setImage:[UIImage imageNamed:@"trans_list_icon"] forState:UIControlStateNormal];
        
        [self.creatButton setImage:[UIImage imageNamed:@"creat_file_icon"] forState:UIControlStateNormal];
        
        [self.upLoadButton setImage:[UIImage imageNamed:@"cloud_upload_icon"] forState:UIControlStateNormal];
        
        [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
        
        self.moreButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
        
//        [self.moreButton setImage:[UIImage imageNamed:@"more_write"] forState:UIControlStateNormal];
        
    }
    
    self.creatButton.hidden = _cloudListCellType == ProicloudListMoreOperaCellType;
    
    self.creatButtonW.constant = _cloudListCellType == ProicloudListMoreOperaCellType ? CGFLOAT_MIN : TYGetUIScreenWidth * 0.3 - 5;
    
    self.contentTopView.hidden = _cloudListCellType != ProicloudListMoreOperaCellType;

    if (TYIS_IPHONE_5) {
        
        self.transButton.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
        
        self.creatButton.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
        
        self.upLoadButton.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
    }
    
    self.transButton.backgroundColor = AppFontEB4E4EColor;
    
    self.creatButton.backgroundColor = AppFontEB4E4EColor;
    
    self.upLoadButton.backgroundColor = AppFontEB4E4EColor;
}

#pragma mark - 更多操作按钮按下

- (void)handleCreatButtonWidth:(CGFloat)width {
    
    //取消全选。回复原来的状态
    for (JGJProicloudListModel *cloudListModel in self.icloudModel.list) {
        
        cloudListModel.isSelected = NO;
        
    }
    
    [self.tableView reloadData];
    
    [self.creatButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(width);
    }];
    
    [self.transButton setTitle:@"将文件移动到..." forState:UIControlStateNormal];
    
    [self.upLoadButton setTitle:@"删除" forState:UIControlStateNormal];
}

- (void)setNavButtonWithCloudListCellType:(ProicloudListCellType)cloudListCellType {


    if (_cloudListCellType == ProicloudListMoreOperaCellType ) {
        
        [self setAllCancelButton];
        
    }else {
    
        [self setLeftBatButtonItem];
    }

}

- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)setAllCancelButton {

    UIButton *cancelButton = [[UIButton alloc] init];
    
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    
    cancelButton.hidden = self.icloudModel.list.count == 0;
    
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.allCancelButton = cancelButton;
    
    [cancelButton addTarget:self action:@selector(allSelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton.frame = CGRectMake(0, 0, 70, 40);
    
    [cancelButton setTitle:@"全选" forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

#pragma mark - buttonAction

#pragma mark - 全选
- (void)allSelButtonPressed:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    [self changeAllSelButtonStatus:sender];
    
    [self showSelFileNum];

}

#pragma mark - 改变全选按钮状态
- (void)changeAllSelButtonStatus:(UIButton *)sender {

    [self.selFiles removeAllObjects];
    
    //全选
    if (sender.selected) {
        
        [self.allCancelButton setTitle:@"取消全选" forState:UIControlStateNormal];
        
        for (JGJProicloudListModel *cloudListModel in self.icloudModel.list) {
            
            cloudListModel.isSelected = YES;
            
            [self.selFiles addObject:cloudListModel];
        }
        
    }else {
        
        [self.allCancelButton setTitle:@"全选" forState:UIControlStateNormal];
        
        //取消全选
        for (JGJProicloudListModel *cloudListModel in self.icloudModel.list) {
            
            cloudListModel.isSelected = NO;
            
        }
        
    }
    
    [self.tableView reloadData];

}

#pragma mark - 返回
- (void)backButtonPressed:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)bottomButtonPressed:(UIButton *)sender {
    
    ProicloudVcButtonType buttonType = sender.tag - 100;
    
    if (self.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        [self moreOperaBottomButtonWithButtonType:buttonType];
    }else {
    
        [self defaultBottomButtonWithButtonType:buttonType];
    }
    
}

#pragma mark - 传输、新建、上传
- (void)defaultBottomButtonWithButtonType:(ProicloudVcButtonType)buttonType {

    if ([self cloudOverTimeTip]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    switch (buttonType) {
        
        //传输
        case ProicloudVcTransButtonType:{
            
            JGJProiCloudTransferListVc *transferListVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProiCloudTransferListVc"];;
            
            transferListVc.proListModel = self.proListModel;
            
            transferListVc.proicloudRootVc = self;
            
            [self.navigationController pushViewController:transferListVc animated:YES];
        }
            
            break;
        
        //新建
        case ProicloudVcCreatButtonType:{

            JGJProicloudListModel *cloudListModel = [JGJProicloudListModel new];
            
            cloudListModel.type = @"dir";
            
            JGJProiCloudCreatFileView *creatFileView = [JGJProiCloudCreatFileView proiCloudCreatFileView:cloudListModel];
            
            
            creatFileView.onOkBlock = ^(JGJProiCloudCreatFileView *creatFileView) {
                
                 weakSelf.createCloudDirRequest.cat_name = creatFileView.fileNameTextField.text;
                
                [weakSelf handleCreateCloudDirRequest];
            };

            
        }
            
            break;
            
        //上传
        case ProicloudVcUploadButtonType:{
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            
            __weak typeof(self) weakSelf = self;
            
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                [weakSelf handelUploadFiles:photos assets:assets isSelectOriginalPhoto:isSelectOriginalPhoto];

            }];
            
            imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, id asset) {
                
                
                [JGJProiCloudTool getPhotoAlbumPathFromPHAsset:asset Complete:^(NSString *filePath, NSString *fileName) {
                    
                    [weakSelf getImageAsset:asset assets:nil image:nil fileUrl:filePath];
                    
                    NSData *videoData = [NSData dataWithContentsOfFile:filePath];
                    
                    TYLog(@"filePath ======%@, fileName ==== %@ videoData.length == %@", filePath, fileName, @(videoData.length));

                }];
                
            };

            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
            //如果空间不足就购买
            JGJProiCloudTool *proiCloudTool = [JGJProiCloudTool shareProiCloudTool];
            
            proiCloudTool.proiCloudToolBlock = ^(id response) {
              
                [weakSelf handleOrderVcWithBuyGoodType:CloudNumType];
                
            };
            
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 上传图片文件
- (void)handelUploadFiles:(NSArray *)medias assets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    __weak typeof(self) weakSelf = self;
    
    for (NSInteger indx = 0; indx < assets.count; indx++) {
        
        UIImage *image = medias[indx];
        
        PHAsset *phAsset = assets[indx];
        
        self.cloudListModel.class_type = self.proListModel.class_type;
        
        self.cloudListModel.group_id = self.proListModel.group_id;
        
        //将相册资源转为地址
        [JGJProiCloudTool getPhotoAlbumPathFromPHAsset:phAsset Complete:^(NSString *filePath, NSString *fileName) {
            
            if ([NSString isEmpty:filePath] && image) {

//                NSString *creatDate = [NSString stringFromDate:phAsset.creationDate withDateFormat:@"yyyy-MM-dd"];
//                
//               NSString *allFileName = [NSString stringWithFormat:@"%@-%@", creatDate, fileName];
                
                NSString *PATH_MOVIE_FILE = UPLoad_FILE_PATH(fileName);
                
                [UIImagePNGRepresentation(image) writeToFile:PATH_MOVIE_FILE atomically:YES];
                
                filePath = PATH_MOVIE_FILE;
            }
            
            [weakSelf getImageAsset:phAsset assets:nil image:image fileUrl:filePath];
            
            
        }];
        
    }
    
}

#pragma mark - 判断文件是否存在
- (BOOL)isDataBaseExistUploadFile:(NSString *)fileName {

    JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
    
    icloudListModel.group_id = self.proListModel.group_id;
    
    NSArray *icloudList = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:ProiCloudDataBaseUpLoadType];
    
    BOOL isExist = NO;
    
    for (JGJProicloudListModel *proicloudListModel in icloudList) {
        
        if ([proicloudListModel.file_name isEqualToString:fileName]) {
            
            isExist = YES;
            
            break;
        }
    }
    
    return isExist;
}

#pragma mark - 移动、删除按钮
- (void)moreOperaBottomButtonWithButtonType:(ProicloudVcButtonType)buttonType {
    
    switch (buttonType) {
        
        //移动文件
        case ProicloudVcMoveButtonType:{
            
            if ([self cloudOverTimeTip]) {
                
                return;
            }
            
            JGJProiCloudMoveFileVc *moveFileVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProiCloudMoveFileVc"];;
            
//            moveFileVc.cloudListModel = self.cloudListModel;
            
            moveFileVc.selFiles = self.selFiles;
            
            moveFileVc.proListModel = self.proListModel;
            
            [self.navigationController pushViewController:moveFileVc animated:YES];

        }
            
            break;
        
        //删除文件
        case ProicloudVcDelButtonType:{
            
            __weak typeof(self) weakSelf = self;
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"确认要删除文件？已删除的文件可以在回收站里恢复";
            
            desModel.popTextAlignment = NSTextAlignmentLeft;
            
            desModel.lineSapcing = 3.0;
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.onOkBlock = ^{
                
                [weakSelf handleDelFiles];
            };
        }
            
            break;
            
            
        default:
            break;
    }

}

- (void)loadProiCloudList {

    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/getOssList" parameters:parameters success:^(id responseObject) {
        
        self.proicloudRootVcType = ProicloudRootDefaultVcType;
        
        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.icloudModel = icloudModel;
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}


- (void)handleCreateCloudDirRequest {
    
    if ([NSString isEmpty:self.createCloudDirRequest.cat_name]) {
        
        return;
    }

    NSDictionary *parameters = [self.createCloudDirRequest mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/createCloudDir" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.icloudModel = icloudModel;
        
//        [self loadProiCloudList];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark- 添加数据到数据库
- (void)getImageAsset:(PHAsset *)asset assets:(NSArray *)assets image:(UIImage *)image fileUrl:(NSString *)fileUrl {
    
    __block NSString *fileType = @"";
    
    __block NSString *fileName = @"";
    
    __block int64_t fileSize = 1 * 1024 * 1024;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    [JGJProiCloudTool getPhotoAlbumPathFromPHAsset:asset photoAlbumResult:^(NSString *orgfileType, NSString *orgFilename, int64_t size) {
       
        fileType = orgfileType.lowercaseString;
    
        NSString *creatDate = [NSString stringFromDate:asset.creationDate withDateFormat:@"yyyy-MM-dd"];
        
        fileName = [NSString stringWithFormat:@"%@-%@", creatDate, orgFilename];
        
        fileSize = size;
        
    }];
    
    //添加到上传列表开始
    
    JGJProicloudListModel *upLoadCloudListModel = [JGJProicloudListModel new];
    
    upLoadCloudListModel.file_name = fileName;
    
    upLoadCloudListModel.file_type = fileType;
    
    upLoadCloudListModel.is_upload = ProiCloudDataBaseUpLoadType;
    
    upLoadCloudListModel.group_id = self.proListModel.group_id;
    
    upLoadCloudListModel.class_type = self.proListModel.class_type;
    
    upLoadCloudListModel.date = [NSString stringFromDate:[NSDate date] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //有就传没有就不传为nil
//    upLoadCloudListModel.fileId = self.cloudListModel.fileId;
    
    //这是父文件id
    upLoadCloudListModel.parent_id = self.cloudListModel.fileId;
    
    // 上传的时候没有id，名字加时间戳作为唯一标示
    upLoadCloudListModel.iCloudUniqueId = [NSString stringWithFormat:@"%@-%@", timeID,fileName];
    
    //获取资源大小
    NSData *photoAlbumData = [NSData dataWithContentsOfFile:fileUrl];
    
    NSString *file_size = [NSString stringWithFormat:@"%@", @(photoAlbumData.length)];
    
    if (image) {
        
        file_size = [NSString stringWithFormat:@"%@", @([TYUIImage imageData:image].length)];
    }
    
    NSInteger verValue = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    //小于10的系统可能获取不到大大小
    if (verValue < 10 && [file_size isEqualToString:@"0"]) {
        
        file_size = [NSString stringWithFormat:@"%@", @(1 * 1024 * 1024)];
        
    }
    
    upLoadCloudListModel.totalBytesExpected = photoAlbumData.length;
    
    upLoadCloudListModel.file_size = file_size;
    
    //上传图片的路径
    upLoadCloudListModel.file_path = fileUrl;
    
    //全路径
    upLoadCloudListModel.file_merge_path = self.cloudListModel.file_merge_path;
    
    //oss_file_name不会改变
    upLoadCloudListModel.oss_file_name = fileName;
    
    //有没有图片作区分大类型
    if (image) {
        
        upLoadCloudListModel.file_broad_type = @"pic";
    }else {
    
        upLoadCloudListModel.file_broad_type = @"video";
    }
    
    if ([self isDataBaseExistUploadFile:fileName]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [TYShowMessage showError:@"上传的文件已存在"];
        });
        
        return;
    }
    
//    //点击之后就添加
//    [JGJProiCloudDataBaseTool addCollecticloudListModel:upLoadCloudListModel];
    
    //调用工具类请求参数上传到OSS
    [JGJProiCloudTool getImageAsset:asset assets:assets image:image fileUrl:fileUrl cloudListModel:upLoadCloudListModel];
    
}

#pragma mark - 删除文件
- (void)handleDelFiles {
    
    NSMutableArray *delfiles = [NSMutableArray new];
    
    for (JGJProicloudListModel *cloudListModel in self.selFiles) {
        
        JGJProiColoudDelFilesRequestModel *delRequestCloudListModel = [JGJProiColoudDelFilesRequestModel new];
        
        delRequestCloudListModel.id = cloudListModel.fileId;
        
        delRequestCloudListModel.type = cloudListModel.type;
        
        [delfiles addObject:delRequestCloudListModel];
    }
    
    self.delFileRequestModel.delFile_ids = delfiles;
    
    NSDictionary *parameters = [self.delFileRequestModel mj_keyValues];
    
    NSArray *sourceIds = parameters[@"delFile_ids"];
    
    NSString *sourceIsStr = [sourceIds mj_JSONString];
    
    sourceIsStr = [sourceIsStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    self.delFileRequestModel.delFile_ids = nil;
    
    parameters = [self.delFileRequestModel mj_keyValues];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addEntriesFromDictionary:parameters];
    
    [dic setObject:sourceIsStr?:@"" forKey:@"source_ids"];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/delFiles" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self.selFiles removeAllObjects];
        
        [self showSelFileNum];
        
        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.icloudModel = icloudModel;
        
        //删除之后恢复初始状态
        self.cloudListCellType = ProicloudListDefaultCellType;
        
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 重命名文件
- (void)handleRenameFileWithCell:(JGJProicloudListCell *)cell {
    
    NSString *fileName = self.renameFileRequestModel.file_name;
    
    BOOL isSame = [cell.cloudListModel.file_name.uppercaseString isEqualToString:fileName.uppercaseString];
    
    //没改变就请求
    if (isSame || [NSString isEmpty:self.renameFileRequestModel.file_name]) {
        
        return;
    }
    
    self.renameFileRequestModel.file_name = fileName;
    
    NSDictionary *parameters = [self.renameFileRequestModel mj_keyValues];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/renameFile" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        cell.cloudListModel.file_name = fileName;
        
//        [self.tableView beginUpdates];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        
//        [self.tableView endUpdates];
                
        [self loadProiCloudList];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 收搜文件
- (void)loadSearchFile {
    
    if ([NSString isEmpty:self.searchFileRequestModel.file_name]) {
        
        return;
    }

    NSDictionary *parameters = [self.searchFileRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/searchFile" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.proicloudRootVcType = ProicloudRootSearchVcType;
        
        self.searchIcloudModel = icloudModel;
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)setProicloudRootVcType:(ProicloudRootVcType)proicloudRootVcType {

    _proicloudRootVcType = proicloudRootVcType;
    
    self.searchFileRequestModel.file_name = nil;
    
    [self.tableView reloadData];
}

- (void)searchValueChange:(NSString *)value {
    
    self.searchFileRequestModel.file_name = value;
    
    if ([NSString isEmpty:value]) {
        
        self.proicloudRootVcType = ProicloudRootDefaultVcType;
        
    }
    
//    [self handleSearchBarMoveTop];
//    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
//        [self.view addSubview:self.searchResultView];
//    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
//        [self.searchResultView removeFromSuperview];
//    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_name contains %@", value];
//        NSMutableArray *chatList = [self.icloudModel.list filteredArrayUsingPredicate:predicate].mutableCopy;
    
//    self.searchResultView.searchValue = value;
//    
//    self.searchResultView.results = chatList;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    [self handleSearchBarViewMoveDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self handleSearchBarMoveTop];
    return YES;
}

#pragma mark - 收搜文件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self loadSearchFile];
    
    [self.view endEditing:YES];
    
    return ![NSString isEmpty:textField.text];
    
}

#pragma mark - 当前不需要添加当前页面搜索
- (void)handleSearchBarMoveTop {
    
//    self.searchResultView.searchValue = nil;
//    self.searchResultView.results = @[];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.navigationController.navigationBarHidden = YES;
//        self.cancelButtonW.constant = 45;
//        self.cancelButton.hidden = NO;
//        [self.view addSubview:self.searchResultView];
//        [self.view layoutIfNeeded];
//    }];
}

- (void)handleSearchBarViewMoveDown {
    self.searchBarTF.text = nil;
    [self.searchBarTF resignFirstResponder];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButtonW.constant = 12;
        self.cancelButton.hidden = YES;
        [self.searchResultView removeFromSuperview];
        [self.view layoutIfNeeded];
    }];
}

- (JGJSearchResultView *)searchResultView {
    CGFloat height = self.tabBarController.tabBar.frame.size.height + 68.0;
    CGFloat searchResultViewY = 68.0;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - height}}];
        
        searchResultView.resultViewType = JGJSearchProiCloudInfoType;
        
        searchResultView.delegate = self;
        
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

- (void)setIcloudModel:(JGJProicloudModel *)icloudModel {

    _icloudModel = icloudModel;
    
    [self showDefaultViewWithIcloudModel:icloudModel];
    
}

- (void)setSearchIcloudModel:(JGJProicloudModel *)searchIcloudModel {

    _searchIcloudModel = searchIcloudModel;

     [self showDefaultViewWithIcloudModel:searchIcloudModel];
}

#pragma mark-是否显示默认页
- (void)showDefaultViewWithIcloudModel:(JGJProicloudModel *)icloudModel{

    self.allCancelButton.hidden = icloudModel.list.count == 0;
    
    if (icloudModel.list.count == 0) {
        
        [self.view addSubview:self.orderDefaultView];
        
        CGFloat top = 48;
        
        if (self.icloudModel.list.count == 0) {
            
            top = 0;
        }
        
        [self.orderDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(top);
            
            make.left.right.mas_equalTo(0);
            
            make.bottom.mas_equalTo(self.bottomView.mas_top);
            
        }];
        
        self.contentSearchBarView.hidden = self.icloudModel.list.count == 0;
        
    }else {
        
        [self.orderDefaultView removeFromSuperview];
        
        self.contentSearchBarView.hidden = NO;
        
    }
    
    [self.tableView reloadData];
    
}

- (void)browsePhotoImageView{
    
    NSMutableArray *photos = [NSMutableArray new];
    
    NSInteger selPhotoIndex = 0;
    
    BOOL isCount = YES;
    
    for (JGJProicloudListModel *cloudListModel in self.icloudModel.list) {
        
        if ([cloudListModel.file_broad_type isEqualToString:@"pic"]) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            NSURL *filePathUrl = [NSURL URLWithString:cloudListModel.file_path]; // 图片路径
            
            photo.url = filePathUrl; // 图片路径
            
            photo.srcImageView = cloudListModel.imageView; // 来源于哪个UIImageView
            
            [photos addObject:photo];
            
            if (![self.selCloudListModel.fileId isEqualToString:cloudListModel.fileId] && isCount) {
                
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

#pragma mark - 云盘过期提示
- (BOOL)cloudOverTimeTip {

    //判断云盘是否过期
    JGJGroupMangerTool *tool = [[JGJGroupMangerTool alloc] init];
    
    tool.buyGoodType = CloudNumType;
    
    tool.targetVc = self.navigationController;
    
    tool.workProListModel = self.proListModel;
    
    return [tool overCloudTip];
}

#pragma mark - 进入购买页面
- (void)handleOrderVcWithBuyGoodType:(BuyGoodType)buyGoodType {
    
    //弹框申请
    JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];
    
    request.group_id = self.proListModel.group_id;
    
    request.class_type = self.proListModel.class_type;
    
    request.server_type = @"1";
    
    [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {
        
        
    }];
    
//    JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
//    
//    SureOrderListVC.GoodsType = buyGoodType;
//    
//    JGJOrderListModel *orderListModel = [JGJOrderListModel new];
//    
//    orderListModel.group_id = self.proListModel.group_id;
//    
//    orderListModel.class_type = self.proListModel.class_type;
//    orderListModel.upgrade = YES;
//    SureOrderListVC.orderListModel = orderListModel;
//    
//    [self.navigationController pushViewController:SureOrderListVC animated:YES];
}

- (JGJProicloudRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJProicloudRequestModel new];
        
        _requestModel.class_type = self.proListModel.class_type;
        
        _requestModel.group_id = self.proListModel.group_id;
        
        _requestModel.parent_id = self.cloudListModel.fileId;
        
    }

    return _requestModel;
}

- (JGJProiColoudCreateCloudDirRequestModel *)createCloudDirRequest {
    
    if (!_createCloudDirRequest) {
        
        _createCloudDirRequest = [JGJProiColoudCreateCloudDirRequestModel new];
        
        _createCloudDirRequest.class_type = self.proListModel.class_type;
        
        _createCloudDirRequest.group_id = self.proListModel.group_id;
        
        _createCloudDirRequest.parent_id = self.cloudListModel.fileId;
        
    }
    
    return _createCloudDirRequest;
}

- (JGJProiCloudUploadFilesRequestModel *)uploadFilesRequestModel {

    if (!_uploadFilesRequestModel) {
        
        _uploadFilesRequestModel = [JGJProiCloudUploadFilesRequestModel new];
        
        _uploadFilesRequestModel.class_type = self.proListModel.class_type;
        
        _uploadFilesRequestModel.group_id = self.proListModel.group_id;
        
        _uploadFilesRequestModel.cat_id = self.cloudListModel.fileId;
    }
    
    return _uploadFilesRequestModel;

}

- (JGJQuaSafeOrderDefaultView *)orderDefaultView {
    
    if (!_orderDefaultView) {
        
        _orderDefaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"云盘暂时没有任何资料";

        infoModel.actionButtonTitle = @"";
        
        infoModel.desInfo = @"";
        
        infoModel.isHiddenActionButton = YES;
        
        infoModel.isHiddenlineView = YES;
        
        infoModel.desButtonFontColor = AppFont999999Color;
        
        infoModel.desButtonFontSize = AppFont34Size;
        
        infoModel.isCenter = YES;
        
        _orderDefaultView.infoModel = infoModel;
        
    }
    
    return _orderDefaultView;
}

- (JGJProiColoudDelFilesRequestModel *)delFileRequestModel {

    if (!_delFileRequestModel) {
        
        _delFileRequestModel = [JGJProiColoudDelFilesRequestModel new];
        
        _delFileRequestModel.class_type = self.proListModel.class_type;
        
        _delFileRequestModel.group_id = self.proListModel.group_id;
        
        _delFileRequestModel.parent_id = self.cloudListModel.fileId;
        
        _delFileRequestModel.del_type = @"0";
    }

    return _delFileRequestModel;
}

- (JGJProiColoudSearchFileRequestModel *)searchFileRequestModel {

    if (!_searchFileRequestModel) {
        
        _searchFileRequestModel = [JGJProiColoudSearchFileRequestModel new];
        
        _searchFileRequestModel.group_id = self.proListModel.group_id;
        
        _searchFileRequestModel.class_type = self.proListModel.class_type;
    }

    return _searchFileRequestModel;
}

- (JGJProiColoudRenameFileRequestModel *)renameFileRequestModel {

    if (!_renameFileRequestModel) {
        
        _renameFileRequestModel = [JGJProiColoudRenameFileRequestModel new];
        
    }
    
    return _renameFileRequestModel;

}

-(NSMutableArray *)selFiles {

    if (!_selFiles) {
        
        _selFiles = [NSMutableArray new];
    }
    
    return _selFiles;

}

- (JGJProicloudListModel *)cloudListModel {

    if (!_cloudListModel) {
        
        _cloudListModel = [JGJProicloudListModel new];
        
        _cloudListModel.class_type = self.proListModel.class_type;
        
        _cloudListModel.group_id = self.proListModel.group_id;
    }

    return _cloudListModel;
}

- (NSTimer *)taskProgressTimer {
    
    if (!_taskProgressTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        _taskProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(taskFreshProgress:) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_taskProgressTimer forMode:NSRunLoopCommonModes];
    }
    
    return _taskProgressTimer;
}

- (void)taskFreshProgress:(NSTimer *)timer {
    
    if (self.handleTaskProgressTimerBlock) {
        
        self.handleTaskProgressTimerBlock();
    }
    
}

#pragma mark - 是否有文件类型
- (JGJProicloudListModel *)iCloudFileTypeWithcloudListModel:(JGJProicloudListModel *)cloudListModel {


    NSRange upperRange = [cloudListModel.file_name rangeOfString:cloudListModel.file_type.uppercaseString];
    
    NSRange lowerRange = [cloudListModel.file_name rangeOfString:cloudListModel.file_type.lowercaseString];
    
    if (upperRange.location == NSNotFound && lowerRange.location == NSNotFound && ![cloudListModel.file_type isEqualToString:@"dir"]) {
        
        cloudListModel.file_name = [NSString stringWithFormat:@"%@.%@", cloudListModel.file_name,cloudListModel.file_type];
    }
    
    return cloudListModel;
}

@end
