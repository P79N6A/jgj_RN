//
//  JGJAddFriendAddressBookVc.m
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendAddressBookVc.h"
#import "JGJAddressBookTool.h"
#import "TYTextField.h"
#import "JGJSearchResultView.h"
#import "CFRefreshStatusView.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "NSString+Extend.h"
#import "JGJAddFriendAddressBookCell.h"
#import "JGJPerInfoVc.h"
#import <AddressBook/AddressBook.h>
#import "TYAddressBook.h"
#import "JGJDataManager.h"

#define RowH 68
#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

@interface JGJAddFriendAddressBookVc ()<
UITableViewDelegate,
UITableViewDataSource,
JGJSearchResultViewdelegate,
DSectionIndexViewDataSource,
DSectionIndexViewDelegate,
JGJSearchResultViewdelegate,
CFRefreshStatusViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) JGJSearchResultView *searchResultView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewH;
@property (strong, nonatomic) JGJAddressBookSortContactsModel *sortContactsModel;
@property (nonatomic, strong) NSMutableArray *sortContacts ;//排序后的联系人
@property (strong, nonatomic) DSectionIndexView            *sectionIndexView;
@property (strong, nonatomic) UILabel *centerShowLetter;
@property (nonatomic, strong) NSMutableArray *contactsLetters;//包含首字母
@property (nonatomic, strong) NSArray *backupSortContacts; //备份排序后数据
//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;
@end

@implementation JGJAddFriendAddressBookVc

- (void)viewDidLoad {
    [super viewDidLoad];
    //    JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool addFriendSortContacts];
    //    self.sortContactsModel = sortContactsModel;
    //    if (sortContactsModel.sortContacts > 0) {
    //        self.contactsLetters = sortContactsModel.contactsLetters;
    //        self.sortContacts = sortContactsModel.sortContacts;
    //        self.backupSortContacts = sortContactsModel.sortContacts.copy;
    //    }else {
    //        [self loadAddressBooksMember];
    //    }
    [self loadAddressBooksMember];
    [self commonInit];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleSearchBarViewMoveDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self handleSearchBarViewMoveDown];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    count = sortFindResult.findResult.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self handleRegisterAddressBookCellWithTableView:tableView indexpath:indexPath];;
    return cell;
}

- (UITableViewCell *)handleRegisterAddressBookCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    JGJAddFriendAddressBookCell *cell = [JGJAddFriendAddressBookCell cellWithTableView:tableView];;
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    cell.contactModel = contactModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = AppFontf1f1f1Color;
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
    firstLetterLable.text = firstLetter ;
    firstLetterLable.textColor = AppFont999999Color;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    [self handleSkipPerInfoVcWithMemberModel:contactModel];
}

#pragma mark - JGJSearchResultView
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedMember:(JGJSynBillingModel *)memberModel {
    [self handleSkipPerInfoVcWithMemberModel:memberModel];
}

- (void)handleSkipPerInfoVcWithMemberModel:(JGJSynBillingModel *)memberModel {
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    if (![memberModel.is_active boolValue]) {
        [TYShowMessage showPlaint:@"TA还没注册吉工宝，不能加为朋友"];
        return;
    }
    
    if ([memberModel.uid isEqualToString:myUid]) {
        [TYShowMessage showPlaint:@"不能添加自己为朋友"];
        return;
    }
    // 设置好友来源为通讯录添加
    [JGJDataManager sharedManager].addFromType = JGJFriendAddFromContacts;

    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    perInfoVc.jgjChatListModel.group_id = memberModel.uid;
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

#pragma mark - 通用设置
- (void)commonInit{
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    //    self.contentSearchBarView.hidden = YES;
    //    self.contentSearchBarViewH.constant = 0;
    //    self.cancelButtonW.constant = 12;
    //    self.cancelButton.hidden = YES;
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
    if ([self.searchBarTF respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = AppFont999999Color;
        self.searchBarTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchBarTF.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        TYLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

- (void)searchValueChange:(NSString *)value {
    [self handleSearchBarMoveTop];
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    self.searchValue = value;
    self.searchResultView.searchValue = value;
    if ([NSString isInputNum:value]) {
        [self searchMemberTelephone:value];
    }else{
        [self searchMemberName:value];
    }
    if ([NSString isEmpty:value]) { //清空之后返回原来的状态
        [self handleSearchBarViewMoveDown];
    }
}

- (JGJSearchResultView *)searchResultView {
    CGFloat searchResultViewY = 64.0;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight}}];
        searchResultView.resultViewType = JGJSearchAddressBookMember;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    
    [self handleSearchBarViewMoveDown];
}

- (void)setSortContacts:(NSMutableArray *)sortContacts {
    _sortContacts = sortContacts;
    if (_sortContacts.count > 0) {
        self.contentSearchBarView.hidden = NO;
        self.contentSearchBarViewH.constant = 48.0;
    }
    [self.tableView reloadData];
}

#pragma mark - 打开通信录
- (void)unfoldAddressBook:(NSArray *)addressBookModels {
    
    NSInteger count = self.sortContactsModel.sortContacts
    .count;
    
    BOOL isHaveContact = addressBookModels.count > 0 || count > 0;
    
    TYWeakSelf(self);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [TYAddressBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            
            if(isAuthorized)
            {
                TYLog(@"打开了------------------");
                
//                [weakself firstOpenAdddressbook];
                
                [TYAddressBook loadAddressBookByHttp];
            }
            
        }];
    }
    
    if (count == 0 && ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
//        [self firstOpenAdddressbook];
        
        [TYAddressBook loadAddressBookByHttp];
    }
    
}

