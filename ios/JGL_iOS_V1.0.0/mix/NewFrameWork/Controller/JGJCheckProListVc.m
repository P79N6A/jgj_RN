//
//  JGJCheckProListVc.m
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckProListVc.h"
#import "JGJCheckProListCell.h"
#import "JGJCheckClosedProListCell.h"
#import "JGJCheckProHeaderView.h"

#import "NSString+Extend.h"

#import "JGJCustomPopView.h"

#import "CFRefreshStatusView.h"

#import "JGJCreatTeamVC.h"

#import "JGJCommonButton.h"

#import "JGJAvatarView.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJCusBottomButtonView.h"

#import "JGJWebAllSubViewController.h"

typedef void(^RunloopTask)(void);

@interface JGJCheckProListVc () <UITableViewDataSource, UITableViewDelegate,JGJCheckProHeaderViewDelegate, SWTableViewCellDelegate>
{
    
    BOOL _isUnfold;// 是否展开 已关闭列表
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJActiveGroupModel *activeGroupModel;

@property (nonatomic, copy) NSArray *unCloseList;

@property (nonatomic, copy) NSArray *closeList;
@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;
@end

@implementation JGJCheckProListVc

@synthesize unCloseList = _unCloseList;

@synthesize closeList = _closeList;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"项目列表";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buttonView];
    self.view.backgroundColor = AppFontf1f1f1Color;
    
//    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
//    rightItemBtn.buttonTitle = @"新建班组";
//    rightItemBtn.type = JGJCommonCreatProType;
//    [rightItemBtn addTarget:self action:@selector(handleCreatGroup:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYTableViewFooterHeight)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.tableFooterView = footerView;
    
    _isUnfold = NO;
    
    TYWeakSelf(self);
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
        
        [weakself.navigationController pushViewController:creatTeamVC animated:YES];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除说明" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
}

- (void)rightItemPressed:(UIBarButtonItem *)item {
    
//    吉工家-删除项目说明 ID：239
//    吉工宝-删除项目说明 ID：240
    
    NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"239"];
    
    //    [TYShowMessage showSuccess:@"帮助按钮按下"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}

