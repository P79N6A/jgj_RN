//
//  JGJMergeProVC.m
//  JGJCompany
//
//  Created by yj on 16/9/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMergeProVC.h"
#import "JGJMergeProCell.h"
#import "JGJMergeProPopView.h"
#import "JGJShareProHeaderView.h"
#import "JGJShareProDesView.h"
#import "CFRefreshStatusView.h"
@interface JGJMergeProVC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *mergeProModels;
@property (strong, nonatomic) NSMutableArray *selectedProModels;
@property (weak, nonatomic) IBOutlet UIButton *mergeButton;
@property (strong, nonatomic) JGJShareProHeaderView *headerVeiw;
@property (strong, nonatomic) JGJSplitProModel *splitProModel;
@property (strong, nonatomic) JGJMergeProPopView *mergeProPopView;
@property (weak, nonatomic) IBOutlet UIView *contentButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentButtonViewH;
@end

@implementation JGJMergeProVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadMergeTeamList];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.mergeProPopView) {
        [self.mergeProPopView removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mergeProModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJMergeProCell *cell = [JGJMergeProCell cellWithTableView:tableView];
    JGJMergeSplitProModel *mergeProModel = self.mergeProModels[indexPath.row];
    cell.mergeProModel = mergeProModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JGJMergeProCell mergeProCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJMergeSplitProModel *mergeProModel = self.mergeProModels[indexPath.row];
    mergeProModel.isSelected = !mergeProModel.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (mergeProModel.isSelected) {
        [self.selectedProModels addObject:mergeProModel];
    } else {
        [self.selectedProModels removeObject:mergeProModel];
    }
}

#pragma mark - 获取未关闭的班组列表
- (void)loadMergeTeamList {
    NSDictionary *body = @{
                           @"ctrl" : @"team",
                           @"action": @"mergeTeamList",
                           };
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        self.mergeProModels = [JGJMergeSplitProModel mj_objectArrayWithKeyValuesArray:responseObject];
    } failure:nil];
}

#pragma mark - setter

- (void)setMergeProModels:(NSArray *)mergeProModels {
    _mergeProModels = mergeProModels;
    if (mergeProModels.count > 0) {
        self.contentButtonView.hidden = NO;
        self.contentButtonViewH.constant = 63.0;
        [self headerVeiw];
    } else {
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂时没有可以合并的项目"];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    }
    [self.tableView reloadData];
}

#pragma mark - getter

- (NSMutableArray *)selectedProModels {
    if (!_selectedProModels) {
        _selectedProModels = [NSMutableArray array];
    }
    return _selectedProModels;
}

#pragma mark - 点击下一步按钮
- (IBAction)handleStepButtonPressed:(UIButton *)sender {
    if (self.selectedProModels.count < 2) {
        [TYShowMessage showPlaint:@"请至少选中需要合并的两个项目"];
        return;
    }
    NSMutableString *mergeID = [NSMutableString string];
    NSMutableString *showMergeName = [NSMutableString string];
    for (JGJMergeSplitProModel *mergeModel in self.selectedProModels) {
        [mergeID appendFormat:@"%@,", mergeModel.team_id];
        [showMergeName appendFormat:@"%@ ", mergeModel.team_name];
    }
    [mergeID replaceCharactersInRange:NSMakeRange(mergeID.length - 1, 1) withString:@""];
    JGJMergeProRequestModel *mergeProRequestModel = [[JGJMergeProRequestModel alloc] init];
    mergeProRequestModel.merge_before_name = showMergeName; //用于弹框显示
    mergeProRequestModel.action = @"mergeTeams";
    mergeProRequestModel.ctrl = @"team";
    __weak typeof(self) weakSelf = self;
    if (self.mergeProPopView) {
        [self.mergeProPopView removeFromSuperview];
    }
     self.mergeProPopView = [[JGJMergeProPopView alloc] initWithFrame:self.view.bounds mergeProRequestModel:mergeProRequestModel];
    self.mergeProPopView.onClickedBlock = ^(JGJMergeProRequestModel *mergeProRequestModel){
        mergeProRequestModel.team_ids = mergeID;
        [weakSelf handleUploadMergePro:mergeProRequestModel];
    };
}

#pragma mark -上传合并信息
- (void)handleUploadMergePro:(JGJMergeProRequestModel *)mergeProRequestModel {
    mergeProRequestModel.merge_before_name = nil;
     __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = [mergeProRequestModel mj_keyValues];
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [TYShowMessage showSuccess:@"合并成功"];
        [TYLoadingHub hideLoadingView];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error,id values) {
         [TYLoadingHub hideLoadingView];
        [TYShowMessage showPlaint:@"合并失败"];
    }];
}

- (void)commonSet {
    self.contentButtonView.hidden = YES;
    self.contentButtonViewH.constant = 0;
    [self.mergeButton.layer setLayerCornerRadius:5.0];
}

- (void)handleClickedProHeaderView:(JGJShareProDesModel *)proDesModel {
    proDesModel.popTitle = @"合并项目说明";
    proDesModel.popDetail = @"1.合并项目便于方便消息通知与管理\n2.不会对数据来源人产生任何影响\n3.原有项目的普通消息会消失,其他消息合并\n4.所有项目成员会自动加入合并后的项目中\n5.项目合并后仍可进行拆分,恢复成原来若干独立的项目";
    proDesModel.contentViewHeight = 405.0;
    proDesModel.icon = @"example_merge_icon";
    [JGJShareProDesView shareProDesViewWithProDesModel:proDesModel];
}

- (JGJShareProHeaderView *)headerVeiw {
    if (!_headerVeiw) {
        __weak typeof(self) weakSelf = self;
        JGJShareProDesModel *proDesModel = [[JGJShareProDesModel alloc] init];
        proDesModel.title = @"选择要合并的项目";
        proDesModel.desTitle = @"合并项目说明";
        _headerVeiw = [[JGJShareProHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, JGJSplitProHeaderViewHeight) shareProDesModel:proDesModel];
        _headerVeiw.shareProHeaderViewBlock = ^(JGJShareProDesModel *proDesModel){
            [weakSelf handleClickedProHeaderView:proDesModel];
        };
        _headerVeiw.backgroundColor = AppFontf1f1f1Color;
        self.tableView.tableHeaderView = _headerVeiw;
    }
    return _headerVeiw;
}
@end
