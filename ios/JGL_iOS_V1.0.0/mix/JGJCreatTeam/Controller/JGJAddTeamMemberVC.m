//
//  JGJAddTeamMemberVC.m
//  mix
//
//  Created by yj on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAddTeamMemberVC.h"
#import "JGJAddressBookTool.h" //通信录数据库工具
#import "TYAddressBook.h"
#import "CFRefreshTableView.h"
#import "JGJAddTeamMemberCell.h"
#import "NSString+Extend.h"
#import "Searchbar.h"
#import "UILabel+GNUtil.h"
#import "JGJSynBillAddContactsHUBView.h"
#import "JGJCreatTeamVC.h"
#import "CustomAlertView.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "NSString+Extend.h"
#import "JGJCreatTeamCell.h"
#import "JGJGroupChatListVc.h"
#import <AddressBook/AddressBook.h>
#import "UIView+GNUtil.h"
#import "JGJCustomPopView.h"

#import "JGJGroupMangerTool.h"

#import "JGJUnhandleSourceListVC.h"

#import "JGJImageModelView.h"

#import "JGJCusBackButton.h"

#import "JGJInputNamePopView.h"

#define RowH 75
#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
#define WorkCircleAddTitle @""
@interface JGJAddTeamMemberVC () <
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
JGJSynBillAddContactsHUBViewDelegate,
CFRefreshStatusViewDelegate,
DSectionIndexViewDataSource,
DSectionIndexViewDelegate,
JGJUnhandleSourceListVCDelegate,
ClickPeopleItemButtondelegate
>
@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *showSelectedCountLable;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;

@property (nonatomic, strong) NSMutableArray *sortContacts ;//排序后的联系人
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (weak, nonatomic) IBOutlet UIView *contentView;//包含底部控件
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *backupSortContacts; //备份排序后数据
@property (nonatomic, strong) NSMutableArray *backupAllContacts; //备份未排序数据
@property (nonatomic, strong) NSMutableArray *selectedSynBillingModels;//选中的同步联系人
@property (nonatomic, strong) NSMutableArray *contactsLetters;//包含首字母
@property (assign, nonatomic) BOOL                         isMoveRightButton;//根据是否显示索引右移按钮
@property (nonatomic, strong) NSMutableDictionary *sameFirstContactsDic;//便于模型转换
@property (nonatomic, strong) NSMutableArray *selectedAddressBooks;//添加通信录返回的单个数据
@property (strong, nonatomic) UILabel *centerShowLetter;
@property (strong, nonatomic)  Searchbar *searchBar;
@property (nonatomic, assign) BOOL isSearchStatus;//当前是搜索状态
@property (nonatomic, strong) NSArray *confirmPosition;//根据首字母判断位置
@property (strong, nonatomic) DSectionIndexView            *sectionIndexView;
@property (strong, nonatomic) JGJSingleListRequest *singleListRequest; //单聊请求数据
@property (strong, nonatomic) NSMutableArray *singleChatMembers; //单聊数据

//搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

@property (weak, nonatomic) IBOutlet UIView *containSourceNumView;

@property (weak, nonatomic) IBOutlet UILabel *sourceNumLable;

@property (strong, nonatomic) JGJSourceSynProFirstModel *synProFirstModel; //同步项目模型

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containSourceViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSelectedMemberViewH;

@property (weak, nonatomic) IBOutlet UIView *contentSelectedMemberView;

//用的以前的控件
@property (strong, nonatomic) JGJImageModelView *imageModelView;

@end

@implementation JGJAddTeamMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self getAddressBook];
    
    //2.3.2去掉从项目添加，右上角单独添加移外面
    
    if (self.commonModel.teamControllerType != JGJCreatTeamControllerType || self.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self setBackButton];
    
    [self.contentSelectedMemberView addSubview:self.imageModelView];
    
}

