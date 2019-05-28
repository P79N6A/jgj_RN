//
//  JGJGroupChatListVc.m
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatListVc.h"
#import "JGJGroupChatListCell.h"
#import "JGJGroupChatSelelctedMembersVc.h"
#import "JGJChatRootVc.h"
#import "CustomAlertView.h"
#import "TYTextField.h"
#import "JGJSearchResultView.h"
#import "NSString+Extend.h"
#import "CFRefreshStatusView.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

typedef void(^HandleLoadGroupChatMemberListBlock)(NSArray *);
@interface JGJGroupChatListVc ()<UITextFieldDelegate, JGJSearchResultViewdelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (strong, nonatomic) JGJSearchResultView *searchResultView;
@property (copy, nonatomic) HandleLoadGroupChatMemberListBlock handleLoadGroupChatMemberListBlock;
@end

@implementation JGJGroupChatListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.groupChatListVcType == JGJGroupChatListWorkVcType || self.groupChatListVcType == JGJContactedAddressBookVcComeIn) {
        self.title = @"选择项目";
        self.searchBarTF.placeholder = @"请输入项目名字查找";
    }else {
        self.title = @"选择群聊";
        self.searchBarTF.placeholder = @"请输入群名称查找";
    }
    
    [self commonInit];
    
    if (self.groupChatList.count == 0) {
        
        [self loadGroupChatList];
        
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleSearchBarViewMoveDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self handleSearchBarViewMoveDown];
}

- (void)commonInit{
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    if (self.groupChatList.count == 0) {
        self.contentSearchBarView.hidden = YES;
        self.contentSearchbarViewH.constant = 0;
    }else {
        [self setFooterViewCount:_groupChatList.count];
    }

    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        [weakSelf searchValueChange:value];
    };
}

- (void)searchValueChange:(NSString *)value {
    [self handleSearchBarMoveTop];
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_name contains %@", value];
    NSMutableArray *chatList = [self.groupChatList filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.groupChatListVcType = self.groupChatListVcType;
    
    self.searchResultView.chatType = self.chatType;
    self.searchResultView.searchValue = value;
    self.searchResultView.results = chatList;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupChatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJMyWorkCircleProListModel *groupListModel = self.groupChatList[indexPath.row];
    JGJGroupChatListCell *cell = [JGJGroupChatListCell cellWithTableView:tableView];
    cell.lineView.hidden = self.groupChatList.count - 1 == indexPath.row;
    cell.groupChatListVcType = self.groupChatListVcType; //区分是否显示数量
    cell.chatType = self.chatType;
    cell.groupListModel = groupListModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJMyWorkCircleProListModel *groupListModel = self.groupChatList[indexPath.row];
    
    [self groupChatListVcTableView:tableView didSelectedGroupListModel:groupListModel];
}

#pragma mark - 点击相应的群聊
- (void)groupChatListVcTableView:(UITableView *)tableView didSelectedGroupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    NSString *classType;
    if (self.groupChatListVcType == JGJGroupChatListWorkVcType) {//如果人员已在被加入班组和群中提示

        if (groupListModel.is_existed) {
            [TYShowMessage showPlaint:@"该项目中没有更多的成员可添加"];
            return;
        }
        //进入选择人员界面
        [self handleGroupChatSelelctedMembersVcWithGroupListModel:groupListModel];

    } else if (self.groupChatListVcType == JGJGroupChatListDefaultVcType) {
        classType = @"groupChat";
        // 进入聊天页面
        groupListModel.class_type = classType;
        JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
        chatRootVc.workProListModel = groupListModel;
        [self.navigationController pushViewController:chatRootVc animated:YES];
        
    }else if (self.groupChatListVcType == JGJContactedAddressBookVcComeIn) {
        
        // 进入聊天页面
        JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
        chatRootVc.workProListModel = groupListModel;
        [self.navigationController pushViewController:chatRootVc animated:YES];
    }
    
}

