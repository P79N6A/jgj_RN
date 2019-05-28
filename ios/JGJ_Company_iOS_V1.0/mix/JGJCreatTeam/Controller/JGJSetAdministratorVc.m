//
//  JGJSetAdministratorVc.m
//  JGJCompany
//
//  Created by yj on 16/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSetAdministratorVc.h"
#import "JGJSetAdministratorCell.h"
#import "JGJAddAdministratorListVc.h"
#import "NSString+Extend.h"
#import "JGJSetAdminHeaderView.h"
#import "JGJShareProDesView.h"
#import "CFRefreshStatusView.h"
#define HeaderViewH 34
@interface JGJSetAdministratorVc () <
UITableViewDelegate,
UITableViewDataSource,
JGJSetAdminHeaderViewDelegate
>
@property (nonatomic, strong) NSMutableArray *memberLists;//成员
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JGJSetAdministratorVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMembersList];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSetAdministratorCell *cell = [JGJSetAdministratorCell cellWithTableView:tableView];
    cell.memberModel = self.memberLists[indexPath.row];
    cell.lineViewH.constant = self.memberLists.count - 1 == indexPath.row ? 0 : 7;
    __weak typeof(self) weakSelf = self;
    cell.removeMemberModelBlock = ^(JGJSynBillingModel *memberModel){
        [weakSelf handleRemoveMemberModel:memberModel indexPath:indexPath];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JGJSetAdminHeaderView *headerView = [[JGJSetAdminHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, HeaderViewH)];
    self.teamInfo.admins_num = [NSString stringWithFormat:@"%@", @(self.memberLists.count)];
    headerView.teamInfo = self.teamInfo;
    headerView.delegate = self;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderViewH;
}

#pragma mark - 移除成员
- (void)handleRemoveMemberModel:(JGJSynBillingModel *)memberModel indexPath:(NSIndexPath *)indexPath {
    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"team",
                                 
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 
                                 @"uid" : memberModel.uid ?:@"",
                                 
                                 @"status" : @"1"
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJHandleAdminURL parameters:parameters success:^(id responseObject) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", memberModel.uid];
        
        JGJSynBillingModel *teamMemberModel = [self.memberLists filteredArrayUsingPredicate:predicate].lastObject;
        
        if (![NSString isEmpty:teamMemberModel.uid]) {
            
            [self.memberLists removeObject:teamMemberModel];
            
            [self showDefaultView];
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)showDefaultView {
    if (self.memberLists.count == 0) {
        
        NSString *tips = [NSString stringWithFormat:@"%@",@"暂未设置管理员\n点击右上角【添加管理员】图标可设置管理员"];
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:tips];
        statusView.frame = self.view.bounds;
        self.tableView.tableFooterView = statusView;
        statusView.tipsLabel.font = [UIFont systemFontOfSize: (TYIS_IPHONE_5 ? AppFont30Size : AppFont34Size)];
    }else {
        self.tableView.tableFooterView = nil;;
    }
}

#pragma mark - 获取成员列表

- (void)loadMembersList {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    NSDictionary *parameters = @{
                                 @"class_type" : @"team",
                                 
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 
                                 @"type"        : @"get_admin_list"
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJOperMembersListURL parameters:parameters success:^(id responseObject) {
        
        self.memberLists = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setMemberLists:(NSMutableArray *)memberLists {
    _memberLists = memberLists;
    [self showDefaultView];
    [self.tableView reloadData];
}

#pragma mark - buttonAction
- (IBAction)handleAddAdminstratorButtonPressed:(UIBarButtonItem *)sender {
    JGJAddAdministratorListVc *addAdministratorVc = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAdministratorListVc"];
    addAdministratorVc.addMemberVcType = JGJAddAdminMember;
    addAdministratorVc.workProListModel = self.workProListModel;
    [self.navigationController pushViewController:addAdministratorVc animated:YES];
}

#pragma mark - JGJSetAdminHeaderViewDelegate

- (void)adminHeaderViewDidSelected:(JGJSetAdminHeaderView *)headerView {
    JGJShareProDesModel *proDesModel = [[JGJShareProDesModel alloc] init];
    proDesModel.popTitle = @"管理员权限包括";
    NSString *spaceStr = @"                 ";
    NSArray *popDetails = @[@"查看项目统计报表\n", @"导出项目数据\n", @"记录晴雨表\n", @"更换质量安全问题整改人等"];
    NSMutableString *mergeStr = [NSMutableString string];
    for (NSString *desStr in popDetails) {
        [mergeStr appendFormat:@"%@%@", spaceStr, desStr];
    }
    proDesModel.popDetail = mergeStr;
    proDesModel.contentViewHeight = 214.0;
    JGJShareProDesView *proDesView = [JGJShareProDesView shareProDesViewWithProDesModel:proDesModel];
    proDesView.popDetailLable.font = [UIFont systemFontOfSize:AppFont26Size];
}
@end

