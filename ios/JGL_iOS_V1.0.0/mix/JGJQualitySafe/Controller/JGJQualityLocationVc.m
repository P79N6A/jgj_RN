//
//  JGJQualityLocationVc.m
//  mix
//
//  Created by YJ on 17/6/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityLocationVc.h"

#import "TYTextField.h"

#import "JGJSearchResultView.h"

#import "UIView+Extend.h"

#import "NSString+Extend.h"

#import "JGJPublQualityLocaCell.h"

#import "CFRefreshStatusView.h"

@interface JGJQualityLocationVc () <UITableViewDelegate, UITableViewDataSource, JGJSearchResultViewdelegate>

@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JGJSearchResultView *searchResultView;

@property (strong, nonatomic) NSArray *locations;

@property (strong, nonatomic) JGJQualityLocationModel *selLocationModel;
@end

@implementation JGJQualityLocationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐患部位";
    [self commonInit];
    
    [self loadNetData];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    //当前版本隐藏了TableView，后面要显示打开即可
    self.tableView.hidden = YES;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
}

#pragma mark - 通用设置
- (void)commonInit{
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] init];
    //    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 10;
    searchIcon.height = 10;
    self.searchBarTF.leftView = searchIcon;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        [weakSelf searchValueChange:value];
    };
    
}

- (void)searchValueChange:(NSString *)value {
    
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text contains %@", value];
    NSMutableArray *locations = [self.locations filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.searchValue = value;
    self.searchResultView.results = locations;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJPublQualityLocaCell *localCell = [JGJPublQualityLocaCell cellWithTableView:tableView];
    
    localCell.locationModel = self.locations[indexPath.row];
    
    localCell.lineView.hidden = self.locations.count -1 == indexPath.row;
    
    return localCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityLocationModel *locationModel = self.locations[indexPath.row];
    
    self.selLocationModel = locationModel;
    
    self.searchBarTF.text = locationModel.text;
}

- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedRow:(NSInteger)row {

    JGJQualityLocationModel *locationModel = searchResultView.results[row];
    
    self.selLocationModel = locationModel;
    
    self.searchBarTF.text = locationModel.text;

}

- (void)loadNetData {

    NSDictionary *parameters = @{@"group_id" :self.proListModel.group_id?:@"",
                                 @"class_type": self.proListModel.class_type?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeLocation" parameters:parameters success:^(id responseObject) {
        
        self.locations = [JGJQualityLocationModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
//    NSMutableArray *locations = [NSMutableArray new];
//    for (NSInteger index = 0; index < 10; index ++) {
//        
//        JGJQualityLocationModel *locationModel = [JGJQualityLocationModel new];
//        
//        locationModel.id = [NSString stringWithFormat:@"%@", @(index)];
//        
//        locationModel.text = [NSString stringWithFormat:@"测试位置%@", @(index)];
//        
//        [locations addObject:locationModel];
//    }
//    
//    self.locations = locations;

}



#pragma amrk - 确定按钮按下
- (void)rightItemPressed:(UIBarButtonItem *)item {

    self.selLocationModel.text = self.searchBarTF.text;
    
    if (self.qualityLocationVcBlock) {
        
        self.qualityLocationVcBlock(self, self.selLocationModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)setLocations:(NSArray *)locations {

    _locations = locations;
    
    if (_locations.count == 0) {
        
        [self showDefaultNodataArray:_locations];
    }
    
    [self.tableView reloadData];

}

- (JGJSearchResultView *)searchResultView {

    CGFloat searchResultViewY = 48;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight}}];
        searchResultView.resultViewType = JGJSearchAddressType;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }else {
    
        self.tableView.tableHeaderView = nil;
    }
    
}

- (JGJQualityLocationModel *)selLocationModel {

    if (!_selLocationModel) {
        
        _selLocationModel = [JGJQualityLocationModel new];
    }

    return _selLocationModel;
}

@end
