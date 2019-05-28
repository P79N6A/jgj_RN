//
//  JGJContactedAddressBookBaseVc.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactedAddressBookBaseVc.h"
#import "JGJSearchResultsVc.h"
#import "JGJAddressBookTool.h"
#import "JGJBlackListVc.h"
#import "JGJGroupChatListVc.h"
#import "TYTextField.h"
#import "JGJPerInfoVc.h"
#import "JGJSearchResultView.h"
#import "JGJEditNameVc.h"
#import "JGJPerInfoVc.h"
#import "NSString+Extend.h"
#import "CFRefreshStatusView.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "JGJContactedAddressBookHeadCell.h"
#import "CustomAlertView.h"
#import "PopoverView.h"
#import "JGJAddFriendVc.h"
#import "JGJFreshFriendCell.h"
#import "JGJFreshFriendVc.h"
#import "JGJChatListTool.h"
#define RowH 68
#define HeaderH 35
#define Padding 15
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

typedef enum : NSUInteger {
    FirstSectionGroupChatCellType,
    FirstSectionGroupWorkCircleCellType,
    FirstSectionGroupFreshFriendListCellType
} FirstSectionCellType;

typedef enum : NSUInteger {
    JGJContactedAddressBookRemarkNameButtonType,
    JGJContactedAddressBookDelButtonType
} JGJContactedAddressBookButtonType;

typedef void(^HandleGroupChatListVcBlock)(NSArray *);

@interface JGJContactedAddressBookBaseVc () <
SWTableViewCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
JGJEditNameVcDelegate,
JGJSearchResultViewdelegate,
DSectionIndexViewDataSource,
DSectionIndexViewDelegate
>
@property (nonatomic, strong) UISearchController *searchController; //不用这种方式
@property (strong, nonatomic) NSMutableArray *singleChatMembers;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) JGJSearchResultView *searchResultView;
@property (strong, nonatomic) JGJSynBillingModel *currentRemarkContact; //当前需要备注的联系人
@property (strong, nonatomic) JGJSingleListRequest *singleListRequest; //单聊请求数据
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewH;
/**
 *  回调是否请求有数据
 */
@property (nonatomic, copy) HandleGroupChatListVcBlock handleGroupChatListVcBlock;
@property (strong, nonatomic) DSectionIndexView            *sectionIndexView;
@property (nonatomic, strong) NSMutableArray *contactsLetters;//包含首字母
@property (strong, nonatomic) UILabel *centerShowLetter;
@property (nonatomic, strong) JGJContactedAddressBookCell *cell;
@property (nonatomic, assign) NSUInteger allMemberCount;//所有成员数量

@property (nonatomic, assign) BOOL isCheckFriendList;//是否查看新朋友列表

@property (nonatomic, strong) CFRefreshStatusView *statusView;
@end

@implementation JGJContactedAddressBookBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    [self commonInit];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJLaunchGroupChatVc")]) {
        
        [self loadSingleChatList];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadGetTemporaryFriendList];
    
    if (![self isMemberOfClass:NSClassFromString(@"JGJLaunchGroupChatVc")]) {
        
        [self loadSingleChatList];
    }
    
    [self handleSearchBarViewMoveDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self handleSearchBarViewMoveDown];
    if (self.statusView) {
        
        [self.statusView removeFromSuperview];
    }
}

#pragma mark - 通用设置
- (void)commonInit{
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.contentSearchBarView.hidden = YES;
    self.contentSearchBarViewH.constant = 0;
    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 33.0, 33.0);
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        [weakSelf searchValueChange:value];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section ==0 ? RowH : [JGJContactedAddressBookCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (section == 0) {
        count = [self JGJAddressBookFirstSectionTableView:tableView numberOfRowsInSection:section];
    }else {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section - 1];
        count = sortFindResult.findResult.count;
    }
    return count;
}

- (NSInteger)JGJAddressBookFirstSectionTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self handleRegisterAddressBookHeadCellWithTableView:tableView indexpath:indexPath];
    }else {
        cell = [self handleRegisterAddressBookCellWithTableView:tableView indexpath:indexPath];
    }
    return cell;
}

- (UITableViewCell *)handleRegisterAddressBookHeadCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    JGJSynBillingModel *headModel = self.headInfos[indexPath.row];
    if (indexPath.row == self.headInfos.count - 1) {
        JGJFreshFriendCell *freshFriendCell = [JGJFreshFriendCell cellWithTableView:tableView];
        freshFriendCell.freshFriendModel = headModel;
        cell = freshFriendCell;
    }else {
        JGJContactedAddressBookHeadCell *addressBookHeadCell =  [JGJContactedAddressBookHeadCell cellWithTableView:tableView];
        addressBookHeadCell.headModel = headModel;
        cell = addressBookHeadCell;
    }
    return cell;
}

