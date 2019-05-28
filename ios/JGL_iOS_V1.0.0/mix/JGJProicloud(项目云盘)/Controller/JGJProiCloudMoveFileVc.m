//
//  JGJProiCloudMoveFileVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudMoveFileVc.h"

#import "JGJProicloudListCell.h"

#import "JGJQuaSafeOrderDefaultView.h"

#import "JGJProiCloudCreatFileView.h"

#import "NSString+Extend.h"

#import "JGJProicloudRootVc.h"

@interface JGJProiCloudMoveFileVc () <

    UITableViewDataSource,

    UITableViewDelegate,

    JGJProicloudListCellDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *moveButton;

@property (strong, nonatomic) NSArray *dataSource;

//目录请求
@property (strong, nonatomic) JGJProicloudRequestModel *requestModel;

@property (strong ,nonatomic) JGJProicloudModel *icloudModel;

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *defaultView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *filePathLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) JGJProiColoudMoveFilesRequestModel *moveFilesRequestModel;

@property (strong, nonatomic) JGJProiColoudCreateCloudDirRequestModel *createCloudDirRequest;

@end

@implementation JGJProiCloudMoveFileVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    
    [self.cancelButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self.cancelButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.moveButton.backgroundColor = AppFontd7252cColor;
    
    [self.moveButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:JGJCornerRadius / 2.0];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.topView.backgroundColor = AppFontf1f1f1Color;
    
    self.filePathLable.text = @"项目云盘";
    
    if (![NSString isEmpty:self.cloudListModel.file_merge_path]) {
        
        NSString *filePath = self.cloudListModel.file_merge_path.copy;
        
        NSMutableString *curFilePath = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@">"].mutableCopy;
        
        [curFilePath insertString:@"项目云盘>" atIndex:0];
        
        NSRange range = [curFilePath rangeOfString:@">" options:NSBackwardsSearch];
        
        curFilePath = [curFilePath substringToIndex:range.location].copy;
        
        self.filePathLable.text = curFilePath;
    }
    
    [self loadProiCloudList];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.icloudModel.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProicloudListModel *cloudListModel = self.icloudModel.list[indexPath.row];
    
    JGJProicloudListCell *cloudListCell = [JGJProicloudListCell cellWithTableView:tableView];
    
    cloudListCell.delegate = self;
    
    cloudListCell.isHiddenButton = YES;
    
    cloudListModel.isExpand = NO;
    
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
    
    JGJProiCloudMoveFileVc *moveFileVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProiCloudMoveFileVc"];;
    
    moveFileVc.selFiles = self.selFiles;
    
    moveFileVc.proListModel = self.proListModel;
    
    moveFileVc.cloudListModel = cloudListModel;
    
    //从第一层开始移动
    
    self.cloudListModel = cloudListModel;
    
    [self.navigationController pushViewController:moveFileVc animated:YES];

}

#pragma mark - JGJProicloudListCellDelegate

