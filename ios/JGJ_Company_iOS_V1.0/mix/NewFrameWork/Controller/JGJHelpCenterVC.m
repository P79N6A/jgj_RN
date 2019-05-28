//
//  JGJHelpCenterVC.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHelpCenterVC.h"
#import "JGJHelpCenterCell.h"
#import "JGJHelpCenterDetailCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

typedef enum : NSUInteger {
    HelpCenterCellType,
    HelpCenterDetailCellType
} JGJHelpCenterType;

@interface JGJHelpCenterVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) JGJHelpCenterType helpCenterType; //根据类型切换cell
@property (nonatomic, strong) NSArray *helpCenterModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JGJHelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadNetData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = 0;
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            count = self.helpCenterModels.count;
        }
            break;
        case HelpCenterDetailCellType: {
            count = 1;
        }
            break;
            
        default:
            break;
    }

    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[section];
            count = helpCenterModel.list.count;
        }
            break;
        case HelpCenterDetailCellType: {
            count = 1;
        }
            break;
            
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            height = [tableView fd_heightForCellWithIdentifier:@"JGJHelpCenterCell" configuration:^(JGJHelpCenterCell  *cell) {
               JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
               JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
                cell.helpCenterListModel = helpCenterListModel;
            }];

        }
            break;
        case HelpCenterDetailCellType: {
           
           height = [tableView fd_heightForCellWithIdentifier:@"JGJHelpCenterDetailCell" configuration:^(JGJHelpCenterDetailCell  *helpCenterDetailCell) {
//               JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
//               JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
               helpCenterDetailCell.helpCenterListModel = self.helpCenterListModel;
            }];
            height = height + 30.0;
        }
            break;
            
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            JGJHelpCenterCell *helpCenterCell = [tableView dequeueReusableCellWithIdentifier:@"JGJHelpCenterCell" forIndexPath:indexPath];;
            JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
            JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
            helpCenterCell.helpCenterListModel = helpCenterListModel;
            cell = helpCenterCell;
            
        }
            break;
        case HelpCenterDetailCellType: {
            JGJHelpCenterDetailCell  *helpCenterDetailCell = [tableView dequeueReusableCellWithIdentifier:@"JGJHelpCenterDetailCell" forIndexPath:indexPath];
//            JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
//            JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
            helpCenterDetailCell.helpCenterListModel = self.helpCenterListModel;
            cell = helpCenterDetailCell;
            
        }
            break;
            
        default:
            break;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            height = 35;
        }
            break;
        case HelpCenterDetailCellType: {
            height = CGFLOAT_MIN;
        }
            break;
            
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    JGJHelpCenterVC *helpCenterDetailVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJHelpCenterDetailVC"];
//    JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
//    JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
//    helpCenterDetailVC.helpCenterListModel = helpCenterListModel;
//    [self.navigationController pushViewController:helpCenterDetailVC animated:YES];
    JGJHelpCenterVC *helpCenterVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJHelpCenterVC"];
    helpCenterVC.helpCenterType = HelpCenterDetailCellType;
    JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[indexPath.section];
    JGJHelpCenterListModel *helpCenterListModel = helpCenterModel.list[indexPath.row];
    helpCenterVC.helpCenterListModel = helpCenterListModel;
    [self.navigationController pushViewController:helpCenterVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.helpCenterType == HelpCenterCellType;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JGJHelpCenterModel *helpCenterModel = self.helpCenterModels[section];
   UIView *headerView = [[UIView alloc] init];
   headerView.backgroundColor = AppFontf1f1f1Color;
   UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.text = helpCenterModel.desc;
   headerTitle.font = [UIFont systemFontOfSize:AppFont30Size];
    headerTitle.textColor = AppFont999999Color;
    [headerView addSubview:headerTitle];
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(headerView);
        make.left.equalTo(@10);
    }];

    switch (self.helpCenterType) {
        case HelpCenterCellType: {
            headerTitle.text = helpCenterModel.desc;
        }
            break;
        case HelpCenterDetailCellType: {
            headerTitle.text = nil;
        }
            break;
            
        default:
            break;
    }
    return headerView;
}

- (void)commonSet {
    switch (self.helpCenterType) {
        case HelpCenterCellType: {
             self.title = @"帮助中心";
        }
            break;
        case HelpCenterDetailCellType: {
             self.title = @"帮助中心详情";
        }
            break;
        default:
            break;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJHelpCenterCell" bundle:nil] forCellReuseIdentifier:@"JGJHelpCenterCell"];
}

- (void)setHelpCenterModels:(NSArray *)helpCenterModels {
    _helpCenterModels = helpCenterModels;
    if (helpCenterModels.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)loadNetData {
    NSDictionary *parameter = @{@"cid" : @4};
    [JLGHttpRequest_AFN PostWithApi:@"v2/helpcenter/helplist"  parameters:parameter success:^(id responseObject) {
       self.helpCenterModels = [JGJHelpCenterModel mj_objectArrayWithKeyValuesArray:responseObject];
    }failure:^(NSError *error) {
        
    }];
}

@end