- (UITableViewCell *)handleRegisterAddressBookCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    JGJContactedAddressBookCell *cell = [JGJContactedAddressBookCell cellWithTableView:tableView];;
    cell.delegate = self;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section - 1];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    contactModel.indexPathMember = indexPath; //获取当前人员的位置
    cell.rightUtilityButtons = [self rightButtons];
    cell.addressBookCellType = [self addressBookCellType];
    cell.contactModel = contactModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (JGJContactedAddressBookCellType)addressBookCellType {
    return JGJContactedAddressBookCellDefaultType;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self JGJAddressBookHeadCellWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }else {
        [self JGJAddressBookTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)JGJAddressBookHeadCellWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    UIViewController *tempVc = nil;
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case FirstSectionGroupChatCellType:{
                JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
                groupChatListVc.groupChatListVcType = JGJGroupChatListDefaultVcType;
                groupChatListVc.chatType = JGJSingleChatType;
                tempVc = groupChatListVc;
                [self.navigationController pushViewController:tempVc animated:YES];
                
                
            }
                break;
            case FirstSectionGroupWorkCircleCellType:{
                JGJGroupChatListVc *workChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
                workChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
                workChatListVc.chatType = JGJSingleChatType;
                tempVc = workChatListVc;
                [self.navigationController pushViewController:tempVc animated:YES];
                
            }
                break;
            case FirstSectionGroupFreshFriendListCellType: {
                self.isCheckFriendList = YES;
                JGJSynBillingModel *freshFriendModel = [self.headInfos lastObject];
                freshFriendModel.head_pic = nil; //清除添加人员头像标记
                
                JGJFreshFriendVc *blackListVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJFreshFriendVc"];
                [self.navigationController pushViewController:blackListVc animated:YES];
                
                NSUInteger row = weakSelf.headInfos.count - 1;
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)JGJAddressBookTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section - 1];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = contactModel.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

- (void)addressBookSelectedMemberModels {
    
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(JGJContactedAddressBookCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case JGJContactedAddressBookRemarkNameButtonType:
            [self handleRemarkNameButtonPressedWithCell:cell buttonType:JGJContactedAddressBookRemarkNameButtonType];
            break;
        case JGJContactedAddressBookDelButtonType:
            [self handleDelButtonPressedWithCell:cell buttonType:JGJContactedAddressBookDelButtonType];
            break;
        default:
            break;
    }
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

#pragma mark - 备注
- (void)handleRemarkNameButtonPressedWithCell:(JGJContactedAddressBookCell *)cell buttonType:(JGJContactedAddressBookButtonType)buttonType {
    self.currentRemarkContact = cell.contactModel; //保存当前需要备注中的联系人
    JGJEditNameVc *editNameVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditNameVc"];
    editNameVc.delegate = self;
    editNameVc.defaultName = cell.contactModel.real_name;
    editNameVc.editNameVcType = JGJEditContactedNameVcType;
    [self.navigationController pushViewController:editNameVc animated:YES];
}
#pragma mark - 删除联系人
- (void)handleDelButtonPressedWithCell:(JGJContactedAddressBookCell *)cell buttonType:(JGJContactedAddressBookButtonType)buttonType {
    NSDictionary *parameters = @{
                                 @"uid" : cell.contactModel.uid?:@""
                                 };
    __weak typeof(self) weakSelf = self;
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"删除朋友，同时将删除与TA的聊天记录，你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    alertView.onOkBlock = ^{
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelFriendURL parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            [weakSelf handleRemoveAllContactMsg:cell.contactModel];
            
            [weakSelf handleDelContactSuccessWithCell:cell];
            
            //删除本地聊天记录
            [weakSelf deleteAllMessageProListModel:cell.contactModel];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
            
        }];
        
    };
    
}

