//
//  JGJPeopleIsOpenReconciliationFunctionViewController.m
//  mix
//
//  Created by Tony on 2019/2/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJPeopleIsOpenReconciliationFunctionViewController.h"
#import "JGJPeopleIsOpenReconciliationListCell.h"
#import "JGJAddressBookTool.h"
#import "JGJSurePoorbillViewController.h"
#import "JGJCustomShareMenuView.h"
#import "TYTextField.h"
#import "YZGNoWorkitemsView.h"
@interface JGJPeopleIsOpenReconciliationFunctionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    JGJPeopleIsOpenReconciliationListCell *_cell;
}

@property (nonatomic, strong) UITableView *peopleList;
@property (nonatomic, strong) NSArray *peopleListArray;

@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;
@property (nonatomic, strong) JGJCustomSearchBar *searchbar;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@end

@implementation JGJPeopleIsOpenReconciliationFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontEBEBEBColor;
    self.title = @"开启对账详情";
    [self initializeAppearance];
    self.searchValue = @"";
    [self getPeopleList];
}

- (void)getPeopleList {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-workday-partner-list" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        self.peopleListArray = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:self.peopleListArray];
        
        if (self.peopleListArray.count == 0) {
            
            [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.height.mas_equalTo(0);
            }];
            
            _searchbar.hidden = YES;
            
            [self.view addSubview:self.yzgNoWorkitemsView];
        }
        
        [self.peopleList reloadData];
        
    } failure:^(NSError *error) {
    
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.peopleList];
    [self.view addSubview:self.searchbar];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        
        make.height.mas_equalTo(SearchbarHeight);
        
    }];
    
    [_peopleList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_searchbar.mas_bottom).offset(0);
        make.bottom.mas_equalTo(-JGJ_IphoneX_BarHeight);
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortContactsModel.sortContacts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SortFindResultModel *sortSectionModel = self.sortContactsModel.sortContacts[section];
    return sortSectionModel.findResult.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [JGJPeopleIsOpenReconciliationListCell cellWithTableViewNotXib:tableView];
    
    SortFindResultModel *sortSectionModel = self.sortContactsModel.sortContacts[indexPath.section];
    _cell.model = sortSectionModel.findResult[indexPath.row];
    _cell.searchValue = self.searchValue;
    
    TYWeakSelf(self);
    _cell.makeReconciliation = ^(NSString *uid) {
      
        JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
        
        poorBillVC.uid = uid;
        
        [weakself.navigationController pushViewController:poorBillVC animated:YES];
    };
    
    _cell.makeTelPhoneOrShare = ^(BOOL isTakePhone,NSString *telphone) {
    
        if (isTakePhone) {// 打电话
            
            NSString * str = [NSString stringWithFormat:@"tel:%@",telphone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }else {//分享邀请
            
            [weakself shareAccountInfo];
        }
    };
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 32)];
    view.backgroundColor = AppFontEBEBEBColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 15, 12)];
    label.font = FONT(AppFont28Size);
    label.textColor = AppFontccccccColor;
    label.text = self.sortContactsModel.contactsLetters[section];
    
    [view addSubview:label];
    

    return view;
}


#pragma mark - 分享记账信息
- (void)shareAccountInfo {
    
    JGJShowShareMenuModel *shareModel = [[JGJShowShareMenuModel alloc] init];
    
    shareModel.title = @"记工账本怕丢失？吉工家手机记工更安全！用吉工家记工，账本永不丢失！";
    
    shareModel.describe = @"1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！";
    
    JGJWXMiniModel *wxMiniModel = [JGJWXMiniModel new];
    
    wxMiniModel.appId = @"gh_89054fe67201";
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSString *path = [NSString stringWithFormat:@"pages/work/index?suid=%@",uid];
    
    wxMiniModel.path = path;
    
    shareModel.url = [NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person",JGJWebDiscoverURL, uid];
    
    wxMiniModel.wxMiniImage = [UIImage imageNamed:@"share_wxMini_account_icon"];
    
    shareModel.imgUrl = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, @"media/default_imgs/logo.jpg"];
    
    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];

    shareMenuView.Vc = self;

    shareMenuView.shareMenuModel = shareModel;

    shareModel.wxMini = wxMiniModel;

    [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
    
}

- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telephone contains %@", lowerSearchText, lowerSearchText];
    
    NSArray *dataSource = [self.peopleListArray  filteredArrayUsingPredicate:predicate].mutableCopy;

    if (![NSString isEmpty:value]) {

        [self sortAccountMemberWithMembers:dataSource];

    } else {

        self.searchbar.searchBarTF.text = nil;

        [self sortAccountMemberWithMembers:self.peopleListArray];

    }

    self.searchValue = value;

    [self.peopleList reloadData];
}

- (void)sortAccountMemberWithMembers:(NSArray *)members {
    
    JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:members];
    
    self.sortContactsModel = sortContactsModel;
    
    if (self.sortContactsModel.sortContacts.count == 0) {
        
        self.yzgNoWorkitemsView.frame = CGRectMake(0, 48, TYGetUIScreenWidth, TYGetUIScreenHeight - 48);
        [self.view addSubview:self.yzgNoWorkitemsView];
        
    }else {
        
        [self.yzgNoWorkitemsView removeFromSuperview];
        [self.peopleList reloadData];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (UITableView *)peopleList {
    
    if (!_peopleList) {
        
        _peopleList = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _peopleList.delegate = self;
        _peopleList.dataSource = self;
        _peopleList.tableFooterView = [[UIView alloc] init];
        _peopleList.rowHeight = 78;
        _peopleList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _peopleList.backgroundColor = AppFontEBEBEBColor;
    }
    return _peopleList;
}

- (NSArray *)peopleListArray {
    
    if (!_peopleListArray) {
        
        _peopleListArray = [[NSArray alloc] init];
    }
    return _peopleListArray;
}

- (JGJAddressBookSortContactsModel *)sortContactsModel {
    
    if (!_sortContactsModel) {
        
        _sortContactsModel = [[JGJAddressBookSortContactsModel alloc] init];
    }
    return _sortContactsModel;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"请输入姓名或手机号码查找";
        
        _searchbar.searchBarTF.delegate = self;
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 11;
        
        __weak typeof(self) weakSelf = self;
        
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
            
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _searchbar;
    
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, self.view.frame.size.height)];
        _yzgNoWorkitemsView.departLable.hidden = YES;
        // 暂无需要你对账的记工 对账完成的记工可去记工流水查看详情
        NSString *firstString = [NSString stringWithFormat:@"   暂无记录哦~"];
        _yzgNoWorkitemsView.contentView.backgroundColor = [UIColor whiteColor];
        
        [_yzgNoWorkitemsView setContentStr:firstString];
        [_yzgNoWorkitemsView setButtonShow:YES];
        _yzgNoWorkitemsView.noRecordButton.hidden = YES;
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}

@end
