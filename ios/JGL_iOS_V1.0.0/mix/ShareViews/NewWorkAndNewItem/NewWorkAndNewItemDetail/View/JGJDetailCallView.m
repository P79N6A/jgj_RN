//
//  JGJDetailCallView.m
//  mix
//
//  Created by yj on 16/6/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJDetailCallView.h"
#import "JGJContactsDetailCallCell.h"
#define HeaderH 59
@interface JGJDetailCallView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
@property (strong, nonatomic) JLGFindProjectModel *jlgFindProjectModel;

@end

@implementation JGJDetailCallView

- (instancetype)initWithFrame:(CGRect)frame findProjectModel:(JLGFindProjectModel *)findProjectModel {

    if (self = [super initWithFrame:frame]) {
        self.jlgFindProjectModel = findProjectModel;
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        [self commonSet];
    }
    return self;
}

#pragma Mark - 常用设置

- (void)commonSet {
     [[[NSBundle mainBundle] loadNibNamed:@"JGJDetailCallView" owner:self options:nil] lastObject];
    self.containView.frame = self.bounds;
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
    [self.tableView.layer setLayerBorderWithColor:[UIColor whiteColor] width:1 radius:5];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.containView];
    NSUInteger count = self.jlgFindProjectModel.contact_info.count;
    if (count > 0) {
        self.tableViewH.constant = count  * RowH + BottomH + HeaderH;
        [self.tableView reloadData];
    }
}

#pragma Mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return RowH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

#pragma Mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJContactsDetailCallCell *cell = [JGJContactsDetailCallCell cellWithTableView:tableView];
    cell.findResultModel = self.jlgFindProjectModel.contact_info[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.jlgFindProjectModel.contact_info.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindResultModel *findResultModel = self.jlgFindProjectModel.contact_info[indexPath.row];
    self.blockContactInfo(findResultModel);
    [self removeFromSuperview];
}

#pragma Mark - 头部标签

- (UIView *)headerView {

    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"请拨打联系人电话";
        title.textColor = AppFont333333Color;
        [_headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headerView);
        }];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setImage:[UIImage imageNamed:@"contact_cancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-5);
            make.top.equalTo(_headerView).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _headerView;
}

#pragma Mark - ButtonAction

- (void)cancelButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
