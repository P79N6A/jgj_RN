//
//  JGJSplitProVC.m
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSplitProVC.h"
#import "JGJSplitProCell.h"
#import "CustomAlertView.h"
#import "JGJShareProHeaderView.h"
#import "JGJShareProDesView.h"
#import "JLGCustomViewController.h"
#import "JGJCustomPopView.h"
@interface JGJSplitProVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;
@property (weak, nonatomic) IBOutlet UIView *containtSplitButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containSplitButtonH;
@property (strong, nonatomic) JGJSplitProModel *splitProModel;
@property (strong, nonatomic) JGJShareProHeaderView *headerVeiw;
@end

@implementation JGJSplitProVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadSplitAfterTeamList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.splitProModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSplitProCell *cell = [JGJSplitProCell cellWithTableView:tableView];
    cell.splitProModel = self.splitProModel.list[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JGJSplitProCellHeight;
}

- (IBAction)handleStepButtonPressed:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"确认拆分项目吗?";
    desModel.popTextAlignment = NSTextAlignmentCenter;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.onOkBlock = ^{
        [weakSelf loadSplitTeam];
    };
}

#pragma mark - setter
- (void)setSplitProModel:(JGJSplitProModel *)splitProModel {
    _splitProModel = splitProModel;
    if (splitProModel.list.count > 0) {
        self.containtSplitButtonView.hidden = NO;
        self.containSplitButtonH.constant = 63.0;
    }
    [self headerVeiw];
    [self.tableView reloadData];
}

- (void)commonSet {
    self.containtSplitButtonView.hidden = YES;
    self.containSplitButtonH.constant = 0;
    [self.splitButton.layer setLayerCornerRadius:5.0];
}

- (void)handleClickedProHeaderView:(JGJShareProDesModel *)proDesModel {
    proDesModel.popTitle = @"什么是拆分项目?";
    proDesModel.popDetail = @"按照数据来源恢复成多个项目，并恢复原有项目名字,成员将自动加入拆分后的项目";
    proDesModel.icon = @"example_splitProLst";
    proDesModel.contentViewHeight = 305.0;
    proDesModel.isSplitDes = YES;
    [JGJShareProDesView shareProDesViewWithProDesModel:proDesModel];
}

#pragma mark - 获取拆分后的列表
- (void)loadSplitAfterTeamList {
    NSDictionary *body = @{
                           @"ctrl" : @"team",
                           @"action": @"splitAfterTeamList",
                           @"team_id" : self.teamInfo.class_TypeId ?:[NSNull null]
                           };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        weakSelf.splitProModel = [JGJSplitProModel mj_objectWithKeyValues:responseObject];
    } failure:nil];
}

#pragma mark - 拆分项目
- (void)loadSplitTeam {
    NSDictionary *body = @{
                           @"ctrl" : @"team",
                           @"action": @"splitTeam",
                           @"team_id" : self.teamInfo.class_TypeId ?:[NSNull null]
                           };
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"拆分成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error,id values) {
        [TYShowMessage showSuccess:@"拆分失败"];
        [TYLoadingHub hideLoadingView];
    }];
}

- (JGJShareProHeaderView *)headerVeiw {
    
    if (!_headerVeiw) {
        __weak typeof(self) weakSelf = self;
        JGJShareProDesModel *proDesModel = [[JGJShareProDesModel alloc] init];
        proDesModel.title = [NSString stringWithFormat:@"%@项目可拆分成以下(%@)项目",self.splitProModel.team_name, self.splitProModel.team_num];
        proDesModel.desTitle = @"拆分项目说明";
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

