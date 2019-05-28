//
//  JGJAddAdministratorListVc.m
//  JGJCompany
//
//  Created by yj on 16/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAddAdministratorListVc.h"
#import "JGJSetAdministratorCell.h"
#import "JGJAddressBookTool.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "CFRefreshStatusView.h"

#import "TYTextField.h"

#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
@interface JGJAddAdministratorListVc () <
UITableViewDelegate,
UITableViewDataSource,
DSectionIndexViewDataSource,
DSectionIndexViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *memberLists;//成员
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息
@property (strong, nonatomic) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母
@property (strong, nonatomic) UILabel *centerShowLetter;

@property (weak, nonatomic) IBOutlet JGJCustomSearchBar *cusSearchBar;

@property (nonatomic, strong)  CFRefreshStatusView *statusView;

@property (strong, nonatomic) NSArray *allMemberModels;

@end

@implementation JGJAddAdministratorListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.addMemberVcType == JGJAddAdminMember ? @"添加管理员" : @"选择成员";
    if (self.addMemberVcType == JGJAddAtMemberType) {
        
        [self loadAtMember];
        
    }else {
        
        [self loadMembersList];
    }
    
    [self initialTopSearchbar];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    count = sortFindResult.findResult.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSetAdministratorCell *cell = [JGJSetAdministratorCell cellWithTableView:tableView];
    cell.adminCellType = JGJSetAdminiCellAddAdminType;
    cell.lineViewH.constant = (sortFindResult.findResult.count -1 - indexPath.row) == 0 ? 0 :  LinViewH;
    cell.searchValue = self.cusSearchBar.searchBarTF.text;
    if (sortFindResult.findResult.count > 0) {
         cell.memberModel = sortFindResult.findResult[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *teamMemberModel = sortFindResult.findResult[indexPath.row];;
    [self handleSetAdminMember:teamMemberModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if ([self.sortContactsModel.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
        firstLetterLable.text = firstLetter ;
    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

#pragma mark - 添加成员
- (void)handleSetAdminMember:(JGJSynBillingModel *)memberModel{
    switch (self.addMemberVcType) {
        case JGJAddAtMemberType:
            [self chatVcSelelctedMember:memberModel];
            break;
        case JGJAddAdminMember:
            [self uploadSelectedMember:memberModel];
            break;
        default:
            break;
    }
}

#pragma mark - 聊天页面选择普通成员
- (void)chatVcSelelctedMember:(JGJSynBillingModel *)memberModel {
    if ([self.delegate respondsToSelector:@selector(addAdminList:didSelectedMember:)]) {
        [self.delegate addAdminList:self didSelectedMember:memberModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 上传添加的管理人员
- (void)uploadSelectedMember:(JGJSynBillingModel *)memberModel {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"team",
                                 
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 
                                 @"uid" : memberModel.uid ?:@"",
                                 
                                 @"status" : @"0"
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJHandleAdminURL parameters:parameters success:^(id responseObject) {
        
         [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 获取成员列表
- (void)loadMembersList {

    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 
                                 @"type"        : @"set_admin_list"
                                 
                                 };
    __weak typeof(self) weakSelf = self;

    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJOperMembersListURL parameters:parameters success:^(id responseObject) {
        
        weakSelf.memberLists = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.allMemberModels = _memberLists.mutableCopy;
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 加载@成员
- (void)loadAtMember {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 @"type"        : @"at_member"
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:JGJOperMembersListURL parameters:parameters success:^(id responseObject) {
        
        self.memberLists = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.allMemberModels = _memberLists.mutableCopy;
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setMemberLists:(NSArray *)memberLists {
    _memberLists = memberLists;
    
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:memberLists];
    self.contactsLetters = self.sortContactsModel.contactsLetters;
}

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
    
    if (sortContactsModel.sortContacts.count > 0 && self.addMemberVcType == JGJAddAtMemberType && self.workProListModel.can_at_all && ![self.workProListModel.class_type isEqualToString:@"singleChat"]) {
        [self addAtAllMembersHeader];
        
    }else if (sortContactsModel.sortContacts.count == 0) {
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"当前没有可选择的成员"];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    }
    [self.tableView reloadData];
}

#pragma mark - At所有人头部
- (void)addAtAllMembersHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 68.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapHeaderView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAtAllMember)];
    [headerView addGestureRecognizer:tapHeaderView];
    self.tableView.tableHeaderView = headerView;
    UIButton *headButton = [UIButton new];
    [headButton.layer setLayerCornerRadius:JGJCornerRadius];
    headButton.backgroundColor = AppFontEB4E4EColor;
    headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont58Size];
    [headButton setTitle:@"@" forState:UIControlStateNormal];
    [headerView addSubview:headButton];
    [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@50);
        make.centerY.equalTo(headerView.mas_centerY);
        make.leading.equalTo(@(12));
    }];
    
    UILabel *titleLable = [UILabel new];
    titleLable.textColor = AppFont333333Color;
    titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    titleLable.text = @"所有人";
    titleLable.textColor = AppFont666666Color;
    titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    [headerView addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.centerY.equalTo(headButton.mas_centerY);
        make.leading.equalTo(headButton.mas_trailing).mas_offset(12);
    }];
}

#pragma mark - At所有人
- (void)handleAtAllMember {
    JGJSynBillingModel *aTAllModel = [JGJSynBillingModel new];
    aTAllModel.uid = @"all";
    aTAllModel.real_name = @"所有人";
    aTAllModel.full_name = @"所有人";
    aTAllModel.firstLetteter = @"@";
    [self handleSetAdminMember:aTAllModel];
}

#pragma mark - 创建右边索引

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        JGJSetAdministratorCell *cell = tableView.visibleCells[0];
        self.centerShowLetter.text = cell.memberModel.firstLetteter.uppercaseString;
        self.centerShowLetter.hidden = NO;
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

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
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

- (void)initialTopSearchbar {
    
    self.cusSearchBar.searchBarTF.placeholder = @"请输入名字或手机号码查找";
    
    self.cusSearchBar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
    
    self.cusSearchBar.searchBarTF.maxLength = 20;
    
    __weak typeof(self) weakSelf = self;
    
    self.cusSearchBar.searchBarTF.valueDidChange = ^(NSString *value){
        
        if ([NSString isEmpty:value]) {
            
            weakSelf.memberLists = weakSelf.allMemberModels.copy;
            
            [weakSelf.cusSearchBar.searchBarTF resignFirstResponder];
            
            if (weakSelf.statusView) {
                
                [weakSelf.statusView removeFromSuperview];
            }
            
            weakSelf.tableView.tableHeaderView = nil;
            
        }else {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telephone contains %@", value, value];
            
            weakSelf.memberLists = [weakSelf.allMemberModels filteredArrayUsingPredicate:predicate].mutableCopy;
            
            if (weakSelf.memberLists.count == 0) {
                
                if (!weakSelf.statusView) {
                    
                    CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"未搜索到相关内容"];
                    weakSelf.statusView = statusView;
                    
                    statusView.frame = weakSelf.tableView.bounds;
                    
                    statusView.y = 48;
                    
                }
                
                [weakSelf.view addSubview:weakSelf.statusView];
                
            }else {
                
                if (weakSelf.statusView) {
                    
                    [weakSelf.statusView removeFromSuperview];
                }
            }
            
            [weakSelf.tableView reloadData];
        }
        
    };
    
}

@end