- (void)handleCreatGroup:(UIBarButtonItem *)rightBarButtonItem {
    
    JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
        
    [self.navigationController pushViewController:creatTeamVC animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadNetData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger count = 0;
    
    if (section == 0) {
        
        count = self.unCloseList.count;
        
    }else if (section == 1 && self.closeList.count > 0) {
        
        count = !_isUnfold ? 0 : self.closeList.count;
        
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (self.unCloseList.count > 0 && indexPath.section == 0) {
        
        JGJCheckProListCell *proListCell = [JGJCheckProListCell cellWithTableView:tableView];
        
        JGJChatGroupListModel *groupListModel = self.unCloseList[indexPath.row];
        
        if (![self.proListModel.group_id isEqualToString:groupListModel.group_id] || ![self.proListModel.class_type isEqualToString:groupListModel.class_type]) {

            groupListModel.is_selected = NO;
        }

        if ([self.proListModel.group_id isEqualToString:groupListModel.group_id] && [self.proListModel.class_type isEqualToString:groupListModel.class_type]) {

            groupListModel.is_selected = YES;
        }
        
        proListCell.groupListModel = groupListModel;
        
        proListCell.lineView.hidden = self.unCloseList.count - 1 == indexPath.row;
        
        cell = proListCell;
        
    }else if (self.closeList.count > 0 && indexPath.section == 1) {
        
        JGJCheckClosedProListCell *closeProListCell = [JGJCheckClosedProListCell cellWithTableView:tableView];
        
        JGJChatGroupListModel *groupClosedModel = self.closeList[indexPath.row];
        
        if (![self.proListModel.group_id isEqualToString:groupClosedModel.group_id] || ![self.proListModel.class_type isEqualToString:groupClosedModel.class_type]) {
            
            groupClosedModel.is_selected = NO;
        }
        
        if ([self.proListModel.group_id isEqualToString:groupClosedModel.group_id] && [self.proListModel.class_type isEqualToString:groupClosedModel.class_type]) {
            
            groupClosedModel.is_selected = YES;
        }
        closeProListCell.groupListModel = groupClosedModel;
        
        closeProListCell.delegate = self;
        
        closeProListCell.rightUtilityButtons = [self handleOpenProWithProListModel:groupClosedModel];
        
        closeProListCell.lineView.hidden = self.activeGroupModel.closed_list.count -1 == indexPath.row;
        
        cell = closeProListCell;
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 71.0;
    
    if (self.unCloseList.count > 0 && indexPath.section == 0) {
        
        JGJChatGroupListModel *proListModel = self.unCloseList[indexPath.row];
        
        proListModel.isCheckClosedPro = NO;
        
        height = proListModel.checkProCellHeight;
        
        if (height < 60.0) {
            
            height = 60.0;
        }
        
    }else if (self.closeList.count > 0 && indexPath.section == 1) {
        
        JGJChatGroupListModel *proListModel = self.closeList[indexPath.row];

        proListModel.isCheckClosedPro = YES;

        height = proListModel.checkProCellHeight;

        if (height < 71.0) {

            height = 71.0;

        }    
    }
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == 0 ? 10 : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    JGJCheckProHeaderView *header = [JGJCheckProHeaderView checkProHeaderViewWithTableView:tableView];
    
    header.delegate = self;
    header.isUnflod = _isUnfold;
    JGJChatGroupListModel *proListModel = [JGJChatGroupListModel new];
    
    if (section == 0) {
        
        proListModel.headerTilte = [NSString stringWithFormat:@"进行中的项目 (%@)",@(self.unCloseList.count)];
        
        header.titleColor = AppFont333333Color;
        
        
    }else if (section == 1) {
        
        if (self.closeList.count > 0) {
            
            proListModel = self.closeList[0];
            
        }
        
        proListModel.headerTilte = [NSString stringWithFormat:@"已关闭且已存档的项目 (%@)",@(self.closeList.count)];
        
        header.titleColor = AppFont999999Color;
        
    }
    
    header.tag = section;
    
    header.groupModel = proListModel;
    
    return header;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    footerView.backgroundColor = AppFontf1f1f1Color;
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJChatGroupListModel *proListModel = [JGJChatGroupListModel new];
    
    if (self.unCloseList.count > 0 && indexPath.section == 0) {
        
        proListModel = self.unCloseList[indexPath.row];
        
    }else if (self.closeList.count > 0 && indexPath.section == 1) {
        
        proListModel = self.closeList[indexPath.row];
        
    }
    
    [self setIndexProListModel:proListModel];
    
}

#pragma mark - 选中之后切换项目，首页项目改变
- (void)setIndexProListModel:(JGJChatGroupListModel *)proListModel {
    
    [self cleanLogSave];
    NSDictionary *body = @{
                           @"client_type": @"person",
                           @"class_type" : proListModel.class_type?:@"",
                           @"group_id" : proListModel.group_id?:@""
                           };
    
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-index-list" parameters:body success:^(id responseObject) {
        
        TYLog(@"切换项目首页responseObject = %@",responseObject);
        [TYLoadingHub hideLoadingView];
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
#pragma mark - 刘远强修改
-(void)cleanLogSave
{
    JGJGetLogTemplateModel *model = [JGJGetLogTemplateModel new];
    model.cat_id = @"";
    model.cat_name = @"通用日志";
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:model];
    [TYUserDefaults setObject:udObject forKey:JGJOldLogType];

}
- (void)swipeableTableViewCell:(JGJCheckClosedProListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            
            [self reopenGroup:cell.groupListModel];
            
            break;
            
        case 1:{
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popDetail = @"注意：删除项目，同时将删除与本项目相关的所有数据，项目删除后将不能找回，请谨慎操作。你确定要删除吗？";
            
            if ([cell.proListModel.class_type isEqualToString:@"group"]) {
                
                desModel.popDetail = @"注意：删除班组，同时将删除与本班组相关的所有数据，班组删除后将不能找回，请谨慎操作。你确定要删除吗？";
            }
            
            desModel.popTextAlignment = NSTextAlignmentLeft;
            
            __weak typeof(self) weakSelf = self;
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.onOkBlock = ^{
                
                [weakSelf delGroup:cell.groupListModel];
                
            };
            
        }
            
            break;
        default:
            break;
    }
}

#pragma mark - 重新打开已关闭的班组、项目组
- (void)reopenGroup:(JGJChatGroupListModel *)groupModel {
    
    NSDictionary *parame = @{@"group_id":groupModel.group_id ? : @"",
                             @"class_type":groupModel.class_type ? : @""
                             };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/reenable-group" parameters:parame success:^(id responseObject) {
       
        JGJChatGroupListModel *group_model = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:groupModel.group_id classType:groupModel.class_type];
        group_model.is_closed = NO;
        
        BOOL updateSuccess = [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:group_model];
        if (updateSuccess) {
            
            [TYShowMessage showSuccess:@"开启成功"];
            [JGJChatGetOffLineMsgInfo http_getChatIndexList];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)delGroup:(JGJChatGroupListModel *)groupModel {
    
    
    NSDictionary *parame = @{@"group_id":groupModel.group_id ? : @"",
                             @"class_type":groupModel.class_type ? : @""
                             };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/del-group" parameters:parame success:^(id responseObject) {
        
        BOOL delGroupSuccess = [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
        if (delGroupSuccess) {
            
            [self loadNetData];
            [TYShowMessage showSuccess:@"删除成功"];
        }
    
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


#pragma mark - 处理显示置顶和取消
- (NSArray *)handleOpenProWithProListModel:(JGJChatGroupListModel *)proListModel {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontC7C6CBColor title:@"重新开启"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontd7252cColor title:@"彻底删除"];
    return rightUtilityButtons;
}

#pragma mark - JGJCheckProHeaderViewDelegate

- (void)checkProHeaderView:(JGJCheckProHeaderView *)headerView {
    
    _isUnfold = !_isUnfold;
    
    [self.tableView reloadData];
    
}

#pragma mark - 加载本地数据
- (void)loadNetData {
    
    self.unCloseList = [JGJChatMsgDBManger getCurrentGroupOrTeamProjecyList];
    self.closeList = [JGJChatMsgDBManger getCurrentGroupOrTeamProjecyClosedList];
    
    [self handleShowDefault];
    
    [self.tableView reloadData];
}

- (void)setUnCloseList:(NSArray *)unCloseList {
    
    _unCloseList = unCloseList;
    
    [self handleShowDefault];
    
}

- (void)setCloseList:(NSArray *)closeList {
    
    _closeList = closeList;
    
    [self handleShowDefault];
    
}

- (void)setActiveGroupModel:(JGJActiveGroupModel *)activeGroupModel {
    
    _activeGroupModel = activeGroupModel;
}

#pragma mark- 是否显示默认页

- (void)handleShowDefault {
    
    if (self.unCloseList.count == 0 && self.closeList.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }else {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
    }
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64 - 65 - JGJ_IphoneX_BarHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"新建班组" forState:UIControlStateNormal];
        [_buttonView.actionButton setImage:IMAGE(@"createNewProjectAdd") forState:(UIControlStateNormal)];
    }
    return _buttonView;
}

- (NSArray *)unCloseList {
    
    if (!_unCloseList) {
        
        _unCloseList = [NSArray array];
    }
    return _unCloseList;
}

- (NSArray *)closeList {
    
    if (!_closeList) {
        
        _closeList = [NSArray array];
    }
    return _closeList;
}
@end