- (void)deleteAllMessageProListModel:(JGJSynBillingModel *)contactModel {
    
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = @"singleChat";
    
    groupModel.group_id = contactModel.uid;
    [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
}

#pragma mark - 移除本地全部和这个人的聊天信息
- (void)handleRemoveAllContactMsg:(JGJSynBillingModel *)contactModel {
    JGJChatMsgListModel *chatMsgListModel = [JGJChatMsgListModel new];
    chatMsgListModel.group_id = contactModel.uid;
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    proListModel.class_type = @"singleChat";
    BOOL isDelSuccess = [JGJChatListTool deleteAllChatMessage:chatMsgListModel workProListModel:proListModel];
    if (isDelSuccess) {
        TYLog(@"删除成功 class_type=== %@", proListModel.class_type);
    }
}

#pragma mark - 处理删除联系人成功处理
- (void)handleDelContactSuccessWithCell:(JGJContactedAddressBookCell *)cell {
    //    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    //    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexpath.section - 1];
    //    NSMutableArray *contacts = sortFindResult.findResult.mutableCopy;
    //    [contacts removeObject:cell.contactModel];
    //    sortFindResult.findResult = contacts;
    //    [self.tableView beginUpdates];
    //    [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tableView endUpdates];
    //    [self setFooterViewCount:--self.allMemberCount];
    //    if (self.allMemberCount == 0) {
    //        [self handleNosortContactsModel:nil];
    //    }
    [self loadSingleChatList];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(JGJContactedAddressBookCell *)cell {
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if (section > 0) {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section - 1];
        
        if (sortFindResult.findResult.count > 0) {
            NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
            firstLetterLable.text = firstLetter;
        }else {
            [self.contactsLetters removeObject:sortFindResult.firstLetter];
            firstLetterLable.hidden = sortFindResult.findResult.count == 0;
        }
    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = HeaderH;
    if (section == 0) {
        height = CGFLOAT_MIN;
    }else {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section - 1];
        height = sortFindResult.findResult.count == 0 ? CGFLOAT_MIN : HeaderH;
    }
    return height;
}

#pragma mark -JGJEditNameVcDelegate
- (void)editNameVc:(JGJEditNameVc *)editNameVc nameString:(NSString *)nameTF {
    NSDictionary *parameters = @{
                                 @"uid" : self.currentRemarkContact.uid?:@"",
                                 
                                 @"comment_name" : nameTF?:@""
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJModifyCommentNameURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf.tableView beginUpdates];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[self.currentRemarkContact.indexPathMember] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf.tableView endUpdates];
        
        [editNameVc.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        [editNameVc.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark - 处理备注成功情况
- (void)handleRemarkSuccess {
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = self.currentRemarkContact.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontF1A039Color title:@"备注名字"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontEA4E3DColor title:@"删除"];
    return rightUtilityButtons;
}

- (NSMutableArray *)headInfos {
    NSArray *detailTitles = @[@"群聊", @"项目", @"新朋友"];
    NSArray *detailImages = @[@"from_group_icon", @"from_pro_add_icon", @"new_friend_icon"];
    if (!_headInfos) {
        _headInfos = [NSMutableArray array];
        for (int indx = 0; indx < detailTitles.count; indx++) {
            JGJSynBillingModel *contactModel = [JGJSynBillingModel new];
            contactModel.head_pic = detailImages[indx];
            contactModel.name = detailTitles[indx];
            [_headInfos addObject:contactModel];
        }
    }
    return _headInfos;
}

#pragma mark - 加载单聊列表
- (void)loadSingleChatList {
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetFriendsListURL parameters:nil success:^(id responseObject) {
        
        weakSelf.singleChatMembers = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)setSingleChatMembers:(NSMutableArray *)singleChatMembers {
    _singleChatMembers = singleChatMembers;
    
    NSArray *existMembers = self.teamInfo.member_list;
    
    //去掉添加和删除模型
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel!=%@",@(YES)];
    
    existMembers = [existMembers filteredArrayUsingPredicate:predicate];
    
    NSMutableString *uids = [[NSMutableString alloc] init];
    
    if (existMembers.count > 0) {
        
        for (JGJSynBillingModel *existMember in existMembers) {
            
            [uids appendFormat:@"%@",[NSString stringWithFormat:@"%@,", existMember.telephone]];
            
            existMember.is_exist = YES;
            
        }
        
    }
    
    self.workProListModel.member_uids = uids;
    
    NSMutableArray *remainMembers = [[NSMutableArray alloc] init];
    
    //判断成员是否已添加
    
    if (![NSString isEmpty:self.workProListModel.member_uids]) {
        
        for (JGJSynBillingModel *memberModel in singleChatMembers) {
            
            if (![self.workProListModel.member_uids containsString:memberModel.telephone]) {
                
                [remainMembers addObject:memberModel];
                
                memberModel.is_exist = NO;
                
            }else {
                
                memberModel.is_exist = YES;
            }
        }
        
    }else {
        
        remainMembers = _singleChatMembers;
    }
    
    //    [remainMembers addObjectsFromArray:existMembers];
    
    [self setFooterViewCount:remainMembers.count];
    
    if (remainMembers.count == 0) {
        
        self.contentSearchBarView.hidden = YES;
        
        self.contentSearchBarViewH.constant = 0;
        
    }else {
        
        self.contentSearchBarView.hidden = NO;
        
        self.contentSearchBarViewH.constant = 48;
        
    }
    
    //全选标记用，未被添加的人员
    
    self.allMemberCount = remainMembers.count;
    
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:singleChatMembers];
}

#pragma mark - 设置底部数据
- (void)setFooterViewCount:(NSUInteger)count {
    BOOL isHiddenFooter = self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType || self.contactedAddressBookVcType == JGJLaunchGroupChatVcType;
    if (isHiddenFooter) { //单聊发起群聊没有底部信息
        return;
    }
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
//    footerView.hidden = count == 0;
//    footerView.backgroundColor = AppFontf1f1f1Color;
//    UILabel *memberNumLable = [[UILabel alloc] initWithFrame:footerView.bounds];
//    memberNumLable.textAlignment = NSTextAlignmentCenter;
//    memberNumLable.backgroundColor = AppFontf1f1f1Color;
//    memberNumLable.textColor = AppFont999999Color;
//    memberNumLable.font = [UIFont systemFontOfSize:AppFont24Size];
//    [footerView addSubview:memberNumLable];
//    self.tableView.tableFooterView = footerView;
//    memberNumLable.text = [NSString stringWithFormat:@"共%@位朋友", @(count)];
}

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    _sortContactsModel = sortContactsModel;
    self.contactsLetters = _sortContactsModel.contactsLetters;
    [self.tableView reloadData];
    [self handleNosortContactsModel:_sortContactsModel];
}

#pragma mark - 处理没有数据的情况
- (void)handleNosortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    NSString *tips = self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType ? @"你还没和任何人成为朋友" :@"你的通讯录中暂时没有联系人可添加";
    
    CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"notice_default_icon") withTips:tips];
    self.statusView = statusView;
    statusView.tipsLabel.font = [UIFont systemFontOfSize:TYIS_IPHONE_5 ? AppFont30Size : AppFont34Size];
    if (sortContactsModel.sortContacts.count == 0) {
        self.contentSearchBarView.hidden = YES;
        self.contentSearchBarViewH.constant = 0;
        NSArray *cells = self.tableView.visibleCells;
        
        CGFloat statusViewY = 0;
        
        if (cells.count > 0) {
            
            UITableViewCell *cell = cells.lastObject;
            
            statusViewY = TYGetMaxY(cell) + Padding;
        }
        
        CGRect rect = CGRectMake(0, statusViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - statusViewY);
        statusView.frame = rect;
        [self.tableView addSubview:statusView];
    } else if([self.view.subviews containsObject:statusView]) {
        self.contentSearchBarView.hidden = NO;
        self.contentSearchBarViewH.constant = 48.0;
        [statusView removeFromSuperview];
    }
}