- (void)getAddressBook {
    
    switch (self.groupMemberMangeType) {
        case JGJGroupMemberMangeAddMemberType: {
            [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
             [self addressBookContacts];
        }
            break;
        case JGJGroupMemberMangePushNotifyType: {
            [self.confirmButton setTitle:@"发送通知" forState:UIControlStateNormal];
            [self addressBookContacts];
        }
            break;
        case JGJGroupMemberMangeRemoveMemberType: {
            
            if (self.currentTeamMembers.count == 0) {
                
                self.contentSearchBarView.hidden = YES;
                
                self.contentSearchbarViewH.constant = 0;
                
            }
            
            [self changeDelMemberSelStatus];
            
            self.dataSource = self.currentTeamMembers.mutableCopy;
            self.backupSortContacts = self.dataSource.mutableCopy;
            self.backupAllContacts = self.dataSource.mutableCopy;
            [self searchSynBillingModel:self.dataSource];
            
            [self handleContactDefaultWithTips:@"没有可删除的成员" dataSource:self.dataSource];
        }
            break;
            
        case JGJAddFriendType:{

            self.sortContacts = self.sortContactsModel.sortContacts;
            
            self.contactsLetters = self.sortContactsModel.contactsLetters;
            
            self.backupSortContacts = self.sortContacts.copy;
            
            self.backupAllContacts = self.sortContacts.copy;
            
            if (self.sortContacts.count == 0) {
                
                [self handleContactDefaultWithTips:@"你的通讯录中暂时没有联系人可添加" dataSource:self.sortContacts];
            }
            
            [self.tableView reloadData];
            
            [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 进入的模型可能已是选中状态

- (void)changeDelMemberSelStatus {
    
    for (JGJSynBillingModel *memberModel in self.currentTeamMembers) {
        
        memberModel.is_exist = NO;
        
        memberModel.isAddedSyn = NO;
        
    }
    
}

#pragma amrk - 删除缺省页显示
- (void)handleContactDefaultWithTips:(NSString *)tips dataSource:(NSArray *)dataSource{
    
    if (dataSource.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:tips];
        
        statusView.frame = self.view.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
    }
}


#pragma mark - 打开通信录
- (void)unfoldAddressBook:(NSArray *)addressBookModels {
    
    TYWeakSelf(self);
    
    BOOL isHaveContact = addressBookModels.count > 0 || self.sortContactsModel.sortContacts
    .count || self.currentTeamMembers.count > 0;
    
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [TYAddressBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            
            if(isAuthorized)
            {
                TYLog(@"打开了------------------");
                
                [weakself firstOpenAdddressbook];
            }
            
        }];
    }
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized && isHaveContact){
        return;
    }
    
    if (!isHaveContact) {
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"当前通讯录还没有数据"];
        statusView.frame = self.view.bounds;
        statusView.delegate = self;
        statusView.buttonTitle = @"读取手机通讯录";
        self.tableView.tableFooterView = statusView;
        self.contentSearchbarViewH.constant = 0;
        self.contentSearchBarView.hidden = YES;
        
    }else {
        
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0);
        
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if ([self.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContacts[section];
        count = sortFindResult.findResult.count;
    }
    
    if ([self.sortContacts[section] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *addressBooks = self.sortContacts[section];
        count = addressBooks.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *synBillingModel = sortFindResult.findResult[indexPath.row];
    JGJAddTeamMemberCell *addTeamMemberCell = [JGJAddTeamMemberCell cellWithTableView:tableView];
    //    共用模型区分同步账单管理
    addTeamMemberCell.searchValue = self.searchValue;
    
    addTeamMemberCell.commonModel = self.commonModel;
    addTeamMemberCell.synBillingCommonModel = self.synBillingCommonModel;
    addTeamMemberCell.synBillingModel = synBillingModel;
    addTeamMemberCell.lineViewH.constant = (sortFindResult.findResult.count -1 - indexPath.row) == 0 ? 0 :  LinViewH;
    cell = addTeamMemberCell;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if ([self.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContacts[section];
        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
//        firstLetterLable.text = [firstLetter isEqualToString:@"0"] ? @"已选中" : firstLetter ;
        firstLetterLable.text = firstLetter ;
        
        if (sortFindResult.findResult.count == 0) {
            
            [self.contactsLetters removeObjectAtIndex:section];
            
            [self.sortContacts removeObjectAtIndex:section];
            
            [self.sectionIndexView reloadItemViews];
            
            [tableView reloadData];
        }

    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *teamMemberModel = sortFindResult.findResult[indexPath.row];
    return !teamMemberModel.isAddedSyn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *teamMemberModel = sortFindResult.findResult[indexPath.row];
    NSString *telephone = [TYUserDefaults objectForKey:JLGPhone];
    BOOL isAddMyPromember = self.commonModel.memberType == JGJProMemberType && [teamMemberModel.telephone isEqualToString:telephone];
    BOOL isAddMySourceMember = self.commonModel.memberType == JGJProSourceMemberType && [teamMemberModel.telephone isEqualToString:telephone];
    if (isAddMyPromember) {
        [TYShowMessage showPlaint:@"尊敬的用户,你已是项目成员!"];
        return;
    }
    if (isAddMySourceMember) {
        [TYShowMessage showPlaint:@"不能添加自己为数据来源人！"];
        return;
    }
    
    if ([NSString containsEmojiStr:teamMemberModel.name]) {
        
        JGJInputNamePopView *namePopView = [[JGJInputNamePopView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        
        namePopView.tel.text = teamMemberModel.telph;
        
        TYWeakSelf(self);
        
        namePopView.confirmBlock = ^(JGJInputNamePopView *popView) {
            
            JGJAddTeamMemberCell *addTeamMemberCell = [weakself.tableView cellForRowAtIndexPath:indexPath];
            
            teamMemberModel.name = popView.name.text;
            
            addTeamMemberCell.synBillingModel = teamMemberModel;
            
            [weakself handleSelTeamMemberModel:teamMemberModel indexPath:indexPath];
            
            NSMutableArray *members = [[NSMutableArray alloc] init];
            
            for (SortFindResultModel *sortFindResult in self.sortContacts) {
                
                if (sortFindResult.findResult.count > 0) {
                    
                    [members addObjectsFromArray:sortFindResult.findResult];
                    
                }
                
            }
            
            JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:members];
            
            weakself.sortContactsModel = sortContactsModel;
            
            weakself.sortContacts = sortContactsModel.sortContacts;
            
            weakself.contactsLetters = sortContactsModel.contactsLetters;
            
            weakself.backupSortContacts = weakself.sortContacts;
        };
        
    }else {
        
           [self handleSelTeamMemberModel:teamMemberModel indexPath:indexPath];
        
    }
    
}

- (void)handleSelTeamMemberModel:(JGJSynBillingModel *)teamMemberModel indexPath:(NSIndexPath *)indexPath {
    
    teamMemberModel.isSelected = !teamMemberModel.isSelected;
    
    if (teamMemberModel.isSelected) {
        
        [self.selectedSynBillingModels addObject:teamMemberModel];
        
    }
    else {
        
        [self.selectedSynBillingModels removeObject:teamMemberModel];
    }
    
    [self showSynBillingSelectedCount:self.selectedSynBillingModels];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 处理项目添加人员
- (void)handleGroupChatList:(NSArray *)groupChatList {
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
    groupChatListVc.chatType = JGJGroupChatType;
    groupChatListVc.contactedAddressBookVcType = self.contactedAddressBookVcType; //班组和项目管理添加人员
    self.workProListModel.cur_group_id = self.workProListModel.group_id;
    self.workProListModel.cur_class_type = self.workProListModel.class_type;
    groupChatListVc.workProListModel = self.workProListModel; //点击从项目添加人员根据cur_group_id、cur_class_type排除当前群选择存在人员
    groupChatListVc.groupChatList = groupChatList;
    
    //2.3.0
    groupChatListVc.teamInfo = self.teamInfo;
    
    [self.navigationController pushViewController:groupChatListVc animated:YES];
}


//    根据数据排序
- (void)searchSynBillingModel:(NSMutableArray *)synBillingModels {
    if (self.dataSource.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getContactsFirstletter:synBillingModels];
        });
    }
}

#pragma mark - 得到字母并且将首字母相同的组合为同一个模型
- (void)getContactsFirstletter:(NSMutableArray *)contacts {
    
    JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool  addressBookToolSortContcts:contacts];
    
    if (!self.sortContactsModel) {
        
        self.sortContactsModel = sortContactsModel;
    }
    
    self.sortContacts = sortContactsModel.sortContacts;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
    
    if (!self.backupSortContacts) {
        
        self.backupSortContacts = self.sortContacts;
        
    }
    
}

#pragma mark - 显示底部控件状态
- (void)showSynBillingSelectedCount:(NSMutableArray *)synBillings {
    
    self.imageModelView.DataMutableArray = synBillings;
    
    self.selectedSynBillingModels = synBillings;
    
    NSString *countStr = [NSString stringWithFormat:@"(%@)", @(synBillings.count)];
    
    NSString *buttonTitle = @"确定";
    
    self.contentSelectedMemberView.hidden = YES;
    
    self.contentSelectedMemberViewH.constant = 0;
    
    self.confirmButton.enabled = NO;
    
    self.confirmButton.backgroundColor = TYColorHex(0xaaaaaa);
    
    if (synBillings.count == 0) {
        
        self.contentSelectedMemberView.hidden = YES;
        
        self.contentSelectedMemberViewH.constant = 0;
        
        self.confirmButton.enabled = NO;
        
        self.confirmButton.backgroundColor = TYColorHex(0xaaaaaa);
        
    } else {
        
        self.contentView.hidden = NO;
        
        self.contentViewH.constant = 63;
        
        self.confirmButton.enabled = YES;
        
        self.contentSelectedMemberView.hidden = NO;
        
        self.contentSelectedMemberViewH.constant = 45;
        
        buttonTitle = [NSString stringWithFormat:@"确定 %@", countStr];
        
        self.confirmButton.backgroundColor = AppFontd7252cColor;
    }
    
    [self.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    BOOL isShowHeader = self.commonModel.teamControllerType == JGJTeamMangerControllerType || self.commonModel.teamControllerType == JGJGroupMangerControllerType;
        if (synBillings.count > 0 && !isShowHeader) { //班组管理、项目管理不隐藏头部
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0);
            self.tableView.tableHeaderView = nil;
        }
        if (synBillings.count > 0) {
            self.tableView.tableFooterView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0);
            self.tableView.tableFooterView = nil;
        }
    
}

#pragma mark - 确认按钮按下
- (IBAction)confirmButtonPressed:(UIButton *)sender {

    //创建班组加人
    if (self.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
        
        [self creatGroupAddmember];
        
    }else {
        
        [self otherTypeAddmember];
    }
    
    
}

#pragma mark - 创建班组添加人员
- (void)creatGroupAddmember {
    
    if (self.targetVc) {
        
        JGJCreatTeamVC *creatTeamVc = (JGJCreatTeamVC *)self.targetVc;
                
        [creatTeamVc handleJGJGroupMemberSelectedTeamMembers:self.selectedSynBillingModels groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
        
        [self.navigationController popToViewController:self.targetVc animated:YES];
        
    }
    
}

#pragma mark - 项目设置、班组设置等添加人员
- (void)otherTypeAddmember {
    
    if (self.groupMemberMangeType == JGJGroupMemberMangePushNotifyType) {
        CustomAlertView *alertView = [CustomAlertView showWithMessage:@"发送消息给对对方，通知他将项目数据同步，对方同意后，会自动将他加入到项目中" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"立即发送"];
        __weak typeof(self) weakSelf = self;
        alertView.onOkBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(handleJGJGroupMemberSelectedTeamMembers:groupMemberMangeType:)]) {
                [weakSelf.delegate handleJGJGroupMemberSelectedTeamMembers:weakSelf.selectedSynBillingModels groupMemberMangeType:weakSelf.groupMemberMangeType];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
    }
    else {
        if ([self.delegate respondsToSelector:@selector(handleJGJGroupMemberSelectedTeamMembers:groupMemberMangeType:)]) {
            [self.delegate handleJGJGroupMemberSelectedTeamMembers:self.selectedSynBillingModels groupMemberMangeType:self.groupMemberMangeType];
        }
        
    }
}

#pragma mark - 处理单个添加模型
- (void)handleAddIndividualTeamMember:(JGJSynBillingModel *)teamModel {
    
    if (teamModel.isMangerModel) { //这个是添加或者删除模型不添加
        
        return;
    }
    
    if ([NSString isEmpty:teamModel.real_name] && [NSString isEmpty:teamModel.telephone]) {
        
        return;
    }
    
    teamModel.firstLetteter = [NSString firstCharactor:teamModel.real_name].uppercaseString;
    
    __block NSUInteger indx = 0;
    [self.contactsLetters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:teamModel.firstLetteter.uppercaseString]) {
            indx = idx;
            *stop = YES;
        }
    }];
    //    判断是否有相同的人添加
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telph contains %@", teamModel.telephone];
    SortFindResultModel *containContactModel = nil;
    
    if (self.sortContacts.count > 0) {
        
        containContactModel = self.sortContacts[indx];
    }
    
    NSArray *sameContacts = [self.backupAllContacts filteredArrayUsingPredicate:predicate];
    
    if (sameContacts.count > 0) { //输入联系人包含在通信录，取出对应位置的数据
        JGJSynBillingModel *teamModel = sameContacts[0];
        teamModel.isSelected = YES;
        [self.contactsLetters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:teamModel.firstLetteter.uppercaseString]) {
                indx = idx;
                *stop = YES;
            }
        }];
        containContactModel = self.sortContacts[indx];
        NSUInteger row = [containContactModel.findResult indexOfObject:teamModel];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:indx];
        [self.tableView reloadData];
        if (!teamModel.isAddedSyn && !teamModel.isSingleChatModel) {
            [self scrollPositionIndexPath:indexpath];
        }
        return;
    }
    [self handleReadAddressBookAddSynMemberModel:teamModel];
}


