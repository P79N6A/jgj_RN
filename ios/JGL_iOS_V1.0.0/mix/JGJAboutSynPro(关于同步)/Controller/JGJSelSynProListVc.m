//
//  JGJSelSynProListVc.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSelSynProListVc.h"

#import "JGJSelSynProListCell.h"

#import "JGJAddProNameVc.h"

#import "TYTextField.h"

#import "JGJCommonButton.h"

#define SearchbarHeight 48

@interface JGJSelSynProListVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJAddProNameVcDelegate,

    UITextFieldDelegate

>

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property(nonatomic ,strong)    NSMutableArray *backUpdataArr;

@property (nonatomic, copy) NSString *searchValue;

@end

@implementation JGJSelSynProListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择项目";
        
    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
    
    rightItemBtn.buttonTitle = @"新建项目";
    
    rightItemBtn.type = JGJCommonCreatProType;
    
    [rightItemBtn addTarget:self action:@selector(addProItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
    
    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.searchbar];
    
    if (self.dataSource.count > 0) {
        
        [self.tableView reloadData];
        
    }else {
        
        [self loadProList];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSelSynProListModel *proModel = self.dataSource[indexPath.row];
    
    if (self.proListVcBlock) {

        self.proListVcBlock(proModel, self.dataSource);
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSelSynProListCell *cell = [JGJSelSynProListCell cellWithTableView:tableView];
    
    cell.searchValue = self.searchValue;
    
    JGJSelSynProListModel *prolistModel = self.dataSource[indexPath.row];
    
    //传进来的项目标识选中
    if (!self.curProModel.isSel && [prolistModel.pid isEqualToString:self.curProModel.pid]) {
        
        prolistModel.isSel = [prolistModel.pid isEqualToString:self.curProModel.pid];
        
    }else {
        
        prolistModel.isSel = NO;
    }
    
    cell.prolistModel = prolistModel;
    
    return cell;
    
}

#pragma mark - 新增项目
- (void)addProItemPressed {
    
    JGJAddProNameVc *addProNameVc = [[JGJAddProNameVc alloc] init];

    addProNameVc.title = @"新建项目";
    
    addProNameVc.delegate = self;
    
    [self.navigationController pushViewController:addProNameVc animated:YES];
}

#pragma mark - JGJAddProNameVcDelegate;

- (void)addProNameVc:(JGJAddProNameVc *)vc requestResponse:(NSDictionary *)requestResponse {
    
    JGJSelSynProListModel *proModel = [JGJSelSynProListModel mj_objectWithKeyValues:requestResponse];
    
    [self addMemberSuccessWithProModel:proModel];
}

- (void)addMemberSuccessWithProModel:(JGJSelSynProListModel *)proModel {
    
    //插入数据
    
    if (self.dataSource.count > 0) {
        
        [self.dataSource insertObject:proModel atIndex:1];
    }else {
        
        [self.dataSource addObject:proModel];
    }
    
    if (self.proListVcBlock) {
        
        self.proListVcBlock(proModel, self.dataSource);
        
    }
    
    [self.navigationController popToViewController:self.popTargetVc animated:YES];
    
//    [self loadProList];
}

- (void)loadProList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    request.requestApi = @"jlworkday/querypro";
    
    request.isOldApi = YES;
    
    request.body = @{@"is_sync" : @"1"}.mutableCopy;
        
    self.tableView.request = request;
    
    [self.tableView loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
        self.dataSource = [JGJSelSynProListModel mj_objectArrayWithKeyValuesArray:self.tableView.dataArray];
        
        return nil;
        
    }];
    
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    //拷贝一份数据搜索用
    self.backUpdataArr = dataSource.mutableCopy;
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"快速搜索关键字";
        
        _searchbar.searchBarTF.delegate = self;
        
        _searchbar.hidden = YES;
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 30;
        
        __weak typeof(self) weakSelf = self;
        
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
            
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_searchbar];
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.equalTo(self.view);
            
            make.height.mas_equalTo(SearchbarHeight);
            
        }];
        
    }
    
    return _searchbar;
    
}

- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pro_name contains %@", lowerSearchText];

    NSMutableArray *dataSource = [self.backUpdataArr  filteredArrayUsingPredicate:predicate].mutableCopy;

    if (![NSString isEmpty:value]) {

        self.dataSource = dataSource;

    } else {

        [self.view endEditing:YES];

        self.dataSource = self.backUpdataArr;

    }

    self.searchValue = value;

    [self.tableView reloadData];
}

@end
