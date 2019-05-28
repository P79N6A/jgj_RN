//
//  JGJSynAddressBookVC.m
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynAddressBookVC.h"
#import "JGJSynAddressBookCell.h"
#import "CFRefreshTableView.h"
#import "TYAddressBook.h"
#import "Searchbar.h"
#import "NSString+Extend.h"
#import "JGJSynBillAddContactsHUBView.h"
#import "JGJSynBillingManageVC.h"
#import "JGJSyncProlistVC.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "CFRefreshStatusView.h"
#import <AddressBook/AddressBook.h>
//-----1.4.5添加
#import "YZGAddContactsTableViewCell.h"
#import "YZGAddForemanAndMateViewController.h"
#import "NSString+Extend.h"
#import "YZGMateReleaseBillViewController.h"

#import "JGJQRecordViewController.h"

#import "JGJInputNamePopView.h"

#import "JGJAddressBookTool.h"

#define RowH 75
#define HeaderH 35
#define Padding 12
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
@interface JGJSynAddressBookVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    JGJSynBillAddContactsHUBViewDelegate,
    DSectionIndexViewDataSource,
    DSectionIndexViewDelegate,
    CFRefreshStatusViewDelegate,
    YZGAddContactsHUBViewDelegate
>
@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarH;
@property (weak, nonatomic) IBOutlet UIView             *contentSearchBarView;

@property (strong, nonatomic) DSectionIndexView            *sectionIndexView;
@property (strong, nonatomic) CFRefreshStatusView          *statusView;
@property (strong, nonatomic) JGJSynBillAddContactsHUBView *addContactsHuBView;
@property (strong, nonatomic) JGJSynBillingModel           *addressBookModel;//存储上传数据模型,同步项目
@property (strong, nonatomic) Searchbar                    *searchBar;
@property (strong, nonatomic) NSArray                      *contactsLetters;//包含首字母
@property (strong, nonatomic) NSMutableDictionary          *sameFirstContactsDic;//便于模型转换
@property (strong, nonatomic) NSMutableArray               *dataSource;
@property (strong, nonatomic) NSMutableArray               *backupsDataSource;//备份数据
@property (strong, nonatomic) NSArray *sortContacts                                 ;//排序后的联系人
@property (strong, nonatomic) UILabel                      *centerShowLetter;
@property (assign, nonatomic) BOOL                         isMoveRightButton;//根据是否显示索引右移按钮
@property (strong, nonatomic) YZGAddContactsHUBView        *addWorkerContactsHUBView; //添加工人的界面 1.4.5添加

@property (strong, nonatomic) JGJInputNamePopView *namePopView;
@end

@implementation JGJSynAddressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton]; //设置返回按钮
    [self commonSet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.tableView headerBegainRefreshing];
}

- (void)commonSet {
    self.title = @"手机通讯录";
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.sectionIndexColor = AppFont999999Color;   //可以改变字体的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];//可以改变索引背景色
    [self.contentSearchBarView addSubview:self.searchBar];
    [self.view addSubview:self.centerShowLetter];
    [self getAddressBook];
    
    //判断通信录是否打开
    [self unfoldAddressBook:nil];
    
    //3.5.0 已去掉
    self.navigationItem.rightBarButtonItem = nil;
    
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YZGAddForemanAndMateViewController class]]) {
            YZGAddForemanAndMateViewController *addForemanAndMateVC = (YZGAddForemanAndMateViewController *)vc;
            addForemanAndMateVC.dataArray = [self.dataArray mutableCopy];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Mark - 获取通信录
- (void)getAddressBook {
    
    NSArray *addressBookArray = [self authorOpenAddressBook];
    
    TYWeakSelf(self);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [TYAddressBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            
            if(isAuthorized)
            {
                TYLog(@"打开了------------------");
                
                [weakself authorOpenAddressBook];
            }
            
        }];
    }
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        if (addressBookArray.count == 0 && self.synBillingModels.count == 0) {
            
            CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc]
                                               initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"当前通讯录还没有数据"];
            statusView.frame = self.view.bounds;
            
            statusView.delegate = self;
            
            //获取手机通讯录
            if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                
                statusView.buttonTitle = @"读取手机通讯录";
                
            }
            
            self.tableView.tableHeaderView = statusView;
        }
    }
    
}