#pragma mark - 进入选择人员界面
- (void)handleGroupChatSelelctedMembersVcWithGroupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    
    JGJGroupChatSelelctedMembersVc *membersVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatSelelctedMembersVc"];
    
    membersVc.chatType = self.chatType;
    
    //获取从群添加人员的id 类型,当前组的信息
    
    groupListModel.cur_group_id = self.workProListModel.cur_group_id;
    
    groupListModel.cur_class_type = self.workProListModel.cur_class_type;
    
    groupListModel.member_uids = self.workProListModel.member_uids;
    
    groupListModel.cur_group_name = self.workProListModel.group_name;
    
    groupListModel.cur_member_num = self.workProListModel.members_num;
    
    membersVc.groupListModel = groupListModel;
    
    membersVc.contactedAddressBookVcType = self.contactedAddressBookVcType;
    
    //项目详情升级人数2.3.0
    membersVc.teamInfo = self.teamInfo;
    
    //项目详情升级人数2.3.2区分添加数据来源人和成员 个人端没有数据来源人不需要添加
    membersVc.commonModel = self.commonModel;
    
    [self.navigationController pushViewController:membersVc animated:YES];
    
}

- (void)loadGroupChatList {

    NSMutableArray *groupChatList = nil;
    
    if (self.groupChatListVcType == JGJGroupChatListWorkVcType || self.groupChatListVcType == JGJContactedAddressBookVcComeIn) {
        
        groupChatList = [JGJChatMsgDBManger getTeamChats].mutableCopy;
        
    }else {
        
        groupChatList = [JGJChatMsgDBManger getGroupChats].mutableCopy;
    }
    
    NSString *class_type = self.workProListModel.cur_class_type;
    
    NSString *group_id = self.workProListModel.cur_group_id;
    
    //排除当前班组或者项目
    if (![NSString isEmpty:class_type] && ![NSString isEmpty:group_id]) {
        
        for (JGJChatGroupListModel *proModel in groupChatList) {
            
            if ([class_type isEqualToString:proModel.class_type] && [group_id isEqualToString:proModel.group_id]) {
                
                [groupChatList removeObject:proModel];
                
                break;
            }
        }
        
    }
    
    self.groupChatList = [JGJMyWorkCircleProListModel mj_objectArrayWithKeyValuesArray:[groupChatList mj_keyValues]];
    
}

- (void)setGroupChatList:(NSArray *)groupChatList {
    _groupChatList = groupChatList;
    if (_groupChatList.count > 0) {
        [self setFooterViewCount:_groupChatList.count];
    }
    [self handleNoGroupgroupChatList:groupChatList];
    [self.tableView reloadData];
}
#pragma mark - 处理没有数据的情况
- (void)handleNoGroupgroupChatList:(NSArray *)groupChatList {
    if (groupChatList.count == 0) {
        self.contentSearchBarView.hidden = YES;
        self.contentSearchbarViewH.constant = 0;
        NSString *tips = nil;
        if (self.groupChatListVcType == JGJGroupChatListWorkVcType || self.groupChatListVcType == JGJContactedAddressBookVcComeIn) {
            tips = @"你暂时没有加入任何项目\n不能从项目添加成员";
        }else {
            tips = @"你暂时还没有加入任何群聊";
        }
        
        self.tableView.tableHeaderView = [self setHeaderDefaultViewWithTips:tips];
        
    } else {
        self.contentSearchBarView.hidden = NO;
        self.contentSearchbarViewH.constant = 48.0;
        self.tableView.tableHeaderView = nil;
    }
}

#pragma mark -设置缺省页
- (UIView *)setHeaderDefaultViewWithTips:(NSString *)tips {
    
    JGJComDefaultView *defaultView = [[JGJComDefaultView alloc] initWithFrame:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT)];
    
    JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
    
    defaultViewModel.lineSpace = 5;
    
    defaultViewModel.des = tips;
    
    defaultViewModel.isHiddenButton = YES;
//    NoDataDefault_NoManagePro
    defaultViewModel.defaultImageStr = @"notice_default_icon";
    
    defaultView.defaultViewModel = defaultViewModel;
    
    return defaultView;
}

