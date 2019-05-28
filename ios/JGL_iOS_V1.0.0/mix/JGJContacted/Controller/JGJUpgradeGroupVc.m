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
@property (strong,nonatomic) JGJCreatTeamModel *upgrageGroupModel;
@end

@implementation JGJUpgradeGroupVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
//    self.rightItem.title = @"";
    self.rightItem.enabled = NO;
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
    upgradeGroupModel.indexPath = indexPath;
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
    if (upgradeGroupModel.indexPath.row == 0) {
        self.upgradeGroupModels[0] = upgradeGroupModel;
    }
    if (upgradeGroupModel.indexPath.row == 1) {
        self.upgradeGroupModels[1] = upgradeGroupModel;
    }
    JGJCreatTeamModel *upgradeGroupProNameModel = self.upgradeGroupModels[0];
    JGJCreatTeamModel *upgradeGroupGroupNameModel = self.upgradeGroupModels[1];
    self.upgrageGroupModel.pro_name = upgradeGroupProNameModel.pro_name;
    self.upgrageGroupModel.group_name = upgradeGroupGroupNameModel.group_name;
    BOOL isEmpty = ![NSString isEmpty:self.upgrageGroupModel.pro_name] && ![NSString isEmpty:self.upgrageGroupModel.group_name];
    if (isEmpty) {
        self.rightItem.title = @"下一步";
        self.rightItem.enabled = YES;
    }else {
//        self.rightItem.title = @"";
        self.rightItem.enabled = NO;
    }
}

- (IBAction)handleRightItemAction:(UIBarButtonItem *)sender {
    if ([NSString isEmpty:self.upgrageGroupModel.pro_name]) {
        [TYShowMessage showPlaint:@"请输入所在项目名称"];
        return;
    }
    if ([NSString isEmpty:self.upgrageGroupModel.group_name]) {
        [TYShowMessage showPlaint:@"请输入班组名称"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(upgradeGroupVc:upgrageGroupModel:)]) {
        [self.delegate upgradeGroupVc:self upgrageGroupModel:self.upgrageGroupModel];
    }
}


- (NSMutableArray *)upgradeGroupModels {
    NSArray *titles = @[@"所在项目:", @"班组名称:"];
    NSArray *placeholders = @[@"请输入所在项目名称",@"请输入班组名称"];
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

- (JGJCreatTeamModel *)upgrageGroupModel {

    if (!_upgrageGroupModel) {
        _upgrageGroupModel = [JGJCreatTeamModel new];
    }
    return _upgrageGroupModel;
}
@end
