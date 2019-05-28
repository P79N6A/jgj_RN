//
//  JGJAccountingMemberVC.m
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAccountingMemberVC.h"

#import "JGJAddressBookTool.h"

#import "JGJAccountingMemberCell.h"

#import "CustomAlertView.h"

#import "JGJSynAddressBookVC.h"

#import "JGJQRecordViewController.h"

#import "JGJTeamWorkListViewController.h"

#import "DSectionIndexView.h"

#import "DSectionIndexItemView.h"

#import "TYTextField.h"

#import "JGJComPaddingCell.h"

#import "JGJAddAccountMemberInfoVc.h"

#import "JLGCustomViewController.h"

#import "CFRefreshStatusView.h"

#define SearchbarHeight 48

#define RowH 87
#define HeaderH 35
#define Padding 15
#define LinViewH 7
#define Selelcted
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

@interface JGJAccountingMemberVC () <
UITableViewDataSource,

UITableViewDelegate,

YZGAddContactsHUBViewDelegate,

DSectionIndexViewDataSource,

DSectionIndexViewDelegate,

UITextFieldDelegate
>

typedef void(^JGJDelMemberBlock)(JGJSynBillingModel *Member);

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

//是否显示删除按钮
@property (nonatomic, assign) BOOL isShowDelButton;

//记账人员
@property (nonatomic, strong) NSArray *accountMembers;

@property (retain, nonatomic) DSectionIndexView *sectionIndexView;

@property (nonatomic,strong) UILabel *centerShowLetter;

@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母

@property (strong, nonatomic) YZGAddContactsHUBView  *addWorkerContactsHUBView; //添加工人的界面 1.4.5添加

//顶部描述信息
@property (nonatomic, strong) NSMutableArray *firstSectionInfos;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property (nonatomic, copy) JGJDelMemberBlock delMemberBlock;

@property (nonatomic, copy) NSString *searchValue;

@end

@implementation JGJAccountingMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self searchbar];
    
    [self.view addSubview:self.tableView];
    
    self.title = JLGisMateBool?@"选择班组长":@"选择工人";
    
    //班组记账不需要显示
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        self.title = @"选择班组成员";
        
    }else if ([self.contractor_type isEqualToString:@"1"]) { //班组长记承包 名字为选择承包对象
        
        self.title = @"选择承包对象";
    }
    
    if ([NSString isEmpty:self.workProListModel.group_id]) {
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delRightBarButtonPressed:)];
        
        self.rightBarButtonItem = rightBarButtonItem;
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }
    
    TYWeakSelf(self);
    
    if (![self checkIsRealName]) {
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself beginReFresh];
            };
        }
        
    }
    
    if (JLGIsRealNameBool) {
        
        [TYLoadingHub showLoadingWithMessage:nil];;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self subViewWillAppear:animated];
}

#pragma mark - 子类使用
- (void)subViewWillAppear:(BOOL)animated {
    
    [self beginReFresh];
}

#pragma mark - 子类使用
- (void)beginReFresh {
    
    [self accountMemberRequest];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        count = [NSString isEmpty:self.searchValue] ? self.firstSectionInfos.count : 0;
        
        //班组记账不需要显示
        if (![NSString isEmpty:self.workProListModel.group_id]) {
            
            count = 0;
            
        }
        
    }else {
        
        if (self.sortContactsModel.sortContacts.count > 0) {
            
            SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[section - 1];
            
            count = sortFindResultModel.findResult.count;
        }
        
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (self.firstSectionInfos.count - 1 == indexPath.row) {
            
            JGJComPaddingCell *paddingCell = [JGJComPaddingCell cellWithTableView:tableView];
            
            paddingCell.infoDesModel = self.firstSectionInfos.lastObject;
            
            paddingCell.topLineView.hidden = self.sortContactsModel.sortContacts.count == 0;
            
            cell = paddingCell;
            
        }else {
            
            JGJCommonInfoDesCell *desCell = [JGJCommonInfoDesCell cellWithTableView:tableView];
            
            JGJCommonInfoDesModel *infoDesModel = self.firstSectionInfos[indexPath.row];
            
            desCell.infoDesModel = infoDesModel;
            
            if (self.contactsLetters.count > ShowCount) {
                
                desCell.nextImageTrail.constant = 40;
            }
            
            cell = desCell;
        }
        
    }else {
        
        cell = [self tableView:tableView selMemberCellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView selMemberCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAccountingMemberCell *memberCell = [self selMemberCellWithTableView:tableView];
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section - 1];
    
    [self setMemberWithCell:memberCell memberModel:sortFindResultModel.findResult[indexPath.row]];
    
    memberCell.lineViewH.constant = sortFindResultModel.findResult.count - 1 == indexPath.row ? CGFLOAT_MIN : 10;
    
    memberCell.centerY.constant = sortFindResultModel.findResult.count - 1 == indexPath.row ? CGFLOAT_MIN : -5;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.contactsLetters.count > ShowCount) {
        
        memberCell.trail.constant = 40;
    }
    
    memberCell.accountingMemberDelButtonPressedBlock = ^(JGJSynBillingModel *accountMember) {
        
        [weakSelf.view endEditing:YES];
        
        [weakSelf accountingMemberDelButtonPressedWithAccountMember:accountMember indexPath:indexPath];
    };
    
    return memberCell;
}