#pragma mark - 设置底部数据
- (void)setFooterViewCount:(NSUInteger)count {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *memberNumLable = [[UILabel alloc] initWithFrame:footerView.bounds];
    memberNumLable.textAlignment = NSTextAlignmentCenter;
    memberNumLable.backgroundColor = AppFontf1f1f1Color;
    memberNumLable.textColor = AppFont999999Color;
    memberNumLable.font = [UIFont systemFontOfSize:AppFont24Size];
    [footerView addSubview:memberNumLable];
    self.tableView.tableFooterView = footerView;
    NSString *footerTitle = nil;
    if (self.groupChatListVcType == JGJGroupChatListWorkVcType || self.groupChatListVcType == JGJContactedAddressBookVcComeIn) {
        footerTitle = @"项目";
    }else {
        footerTitle = @"群组";
    }
    memberNumLable.text = [NSString stringWithFormat:@"共%@个%@",@(count), footerTitle];
}

//#pragma mark - 加载群聊列表
//- (void)loadGroupChatMemberList:(JGJMyWorkCircleProListModel *)workProListModel {
//    NSMutableDictionary *parameters = @{@"ctrl" : @"Chat",
//                                        @"action" :@"getChatMembers",
//                                        @"class_type" : workProListModel.class_type?:@"",
//                                        @"group_id" : workProListModel.group_id?:@"",
//                                        @"is_active" : @"1", //排除未注册人员
//                                        @"is_exclude_self" :@"1" //排除自己
//                                        }.mutableCopy;
//    //班组、项目组群聊进入排除当前人员
//    if (self.workProListModel) {
//        [parameters setObject:self.workProListModel.cur_group_id?:@"" forKey:@"cur_group_id"];
//        [parameters setObject:self.workProListModel.cur_class_type?:@"" forKey:@"cur_class_type"];
//    }
//    //班组、项目组添加显示未在平台注册人员
//    BOOL isShowActive = self.contactedAddressBookVcType == JGJGroupMangerAddMembersVcType || self.contactedAddressBookVcType == JGJTeamMangerAddMembersVcType;
//    if (isShowActive) {
//        [parameters setObject:@"0" forKey:@"is_active"];
//    }
//    //排除自己
//    [parameters setObject:@"1" forKey:@"is_exclude_self"];
//
//    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType) {
//        //排除自己
//        [parameters setObject:@"0" forKey:@"is_exclude_self"];
//
//    }
//    __weak typeof(self) weakSelf = self;
//    [TYLoadingHub showLoadingWithMessage:nil];
//    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        [TYLoadingHub hideLoadingView];
//        NSArray *members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
//        if (weakSelf.handleLoadGroupChatMemberListBlock) {
//            weakSelf.handleLoadGroupChatMemberListBlock(members);
//        }
//    } failure:^(NSError *error, id values) {
//        [TYLoadingHub hideLoadingView];
//    }];
//}


- (JGJSearchResultView *)searchResultView {
    CGFloat searchResultViewY = 68.0;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - searchResultViewY}}];
        searchResultView.resultViewType = JGJSearchGroupChatListViewType;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

#pragma makr - JGJSearchResultViewdelegate
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedChatListModel:(JGJMyWorkCircleProListModel *)chatListModel {
    [self groupChatListVcTableView:self.tableView didSelectedGroupListModel:chatListModel];
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    [self handleSearchBarViewMoveDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (![NSString isEmpty:self.searchBarTF.text]) {
//        [self handleSearchBarMoveTop];
//    }
    [self handleSearchBarMoveTop];
    return YES;
}
- (void)handleSearchBarMoveTop {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.cancelButtonW.constant = 45;
        self.cancelButton.hidden = NO;
        [self.view addSubview:self.searchResultView];
        [self.view layoutIfNeeded];
    }];
}

- (void)handleSearchBarViewMoveDown {
    self.searchBarTF.text = nil;
    [self.searchBarTF resignFirstResponder];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButtonW.constant = 12;
        self.cancelButton.hidden = YES;
        [self.searchResultView removeFromSuperview];
        [self.view layoutIfNeeded];
    }];
}
@end
