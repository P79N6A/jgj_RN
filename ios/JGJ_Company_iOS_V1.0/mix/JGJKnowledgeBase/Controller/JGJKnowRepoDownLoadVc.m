//
//  JGJKnowRepoDownLoadVc.m
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJKnowRepoDownLoadVc.h"

#import "JGJKonwBaseDownloadCell.h"

#import "JGJknowledgeDownloadTool.h"

#import "CFRefreshStatusView.h"

#import "JGJCusBottomButtonView.h"

#import "JGJCustomPopView.h"

@interface JGJKnowRepoDownLoadVc ()<SWTableViewCellDelegate>

//是否批量删除
@property (nonatomic, assign) BOOL isBatchDel;

@property (nonatomic, strong) UIButton *allCancelButton;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@property (nonatomic, strong) NSMutableArray *selKnowBaseModels;

@end

@implementation JGJKnowRepoDownLoadVc

@synthesize knowRepos = _knowRepos;

@synthesize selKnowBaseModels = _selKnowBaseModels;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已下载资料";
    
    [self.view addSubview:self.buttonView];
    
    self.tableView.frame = CGRectMake(0, SearchbarHeight, TYGetUIScreenWidth, TYGetMinY(self.buttonView) - SearchbarHeight);;
    
    [self setLeftBatButtonItem];
    
    TYWeakSelf(self);
    
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        [weakself delPopViewWithMsg:@"您确定要删除所选资料吗？" knowbaseModels:weakself.selKnowBaseModels];
    };
    
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
    
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cancelButton.hidden = self.knowRepos.count == 0;
    
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.allCancelButton = cancelButton;
    
    [cancelButton addTarget:self action:@selector(allSelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton.frame = CGRectMake(0, 0, 70, 40);
    
    [cancelButton setTitle:@"全选" forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)rightItemPressed:(UIBarButtonItem *)item {
    
    self.isBatchDel = !self.isBatchDel;
    
    CGFloat height = _isBatchDel ? 0 : SearchbarHeight;
    
    self.navigationItem.rightBarButtonItem.title = _isBatchDel ? @"取消" : @"删除";
    
    [self allSelWithIsSel:NO];
    
    if (_isBatchDel) {
        
        [self setAllCancelButton];
        
        
    }else {
        
        [self setLeftBatButtonItem];
        
        self.buttonView.actionButton.backgroundColor = AppFontaaaaaaColor;
    }
    
    [self.searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        
        make.height.mas_equalTo(height);
        
    }];
    
    if (_isBatchDel) {
        
        self.buttonView.height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        self.buttonView.y = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - [JGJCusBottomButtonView cusBottomButtonViewHeight];
    }else {
        
        self.buttonView.height = 0;
        
        self.buttonView.y = TYGetUIScreenHeight - JGJ_NAV_HEIGHT;
    }
    
    
    self.buttonView.hidden = !_isBatchDel;
    
    self.tableView.y = height;
    
    self.tableView.height = TYGetMinY(self.buttonView) - height;
    
    [self.tableView reloadData];
    
}

- (void)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)allSelButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [self changeAllSelButtonStatus:sender.selected];
}

#pragma mark - 改变全选按钮状态
- (void)changeAllSelButtonStatus:(BOOL)isSel {
    
    //全选
    if (isSel) {
        
        [self allSelWithIsSel:YES];
        
    }else {
        
        [self allSelWithIsSel:NO];
    }
    
}

- (void)allSelWithIsSel:(BOOL)isSel {
    
    [self.selKnowBaseModels removeAllObjects];
    
    NSMutableArray *allSelMdoels = [NSMutableArray new];
    
    for (JGJKnowBaseModel *knowbaseModel in self.knowRepos) {
        
        knowbaseModel.isSelected = isSel;
        
        if (knowbaseModel.isSelected) {
            
            [allSelMdoels addObject:knowbaseModel];
            
        }
    }
    
    self.selKnowBaseModels = allSelMdoels;
    
    [self showButtonBaseModels:self.selKnowBaseModels];
    
    [self.tableView reloadData];
}

#pragma mark - 重写父类
- (void)initialSet {
    
    
}

- (UITableViewCell *)registerCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJKonwBaseDownloadCell *cell = [JGJKonwBaseDownloadCell cellWithTableView:tableView];
    
    cell.isBatchDel = self.isBatchDel;
    
    cell.rightUtilityButtons = [self rightUtilityButton];
    
    cell.delegate = self;
    
    cell.knowBaseModel = self.knowRepos[indexPath.row];
    
    return cell;
}

- (CGFloat)registerCellTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJKnowBaseModel *knowBaseModel = self.knowRepos[indexPath.row];
    
    return knowBaseModel.downloadCellHeight;
}