#pragma mark - 处理取消已选中情况
- (void)handleReadAddressBookAddSynMemberModel:(JGJSynBillingModel *)synBillingModel {
    __block BOOL isContainModel = NO;
    
    //判断人员是否存在不能用姓名首字母去判断 要用电话号码去 判断是否相同
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telph contains %@",synBillingModel.telephone];
    JGJSynBillingModel *existContactModel = [JGJSynBillingModel new];
    for (SortFindResultModel *sortContactModel in self.sortContacts) {
        NSArray *existContacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate];
        if (existContacts.count > 0 && sortContactModel.findResult.count > 0) {
            existContactModel = existContacts.lastObject;
            NSMutableArray *repeatContacts = sortContactModel.findResult.mutableCopy;
            
            if (repeatContacts.count > 0) {
                
                [repeatContacts removeObject:existContactModel]; //找到原来通信录的人员移除、判断重复
                sortContactModel.findResult = repeatContacts;
            }
            isContainModel = YES;
            break; //存在就退出
        }
    }
    
    
    NSString *firstLetter = [NSString firstCharactor:synBillingModel.real_name].uppercaseString; //当前数据插入到对应段的位置
    SortFindResultModel *queryContactModel = [[SortFindResultModel alloc] init];
    queryContactModel.firstLetter = firstLetter;

    //判断位置
    __block NSInteger indx = 0;
    [self.contactsLetters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:firstLetter]) {
            indx = idx;
            isContainModel = YES;
            *stop = YES;
        }
    }];
    
    if (!isContainModel) { //注意此处判断是否存在原数据组，若已全移除，数据返回时要重新创建
        NSMutableArray *firstLetters = self.contactsLetters.mutableCopy;
        [firstLetters addObject:firstLetter];
        self.contactsLetters = firstLetters;
        SortFindResultModel *resetContactSortModel = [[SortFindResultModel alloc] init];
        firstLetter = [NSString firstCharactor:synBillingModel.real_name].uppercaseString;
        resetContactSortModel.firstLetter = firstLetter;
        synBillingModel.firstLetteter = firstLetter;
        resetContactSortModel.findResult = @[synBillingModel].mutableCopy;
        if (!self.sortContacts) {
            self.sortContacts = [NSMutableArray array];//未打开通信录情况
        }
        if (!self.contactsLetters) {
            self.contactsLetters = [NSMutableArray array];
        }
        [self.sortContacts insertObject:resetContactSortModel atIndex:0];
        [self.contactsLetters addObject:firstLetter];
        //    contactsLetters包含没有重复的字母
        NSSet *set = [NSSet setWithArray:self.contactsLetters]; //去掉重复的字母并排序
        self.contactsLetters  = [set allObjects].mutableCopy;
        self.contactsLetters = [NSMutableArray arrayWithArray: [self.contactsLetters sortedArrayUsingSelector:@selector(compare:)]];
        NSInteger firstIndx = [self.contactsLetters indexOfObject:firstLetter];
        if (firstIndx != NSNotFound) {
            indx = firstIndx;
        }
    } else {
        SortFindResultModel *containContactModel = self.sortContacts[indx];
        NSMutableArray *sortContacts = containContactModel.findResult.mutableCopy;
        //    判断是否有相同的人添加
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telph contains %@ or telephone contains %@", synBillingModel.telph, synBillingModel.telephone];
//        NSArray *addedContacts = [containContactModel.findResult filteredArrayUsingPredicate:predicate];
//        
//        if (addedContacts.count > 0) { //当前人员存在并且标记为已添加
//            JGJSynBillingModel *teamMemberModel = addedContacts.firstObject;
//            teamMemberModel.isAddedSyn = synBillingModel.isAddedSyn; //当前状态标记为传进来的初始数据
//            synBillingModel.isAddedSyn = teamMemberModel.isAddedSyn; //当前状态赋值给通信录人员
//            [containContactModel.findResult removeObject:existContactModel]; // ，删除之前通信录人员
//            
//        }else { //当前人员不存在添加
            [sortContacts insertObject:synBillingModel atIndex:0];
            containContactModel.findResult = sortContacts;
//        }
    }
    self.sortContactsModel.sortContacts = self.sortContacts;
    
    self.sortContactsModel.contactsLetters = self.contactsLetters;
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    
    [self.sortContacts sortUsingDescriptors:sortDescriptors];