- (void)proicloudListCell:(JGJProicloudListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel {
    
    
    
}

- (void)loadProiCloudList {
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/excloudFiles" parameters:parameters success:^(id responseObject) {

        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.icloudModel = icloudModel;
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)setIcloudModel:(JGJProicloudModel *)icloudModel {
    
    _icloudModel = icloudModel;
    
    [self showDefaultViewWithIcloudModel:icloudModel];
    
}

#pragma mark-是否显示默认页
- (void)showDefaultViewWithIcloudModel:(JGJProicloudModel *)icloudModel{
    
    if (icloudModel.list.count == 0) {
        
        [self.view addSubview:self.defaultView];
        
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.mas_equalTo(0);
            
            make.bottom.mas_equalTo(self.bottomView.mas_top);
            
        }];
        
    }else {
        
        [self.defaultView removeFromSuperview];
        
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - buttonAction
#pragma mark - 新建文件夹按钮按下
- (IBAction)rightItemPressed:(UIBarButtonItem *)sender {
    
    JGJProicloudListModel *cloudListModel = [JGJProicloudListModel new];
    
    cloudListModel.type = @"dir";
    
    __weak typeof(self) weakSelf = self;
    
    JGJProiCloudCreatFileView *creatFileView = [JGJProiCloudCreatFileView proiCloudCreatFileView:cloudListModel];
    
//    creatFileView.proiCloudCreatFileViewBlock = ^(JGJProiCloudCreatFileView *creatFileView, NSString *fileNameText) {
//        
//        weakSelf.createCloudDirRequest.cat_name = fileNameText;
//        
//    };
    
     creatFileView.onOkBlock = ^(JGJProiCloudCreatFileView *creatFileView) {
        
         weakSelf.createCloudDirRequest.cat_name = creatFileView.fileNameTextField.text;
         
        [weakSelf handleCreatFiles];
        
    };

}

- (void)handleMoveFiles {

    NSMutableArray *delfiles = [NSMutableArray new];
    
    for (JGJProicloudListModel *cloudListModel in self.selFiles) {
        
        JGJProiColoudMoveFilesRequestModel *moveRequestCloudListModel = [JGJProiColoudMoveFilesRequestModel new];
        
        moveRequestCloudListModel.id = cloudListModel.fileId;
        
        moveRequestCloudListModel.type = cloudListModel.type;
        
        [delfiles addObject:moveRequestCloudListModel];
    }
    
    self.moveFilesRequestModel.moveFile_ids = delfiles;
    
    NSDictionary *parameters = [self.moveFilesRequestModel mj_keyValues];
    
    NSArray *sourceIds = parameters[@"moveFile_ids"];
    
    NSString *sourceIsStr = [sourceIds mj_JSONString];
    
    sourceIsStr = [sourceIsStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    self.moveFilesRequestModel.moveFile_ids = nil;
    
    self.moveFilesRequestModel.dir_id = self.cloudListModel.fileId;
    
    parameters = [self.moveFilesRequestModel mj_keyValues];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addEntriesFromDictionary:parameters];
    
    [dic setObject:sourceIsStr?:@"" forKey:@"source_ids"];

    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/moveFiles" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
//        [self loadProiCloudList];
        
        [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:[JGJProicloudRootVc class]]) {
                
                [self.navigationController popToViewController:obj animated:YES];
                
                *stop = YES;
            }
            
        }];
        
        [TYShowMessage showSuccess:@"移动成功"];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}


#pragma mark - 创建文件夹

- (void)handleCreatFiles {
    
    if ([NSString isEmpty:self.createCloudDirRequest.cat_name]) {
        
        return;
    }
    
    NSDictionary *parameters = [self.createCloudDirRequest mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/createCloudDir" parameters:parameters success:^(id responseObject) {
        
        [self loadProiCloudList];
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)moveButtonPressed:(UIButton *)sender {
    
    [self handleMoveFiles];
}

- (JGJProicloudRequestModel *)requestModel {
    
    if (!_requestModel) {
        
        _requestModel = [JGJProicloudRequestModel new];
        
        _requestModel.class_type = self.proListModel.class_type;
        
        _requestModel.group_id = self.proListModel.group_id;
        
        if ([NSString isEmpty:self.cloudListModel.fileId]) {
            
            _requestModel.parent_id = @"0";
            
        }else {
        
            _requestModel.parent_id = self.cloudListModel.fileId;
        }

        NSMutableString *mergeMoveid = [NSMutableString string];
        
        for (JGJProicloudListModel *cloudListModel in self.selFiles) {
            
            [mergeMoveid appendFormat:@"%@,", cloudListModel.fileId];
            
        }
        
        _requestModel.move_id = mergeMoveid;
        
        _requestModel.type = @"dir";
    }
    
    return _requestModel;
}

- (JGJQuaSafeOrderDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJQuaSafeOrderDefaultView alloc] init];
        
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

- (JGJProiColoudMoveFilesRequestModel *)moveFilesRequestModel {

    if (!_moveFilesRequestModel) {
        
        _moveFilesRequestModel = [JGJProiColoudMoveFilesRequestModel new];
        
        _moveFilesRequestModel.class_type = self.proListModel.class_type;
        
        _moveFilesRequestModel.group_id = self.proListModel.group_id;
        
    }

    return _moveFilesRequestModel;
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

@end