- (void)searchValueChange:(NSString *)value {
    [self handleSearchBarMoveTop];
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telphone contains %@", value, value];
    NSMutableArray *contacts = [self.singleChatMembers filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.searchValue = value;
    self.searchResultView.results = contacts;
    if ([NSString isEmpty:value]) { //清空之后返回原来的状态
        [self handleSearchBarViewMoveDown];
    }
}

- (JGJSearchResultView *)searchResultView {
    CGFloat height = JGJ_NAV_HEIGHT;
    CGFloat searchResultViewY = JGJ_NAV_HEIGHT;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - height}}];
        searchResultView.resultViewType = JGJSearchContactedAddressBookType;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

#pragma mark - JGJSearchResultView
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedMember:(JGJSynBillingModel *)memberModel {
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
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
        self.contentSearchBarViewTop.constant = 0;
        self.contentSearchBarViewBottom.constant = 0;
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
        self.contentSearchBarViewTop.constant = 0;
        self.contentSearchBarViewBottom.constant = 0;
        self.cancelButtonW.constant = 12;
        self.cancelButton.hidden = YES;
        [self.searchResultView removeFromSuperview];
        [self.view layoutIfNeeded];
    }];
}

- (JGJSingleListRequest *)singleListRequest {
    
    if (!_singleListRequest) {
        _singleListRequest = [JGJSingleListRequest new];
        _singleListRequest.ctrl = @"Chat";
        _singleListRequest.action = @"getSingleList";
        _singleListRequest.class_type = @"friendsChat";
    }
    
    //添加人员排除被添加人员所传字段
    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddMembersVcType || self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType) { //单聊详情创建群聊
        _singleListRequest.cur_class_type = self.workProListModel.class_type;
        _singleListRequest.cur_group_id = self.workProListModel.group_id;
    }
    return _singleListRequest;
}

