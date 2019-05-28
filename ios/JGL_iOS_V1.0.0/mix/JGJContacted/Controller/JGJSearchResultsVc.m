//
//  JGJSearchResultsVc.m
//  JGJCompany
//
//  Created by YJ on 16/12/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSearchResultsVc.h"

@interface JGJSearchResultsVc ()<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray *searchDataSource; // 根据searchController搜索的城市
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JGJSearchResultsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSMutableArray *)searchDataSource
{
    if (_searchDataSource == nil) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.searchDataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"%@", [NSThread currentThread]);
    [self.searchDataSource removeAllObjects];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchController.searchBar.text];
    self.searchDataSource = [[self.dataSource filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", self.searchDataSource[indexPath.row]);
}
@end