#pragma mark - 打开通信录
- (void)unfoldAddressBook:(NSArray *)addressBookModels {
    
    TYWeakSelf(self);
    
    BOOL isHaveContact = addressBookModels.count > 0 || self.synBillingModels.count > 0;
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized && isHaveContact){
        
        return;
    }
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [TYAddressBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            
            if(isAuthorized)
            {
                TYLog(@"打开了------------------");
                
                [self getAddressBook];
                
            }
            
        }];
    }
    
}

#pragma mark - 授权打开通讯录

- (NSArray *)authorOpenAddressBook {
    
    NSArray *addressBookArray = [TYAddressBook loadAddressBook];
    
    self.dataSource = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:addressBookArray];
    
    self.contentSearchBarH.constant = (addressBookArray.count == 0  && self.synBillingModels.count == 0)? 0 : 48;
    
    self.backupsDataSource = self.dataSource;
    
    [self searchAddressBookWithAddressBookModels:self.dataSource];
    
    return addressBookArray;
}

- (void)searchAddressBookWithAddressBookModels:(NSMutableArray *)addressBookModels {

    [TYLoadingHub showLoadingWithMessage:nil];
//    全部数据
    [self.synBillingModels addObjectsFromArray:self.selelctedModels];
    NSArray *allContacts =  self.synBillingModels.copy;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < allContacts.count; i ++) {
            JGJSynBillingModel *synBillingModel = allContacts[i];
            synBillingModel.isAddedSyn = YES;
            for (int j = 0; j < addressBookModels.count; j ++) {
                JGJSynBillingModel *addressBookModel = addressBookModels[j];
                if ([synBillingModel.telephone isEqualToString:addressBookModel.telph]) {
                    addressBookModel.isAddedSyn = YES;
                    if (![NSString isEmpty:synBillingModel.real_name]) {
                        addressBookModel.name = synBillingModel.real_name;//修改后的名字
                    }
                    [self.synBillingModels removeObject:synBillingModel]; //移除和通信录相同的模型
                }
            }
        }
        [addressBookModels addObjectsFromArray:self.synBillingModels];//剩余数据添加到通信录
        [self getContactsFirstletter:addressBookModels];
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
    });
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    return sortFindResult.findResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSynAddressBookCell *cell = [JGJSynAddressBookCell cellWithTableView:tableView];
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *addressBookModel = sortFindResult.findResult[indexPath.row];
    addressBookModel.isMoveRightButton = self.isMoveRightButton;
    
    cell.searchValue = self.searchBar.text;
    
    cell.addressBookModel = addressBookModel;
    __weak typeof(self) weakSelf = self;
    cell.addSynModelBlock = ^(JGJSynBillingModel *addressBookModel){
        
        if (weakSelf.hubViewType == YZGAddContactsHUBViewDefaultType) {
            
            [weakSelf addOldMemberWithAddressBookModel:addressBookModel];
            
        }else if (weakSelf.addSynModelBlock) {
          
            weakSelf.addSynModelBlock(addressBookModel); //同步人员直接返回3.2.0
            
        }
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *addressBookModel = sortFindResult.findResult[indexPath.row];

    if (self.hubViewType == YZGAddContactsHUBViewDefaultType) {
        
        [self addOldMemberWithAddressBookModel:addressBookModel];
        
    }else if (self.addSynModelBlock) {
        
        self.addSynModelBlock(addressBookModel); //同步人员直接返回3.2.0
        
    }

}