#pragma mark - 创建右边索引

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        if ([tableView.visibleCells[0] isKindOfClass:[JGJContactedAddressBookCell class]]) {
            JGJContactedAddressBookCell *cell = tableView.visibleCells[0];
            self.centerShowLetter.text = cell.contactModel.firstLetteter.uppercaseString;
            self.centerShowLetter.hidden = NO;
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    self.centerShowLetter.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.centerShowLetter.hidden = !decelerate;
}

- (void)setContactsLetters:(NSMutableArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount ) {
        if (!self.sectionIndexView) {
            [self creatTableIndexView];
        }
        BOOL isShow = _contactsLetters.count  > ShowCount? NO:YES; //搜索时隐藏所以
        self.sectionIndexView.hidden = isShow;
        [self.sectionIndexView reloadItemViews];
    }else {
        
        self.sectionIndexView.hidden = YES;
        
    }
}

- (void)creatTableIndexView {
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(TYGetUIScreenWidth - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    [self.view addSubview:self.sectionIndexView];
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.contactsLetters objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = AppFont999999Color;
    itemView.titleLabel.highlightedTextColor = AppFontd7252cColor;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.contactsLetters objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [self.contactsLetters objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    __weak typeof(self) weakSelf  = self;
    self.centerShowLetter.text = self.contactsLetters[section];
    self.centerShowLetter.hidden = NO;
    sectionIndexView.touchCancelBlock = ^(DSectionIndexView *sectionIndexView, BOOL isTouchCancel){
        //        延时的目的是当touch停止的时候还会滚动一小段时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.centerShowLetter.hidden = isTouchCancel;
        });
    };
}

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = AppFontd7252cColor;
        _centerShowLetter.hidden = YES;
    }
    return _centerShowLetter;
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContactsLetters:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

//2.1.2-yj添加
#pragma mark - buttonAction
- (IBAction)handleRightButton:(UIButton *)sender {
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:[self JGJChatActions]];
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    // 添加朋友 action
    __weak typeof(self) weakSelf = self;
    PopoverAction *addFriendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"add-friend-little"] title:@"添加朋友" handler:^(PopoverAction *action) {
        [weakSelf handleAddFriendAction];
    }];
    // 删除 action
    PopoverAction *blackListAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"blacklist-icon"] title:@"黑名单" handler:^(PopoverAction *action) {
        [weakSelf handleShowBlackListAction];
    }];
    return @[addFriendAction, blackListAction];
}

#pragma amrk - 添加朋友
- (void)handleAddFriendAction {
    JGJAddFriendVc *addFriendVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendVc"];
    [self.navigationController pushViewController:addFriendVc animated:YES];
}

#pragma mark - 黑名单
- (void)handleShowBlackListAction {
    JGJBlackListVc *blackListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBlackListVc"];
    [self.navigationController pushViewController:blackListVc animated:YES];
}

#pragma mark - 获取临时好友
- (void)loadGetTemporaryFriendList {
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    NSDictionary *parameters = @{
                                 @"uid" : userId?:@""
                                 };
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetTemporaryFriendList parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJSynBillingModel *freshFriendModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
        
        JGJSynBillingModel *lastFreshFriendModel = [weakSelf.headInfos lastObject];
        
        if (![NSString isEmpty:freshFriendModel.head_pic]) {
            
            lastFreshFriendModel.head_pic = freshFriendModel.head_pic;
            
            lastFreshFriendModel.members_num = freshFriendModel.members_num;
            
            lastFreshFriendModel.real_name = freshFriendModel.real_name;
            
        }else {
            
            lastFreshFriendModel.head_pic = @"";
            
            lastFreshFriendModel.members_num = @"0";
        }
        
        NSUInteger row = weakSelf.headInfos.count - 1;
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
        
        [weakSelf.tableView beginUpdates];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf.tableView endUpdates];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

@end

