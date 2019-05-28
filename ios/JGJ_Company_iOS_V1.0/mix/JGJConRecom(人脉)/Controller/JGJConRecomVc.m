//
//  JGJConRecomVc.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJConRecomVc.h"

#import "JGJConRecomCell.h"

#import "JGJCustomLable.h"

#import "JGJConRecomHeaderView.h"

#import "JGJCusActiveSheetView.h"

#import "JGJPerInfoVc.h"

#import "JGJAddFriendSendMsgVc.h"

#import "MJRefresh.h"

#import "JGJCustomPopView.h"

#import "JGJWebAllSubViewController.h"

@interface JGJConRecomVc () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//推荐好友列表
@property (nonatomic, strong) NSMutableArray *recList;

@property (nonatomic, strong) JGJCustomLable *headerDes;

//筛选类型 1,工人，2班组长，0全部，不传默认是0
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, strong) JGJConRecomHeaderView *headerView ;

//是否加载完毕
@property (nonatomic, assign) BOOL isLoadFinish;


@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;

@end

@implementation JGJConRecomVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脉资源";
    
    [self.view addSubview:self.tableView];
    
    //获取用户信息判断是否签名
    [self loadUserInfo];
    
    JGJConRecomHeaderView *headerView = [[JGJConRecomHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    
    self.headerView = headerView;
    
    TYWeakSelf(self);
    
    headerView.conRecomHeaderViewBlock = ^(id headerView) {
      
        UIViewController *addressBookBaseVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedAddressBookBaseVc"];
        
        [weakself.navigationController pushViewController:addressBookBaseVc animated:YES];
    };
    
    
    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_write"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFriendData)];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFriendData)];
    
    [self.tableView.mj_header beginRefreshing];

    _isLoadFinish = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadGetTemporaryFriendList];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJConRecomCell *cell = [JGJConRecomCell cellWithTableView:tableView];

    cell.friendlyModel = self.recList[indexPath.row];
    
    TYWeakSelf(self);
    
    cell.conRecomCellBlock = ^(JGJSynBillingModel *friendlyModel) {
      
        [weakself addFriendWithMemberModel:friendlyModel];
        
        [weakself sendSuccessChangeAddButtonWithMemberModel:friendlyModel indexPath:indexPath];
    };
    
    cell.topLineView.hidden = indexPath.row != 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return _isLoadFinish ? JGJFooterHeight : CGFLOAT_MIN;;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = nil;
    
    if (_isLoadFinish && _recList.count > 0) {
        
        footerView = [self.tableView setFooterViewInfoModel:self.footerInfoModel];
    }
    
    return footerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return _recList.count > 0 ? self.headerDes : nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSynBillingModel *memberModel = self.recList[indexPath.row];
        
    [self checkPerInfoWithMemberModel:memberModel];
    
}

#pragma mark - 获取好友数据
- (void)loadFriendData {
    
    if ([NSString isEmpty:self.type]) {
        
        self.type = @"0";
    }
    
    self.pg = 1;
    
    NSDictionary *parameters = @{@"type" : self.type?:@"0",
                                 @"pg" : @(self.pg),
                                 @"pagesize"  : @"20"
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/recommendList" parameters:parameters success:^(id responseObject) {
        
        self.recList = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (self.recList.count > 0) {
            
            self.pg ++;
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)loadMoreFriendData {
    
    if ([NSString isEmpty:self.type]) {
        
        self.type = @"0";
    }
    
    NSDictionary *parameters = @{@"type" : self.type?:@"0",
                                 @"pg" : @(self.pg),
                                 @"pagesize"  : @"20"
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/recommendList" parameters:parameters success:^(id responseObject) {
        
        NSArray *recList = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (recList.count > 0) {
            
            self.pg ++;
            
            [self.recList addObjectsFromArray:recList];
            
        }
        
        if (recList.count < 20) {
            
            self.tableView.mj_footer = nil;

            self.isLoadFinish = YES;

        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
         [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    
    NSArray *buttons = @[@"只看班组长", @"只看工人", @"查看全部", @"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            weakSelf.type = @"2";
            
        }else if (buttonIndex == 1) {
            
            weakSelf.type = @"1";
            
        }else if (buttonIndex == 2) {
            
            weakSelf.type = @"0";
        }

        [weakSelf loadFriendData];
    }];
    
    [sheetView showView];
}

#pragma mark - 查看个人信息
- (void)checkPerInfoWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    
    perInfoVc.jgjChatListModel.group_id = memberModel.uid;
    
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    
    [self.navigationController pushViewController:perInfoVc animated:YES];
    
}

#pragma mark - 添加朋友
- (void)addFriendWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJAddFriendSendMsgVc *addFriendSendMsgVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendSendMsgVc"];
    JGJChatPerInfoModel *perInfoModel = [JGJChatPerInfoModel new];
    
    perInfoModel.uid = memberModel.uid;
    
    perInfoModel.top_name = memberModel.real_name;
    
    addFriendSendMsgVc.perInfoModel = perInfoModel;
    
    [self.navigationController pushViewController:addFriendSendMsgVc animated:YES];
}

- (void)sendSuccessChangeAddButtonWithMemberModel:(JGJSynBillingModel *)memberModel indexPath:(NSIndexPath *)indexPath {
    
    TYWeakSelf(self);
    
    self.sendSuccessBlock = ^(id response) {
        
        memberModel.isSelected = YES; //已成功发送
        
        [weakself.tableView beginUpdates];
        
        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakself.tableView endUpdates];
        
    };
}

