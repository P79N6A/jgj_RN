//
//  CityMenuView.m
//  mix
//
//  Created by yj on 16/4/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

/**
 *2.0版本选择地点时(创建班组、班组管理)取消全省和全国 isCancelAllProvince
 */

#define CellRowH 40
#define PrivicesTableViewW 130
#define HeaderH 25
#define Padding 12
#import "CityMenuView.h"
#import "TYFMDB.h"
#import "JGJCityCell.h"
#import "JGJProvinceCell.h"
#import "JGJSearchCityCell.h"
#import "Searchbar.h"
#import "CityMenuView.h"
#import "NSString+Extend.h"
typedef enum : NSUInteger {
    privicesType,
    cityType
    
}  SelectedType;

@interface CityMenuView ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSMutableArray *privices;
@property (weak, nonatomic) IBOutlet UITableView *privicesTableView;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTableViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privicesTableViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *citiesTableViewW;

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) SelectedType selectedType;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) id blockCityModel;
@property (strong, nonatomic)  Searchbar *searchBar;
@property (strong, nonatomic) NSArray *searchCities;
@property (strong, nonatomic) NSArray *allCities;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchViewHeight;
@end

@implementation CityMenuView

- (instancetype)initWithFrame:(CGRect)frame cityName:(void (^)(JLGCityModel *))cityModel {
    self = [super initWithFrame:frame];
    if (self) {
     
        [self commonSet];
        self.blockCityModel = cityModel;
    }
    return self;
}

- (void)setIsCancelAllProvince:(BOOL)isCancelAllProvince {
    _isCancelAllProvince = isCancelAllProvince;
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if ([tableView isEqual:self.privicesTableView]) {
        count = self.privices.count;
    }
    
    if ([tableView isEqual:self.citiesTableView]) {
        count = self.cities.count;
    }
    
    if ([tableView isEqual:self.searchTableView]) {
        
        count = self.searchCities.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CellRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [JGJSearchCityCell cellWithTableView:tableView];
    
    if ([tableView isEqual:self.privicesTableView]) {
        JGJProvinceCell *provicesCell = [JGJProvinceCell cellWithTableView:tableView];
        provicesCell.cityModel = self.privices[indexPath.row];
        cell = provicesCell;
    }
    
    if ([tableView isEqual:self.citiesTableView]) {
    
        JGJCityCell *cityCell = [JGJCityCell cellWithTableView:tableView];
        cityCell.cityModel = self.cities[indexPath.row];
        cell = cityCell;
    }

    if ([tableView isEqual:self.searchTableView]) {

        JGJSearchCityCell *searchCityCell = [JGJSearchCityCell cellWithTableView:tableView];
        if (indexPath.row < self.searchCities.count && self.searchCities.count > 0) {
            searchCityCell.cityModel = self.searchCities[indexPath.row];
            cell = searchCityCell;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            searchCityCell.lineView.backgroundColor = (indexPath.row == (self.searchCities.count - 1)) ? [UIColor whiteColor] : AppFontdbdbdbColor;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lineView.hidden = NO;
    JLGCityModel *cityModel = [[JLGCityModel alloc] init];
    NSArray *specialCities = @[@"北京市",@"天津市",@"上海市", @"重庆市"];
    void(^blockCityModel)(JLGCityModel *) = self.blockCityModel;
    if ([tableView isEqual:self.privicesTableView]) {
        JLGCityModel *privoice = self.privices[indexPath.row];
        self.cities = [TYFMDB getCitysByProvince:privoice].mutableCopy;
        if (indexPath.row == 0  && !self.isCancelAllProvince) { //点击查看全国 返回当前城市的编码
            blockCityModel(privoice);
            [self removeFromSuperview];
        }
        if (self.cities.count > 0 && !self.isCancelAllProvince) {
            cityModel = privoice;
//            if (![privoice.city_name isEqualToString:@"北京市" ] && ![privoice.city_name isEqualToString:@"天津市"] && ![privoice.city_name isEqualToString:@"上海市"] && ![privoice.city_name isEqualToString:@"重庆市"]) {
//                [self.cities insertObject:cityModel atIndex:0];
//            }
            if ([specialCities indexOfObject:privoice.city_name] == NSNotFound) {
                [self.cities insertObject:cityModel atIndex:0];
            }
        }
        self.privicesTableViewW.constant = PrivicesTableViewW;
        self.citiesTableViewW.constant = TYGetViewW(self) - PrivicesTableViewW;
        [self.citiesTableView reloadData];
    } else {
        if ([tableView isEqual:self.citiesTableView]) {
            cityModel = self.cities[indexPath.row];
        }
        if ([tableView isEqual:self.searchTableView]) {
            cityModel = self.searchCities[indexPath.row];
        }
        if (self.isCancelAllProvince) { //拼接当前城市的省
            NSString *province_name = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:cityModel.parent_id byColume:@"city_name"];
            BOOL isSameCityName = [province_name isEqualToString:cityModel.city_name];
            cityModel.provinceCityName = [NSString stringWithFormat:@"%@ %@", province_name, !isSameCityName ? cityModel.city_name :@""];
        }
        blockCityModel(cityModel);

    }
}

/** 搜索框的文字发生改变的时候调用 */
- (void)textFieldDidChange:(UITextField *)textField {

    NSString *lowerSearchText = textField.text.lowercaseString;
    NSArray *cities = [JLGCityModel mj_objectArrayWithKeyValuesArray:self.allCities];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city_url.lowercaseString contains %@ or city_name contains %@", lowerSearchText, lowerSearchText];
    self.searchCities = [cities filteredArrayUsingPredicate:predicate];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"city_name" ascending:YES]];
    self.searchCities = [self.searchCities sortedArrayUsingDescriptors:sortDescriptors];
    
    NSArray *sortDescriptorsOther = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"city_url" ascending:YES]];
    self.searchCities = [self.searchCities sortedArrayUsingDescriptors:sortDescriptorsOther];
    NSInteger charLength = textField.text.length > 0 ? 1 : 0;
    NSMutableArray *searchCities = self.searchCities.mutableCopy;
        for (JLGCityModel *cityModel in self.searchCities) {
             NSString *searchLowerCaseString = [lowerSearchText substringToIndex:charLength];
            if (![self isChinese:lowerSearchText]) {
                NSString *lowerCharCityUrl =  [cityModel.city_url substringToIndex:charLength].lowercaseString;
                if (![lowerCharCityUrl isEqualToString:searchLowerCaseString]) {
                    [searchCities removeObject:cityModel];
                }
            }
        }
    self.searchCities = searchCities;
    [self.searchTableView layoutIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        CGFloat searchTableViewH = self.searchCities.count * CellRowH;
        if (searchTableViewH >= TYGetViewH(self) - TYGetMaxY(self.searchBar)) {
            
            self.searchTableViewH.constant = TYGetViewH(self) - TYGetMaxY(self.searchBar);
            self.contentSearchViewHeight.constant = self.searchTableViewH.constant + TYGetViewH(self.searchBar) + 8;
        }else {
            CGFloat height = self.searchCities.count * CellRowH;
            self.searchTableViewH.constant = height;
            self.contentSearchViewHeight.constant = height + TYGetViewH(self.searchBar)  + 8;
        }
        [self.searchTableView layoutIfNeeded];
        [self.searchTableView reloadData];
    }];
    if (self.searchCities.count == 0) {
        self.contentSearchViewHeight.constant = 0;
    }
}

