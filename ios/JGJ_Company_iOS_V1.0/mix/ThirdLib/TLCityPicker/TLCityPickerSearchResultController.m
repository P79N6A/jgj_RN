//
//  TLCityPickerSearchResultController.m
//  TLCityPickerDemo
//
//  Created by 李伯坤 on 15/11/5.
//  Copyright © 2015年 李伯坤. All rights reserved.
//

#import "TLCityPickerSearchResultController.h"
#import "TLCity.h"
#import "UITableView+TYSeparatorLine.h"

@interface TLCityPickerSearchResultController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

//Tony修改过的地方
#define TLCityPickerSearchResultTableViewT (64 + 44)
@implementation TLCityPickerSearchResultController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView setFrame:CGRectMake(0, TLCityPickerSearchResultTableViewT, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - TLCityPickerSearchResultTableViewT)];
    
    //自己修改的，避免出现布局有问题的情况
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UITableView hiddenExtraCellLine:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    TLCity *city =  [self.data objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TLCity *city = [self.data objectAtIndex:indexPath.row];
    if (_searchResultDelegate && [_searchResultDelegate respondsToSelector:@selector(searchResultControllerDidSelectCity:)]) {
        [_searchResultDelegate searchResultControllerDidSelectCity:city];
    }
}


#pragma mark - UISearchResultsUpdating
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    [self.data removeAllObjects];
    for (TLCity *city in self.cityData){
        TYLog(@"city.cityName = %@,city.pinyin = %@,city.initials = %@,searchText = %@",city.cityName,city.pinyin,city.initials,searchText);
        if ([city.cityName containsString:searchText] || [city.pinyin containsString:searchText] || [city.initials containsString:searchText]) {
            [self.data addObject:city];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Getter
- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

@end
