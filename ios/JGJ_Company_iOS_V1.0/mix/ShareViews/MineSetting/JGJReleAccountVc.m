//
//  JGJReleAccountVc.m
//  mix
//
//  Created by yj on 2018/12/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJReleAccountVc.h"

#import "JGJComImageTitleCell.h"

#import "JGJMineSettingVc+WXLoginService.h"

@interface JGJReleAccountVc ()

@end

@implementation JGJReleAccountVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self getWXStatus];
//    //获取微信登录状态
//    [self requestWxLogionStatus];
    
    self.title = @"关联账号";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.tableHeaderView = lineView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
    [self setLogionStatus];
}

- (void)rightBarButtonItemPressed {
    
    
}

- (void)getWXStatus {
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    JGJComImageTitleCell *cell = [JGJComImageTitleCell cellWithTableView:tableView];
    
    self.infoModel.workerIcon = @"wx_login_icon";
    
    cell.infoModel = self.infoModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self handleBindWX];
}

- (void)setLogionStatus {
    
    self.infoModel.detailTitle = [self.userInfo.is_bind isEqualToString:@"1"] ? @"已关联" : @"未关联";
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