//3.2.0取消
//    [self showSynBillingSelectedCount:self.selectedSynBillingModels]; //底部添加控件
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:indx];
    
    [self.tableView reloadData];
    
    if (!synBillingModel.isAddedSyn && !synBillingModel.isSingleChatModel) {
        [self scrollPositionIndexPath:indexpath];
    }
    
}

#pragma mark - 去掉滚动到固定位置
- (void)scrollPositionIndexPath:(NSIndexPath *)indexpath {
    
//    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.centerShowLetter.hidden = YES;
//    });
    
}

#pragma mark - 获取通信录信息
- (void)addressBookContacts {
    
    if (self.sortContacts.count == 0) {
        
         [self firstOpenAdddressbook];
        
    }
    
}

#pragma mark - 获取通信录信息

- (void)firstOpenAdddressbook {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    self.sortContactsModel = [JGJAddressBookTool addressBookContacts];
    
    if (self.sortContactsModel.sortContacts.count == 0) { //未缓存成功重新缓存
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *contacts = [TYAddressBook loadAddressBook];
            contacts = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:contacts];
            self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:contacts];
            [JGJAddressBookTool archiveSortContactsModel:self.sortContactsModel contactsPath:JGJAddressBookToolPath];
            
            [self handleCurrentTeamMember:self.sortContactsModel];
            
            [TYLoadingHub hideLoadingView];
        });
        
    }else {
        
        [TYLoadingHub hideLoadingView];
    }
    
    [self handleCurrentTeamMember:self.sortContactsModel];
    
}