#pragma mark - 子类使用
- (void)setMemberWithCell:(JGJAccountingMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel {
    
    cell.searchValue = self.searchValue;
    
    cell.accountMember = memberModel;
    
    cell.isShowDelButton = self.isShowDelButton;
}

//子类使用
- (JGJAccountingMemberCell *)selMemberCellWithTableView:(UITableView *)tableView {
    
    JGJAccountingMemberCell *memberCell = [JGJAccountingMemberCell cellWithTableView:tableView];
    
    return memberCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self registerSubWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

#pragma makr - 子类使用
- (void)registerSubWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self setTopInfoSelectRowAtIndexPath:indexPath];
        
    }else {
        
        SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section - 1];
        
        JGJSynBillingModel *accountMember = sortFindResultModel.findResult[indexPath.row];
        
        //点击删除
        
        if (self.isShowDelButton) {
            
            [self accountingMemberDelButtonPressedWithAccountMember:accountMember indexPath:indexPath];
            
        }else {
            
            //设置状态
            
            [self selMemberStatus:accountMember];
            
            self.memberType = AddComMemberType;
            
            //3.2.0添加是否已经同步人员
            accountMember.isExistedSynMember = [self isExistedSynMember];
            
            //点击人员返回
            [self selectedMemberWithMemberModel:accountMember];
            
            //工人管理子类使用
            
            [self workMangerSubClassSelectedMemberWithMemberModel:accountMember didSelectRowAtIndexPath:indexPath];
        }
        
    }
}

#pragma mark - 子类使用

- (void)selMemberStatus:(JGJSynBillingModel *)memberModel {
    
    memberModel.isSelected = !memberModel.isSelected;
}

#pragma mark - 是否已经是同步人员
- (BOOL)isExistedSynMember {
    
    return YES;
}

