//
//  JGJProFilterView.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJProFilterView.h"

#import "JGJProFilterCell.h"

#import "UIView+GNUtil.h"

#define AllProDes @"全部项目"

@interface JGJProFilterView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

//首次筛选项目默认选择
@property (nonatomic, assign) BOOL isFirstFilter;

@property (nonatomic, strong) JGJCusNavBar *cusNavBar;

@end

@implementation JGJProFilterView

//@synthesize allPros = _allPros;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
      
        [self initialSubView];
    }

    return self;
    
}

- (void)initialSubView {
    
    [self addSubview:self.cusNavBar];
    
    [self addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
    
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allPros.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJProFilterCell *cell = [JGJProFilterCell cellWithTableView:tableView];
    
    cell.proModel = self.allPros[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JGJRecordWorkPointFilterModel *proModel = self.allPros[indexPath.row];
//
//    if (![NSString isEmpty:proModel.class_type_id] && [proModel.class_type_id isEqualToString:self.selProModel.class_type_id] && !_isFirstFilter) {
//
//        self.lastIndexPath = indexPath;
//
//    }
    
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkPointFilterModel *proModel = self.allPros[indexPath.row];
    
    if (self.proFilterViewBlock) {
        
        self.proFilterViewBlock(proModel);
    }
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if (temp && temp != indexPath) {
        
        JGJRecordWorkPointFilterModel *lastProModel = self.allPros[temp.row];
        
        lastProModel.isSel = NO;
        
//        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    proModel.isSel = YES;
    
    self.lastIndexPath = indexPath;
    
    [self.tableView reloadData];
    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, self.cusNavBar.height, TYGetUIScreenWidth, self.height - self.cusNavBar.height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (void)setAllPros:(NSArray *)allPros {
    
    _allPros = allPros;
    
    NSInteger row = 0;

    for (NSInteger index = 0; index < self.allPros.count; index++) {

        JGJRecordWorkPointFilterModel *proModel = self.allPros[index];

        if ([proModel.class_type_id isEqualToString:self.selProModel.class_type_id] && [proModel.name isEqualToString:self.selProModel.name]) {

            row = index;

            proModel.isSel = YES;

        }else {

             proModel.isSel = NO;
        }

    }

    [self.tableView reloadData];

    self.lastIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
}

- (void)setSelProModel:(JGJRecordWorkPointFilterModel *)selProModel {
    
    _selProModel = selProModel;
    
    NSInteger row = 0;
    
    for (NSInteger index = 0; index < self.allPros.count; index++) {
        
        JGJRecordWorkPointFilterModel *proModel = self.allPros[index];
        
        if ([proModel.class_type_id isEqualToString:self.selProModel.class_type_id]) {
            
            row = index;
            
            proModel.isSel = YES;
            
        }else {
            
            proModel.isSel = NO;
        }
        
    }
    
    [self.tableView reloadData];
    
    self.lastIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.proFilterViewBlock) {
        
        self.proFilterViewBlock(nil);
    }
}

- (JGJCusNavBar *)cusNavBar {
    
    if (!_cusNavBar) {
        
        _cusNavBar = [[JGJCusNavBar alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 40, JGJ_NAV_HEIGHT)];
        
        _cusNavBar.title.text = AllProDes;
        
        TYWeakSelf(self);
        
        //返回按钮按下
        _cusNavBar.backBlock = ^{
          
            if (weakself.backBlock) {

                weakself.backBlock();
            }

        };
        
    }
    
    return _cusNavBar;
}

@end