#pragma mark - 处理当前传入的成员
- (void)handleCurrentTeamMember:(JGJAddressBookSortContactsModel *)sortContactsModel {

    self.sortContacts = sortContactsModel.sortContacts;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
    
    self.backupSortContacts = self.sortContacts;
    
    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType || self.contactedAddressBookVcType == JGJCreatGroupAddMemberType || self.contactedAddressBookVcType == JGJTeamMangerAddMembersVcType) {
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            [self handleCurentSelectedMembers];
            
            [self.tableView reloadData];
            
            [TYLoadingHub hideLoadingView];
        });
    }
    
    if (self.commonModel.teamControllerType == JGJTeamMangerControllerType || self.commonModel.teamControllerType == JGJGroupMangerControllerType) {
    
        //判断通信录是否打开
        [self unfoldAddressBook:nil];
        
        //当前班组人员状态去对比通信录人员状态
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            // 在此处进行UI刷新
            
            [self handleCurentSelectedMembers];
            
            [self.tableView reloadData];
            
            [TYLoadingHub hideLoadingView];
        });
    }
}

- (void)setSortContacts:(NSMutableArray *)sortContacts {
    
    _sortContacts = sortContacts;
    
    BOOL isRefreshPro = self.groupMemberMangeType == JGJGroupMemberMangePushNotifyType && !self.synProFirstModel;
    
    if (isRefreshPro) {
        
        [self loadExistSynProList]; //人员显示完加载存在的同步项目
    }
    
    [self.tableView reloadData];
}