- (void)showDefault:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无联系人"];
        
        statusView.frame = self.view.bounds;
        
        statusView.delegate = self;
        
        self.tableView.tableFooterView = statusView;
        
    }else {
        
        self.tableView.tableFooterView = nil;
        
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
            
            [self saveAddressbookWithSortContactsModel:self.sortContactsModel];
            
            [TYLoadingHub hideLoadingView];
        });
        
    }else {
        
        [TYLoadingHub hideLoadingView];
    }
    
}

#pragma mark - 搜索姓名
- (void)searchMemberName:(NSString *)value {
    self.sortContacts = self.sortContactsModel.sortContacts;
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    if ([NSString isEmpty:value]) {
        self.searchResultView.searchValue = nil;
        self.searchResultView.results = self.backupSortContacts.mutableCopy;
        return;
    }
    NSString *firstLetter = nil;
    if (value.length >= 1) {
        firstLetter = [NSString firstCharactor:[value substringToIndex:1]].uppercaseString;
    }
    if (value.length > 0 && value != nil) {
        NSString *lowerSearchText = value.lowercaseString;
        NSMutableArray *searchSortContacts = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (SortFindResultModel *sortContactModel in self.sortContacts) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or telephone contains %@ or name_pinyin contains %@  or firstLetteter contains %@", value, lowerSearchText, lowerSearchText, lowerSearchText];
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
            self.searchResultView.results = self.sortContacts;
        });
        
        self.sectionIndexView.hidden = YES;
        
    } else {
        self.sortContacts = self.backupSortContacts.mutableCopy;
    }
    [self.tableView reloadData];
}

#pragma mark - 电话号码搜索
- (void)searchMemberTelephone:(NSString *)value {
    self.sortContacts = self.sortContactsModel.sortContacts;
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    if (value.length <= 3) {
        self.searchResultView.searchValue = nil;
        self.searchResultView.results = self.backupSortContacts.mutableCopy;
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (value.length > 0 && value != nil) {
            NSString *lowerSearchText = value.uppercaseString;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",lowerSearchText];
            NSMutableArray *searchContacts = [NSMutableArray array];
            for (SortFindResultModel *sortContactModel in self.sortContacts) {
                NSArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate];
                if (contacts.count > 0) {
                    [searchContacts addObjectsFromArray:contacts];
                }
            }
            self.sortContacts = [JGJAddressBookTool addressBookToolSortContcts:searchContacts].sortContacts;
            self.searchResultView.searchValue = self.searchValue;
            self.searchResultView.results = self.sortContacts;
        } else {
            self.sortContacts = self.backupSortContacts.mutableCopy;
        }
        [self.tableView reloadData];
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
    
    self.sortContacts = self.backupSortContacts.mutableCopy;
    
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    
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

#pragma mark - 获取通讯录成员
- (void)loadAddressBooksMember {
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    NSDictionary *parameters = @{
                                 @"uid" : userId?: @"",
                                 };
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJChatGetMemberTelephoneURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSArray *contacts = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:contacts];
        
        [weakSelf saveAddressbookWithSortContactsModel:sortContactsModel];
        
//        [weakSelf unfoldAddressBook:contacts];
        
        if (contacts.count == 0) {
            
            self.contentSearchBarViewH.constant = 0;
            
            self.contentSearchBarView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)saveAddressbookWithSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    [JGJAddressBookTool archiveSortContactsModel:sortContactsModel contactsPath:JGJAddFreiendAddressBookPath];
    
    self.sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
    
    self.sortContacts = sortContactsModel.sortContacts;
    
    self.backupSortContacts = sortContactsModel.sortContacts.copy;
    
    [self.tableView reloadData];
    
    //是否显示默认数据
    [self showDefault:self.sortContacts];
    
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

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
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

#pragma mark - CFRefreshStatusViewDelegate
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end