#pragma mark - 老版本添加人员
- (void)addOldMemberWithAddressBookModel:(JGJSynBillingModel *)addressBookModel {
    
    if (_addressBookAddButtonType == AddressBookAddWorkerButton) {
        
        [self clickedAddButtonUploadWorkerBookModel:addressBookModel];
        
    } else {
        
        [self upLoadAddressBookWithAddressBookModel:addressBookModel];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    firstLetterLable.text = sortFindResult.firstLetter.uppercaseString;
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return HeaderH;
}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        JGJSynAddressBookCell *cell = tableView.visibleCells[0];
        self.centerShowLetter.text = cell.addressBookModel.firstLetteter.uppercaseString;
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

#pragma - 同步账单添加通信录信息
- (void)upLoadAddressBookWithAddressBookModel:(JGJSynBillingModel *)addressBookModel {
    NSDictionary *parameters = @{@"realname" : addressBookModel.name ? : [NSNull null],
                                                         @"telph" : addressBookModel.telph ? : [NSNull null],
                                                         @"option" : @"a"};
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/optusersync" parameters:parameters success:^(NSDictionary *responseObject) {
        [TYShowMessage showSuccess:@"添加成功!"];
        [TYLoadingHub hideLoadingView];
        addressBookModel.target_uid = responseObject[@"target_uid"];
        self.addressBookModel = addressBookModel;
        self.addressBookModel.real_name = addressBookModel.name;
//        工资清单进入跳转到同步人联系页面 否则进入同步项目页面
        if (self.synBillingCommonModel.isWageBillingSyn) {
            
            self.addSynModelBlock(addressBookModel);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
        
            JGJSyncProlistVC *syncProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSyncProlistVC"];
            syncProlistVC.synBillingModel = self.addressBookModel;
            [self.navigationController pushViewController:syncProlistVC animated:YES];
        }
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showPlaint:@"添加失败!"];
    }];
}

#pragma - 记一笔添加通信录上传参数
- (void)clickedAddButtonUploadWorkerBookModel:(JGJSynBillingModel *)workerBookModel {
    
    NSString *workerName = workerBookModel.name ?:@"";
    
    NSString *workerTelph = workerBookModel.telph ?:@"";
    
    __block NSDictionary *parameters = @{@"name":workerName,
                                         
                                         @"telph":workerTelph};
    
    if ([NSString containsEmojiStr:workerBookModel.name]) {
        
        JGJInputNamePopView *namePopView = [[JGJInputNamePopView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];

        self.namePopView = namePopView;
        
        namePopView.tel.text = workerBookModel.telph;
        
        TYWeakSelf(self);
        
        namePopView.confirmBlock = ^(JGJInputNamePopView *popView) {
            
            NSString *name = popView.name.text;
            
            parameters = @{@"name":name?:@"",
                           
                           @"telph":workerTelph};
            
            if (![NSString isEmpty:self.workProListModel.group_id]) {
                
                parameters = @{@"name":name?:@"",
                               
                               @"telph":workerTelph?:@"",
                               
                               @"group_id" : weakself.workProListModel.group_id?:@""
                               
                               };
            }
            
            [weakself addAccountUser:parameters];
            
        };
        
    }else {
        
        if (![NSString isEmpty:self.workProListModel.group_id]) {
            
            parameters = @{@"name":workerName?:@"",
                           
                           @"telph":workerTelph?:@"",
                           
                           @"group_id" : self.workProListModel.group_id?:@""
                           
                           };
        }
        
        [self addAccountUser:parameters];
        
    }
        
    
}

- (void)addAccountUser:(NSDictionary *)parameters {
    
    NSString *contractor_type = [NSString isEmpty:self.contractor_type] ? @"0" : @"1";
    
    NSMutableDictionary *dic = @{@"contractor_type" : contractor_type}.mutableCopy;
    
    [dic addEntriesFromDictionary:parameters];
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/add-fm" parameters:dic success:^(id responseObject) {
        
        YZGAddForemanModel *yzgAddForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:responseObject];
        
        [self popToReleaseBillVc:yzgAddForemanModel];
        
    }failure:nil];
    
}