- (void)commonSet {
    
    //数据来源人
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExistSourceButtonAction:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.containSourceNumView addGestureRecognizer:tap];

    self.sourceNumLable.textColor = AppFontf18215Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.confirmButton.backgroundColor = AppFontd7252cColor;
    [self.confirmButton.layer setLayerCornerRadius:5];
    self.showSelectedCountLable.textColor = AppFont666666Color;
    [self.contentSearchBarView addSubview:self.searchBar];
    self.showSelectedCountLable.textColor = AppFont666666Color;
    self.showSelectedCountLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.navigationItem.title = self.synBillingCommonModel.synBillingTitle;
    self.tableView.sectionIndexColor = AppFont999999Color;   //可以改变字体的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];  //可以改变索引背景色
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.centerShowLetter];
    [self showSynBillingSelectedCount:self.selectedSynBillingModels];
    if (self.groupMemberMangeType == JGJGroupMemberMangeRemoveMemberType) {
        self.rightItem.image = [UIImage imageNamed:@""];
        self.rightItem.enabled = NO;
    }
    
    self.containSourceViewTop.constant = -self.containSourceNumView.height;
}

#pragma mark - 搜索输入
- (void)textFieldDidChange:(UITextField *)textField {
    if ([NSString isInputNum:textField.text]) {
        
        [self searchMemberTelephone:textField];

    }else {
        
        [self searchMemberName:textField];

        
    }
    
    self.searchValue = textField.text;
}

#pragma mark - 搜索姓名
- (void)searchMemberName:(UITextField *)textField {
    self.sortContacts = self.sortContactsModel.sortContacts;
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    if ([NSString isEmpty:textField.text]) {
        return;
    }
    NSString *firstLetter = nil;
    if (textField.text.length >= 1) {
        firstLetter = [NSString firstCharactor:[textField.text substringToIndex:1]].uppercaseString;
    }
    if (textField.text.length > 0 && textField.text != nil) {
        NSString *lowerSearchText = textField.text.lowercaseString;
        NSMutableArray *searchSortContacts = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (SortFindResultModel *sortContactModel in self.sortContacts) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or telephone contains %@ or name_pinyin contains %@  or firstLetteter contains %@", textField.text, lowerSearchText, lowerSearchText, lowerSearchText];
                NSMutableArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate].mutableCopy;
                NSDictionary *contactDic = @{@"firstLetter" : contacts.count > 0 ? sortContactModel.firstLetter : @"",
                                             @"findResult" : contacts
                                             };
                SortFindResultModel *sortResultModel = [SortFindResultModel mj_objectWithKeyValues:contactDic];
                if (contacts.count > 0) {
                    [searchSortContacts addObject:sortResultModel];
                }
            }
            self.sortContacts = searchSortContacts;
        });
        
        self.sectionIndexView.hidden = YES;
        
    } else {
        self.sortContacts = self.backupSortContacts.mutableCopy;
    }
    [self.tableView reloadData];
}

