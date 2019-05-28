//
//  JGJAccountShowTypeVc.m
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAccountShowTypeVc.h"

#import "JGJAccountShowTypeCell.h"

@interface JGJAccountShowTypeVc ()

//<UITableViewDelegate, UITableViewDataSource>
//
//@property (nonatomic, strong) UITableView *tableView;
//
//@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJAccountShowTypeView *showTypeView;

@end

@implementation JGJAccountShowTypeVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.showTypeView];
    
    self.showTypeView.selTypeModel = self.selTypeModel;
    
    self.showTypeView.type = self.type;
    
    TYWeakSelf(self);
    
    self.showTypeView.accountShowTypeViewBlock = ^(JGJAccountShowTypeModel *typeModel) {
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
        [TYShowMessage showSuccess:@"切换成功!"];
        
    };
    
//    [self.view addSubview:self.tableView];
    
    self.title = @"记工显示方式";
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    JGJAccountShowTypeCell *cell = [JGJAccountShowTypeCell cellWithTableView:tableView];
//
//    JGJAccountShowTypeModel *typeModel = self.dataSource[indexPath.row];
//
//    typeModel.isSel = typeModel.type == self.selTypeModel.type;
//
//    cell.showTypeModel = typeModel;
//
//    cell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [JGJAccountShowTypeTool saveShowTypeModel:self.dataSource[indexPath.row]];
//
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 50.0;
//}
//
//- (UITableView *)tableView {
//
//    if (!_tableView) {
//
//        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
//
//        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
//
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        _tableView.dataSource = self;
//
//        _tableView.delegate = self;
//
//        _tableView.backgroundColor = AppFontf1f1f1Color;
//
//    }
//
//    return _tableView;
//}
//
//- (NSMutableArray *)dataSource {
//
//    if (!_dataSource) {
//
//        NSArray *titles = @[@"上班按工天、加班按小时", @"按工天", @"按小时"];
//
//        _dataSource = [NSMutableArray array];
//
//        for (NSInteger index = 0; index < titles.count; index++) {
//
//            JGJAccountShowTypeModel *typeModel = [[JGJAccountShowTypeModel alloc] init];
//
//            typeModel.title = titles[index];
//
//            typeModel.type = index;
//
//            [_dataSource addObject:typeModel];
//        }
//    }
//
//    return _dataSource;
//}

- (JGJAccountShowTypeView *)showTypeView {
    
    if (!_showTypeView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _showTypeView = [[JGJAccountShowTypeView alloc] initWithFrame:rect];
        
    }
    
    return _showTypeView;
}

@end