- (void)registerCellTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isBatchDel) {
        
        JGJKonwBaseDownloadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        JGJKnowBaseModel *knowbaseModel = cell.knowBaseModel;
        
        knowbaseModel.isSelected = !knowbaseModel.isSelected;
        
        NSMutableArray *selModels = self.selKnowBaseModels;
        
        if (knowbaseModel.isSelected) {
            
            [selModels addObject:knowbaseModel];
            
        }else {
            
            [selModels removeObject:knowbaseModel];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        self.selKnowBaseModels = selModels;
        
        [self showButtonBaseModels:self.selKnowBaseModels];
        
    }else {
        
        [super registerCellTableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
}

#pragma mark - 处理显示置顶和取消
- (NSArray *)rightUtilityButton {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontd7252cColor title:@"删除"];
    
    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}

- (void)swipeableTableViewCell:(JGJKonwBaseDownloadCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    [self delPopViewWithMsg:@"您确定要删除该资料吗？" knowbaseModels:@[cell.knowBaseModel]];
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
        
    }
}

- (void)delPopViewWithMsg:(NSString *)msg knowbaseModels:(NSArray *)knowbaseModels {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = msg;
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf delknowbaseModels:knowbaseModels];
    };
    
}

- (void)delknowbaseModels:(NSArray *)knowbaseModels {
    
    for (JGJKnowBaseModel *knowBaseModel in knowbaseModels) {
        
        [JGJknowledgeDownloadTool removeCollectKnowBaseModel:knowBaseModel];
        
    }
    
    self.knowRepos = [JGJknowledgeDownloadTool allknowBaseModels].mutableCopy;
    
    for (JGJKnowBaseModel *knowBaseModel in self.selKnowBaseModels) {
        
        knowBaseModel.isSelected = NO;
    }
    
    [self.tableView reloadData];
    
    //恢复原来状态
    self.isBatchDel = NO;
    
    //回复item初始状态
    [self initialItemStatus];
}

- (BOOL)isHiddenSearch {
    
    return NO;
}

- (void)setSelKnowBaseModels:(NSMutableArray *)selKnowBaseModels {
    
    _selKnowBaseModels = selKnowBaseModels;
    
}

- (void)showButtonBaseModels:(NSMutableArray *)selKnowBaseModels  {
    
    self.buttonView.actionButton.enabled = selKnowBaseModels.count != 0;
    
    self.buttonView.actionButton.backgroundColor = selKnowBaseModels.count == 0 ? AppFontaaaaaaColor : AppFontEB4E4EColor;
    
    BOOL isSel  = selKnowBaseModels.count == self.knowRepos.count;
    
    [self.allCancelButton setTitle:!isSel ? @"全选" : @"全不选" forState:UIControlStateNormal];
    
    self.allCancelButton.selected = isSel;
}

#pragma mark - 设置item初始状态
- (void)initialItemStatus {
    
    CGFloat height = self.knowRepos.count == 0 ? 0 : SearchbarHeight;
    
    [self setLeftBatButtonItem];
    
    self.navigationItem.rightBarButtonItem.title = @"删除";
    
    [self.searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        
        make.height.mas_equalTo(height);
        
    }];
    
    self.tableView.y = height;
    
    self.tableView.height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height;
    
}

- (void)setKnowRepos:(NSMutableArray *)knowRepos {
    
    _knowRepos = knowRepos;
    
    if (knowRepos.count == 0) {
        
        [self setDefaultPage];
        
        [self.searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(0);
            
        }];
        
        self.searchbar.hidden = YES;
        
        self.buttonView.frame = CGRectZero;
        
        [self setLeftBatButtonItem];
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }else {
        
        //        self.tableView.tableHeaderView.frame = CGRectZero;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
        
    }
    
    self.isBatchDel = NO;
    
    self.buttonView.hidden = knowRepos.count == 0 || !self.isBatchDel;
    
}

#pragma mark - 处理搜索文件
- (void)handleSearchFile:(NSString *)value {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_name contains %@", value];
    
    NSMutableArray *dataSource = [self.knowRepos  filteredArrayUsingPredicate:predicate].mutableCopy;
    
    self.searchResultView.results = dataSource;
    
    if (dataSource.count == 0) {
        
        //搜索知识库网络请求没有数据
        
        self.searchResultView.searchResultDefaultCellType = JGJKnowBaseNoResultDefaultCellType;
        
        //默认没有数据
        self.searchResultView.resultViewType = JGJSearchKnowBaseNoRusultFileType;
        
    }else {
        
        //有结果时
        
        self.searchResultView.resultViewType = JGJSearchKnowBaseDownloadType;
    }
    
}

- (void)setDefaultPage {
    
    self.tableView.frame = self.view.bounds;
    
    CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
    
    statusView.frame = self.view.bounds;
    
    self.tableView.tableHeaderView = statusView;
}

- (NSMutableArray *)knowRepos {
    
    if (!_knowRepos) {
        
        _knowRepos = [NSMutableArray new];
        
        NSArray *models = [JGJknowledgeDownloadTool allknowBaseModels];
        
        self.knowRepos = models.mutableCopy;
    }
    
    return _knowRepos;
    
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = CGFLOAT_MIN;
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        _buttonView.hidden = YES;
        
        [_buttonView.actionButton setTitle:@"从本机删除" forState:UIControlStateNormal];
        
        _buttonView.actionButton.backgroundColor = AppFontaaaaaaColor;
        
        _buttonView.actionButton.enabled = NO;
        
    }
    return _buttonView;
}

- (NSMutableArray *)selKnowBaseModels {
    
    if (!_selKnowBaseModels) {
        
        _selKnowBaseModels = [NSMutableArray new];
    }
    
    return _selKnowBaseModels;
}

@end