- (void)setRecList:(NSMutableArray *)recList {
    
    _recList = recList;
    
    if (!self.headerView) {
        
        JGJConRecomHeaderView *headerView = [[JGJConRecomHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
        
        self.headerView = headerView;
        
        TYWeakSelf(self);
        
        headerView.conRecomHeaderViewBlock = ^(id headerView) {
            
            UIViewController *addressBookBaseVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedAddressBookBaseVc"];
            
            [weakself.navigationController pushViewController:addressBookBaseVc animated:YES];
        };
        
        
        self.tableView.tableHeaderView = headerView;
    }
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

#pragma mark - 获取添加的好友
- (void)loadGetTemporaryFriendList {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSDictionary *parameters = @{
                                 @"uid" : userId?:@""
                                 };
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetTemporaryFriendList parameters:parameters success:^(id responseObject) {
        
        JGJSynBillingModel *freshFriendModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
        
        weakSelf.isCheckFreshFriend = [NSString isEmpty:freshFriendModel.head_pic];
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

#pragma mark - 判断用户是否签名
- (void)loadUserInfo {
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/userstatus" parameters:nil success:^(id responseObject) {
        
        JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
        
        if ([NSString isEmpty:userInfo.signature]) {
            
            [self signPopView];
        }
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

- (void)signPopView {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];

    desModel.popDetail = @"你还未设置自己的个性签名，有个性的签名会让你人气爆棚哦！";

    desModel.leftTilte = @"取消";

    desModel.rightTilte = @"去设置";

    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];

    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    
    __weak typeof(self) weakSelf = self;

    alertView.onOkBlock = ^{

        NSString *webUrl = [NSString stringWithFormat:@"%@my/list", JGJWebDiscoverURL];

        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];

        [weakSelf.navigationController pushViewController:webVc animated:YES];

    };
}

- (void)setIsCheckFreshFriend:(BOOL)isCheckFreshFriend {
    
    _isCheckFreshFriend = isCheckFreshFriend;
    
    self.headerView.isCheckFreshFriend = isCheckFreshFriend;
    
}

- (JGJCustomLable *)headerDes {
    
    if (!_headerDes) {
        
        _headerDes = [[JGJCustomLable alloc] initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth - 40, 36)];
        
        _headerDes.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        _headerDes.textAlignment = NSTextAlignmentLeft;
        
        _headerDes.textColor = AppFont333333Color;
        
        _headerDes.font = [UIFont systemFontOfSize:AppFont30Size];
        
        _headerDes.text = @"你可能想认识";
    }
    
    return _headerDes;
}

- (JGJFooterViewInfoModel *)footerInfoModel {
    
    if (!_footerInfoModel) {
        
        _footerInfoModel = [JGJFooterViewInfoModel new];
        
        _footerInfoModel.backColor = AppFontf1f1f1Color;
        
        _footerInfoModel.textColor = AppFont999999Color;
        
        _footerInfoModel.desType = UITableViewFooterFirstType;
    }
    
    return _footerInfoModel;
    
}

@end