- (void)popToReleaseBillVc:(YZGAddForemanModel *)addForemanModel{

    JGJSynBillingModel *accountMember = [JGJSynBillingModel new];
    
    accountMember.telph = addForemanModel.telph;
    
    accountMember.name = addForemanModel.name;
    
    accountMember.uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    
    if (self.addSynModelBlock) {
        
        self.addSynModelBlock(accountMember);
    }
    
}

- (void)getContactsFirstletter:(NSArray *)contacts {
    self.sortContacts = [JGJAddressBookTool sortContacts:contacts];
}
#pragma Mark - buttonAction 
- (IBAction)newAddSynBillingModel:(UIBarButtonItem *)sender {    
    if (self.addressBookAddButtonType == AddressBookAddWorkerButton) {
        if (!self.addWorkerContactsHUBView.delegate) {
            self.addWorkerContactsHUBView.delegate = self;
        }
        [self.addWorkerContactsHUBView showAddContactsHubView];
        
        self.addWorkerContactsHUBView.hubViewType = self.hubViewType;
        
    } else {
        [self.addContactsHuBView showAddContactsHubView];
    }
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

- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length > 0 && textField.text != nil) {
        
        NSString *lowerSearchText = textField.text.lowercaseString;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or telph contains %@", lowerSearchText, lowerSearchText];
        self.dataSource = [self.backupsDataSource filteredArrayUsingPredicate:predicate].mutableCopy;
        [self getContactsFirstletter:self.dataSource];
        
    } else {
        
        [self getContactsFirstletter:self.backupsDataSource];
    }
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 提交成功以后
- (void)SynBillAddContactsHubSaveSuccess:(JGJSynBillAddContactsHUBView *)contactsView{
    
    if (self.synBillingCommonModel.isWageBillingSyn) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[JGJSynBillingManageVC class]]) {
                JGJSynBillingManageVC *synBillingManageVC  =  ( JGJSynBillingManageVC *)vc;
                //        添加的数据添加到选中
                contactsView.jgjSynBillingModel.isSelected = YES;
                synBillingManageVC.isScroTop = YES;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telph contains %@", contactsView.jgjSynBillingModel.telph];
                NSArray *oldContacts = [self.backupsDataSource filteredArrayUsingPredicate:predicate];
                if (oldContacts.count > 0) {
                     [TYShowMessage showPlaint:@"该联系人已存在!"];
                    return;
                }
                [synBillingManageVC didClickedButtonPressedSelectedSynBillingModel:contactsView.jgjSynBillingModel];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    
        JGJSyncProlistVC *syncProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSyncProlistVC"];
        syncProlistVC.synBillingModel = contactsView.jgjSynBillingModel;
        [self.navigationController pushViewController:syncProlistVC animated:YES];
    }
    
}

#pragma mark - YZGAddContactsHUBViewDelegate 保存了姓名
- (void)AddContactsHubSaveBtcClick:(YZGAddContactsHUBView *)contactsView{

    [self popToReleaseBillVc:contactsView.yzgAddForemanModel];
    
}

#pragma mark - 懒加载
- (JGJSynBillAddContactsHUBView *)addContactsHuBView{
    if (!_addContactsHuBView) {
        _addContactsHuBView = [[JGJSynBillAddContactsHUBView alloc] initWithFrame:TYSetRect(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _addContactsHuBView.delegate = self;
        
        [self.view addSubview:_addContactsHuBView];
    }

    return _addContactsHuBView;
}

- (YZGAddContactsHUBView *)addWorkerContactsHUBView
{
    if (!_addWorkerContactsHUBView) {
        
        _addWorkerContactsHUBView = [[YZGAddContactsHUBView alloc] initWithFrame:self.view.bounds];
        
        _addWorkerContactsHUBView.workProListModel = self.workProListModel;
        
        _addWorkerContactsHUBView.hubViewType = self.hubViewType;
        
    }
    return _addWorkerContactsHUBView;
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
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

#pragma mark - CFRefreshStatusViewDelegate
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
   
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContactsLetters:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}
@end
