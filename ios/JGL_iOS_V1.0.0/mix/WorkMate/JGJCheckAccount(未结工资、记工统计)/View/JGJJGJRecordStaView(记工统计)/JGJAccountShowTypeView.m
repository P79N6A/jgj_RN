//
//  JGJAccountShowTypeView.m
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAccountShowTypeView.h"

#import "JGJAccountShowTypeCell.h"

#import "JGJTabPaddingView.h"

@interface JGJAccountShowTypeView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JGJAccountShowTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAccountShowTypeCell *cell = [JGJAccountShowTypeCell cellWithTableView:tableView];
    
    JGJAccountShowTypeModel *typeModel = self.dataSource[indexPath.row];
    
    typeModel.isSel = typeModel.type == self.selTypeModel.type;
    
    cell.showTypeModel = typeModel;
    
    cell.topLineView.hidden = indexPath.row != 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAccountShowTypeModel *typeModel = self.dataSource[indexPath.row];
    
    switch (self.type) {
            
        case JGJAccountShowTypeViewDefaultType:{
            
            //保存数据
            [JGJAccountShowTypeTool saveShowTypeModel:typeModel];
        }
            
            break;
            
        case JGJAccountShowTypeViewStaType:{
            

        }
            
            break;
            
        default:
            break;
    }
    
    if (self.accountShowTypeViewBlock) {
        
        self.accountShowTypeViewBlock(typeModel);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self cellHeight];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGFloat height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT;
        
        CGRect rect = CGRectMake(0, 10, TYGetUIScreenWidth, height - 10);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
        NSArray *titles = [self titles];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJAccountShowTypeModel *typeModel = [[JGJAccountShowTypeModel alloc] init];
            
            typeModel.title = titles[index];
            
            typeModel.type = index;
            
            [_dataSource addObject:typeModel];
        }
    }
    
    return _dataSource;
}

- (NSArray *)titles {
    
    NSArray *titles = nil;
    
    switch (self.type) {
        case JGJAccountShowTypeViewDefaultType:{
            
            titles = JGJShowTypes;
        }

            break;
            
        case JGJAccountShowTypeViewStaType:{
            
            titles = @[@"按天统计", @"按月统计"];
        }
            
            break;
            
        default:
            break;
    }
    
    
    return titles;
}

- (void)setSelTypeModel:(JGJAccountShowTypeModel *)selTypeModel {
    
    _selTypeModel = selTypeModel;
    
    [self.tableView reloadData];
}

- (void)setType:(JGJAccountShowTypeViewType)type {
    
    _type = type;
    
    if (type == JGJAccountShowTypeViewStaType) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        CGFloat height = [self titles].count * [self cellHeight];
                
        self.tableView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, height);
        
        self.tableView.scrollEnabled = NO;
    }

}

- (CGFloat)cellHeight {
    
    CGFloat height = 50;
    
    switch (self.type) {
        case JGJAccountShowTypeViewDefaultType:{
            
            height = 50;
        }
            
            break;
            
        case JGJAccountShowTypeViewStaType:{
            
            height = 50;
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //返回关闭页面旋转箭头
    if (self.accountShowTypeViewBlock) {
        
        self.accountShowTypeViewBlock(self.selTypeModel);
    }
    
    [self dismiss];
}

@end