#pragma mark - 电话号码搜索
- (void)searchMemberTelephone:(UITextField *)textField {
    self.sortContacts = self.sortContactsModel.sortContacts;
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    if (textField.text.length <= 3) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (textField.text.length > 0 && textField.text != nil) {
            NSString *lowerSearchText = textField.text.uppercaseString;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",lowerSearchText];
            
            NSArray *backups = self.sortContacts.mutableCopy;
            
            NSMutableArray *searchContacts = [NSMutableArray array];
            for (SortFindResultModel *sortContactModel in backups) {
                NSArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate];
                if (contacts.count > 0) {
                    [searchContacts addObjectsFromArray:contacts];
                }
            }
            [self getContactsFirstletter:searchContacts];
        } else {
            self.sortContacts = self.backupSortContacts.mutableCopy;
        }
        [self.tableView reloadData];
    });
}

#pragma mark - CFRefreshStatusViewDelegate
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (NSMutableArray *)selectedSynBillingModels {
    
    if (!_selectedSynBillingModels) {
        _selectedSynBillingModels = [NSMutableArray array];
    }
    return _selectedSynBillingModels;
}

- (NSMutableArray *)selectedAddressBooks {
    
    if (!_selectedAddressBooks) {
        
        _selectedAddressBooks = [NSMutableArray array];
    }
    return _selectedAddressBooks;
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

- (Searchbar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [Searchbar searchBar];
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _searchBar.backgroundColor = TYColorHex(0Xf3f3f3);
        _searchBar.frame = CGRectMake(12, 7, TYGetUIScreenWidth - 24, 33);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名或手机号码查找";
        [_searchBar setReturnKeyType:UIReturnKeyDone];
    }
    return _searchBar;
}

