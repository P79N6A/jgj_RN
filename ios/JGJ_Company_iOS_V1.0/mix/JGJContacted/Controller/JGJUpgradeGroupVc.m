//
//  JGJUpgradeGroupVc.m
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUpgradeGroupVc.h"
#import "JGJUpgradeGroupCell.h"
#import "NSString+Extend.h"
@interface JGJUpgradeGroupVc ()<UITableViewDelegate, UITableViewDataSource, JGJUpgradeGroupCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *upgradeGroupModels;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (strong, nonatomic) JGJUpgradeGroupCell *upgradeGroupCell;
@end

@implementation JGJUpgradeGroupVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
//    self.rightItem.enabled = NO;
    self.rightItem.enabled = ![NSString isEmpty:self.nameStr];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upgradeGroupModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCreatTeamModel *upgradeGroupModel = self.upgradeGroupModels[indexPath.row];
    if (indexPath.row == 0) {
        upgradeGroupModel.detailTitle = self.nameStr?:@"";
    }
    JGJUpgradeGroupCell *cell = [JGJUpgradeGroupCell cellWithTableView:tableView];
    self.upgradeGroupCell = cell;
    cell.upgradeGroupModel = upgradeGroupModel;
    cell.delegate = self;
    cell.lineView.hidden = self.upgradeGroupModels.count - 1 == indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [JGJUpgradeGroupCell upgradeGroupCellHeight];
}

#pragma mark - JGJUpgradeGroupCellDelegate
- (void)upgradeGroupCell:(JGJUpgradeGroupCell *)cell upgradeGroupModel:(JGJCreatTeamModel *)upgradeGroupModel {
    if (![NSString isEmpty:upgradeGroupModel.detailTitle]) {
        self.rightItem.title = @"下一步";
        self.rightItem.enabled = YES;
    }else {
//        self.rightItem.title = @"";
        self.rightItem.enabled = NO;
    }
}

- (IBAction)handleRightItemAction:(UIBarButtonItem *)sender {
    if ([NSString isEmpty:self.upgradeGroupCell.upgradeGroupModel.detailTitle]) {
        [TYShowMessage showPlaint:@"请输入项目组名称"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(upgradeGroupVc:upgrageGroupModel:)]) {
        [self.delegate upgradeGroupVc:self upgrageGroupModel:self.upgradeGroupCell.upgradeGroupModel];
    }
}


- (NSMutableArray *)upgradeGroupModels {
    NSArray *titles = @[@"项目组名称:"];
    NSArray *placeholders = @[@"请输入项目组名称"];
    if (!_upgradeGroupModels) {
        _upgradeGroupModels = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.placeholderTitle = placeholders[indx];
            [_upgradeGroupModels addObject:teamModel];
        }
    }
    return _upgradeGroupModels;
}
@end
