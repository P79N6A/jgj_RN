//
//  JGJProiCloudRecycleVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudRecycleVc.h"

#import "JGJCustomLable.h"

#import "JGJSearchResultView.h"

#import "TYTextField.h"

#import "JGJProicloudListCell.h"

#import "UIView+Extend.h"

#import "JGJQuaSafeOrderDefaultView.h"

#import "NSString+Extend.h"

#import "JGJCustomPopView.h"

#import "JGJProiCloudTool.h"

typedef void(^RequestSuccessBlock)(id);

@interface JGJProiCloudRecycleVc ()<

    UITableViewDelegate,

    UITableViewDataSource,

    JGJProicloudListCellDelegate

>

@property (weak, nonatomic) IBOutlet UIButton *selButton;

@property (weak, nonatomic) IBOutlet JGJCustomLable *desLable;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;

@property (strong, nonatomic) JGJSearchResultView *searchResultView;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;

@property (strong, nonatomic) NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, assign) ProicloudListCellType cloudListCellType;

@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

@property (weak, nonatomic) IBOutlet UIButton *thoroughButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;

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

//删除和回复请求成功提示语
@property (copy, nonatomic) RequestSuccessBlock requestSuccessBlock;

//右上角按钮
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UIButton *allCancelButton;

@end

@implementation JGJProiCloudRecycleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    
    [self loadProiCloudList];
}

#pragma mark - 通用设置
- (void)commonInit{

    self.searchBarTF.layer.borderWidth = 0;
    
    self.searchBarTF.layer.cornerRadius = 3;
    
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    //    self.contentSearchBarView.hidden = YES;
    //    self.contentSearchbarViewH.constant = 0;
    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    self.searchBarTF.returnKeyType = UIReturnKeySearch;
    
    __weak typeof(self) weakSelf = self;
    
    self.searchBarTF.valueDidChange = ^(NSString *value){
        
        [weakSelf searchValueChange:value];
        
        if ([weakSelf.view.subviews containsObject:weakSelf.orderDefaultView]) {
            
            [weakSelf.orderDefaultView removeFromSuperview];
        }
    };
    
    self.topView.backgroundColor = AppFontf1f1f1Color;
    
    self.desLable.textColor = AppFont999999Color;
    
    if (TYIS_IPHONE_5) {
        
        self.desLable.font = [UIFont systemFontOfSize:11];
    }
    
    self.restoreButton.backgroundColor = [UIColor whiteColor];
    
    [self.restoreButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self.restoreButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.thoroughButton.backgroundColor = AppFontEB4E4EColor;
    
    [self.thoroughButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self showBottomView];
    
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
    
    NSInteger count = 0;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
        count = self.searchIcloudModel.list.count;
        
    }else {
        
        cloudListModel = self.icloudModel.list[indexPath.row];
        
        count = self.icloudModel.list.count;
    }
    
    cloudListModel.cloudListCellType = self.cloudListCellType;
    
    cloudListCell.isHiddenButton = YES;
    
    cloudListModel.isExpand = NO;
    
    //需要改变的颜色
    cloudListCell.searchValue = self.searchBarTF.text;
    
    cloudListCell.cloudListModel = cloudListModel;
    
    cloudListCell.lineView.hidden = count - 1 == indexPath.row;
    
    return cloudListCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProicloudListModel *cloudListModel = nil;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
    }else {
        
        cloudListModel = self.icloudModel.list[indexPath.row];
    }
    
    return cloudListModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.cloudListCellType == ProicloudListDefaultCellType) {
        
        return;
    }
    
    JGJProicloudListModel *cloudListModel = nil;
    
    if (self.proicloudRootVcType == ProicloudRootSearchVcType) {
        
        cloudListModel = self.searchIcloudModel.list[indexPath.row];
        
    }else {
        
        cloudListModel = self.icloudModel.list[indexPath.row];
    }
    
    [self selDirWithCloudListModel:cloudListModel];
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];

}