- (void)setTopInfoSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (JLGisLeaderBool) {
        
        [self workLeaderDidSelectRowAtIndexPath:indexPath];
        
    }else {
        
        [self normalWorkerDidSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - 选中人员
- (void)selectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    if (self.accountingMemberVCSelectedMemberBlock) {
        
        self.accountingMemberVCSelectedMemberBlock(memberModel);
        
        [self popSynVc];
    }
    
}

#pragma mark - 工人管理子类使用
- (void)workMangerSubClassSelectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)popSynVc {
    
    if (self.targetVc) {
        
        //        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:self.targetVc animated:YES];
        
    }else {
        
        BOOL isHaveSegmentController = NO;
        
        UIViewController *SlideSegmentController;
        for (UIViewController *popVc in self.navigationController.viewControllers) {
            
            if ([popVc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
                
                isHaveSegmentController = YES;
                SlideSegmentController = popVc;
                break;
            }
        }
        
        if (isHaveSegmentController) {
            
            [self.navigationController popToViewController:SlideSegmentController animated:YES];
        }else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

#pragma mark - 工头选择
- (void)workLeaderDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.memberType = AddOtherMemberType;
    
    switch (indexPath.row) {
            
        case 0:{
            [self addAccountMemberInfo];
            
            self.memberType = AddSingleMemberType;
            
        }
            
            break;
        case 1:{
            
            [self addTelContacts];
            
        }
            
            break;
            
        case 2:{
            
            JGJTeamWorkListViewController *workListVc = [[JGJTeamWorkListViewController alloc]init];
            
            workListVc.isRecordSingleMember = YES;
            
            [self.navigationController pushViewController:workListVc animated:YES];
            
            __weak typeof(self) weakSelf  = self;
            
            workListVc.selelctedMembersVcBlock = ^(JGJSynBillingModel *accountMember) {
                
                [weakSelf addRecordMember:accountMember success:^(id response) {
                    
                    [weakSelf selectedMemberWithMemberModel:accountMember];
                }];
                
            };
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 普通工人
- (void)normalWorkerDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.memberType = AddOtherMemberType;
    
    switch (indexPath.row) {
        case 0:{
            
            if (self.hubViewType == YZGAddContactsHUBViewSynType || self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
                
                [self addSingleAccountMemberModel];
                
            }else {
                
                [self addAccountMemberInfo];
            }
            
            self.memberType = AddSingleMemberType;
            
        }
            
            break;
        case 1:{
            
            [self addTelContacts];
            
        }
            
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = indexPath.section == 0 ? [JGJCommonInfoDesCell JGJCommonInfoDesCellHeight] : JGJMemberRowH;
    
    //数据为0去掉隐藏常选工人或者班组长类型
    if ((self.accountMembers.count == 0 && indexPath.section == 0 && indexPath.row == self.firstSectionInfos.count - 1)) {
        
        height = CGFLOAT_MIN;
        
    }else if (indexPath.section == 0 && indexPath.row == self.firstSectionInfos.count - 1) {
        
        height = [JGJComPaddingCell cellHeight];
        
        if (self.memberType == AddGroupMangerMember || [self isMemberOfClass:NSClassFromString(@"JGJMemeberMangerVc")]) {
            
            height = CGFLOAT_MIN;
            
        }
        
    }else if (indexPath.section > 0) {
        
        height = [self registerSubClassWithtableView:tableView heightForRowAtIndexPath:indexPath];
        
    }else if ([self.contractor_type isEqualToString:@"1"] && indexPath.section == 0 && indexPath.row == 2) { //承包没有班组选择
        
        height = CGFLOAT_MIN;
    }
    
    return height;
    
}

- (CGFloat)registerSubClassWithtableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section - 1];
    
    CGFloat height = sortFindResultModel.findResult.count -1 == indexPath.row ? JGJMemberRowH -10 : JGJMemberRowH;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = section == 0 ? CGFLOAT_MIN : HeaderH;
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section > 0) {
        
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
            }
        }
        firstLetterLable.textColor = AppFont999999Color;
        
        [headerView addSubview:firstLetterLable];
        
        return headerView;
    }
    
    return nil;
}

- (void)delRightBarButtonPressed:(UIBarButtonItem *)rightBarButtonItem {
    
    _isShowDelButton = !_isShowDelButton;
    
    rightBarButtonItem.title = _isShowDelButton ? @"取消" : @"删除";
    
    [self.tableView reloadData];
}