-(BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
}
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self endEditing:YES];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    UITableView *tableView = (UITableView *)scrollView;
    if ([tableView isEqual:self.privicesTableView] || [tableView isEqual:self.citiesTableView]) {
         self.searchTableViewH.constant = 0;
        self.searchBar.text = nil;
        self.contentSearchViewHeight.constant = 0;
    }
}

- (void)scrollViewDidScroll:(UITableView *)tableView {

    CGFloat contentInsetTop = -tableView.contentInset.top;
    if (tableView.contentOffset.y < contentInsetTop) {
        tableView.contentOffset = CGPointMake(0, contentInsetTop);
    }
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"CityMenuView" owner:self options:nil] lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self addSubview:self.searchBar];//搜索框
    self.lineView.hidden = YES;
    self.privicesTableViewW.constant = TYGetViewW(self);
    self.contentSearchView.layer.borderColor = TYColorHex(0Xc9c9c9).CGColor;
    self.contentSearchView.layer.borderWidth = 1;
    self.contentSearchView.layer.cornerRadius = 3;
}

#pragma Mark - 加载城市
- (NSMutableArray *)privices {
    if (!_privices) {
        _privices= [TYFMDB getAllProvince].mutableCopy;
        if (!self.isCancelAllProvince) { //创建班组时取消全国
            JLGCityModel *cityModel = [[JLGCityModel alloc] init];
            cityModel.city_name = @"全国";
            cityModel.is_all_area = @"1";
            NSString *currentCityNo = [TYUserDefaults objectForKey:JLGSelectCityNo]; //查看全国数据时默认传当前城市
            cityModel.city_code = currentCityNo;
            [_privices insertObject:cityModel atIndex:0];
        }
    }
    return _privices;
}

- (NSArray *)allCities {

    if (!_allCities) {
        _allCities = [TYFMDB getAllListCitys];
    }
    return _allCities;
}

- (Searchbar *)searchBar {

    if (!_searchBar) {
        _searchBar = [Searchbar searchBar];
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _searchBar.backgroundColor = TYColorHex(0Xf3f3f3);
        _searchBar.frame = CGRectMake(11, 7, TYGetUIScreenWidth - 22, 33);
        _searchBar.delegate = self;
        [_searchBar setReturnKeyType:UIReturnKeyDone];
    }
    return _searchBar;
}

@end