- (void)selDirWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    cloudListModel.isSelected = !cloudListModel.isSelected;
    
    if (cloudListModel.isSelected) {
        
        [self.selFiles addObject:cloudListModel];
        
    }else {
        
        [self.selFiles removeObject:cloudListModel];
        
    }
    
    [self showBottomView];
    
}

#pragma mark - JGJProicloudListCellDelegate

- (void)proicloudListCell:(JGJProicloudListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel {
    

    
}

#pragma mark - 是否显示底部
- (void)showBottomView {

    if (_cloudListCellType == ProicloudListMoreOperaCellType) {
        
        self.bottomView.hidden = self.selFiles.count == 0;
        
        self.bottomViewH.constant = self.selFiles.count == 0 ? 0 : 63;
        
        self.topViewH.constant = 0;
        
        self.topView.hidden = YES;
        
        self.allCancelButton.selected = (self.selFiles.count == self.icloudModel.list.count) && self.selFiles.count > 0;
        
        NSString *buttonTitle = self.allCancelButton.selected ? @"取消全选" : @"全选";
        
        [self.allCancelButton setTitle:buttonTitle forState:UIControlStateNormal];
        
    }else {
        
        self.bottomView.hidden = YES;
        
        self.bottomViewH.constant =  0;
        
        self.topViewH.constant = 78;
        
        self.topView.hidden = NO;
    }
    
    //更改右上角按钮文字状态
    if (self.rightButton.selected) {
        
        [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        
    }else {
        
        [self.rightButton setTitle:@"选择" forState:UIControlStateNormal];
    }

}

- (void)setCloudListCellType:(ProicloudListCellType)cloudListCellType {

    _cloudListCellType = cloudListCellType;
    
    self.searchBarTF.text = nil;
    
    [self setNavButtonWithCloudListCellType:_cloudListCellType];
    
    [self showBottomView];

}

- (IBAction)handleRightSelButtonPressed:(UIButton *)sender {
    
    if (self.icloudModel.list.count == 0) {
        
        return;
    }
    
    sender.selected = !sender.selected;
    
    self.rightButton = sender;
    
    if (sender.selected) {
        
        self.cloudListCellType = ProicloudListMoreOperaCellType;
        
        //添加全选按钮
        [self setAllCancelButton];
        
    }else {
    
        self.cloudListCellType = ProicloudListDefaultCellType;
        
    }
    
    [self.tableView reloadData];
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
}

#pragma mark - 获取回收站列表
- (void)loadProiCloudList {
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/getOssList" parameters:parameters success:^(id responseObject) {
        
        self.proicloudRootVcType = ProicloudRootDefaultVcType;
        
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

- (void)setSearchIcloudModel:(JGJProicloudModel *)searchIcloudModel {
    
    _searchIcloudModel = searchIcloudModel;
    
    [self showDefaultViewWithIcloudModel:searchIcloudModel];
}

#pragma mark-是否显示默认页
- (void)showDefaultViewWithIcloudModel:(JGJProicloudModel *)icloudModel{
    
    if (icloudModel.list.count == 0) {
        
        [self.view addSubview:self.orderDefaultView];
        
        CGFloat top = 78;
        
//        if (self.icloudModel.list.count == 0) {
//            
//            top = 0;
//            
//            self.contentSearchBarView.hidden = YES;
//        }
        
        [self.orderDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(top);
            
            make.left.right.mas_equalTo(0);
            
            make.bottom.mas_equalTo(self.bottomView.mas_top);
            
        }];
        
        
    }else {
        
        [self.orderDefaultView removeFromSuperview];
        
        self.contentSearchBarView.hidden = NO;
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - 删除文件

- (void)handleDelFiles {
    
    __weak typeof(self) weakSelf = self;
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确认要删除文件,一经删除无法恢复";
    
    desModel.popTextAlignment = NSTextAlignmentLeft;
    
    desModel.lineSapcing = 3.0;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.onOkBlock = ^{
        
        [weakSelf handleRestoreDelFileWithUrl:@"v2/cloud/delFiles"];
        
        weakSelf.requestSuccessBlock = ^(id response) {
          
            [TYShowMessage showSuccess:@"删除成功"];
            
        };
    };
    
    
}

#pragma mark - 还原文件
- (void)handleRestoreFile {
    
    [self handleRestoreDelFileWithUrl:@"v2/cloud/restoreFiles"];
    
    self.requestSuccessBlock = ^(id response) {
        
        [TYShowMessage showSuccess:@"还原文件操作成功"];
        
    };
    
}
- (void)handleRestoreDelFileWithUrl:(NSString *)url {

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
    
    [JLGHttpRequest_AFN PostWithApi:url parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self delLocalFile];
        
        [self.selFiles removeAllObjects];
        
        //状态为选择初始状态
        self.rightButton.selected = NO;
        
        //恢复状态
        self.cloudListCellType = ProicloudListDefaultCellType;
        
        self.proicloudRootVcType = ProicloudRootDefaultVcType;
        
        JGJProicloudModel *icloudModel = [JGJProicloudModel mj_objectWithKeyValues:responseObject];
        
        self.icloudModel = icloudModel;
        
        if (self.requestSuccessBlock) {
            
            self.requestSuccessBlock(responseObject);
        }
        
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

#pragma mark - 删除本地文件
- (void)delLocalFile {
    
    for (JGJProicloudListModel *icloudListModel in self.selFiles) {
        
        [JGJProiCloudDataBaseTool removeCollecticloudListModel:icloudListModel];
        
        NSString *filePath = UPLoad_FILE_PATH(icloudListModel.file_name);
        
        BOOL isRemoveSuccess = [JGJOSSCommonHelper removeFileWithFilepath:filePath];
        
        if (isRemoveSuccess) {
            
            TYLog(@"删除成功");
        }
    }
}


#pragma mark - 收搜文件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    [self loadSearchFile];
    
    return YES;
    
}

#pragma mark - buttonAction

- (IBAction)handleDelButtonPressed:(UIButton *)sender {
    
    [self handleDelFiles];
}

- (IBAction)handleRestoreButtonPressed:(UIButton *)sender {
    
    [self handleRestoreFile];
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

#pragma mark - 返回
- (void)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setAllCancelButton {
    
    UIButton *cancelButton = [[UIButton alloc] init];
    
    cancelButton.hidden = self.icloudModel.list.count == 0;
    
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.allCancelButton = cancelButton;
    
    [cancelButton addTarget:self action:@selector(allSelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton.frame = CGRectMake(0, 0, 100, 40);
    
    [cancelButton setTitle:@"全选" forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

#pragma mark - buttonAction

#pragma mark - 全选
- (void)allSelButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
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
    
    [self showBottomView];
    
    [self.tableView reloadData];
    
}


- (JGJProicloudRequestModel *)requestModel {
    
    if (!_requestModel) {
        
        _requestModel = [JGJProicloudRequestModel new];
        
        _requestModel.class_type = self.proListModel.class_type;
        
        _requestModel.group_id = self.proListModel.group_id;
        
//        _requestModel.parent_id = self.cloudListModel.fileId;
        
        _requestModel.is_bin = @"1";
    }
    
    return _requestModel;
}


- (JGJQuaSafeOrderDefaultView *)orderDefaultView {
    
    if (!_orderDefaultView) {
        
        _orderDefaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"暂无文件";
        
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
        
        _delFileRequestModel.del_type = @"-1";
    }
    
    return _delFileRequestModel;
}

- (JGJProiColoudSearchFileRequestModel *)searchFileRequestModel {
    
    if (!_searchFileRequestModel) {
        
        _searchFileRequestModel = [JGJProiColoudSearchFileRequestModel new];
        
        _searchFileRequestModel.cat_id = self.cloudListModel.parent_id;
        
        _searchFileRequestModel.group_id = self.proListModel.group_id;
        
        _searchFileRequestModel.class_type = self.proListModel.class_type;
        
        _searchFileRequestModel.is_bin = @"1";
    }
    
    return _searchFileRequestModel;
}

-(NSMutableArray *)selFiles {
    
    if (!_selFiles) {
        
        _selFiles = [NSMutableArray new];
    }
    
    return _selFiles;
    
}

@end