#pragma mark - 记账请求
- (void)accountMemberRequest{
    
    NSDictionary *parameters = nil;
    
    NSString *api = [self requestApi];
    
    //班组进入显示班组成员
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        parameters = @{@"group_id" : self.workProListModel.group_id};
        
        api = @"v2/Workday/billToGroupMemberList";
        
        [JLGHttpRequest_AFN PostWithApi:api parameters:parameters success:^(NSArray *responseObject) {
            
            [self handleSuccessResponse:responseObject];
            
        }failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        
    }else {
        
        if ([self.contractor_type isEqualToString:@"1"] && JLGisLeaderBool) {
            
            parameters = @{@"contractor_type" : @"1"};
            
        }
        
        [JLGHttpRequest_AFN PostWithNapi:api parameters:parameters success:^(NSArray *responseObject) {
            
            [self handleSuccessResponse:responseObject];
            
        }failure:^(NSError *error) {
            
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
}

- (void)handleSuccessResponse:(NSArray *)responseObject {
    
    NSArray *members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
    
    self.accountMembers = members;
    
    _tableView.hidden = NO;
    
    _searchbar.hidden = members.count == 0;
    
    CGRect rect = [self setSubTableViewFrame];
    
    if (members.count == 0) {
        
        rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
    }
    
    self.tableView.frame = rect;
    
    //人员排序
    [self sortAccountMemberWithMembers:members];
    
    //去掉右上角删除按钮
    [self cancelRightItemTitle];
    
    //去掉第一段常用工人班组长信息
    [self cancelFirstSectionLastRowInfo];
    
    [TYLoadingHub hideLoadingView];
    
    self.delMemberBlock = ^(JGJSynBillingModel *Member) {
        
        [TYShowMessage showSuccess:@"删除成功！"];
    };
    
    if ([self isMemberOfClass:NSClassFromString(@"JGJMemeberMangerVc")]) {
        
        //判断是否有数据
        [self handleNoList:members];
        
    }
    
}

- (void)handleNoList:(NSArray *)list  {
    
    if (list.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
    } else {
        
        self.tableView.tableHeaderView = nil;
        
    }
    
}

#pragma mark - 请求接口子类也会使用
- (NSString *)requestApi {
    
    return @"workday/fm-list";
}

#pragma mark - 添加记账人员
- (void)addRecordMember:(JGJSynBillingModel *)recordMember success:(void (^)(id response)) response {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    NSString *contractor_type = [NSString isEmpty:self.contractor_type] ? @"0" : @"1";
    
    NSDictionary *parameters = @{@"name":recordMember.name?:@"",
                                 @"telph":recordMember.telph?:@"",
                                 @"contractor_type" : contractor_type};
    //班组进入显示班组成员
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        parameters = @{@"name":recordMember.name?:@"",
                       @"telph":recordMember.telph?:@"",
                       @"group_id" : self.workProListModel.group_id,
                       @"contractor_type" : contractor_type};
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/add-fm" parameters:parameters success:^(id responseObject) {
        
        if (response) {
            
            response(responseObject);
        }
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)sortAccountMemberWithMembers:(NSArray *)members {
    
    JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:members];
    
    self.sortContactsModel = sortContactsModel;
    
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    
    NSString *uid = [NSString stringWithFormat:@"%@", self.seledAccountMember.uid];
    
    //标记之前选中的
    if (![NSString isEmpty:uid]) {
        
        for (SortFindResultModel *sortContactsModel in self.sortContactsModel.sortContacts) {
            
            NSPredicate *predicate = [self setMemberPredicate];
            
            NSArray *filterMembers = [sortContactsModel.findResult filteredArrayUsingPredicate:predicate];
            
            if (filterMembers.count > 0) {
                
                JGJSynBillingModel *seledAccountMember = filterMembers.firstObject;
                
                seledAccountMember.isSelected = YES;
                
                break;
            }
            
        }
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - 子类也在使用
- (NSPredicate *)setMemberPredicate {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid=%@",self.seledAccountMember.uid];
    
    return predicate;
    
}

#pragma mark - 没有记账人员去掉常选工人、班组长最后一个标识
- (void)cancelFirstSectionLastRowInfo {
    
    if (self.accountMembers.count == 0 && self.firstSectionInfos.count > 0) {
        
        JGJCommonInfoDesModel *infoDesModel = self.firstSectionInfos.lastObject;
        
        infoDesModel.title = @"";
        
    }else if (self.accountMembers.count > 0) {
        
        JGJCommonInfoDesModel *infoDesModel = self.firstSectionInfos.lastObject;
        
        infoDesModel.title = [self.contractor_type isEqualToString:@"1"] ? @"常选承包对象" :@"常选人员";
        
        if (self.memberType == AddGroupMangerMember) {
            
            infoDesModel.title = JLGisLeaderBool ? @"常选工人" : @"常选班组长";
            
        }
        
    }
    
}

#pragma mark - 去掉右上角的删除按钮
- (void)cancelRightItemTitle {
    
    if (self.accountMembers.count == 0) {
        
        self.rightBarButtonItem.title = @"";
        
    }else {
        
        self.rightBarButtonItem.title = _isShowDelButton ? @"取消" : @"删除";;
    }
}

#pragma mark - 删除记账人
- (void)accountingMemberDelButtonPressedWithAccountMember:(JGJSynBillingModel *)accountMember indexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    //如果是已选中点击直接返回
    if (accountMember.isSelected && !self.isShowDelButton) {
        
        [self selectedMemberWithMemberModel:accountMember];
        
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"确定要删除 %@ 吗?", accountMember.name];
    
    if (accountMember.is_not_telph) {
        
        title = [NSString stringWithFormat:@"删除无电话号码的用户后，将无法再次对该用户记账。确定要删除 %@ 吗?", accountMember.name];
    }
    
    __weak typeof(self) weakSelf = self;
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:title leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    
    alertView.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    alertView.onOkBlock = ^{
        [weakSelf deleteServiceContactMdoel:accountMember indexPath:indexPath];
    };
    
}

#pragma mark - 删除服务器数据
- (void)deleteServiceContactMdoel:(JGJSynBillingModel  *)accountMember indexPath:(NSIndexPath *)indexPath {
    
    NSString *uid = [self delMemberWithMember:accountMember];
    
    [JLGHttpRequest_AFN PostWithApi:[self delMemberApi] parameters:[self delParametersWithUid:uid] success:^(id responseObject) {
        
        [self delOldSortMemberModel:accountMember indexPath:indexPath];
        
    } failure:^(NSError *error) {
        //        [TYShowMessage  showError:@"删除联系人失败"];
    }];
    
}

- (NSString *)delMemberWithMember:(JGJSynBillingModel *)member {
    
    NSString *uid = [NSString stringWithFormat:@"%@", member.uid];
    
    return uid;
}

- (NSString *)delMemberApi {
    
    return @"v2/workday/delfm";
}

- (NSDictionary *)delParametersWithUid:(NSString *)uid {
    
    NSString *contractor_type = [NSString isEmpty:self.contractor_type] ? @"0" : @"1";
    
    return @{@"partner" : uid ?:[NSNull null],
             @"contractor_type" : contractor_type
             };
}

#pragma mark - 删除本地已排好的数据
- (void)delOldSortMemberModel:(JGJSynBillingModel *)accountMember indexPath:(NSIndexPath *)indexPath {
    
    //  删除的当前记账人员,清空数据
    if ([accountMember.uid isEqualToString:self.seledAccountMember.uid]) {
        
        accountMember.isDelMember = YES;
        
        [self selectedMemberWithMemberModel:accountMember];
    }
    
    //弹框使用
    if (self.delMemberBlock) {
        
        self.delMemberBlock(accountMember);
    }
    
    [self beginReFresh];
}

#pragma mark - YZGAddContactsHUBViewDelegate
- (void)AddContactsHubSaveBtcClick:(YZGAddContactsHUBView *)contactsView {
    
    [self popToReleaseBillVc:contactsView.yzgAddForemanModel];
}

- (void)popToReleaseBillVc:(YZGAddForemanModel *)addForemanModel{
    
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    
    memberModel.uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    
    //同步项目的话使用的是target_uid
    if (self.addWorkerContactsHUBView.hubViewType == YZGAddContactsHUBViewSynType) {
        
        memberModel.target_uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    }
    
    memberModel.telph = addForemanModel.telph;
    
    memberModel.name = addForemanModel.name;
    
    [self selectedMemberWithMemberModel:memberModel];
    
}

#pragma mark - 添加单个人员
- (void)addSingleAccountMemberModel {
    
    if (!self.addWorkerContactsHUBView.delegate) {
        
        self.addWorkerContactsHUBView.delegate = self;
    }
    
    [self.addWorkerContactsHUBView showAddContactsHubView];
}

- (void)addAccountMemberInfo {
    
    JGJAddAccountMemberInfoVc *addMemberInfoVc = [[JGJAddAccountMemberInfoVc alloc] init];
    
    //是否是记得承包
    
    addMemberInfoVc.contractor_type = self.contractor_type;
    
    addMemberInfoVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:addMemberInfoVc animated:YES];
    
    TYWeakSelf(self);
    
    addMemberInfoVc.addAccountMemberInfoVcBlock = ^(JGJSynBillingModel *memberModel) {
        
        [weakself selectedMemberWithMemberModel:memberModel];
        
    };
}

#pragma mark - 添加通讯录
- (void)addTelContacts{
    
    JGJSynAddressBookVC *synAddressBookVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynAddressBookVC"];
    
    synAddressBookVC.synBillingModels = self.accountMembers.mutableCopy ;
    
    synAddressBookVC.addressBookAddButtonType = [self buttonType];
    
    synAddressBookVC.dataArray = [self.accountMembers  mutableCopy];
    
    synAddressBookVC.workProListModel = self.workProListModel;
    
    synAddressBookVC.hubViewType = self.hubViewType;
    
    synAddressBookVC.contractor_type = self.contractor_type;
    
    [self.navigationController pushViewController:synAddressBookVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //通讯录选择回调
    synAddressBookVC.addSynModelBlock = ^(JGJSynBillingModel *accountMember) {
        
        //返回到对应页面
        [weakSelf selectedMemberWithMemberModel:accountMember];
        
    };
}

#pragma mark - 同步按钮下的类型
- (AddressBookAddButtonType)buttonType {
    
    return AddressBookAddWorkerButton;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = [self setSubTableViewFrame];
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.hidden = YES;
    }
    
    return _tableView;
    
}

- (CGRect)setSubTableViewFrame {
    
    CGRect rect = CGRectMake(0, SearchbarHeight, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - SearchbarHeight);
    
    return rect;
}

- (NSMutableArray *)firstSectionInfos {
    
    if (!_firstSectionInfos) {
        
        _firstSectionInfos = [NSMutableArray new];
        
        NSString *addWorkMemberTitle = @"添加班组长";
        
        if (![NSString isEmpty:self.agency_title]) {
            
            addWorkMemberTitle = [NSString stringWithFormat:@"添加%@",self.agency_title];
        }
        
        NSArray *titles = @[addWorkMemberTitle, @"从手机通讯录选择", @"常选人员"];
        
        NSArray *desTitles = @[ @"没有电话号码也可添加",@"选择手机通讯录中的联系人",  @""];
        
        //工头身份
        if (JLGisLeaderBool) {
            
            NSString *memberDes = [self.contractor_type isEqualToString:@"1"] ? @"添加承包对象" : @"添加工人";
            
            titles = @[memberDes,@"从手机通讯录选择", @"从班组选择", @"常选人员"];
            
            desTitles = @[@"没有电话号码也可添加",@"选择手机通讯录中的联系人",  @"选择已有班组中的人", @""];
            
            if ([self.contractor_type isEqualToString:@"1"]) {
                
                titles = @[memberDes, @"从手机通讯录选择",@"", @"常选承包对象"];
                
                desTitles = @[@"没有电话号码也可添加", @"选择手机通讯录中的联系人", @"", @""];
                
            }
            
        }
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJCommonInfoDesModel *infoDesModel = [JGJCommonInfoDesModel new];
            
            infoDesModel.title = titles[index];
            
            infoDesModel.des = desTitles[index];
            
            infoDesModel.leading =  index == titles.count - 2 ? 0 : 10;
            
            infoDesModel.trailing = infoDesModel.leading;
            
            NSString *imageStr = nil;
            
            if (index == 0) {
                
                imageStr = @"from_tel_icon";
                
            }else if (index == 1) {
                
                imageStr = @"from_addressbook_icon";
                
            }else if (index == 2 && ![self.contractor_type isEqualToString:@"1"]) { //不是承包
                
                imageStr = @"from_group_icon";
            }
            
            infoDesModel.imageStr = imageStr;
            
            infoDesModel.trailing = infoDesModel.leading;
            
            [_firstSectionInfos addObject:infoDesModel];
        }
        
    }
    
    return _firstSectionInfos;
}

- (YZGAddContactsHUBView *)addWorkerContactsHUBView
{
    if (!_addWorkerContactsHUBView) {
        _addWorkerContactsHUBView = [[YZGAddContactsHUBView alloc] initWithFrame:self.view.bounds];
    }
    return _addWorkerContactsHUBView;
}

#pragma mark - 以下代码索引用

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.hidden = YES;
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = [UIColor orangeColor];
    }
    return _centerShowLetter;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
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

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
}

