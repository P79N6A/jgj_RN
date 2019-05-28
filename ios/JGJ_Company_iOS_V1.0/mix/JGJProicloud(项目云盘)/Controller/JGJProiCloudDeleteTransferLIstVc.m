//
//  JGJProiCloudDeleteTransferLIstVc.m
//  JGJCompany
//
//  Created by yj on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudDeleteTransferLIstVc.h"

#import "JGJProicloudListCell.h"

#import "UILabel+GNUtil.h"

#import "JGJQuaSafeOrderDefaultView.h"


#import "JGJProiCloudTool.h"


@interface JGJProiCloudDeleteTransferLIstVc () <

    UITableViewDelegate,

    UITableViewDataSource

>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property (weak, nonatomic) IBOutlet UILabel *showSelectedCountLable;

//选择要删除的文件
@property (nonatomic, strong) NSMutableArray *selFiles;

@property (weak, nonatomic) IBOutlet UIView *contentBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottomViewH;

@property (strong, nonatomic) UIButton *allCancelButton;


@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *defaultView;

@property (strong ,nonatomic) JGJProicloudModel *icloudModel;

@end

@implementation JGJProiCloudDeleteTransferLIstVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllCancelButton];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.showSelectedCountLable.textColor = AppFont666666Color;
    
    self.showSelectedCountLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    [self.delButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:JGJCornerRadius];
    
    self.delButton.backgroundColor = AppFontEB4E4EColor;
    
    self.contentBottomView.hidden = YES;
    
    self.contentBottomViewH.constant = 0;
 
    switch (self.baseType) {
        case ProiCloudDataBaseDownLoadType:{
            
            self.title = @"我下载的";
            
        }
            
            break;
       
        case ProiCloudDataBaseUpLoadType:{
            
            self.title = @"我上传的";
        }
            
            break;
            
        default:
            break;
    }
    
    JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
    
    icloudListModel.group_id = self.proListModel.group_id;
    
    NSArray *icloudModelList = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:self.baseType];
    
    JGJProicloudModel *icloudModel = [JGJProicloudModel new];
    
    icloudModel.list = icloudModelList;

    self.icloudModel = icloudModel;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.icloudModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProicloudListCell *cloudListCell = [JGJProicloudListCell cellWithTableView:tableView];

    JGJProicloudListModel *cloudListModel = self.icloudModel.list[indexPath.row];
    
    cloudListModel.cloudListCellType = ProicloudListMoreOperaCellType;
    
    cloudListCell.isHiddenButton = YES;
    
    cloudListCell.lineView.hidden = self.icloudModel.list.count - 1 == indexPath.row;
    
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

    [self showSelFilesSelectedCount:self.selFiles];
    
}

- (void)setIcloudModel:(JGJProicloudModel *)icloudModel {

    _icloudModel = icloudModel;
    
    if (_icloudModel.list.count > 0) {
        
        [self.tableView reloadData];
        
    }else {
        
        [self showDefaultView];
    }

}

-(NSMutableArray *)selFiles {
    
    if (!_selFiles) {
        
        _selFiles = [NSMutableArray new];
    }
    
    return _selFiles;
    
}

#pragma mark - 显示底部控件状态
- (void)showSelFilesSelectedCount:(NSMutableArray *)selFiles {

    NSString *countStr = [NSString stringWithFormat:@"%@", @(selFiles.count)];
    
    self.showSelectedCountLable.text = [NSString stringWithFormat:@"本次已选中 %@ 文件", countStr];
    
    [self.showSelectedCountLable markText:countStr withColor:AppFontd7252cColor];
    
    if (selFiles.count == 0) {
        
        self.contentBottomView.hidden = YES;
        
        self.contentBottomViewH.constant = 0;
        
    } else {
        
        self.contentBottomView.hidden = NO;
        
        self.contentBottomViewH.constant = 63;
    }
    
    self.allCancelButton.selected = (self.selFiles.count == self.icloudModel.list.count) && self.selFiles.count > 0;
    
    NSString *buttonTitle = self.allCancelButton.selected ? @"取消全选" : @"全选";
    
    [self.allCancelButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

#pragma mark-是否显示默认页
- (void)showDefaultView{
    
    [self.view addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
    
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


- (void)setAllCancelButton {
    
    UIButton *cancelButton = [[UIButton alloc] init];
    
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
    
    [self.tableView reloadData];
    
    [self showSelFilesSelectedCount:self.selFiles];
    
}

#pragma mark - 删除按钮按下

- (IBAction)delButtonPressed:(UIButton *)sender {
    
    for (JGJProicloudListModel *icloudListModel in self.selFiles) {
        
        [JGJProiCloudDataBaseTool removeCollecticloudListModel:icloudListModel];
        
        NSString *filePath = FILE_PATH(icloudListModel.file_name);
        
        if (self.baseType == ProiCloudDataBaseUpLoadType) {
            
            filePath = UPLoad_FILE_PATH(icloudListModel.file_name);
        }
        
        [JGJOSSCommonHelper removeFileWithFilepath:filePath];
        
        if ([JGJOSSCommonHelper removeFileWithFilepath:filePath]) {

            
        }
    }
    
    switch (self.baseType) {
            
        case ProiCloudDataBaseDownLoadType:{
            
        
        }
            
            break;
            
        case ProiCloudDataBaseUpLoadType:{
            

        }
            
            break;
            
        default:
            break;
    }
    
    //返回删除后已完成的所有数据
    JGJProicloudListModel *icloudListModel = [JGJProicloudListModel new];
    
    icloudListModel.group_id = self.proListModel.group_id;
    
    NSArray *icloudModelList = [JGJProiCloudDataBaseTool allicloudListWithIcloudListModel:icloudListModel proiCloudDataBaseType:self.baseType];
    
    JGJProicloudModel *icloudModel = [JGJProicloudModel new];
    
    icloudModel.list = icloudModelList;
    
    self.icloudModel = icloudModel;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 取消按钮按下返回
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
