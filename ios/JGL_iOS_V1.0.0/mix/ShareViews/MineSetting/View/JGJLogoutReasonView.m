//
//  JGJLogoutReasonView.m
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutReasonView.h"

#import "JGJLogputReasonCell.h"

#import "JGJCustomLable.h"

@interface JGJLogoutReasonView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGRect currentTextViewRect;

@property (nonatomic, weak) JGJLogoutOtherReasonCell *cell;

@end

@implementation JGJLogoutReasonView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    [self addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJLogoutReasonModel *desModel = self.dataSource[indexPath.row];
    
    if (indexPath.row == self.dataSource.count - 1) {
        
        JGJLogoutOtherReasonCell *cell = [JGJLogoutOtherReasonCell cellWithTableView:tableView];
        
        self.cell = cell;
        
        cell.desModel = desModel;
        
        cell.reasonCellBlock = ^(NSString *text) {
          
            TYLog(@"-=======%@", text);
            
            desModel.des = text;
        };
        
        return cell;
        
    }else {
        
        JGJLogputReasonCell *cell = [JGJLogputReasonCell cellWithTableView:tableView];
        
        cell.desModel = desModel;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataSource.count - 1 == indexPath.row ? 170 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJLogoutReasonModel *desModel = self.dataSource[indexPath.row];
    
    desModel.isSel = !desModel.isSel;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(20, 0, self.width - 40, self.height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontEBEBEBColor;
        
        [_tableView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:10];
        
        _tableView.layer.masksToBounds = YES;
    }
    
    return _tableView;
    
}

+ (CGFloat)logoutReasonViewHeightWithCount:(NSInteger)count {
    
    CGFloat height = [JGJLogputReasonCell cellHeight] * count + [JGJLogoutOtherReasonCell cellHeight];
    
    return height;
}

//- (NSMutableArray *)dataSource {
//    
//    if (!_dataSource) {
//        
//        _dataSource = [NSMutableArray array];
//        
//        NSArray *titles = @[@"想删除记工数据",@"有多个账号,想取消1个", @"改行不用了", @"弄不懂、不好用", @"其他"];
//        
//        for (NSInteger index = 0; index < titles.count; index++) {
//            
//            JGJLogoutReasonModel *desModel = [[JGJLogoutReasonModel alloc] init];
//            
//            desModel.name = titles[index];
//            
//            [_dataSource addObject:desModel];
//        }
//    }
//    
//    return _dataSource;
//}

@end