#pragma Mark - 创建右边索引
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
    if (self.sectionIndexView) {
        [self.sectionIndexView removeFromSuperview];
        [self.view addSubview:self.sectionIndexView];
    }
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
    //加上顶部的一段
    NSInteger scroSection = section + 1;
    
    if (self.contactsLetters.count < scroSection) {
        
        return ;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:scroSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telephone contains %@", lowerSearchText, lowerSearchText];
    
    NSArray *dataSource = [self.accountMembers  filteredArrayUsingPredicate:predicate].mutableCopy;
    
    //搜索的人员比较选中状态
    self.searchAccountMembers = dataSource.mutableCopy;
    
    
    if (![NSString isEmpty:value]) {
        
        [self sortAccountMemberWithMembers:dataSource];
        
    } else {
        
        self.searchbar.searchBarTF.text = nil;
        
        [self sortAccountMemberWithMembers:self.accountMembers];
        
    }
    
    self.searchValue = value;
    
    [self.tableView reloadData];
    
    [self searchAccountMember];
    
    [self registerSubClassSearchWithValue:value];
}

- (void)registerSubClassSearchWithValue:(NSString *)value {
    
    
    
}

#pragma mark - 搜索人员子类使用,用于选中状态

- (void)searchAccountMember {
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"请输入姓名或手机号码查找";
        
        _searchbar.searchBarTF.delegate = self;
        
        _searchbar.hidden = YES;
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 11;
        
        __weak typeof(self) weakSelf = self;
        
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
            
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_searchbar];
        
        [self setSeachbarConstantWithSearchbar:_searchbar];
    }
    
    return _searchbar;
    
}

- (void)setSeachbarConstantWithSearchbar:(JGJCustomSearchBar *)searchbar {
    
    [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        
        make.height.mas_equalTo(SearchbarHeight);
        
    }];
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

@end