#pragma mark - 创建右边索引

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        if ([tableView.visibleCells[0] isKindOfClass:[JGJAddTeamMemberCell class]]) {
            JGJAddTeamMemberCell *cell = tableView.visibleCells[0];
            self.centerShowLetter.text = cell.synBillingModel.firstLetteter.uppercaseString;
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

#pragma mark - 添加通信录但聊过的成员到列表
- (void)setSingleChatMembers:(NSMutableArray *)singleChatMembers {
    
    _singleChatMembers = singleChatMembers;
    
    self.currentTeamMembers = _singleChatMembers;
    
    [self handleCurentSelectedMembers];
    
}

- (void)handleCurentSelectedMembers {
    
    BOOL isAddedMember = NO;
    
    if (self.currentTeamMembers.count > 0) {
        
        for (JGJSynBillingModel *contactModel in self.currentTeamMembers) {
            
            for (SortFindResultModel *sortContactModel in self.sortContacts) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",contactModel.telephone];
                
                NSArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate];
                
                if (contacts.count > 0) {
                    
                    JGJSynBillingModel *existContactModel = contacts.lastObject;
                    
                    existContactModel.head_pic = contactModel.head_pic;
                    
                    existContactModel.real_name = contactModel.real_name;
                    
                    existContactModel.isAddedSyn = YES; //已添加
                    
//                    isAddedMember = YES;
                    
                }
            }
            
//            if (!isAddedMember) {
//
//                [self handleAddIndividualTeamMember:contactModel];
//            }
            
        }
        [self.tableView reloadData];
    }
    
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (void)setContactsLetters:(NSMutableArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount) {
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

- (JGJSingleListRequest *)singleListRequest {
    
    if (!_singleListRequest) {
        _singleListRequest = [JGJSingleListRequest new];
        _singleListRequest.ctrl = @"Chat";
        _singleListRequest.action = @"getSingleList";
        _singleListRequest.class_type = @"friendsChat";
        _singleListRequest.cur_class_type = self.workProListModel.class_type;
        _singleListRequest.cur_group_id = self.workProListModel.group_id;
    }
    return _singleListRequest;
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContactsLetters:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    JGJCusBackButton *button = [JGJCusBackButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)backButtonPressed {
    
    if (self.skipToNextVc) {
        
        self.skipToNextVc(self);
    }
    
    if (self.selectedSynBillingModels.count > 0) {
        
        for (JGJSynBillingModel *selMemberModel in self.selectedSynBillingModels) {
            
            selMemberModel.isSelected = NO;
            
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 处理最大可选人数
- (BOOL)handleMaxSelMemberWithSelMembers:(NSArray *)selMembers {
    
    NSUInteger allMemberNum = self.teamInfo.members_num.integerValue + selMembers.count;
    
    JGJGroupMangerTool *mangerTool = [[JGJGroupMangerTool alloc] init];
    
    self.teamInfo.cur_member_num = allMemberNum - 1;
    
    mangerTool.teamInfo = self.teamInfo;
    
    mangerTool.targetVc = self.navigationController;
    
    mangerTool.workProListModel = self.workProListModel;
    
    return mangerTool.isPopView;
    
}

#pragma mark - 添加数据源

#pragma mark - 显示现成的数据源列表
- (void)handleExistSourceButtonAction:(UITapGestureRecognizer *)tapGesture {
    JGJUnhandleSourceListVC *sourceListVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJUnhandleSourceListVC"];
    sourceListVC.synProFirstModel = self.synProFirstModel;
    sourceListVC.delegate = self;
    NSUInteger navCount = self.navigationController.viewControllers.count - 2;
    sourceListVC.skipVC = self.navigationController.viewControllers[navCount];
    sourceListVC.teamMemberModels = self.currentTeamMembers; //已添加为数据来源人
    [self.navigationController pushViewController:sourceListVC animated:YES];
}

#pragma mark - JGJUnhandleSourceListVCDelegate
- (void)JGJUnhandleSourceListVcConfirmButtonPressed:(JGJUnhandleSourceListVC *)sourceListVC {
    NSMutableArray *selecteSourceMember = sourceListVC.synProFirstModel.selectedSync_sources.mutableCopy;
    NSArray *allSelectedSourceMember = selecteSourceMember.copy;
    for (JGJSynBillingModel *teamMemberModel in allSelectedSourceMember) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@", teamMemberModel.telephone];
        JGJSynBillingModel *selelctedTeamModel = [self.currentTeamMembers filteredArrayUsingPredicate:predicate].lastObject;
        if ([selelctedTeamModel.telephone isEqualToString:teamMemberModel.telephone]) {
            selelctedTeamModel.source_pro_id = teamMemberModel.source_pro_id; //包含已添加的,不显示。但是要赋值source_pro_id
//            [selecteSourceMember removeObject:selelctedTeamModel];
        }
    }
    if (self.selectedSynBillingModels.count > 0) {
        
        [selecteSourceMember addObjectsFromArray:self.selectedSynBillingModels];
    }
    
    JGJSourceSynProFirstModel *sourceSynProFirstModel = [JGJSourceSynProFirstModel new];
    
    sourceSynProFirstModel.selectedSync_sources = selecteSourceMember;

    if ([self.delegate respondsToSelector:@selector(handleJGJGroupMemberSelectedTeamMembers:groupMemberMangeType:)]) {
        
        [self.delegate handleJGJGroupMemberSelectedTeamMembers:selecteSourceMember groupMemberMangeType:self.groupMemberMangeType];
        
    }
    
}

- (void)setSynProFirstModel:(JGJSourceSynProFirstModel *)synProFirstModel {
    _synProFirstModel = synProFirstModel;
    NSUInteger count = [synProFirstModel.sync_count.sync_unsource_person_count integerValue];
    if (count > 0) {
        if (count > 0) {
            CGFloat duration = 0.7; // 动画的时间
            [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.containSourceViewTop.constant += 45;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
            NSString *sync_count = [NSString stringWithFormat:@"选择现成数据源 (%@个)", @(count)];
            self.sourceNumLable.text = sync_count;
        }
        NSMutableString *mergeProId = [NSMutableString string];
        for (JGJSynBillingModel *synTeamMemberModel in self.currentTeamMembers) {
            if (![NSString isEmpty:synTeamMemberModel.source_pro_id]) {
                if ([mergeProId rangeOfString:synTeamMemberModel.source_pro_id].location == NSNotFound) {
                    [mergeProId appendFormat:@"%@,", synTeamMemberModel.source_pro_id];
                }
            }
        }
        [synProFirstModel.list enumerateObjectsUsingBlock:^(JGJSourceSynProSeclistModel * _Nonnull seclistModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *sourceProIDs = nil;
            sourceProIDs = [mergeProId componentsSeparatedByString:@","];
            if (sourceProIDs.count > 0) {
                [sourceProIDs enumerateObjectsUsingBlock:^(NSString   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid == %@", obj];
                    JGJSyncProlistModel *prolistModel = [seclistModel.sync_unsource.list filteredArrayUsingPredicate:predicate].lastObject;
                    if ([prolistModel.pid isEqualToString:obj]) {
                        prolistModel.isSelected = YES;
                    }
                }];
            }
        }];
        [self.tableView reloadData];
    }
}

#pragma mark - 获取同步项目列表
- (void)loadExistSynProList {
    
    [TYLoadingHub showLoadingWithMessage:nil];

    __weak typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithNapi:JGJGroupSyncproFromSourceListURL parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        self.synProFirstModel = [JGJSourceSynProFirstModel mj_objectWithKeyValues:responseObject];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - ClickPeopleItemButtondelegate
-(void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel {
    
    deleteModel.isSelected = NO;
    
    if (self.selectedSynBillingModels.count > 0) {
        
        [self.selectedSynBillingModels removeObject:deleteModel];
    }
    
    [self.tableView reloadData];
    
    [self showSynBillingSelectedCount:self.selectedSynBillingModels];
}

- (JGJImageModelView *)imageModelView {
    
    if (!_imageModelView) {
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, ImageModelViewHeight);
        _imageModelView = [[JGJImageModelView alloc] initWithFrame:rect];
        _imageModelView.peopledelegate = self;
    }
    return _imageModelView;
}

@end
