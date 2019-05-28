//
//  JGJConCommonFriendVc.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//
//  共同好友

#import "JGJConCommonFriendVc.h"

#import "JGJCustomLable.h"

#import "JGJFilterAccountMemberCell.h"

#import "JGJPerInfoVc.h"

#import "JGJCommonFriendCell.h"

static NSString *const commonFriendCellID = @"JGJCommonFriendCell";

@interface JGJConCommonFriendVc ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJCustomLable *headerDes;

@end

@implementation JGJConCommonFriendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JGJCommonFriendCell class]) bundle:nil] forCellReuseIdentifier:commonFriendCellID];
    
//    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
//    [self loadFriendData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.title = [NSString stringWithFormat:@"我和%@", self.perInfoModel.real_name];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JGJFilterAccountMemberCell *cell = [JGJFilterAccountMemberCell cellWithTableView:tableView];
//
//    cell.memberModel = self.friendsList[indexPath.row];
    JGJCommonFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:commonFriendCellID forIndexPath:indexPath];
    friendCell.comFriend = self.friendsList[indexPath.row];
    return friendCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [UIView new];
    
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerDes;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJSynBillingModel *memberModel = self.friendsList[indexPath.row];
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    
    perInfoVc.jgjChatListModel.group_id = memberModel.uid;
    
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    
    [self.navigationController pushViewController:perInfoVc animated:YES];

}

#pragma mark - 获取好友数据
- (void)loadFriendData {
    
    NSDictionary *parameters = @{@"uid" : self.perInfoModel.uid?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/commonFriendsList" parameters:parameters success:^(id responseObject) {
        
        self.friendsList = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setFriendsList:(NSArray *)friendsList {
    
    _friendsList = friendsList;
    
    self.tableView.hidden = NO;
    
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
        
        self.tableView.hidden = YES;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (JGJCustomLable *)headerDes {
    
    if (!_headerDes) {
        
        _headerDes = [[JGJCustomLable alloc] initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth - 40, 36)];
        
        _headerDes.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        _headerDes.textAlignment = NSTextAlignmentLeft;
        
        _headerDes.textColor = AppFont666666Color;
        
        _headerDes.font = [UIFont systemFontOfSize:AppFont30Size];
        
        _headerDes.text = @"共同好友";
    }
    
    return _headerDes;
}


@end
