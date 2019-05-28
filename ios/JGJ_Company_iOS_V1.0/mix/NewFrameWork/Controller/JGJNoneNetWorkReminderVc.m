//
//  JGJNoneNetWorkReminderVc.m
//  JGJCompany
//
//  Created by YJ on 16/11/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNoneNetWorkReminderVc.h"
#import "JGJNoneNetWorkReminderCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface JGJNoneNetWorkReminderVc ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *reminderTitles;//提醒文字
@end

@implementation JGJNoneNetWorkReminderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJNoneNetWorkReminderCell" bundle:nil] forCellReuseIdentifier:@"JGJNoneNetWorkReminderCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reminderTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"JGJNoneNetWorkReminderCell" configuration:^(JGJNoneNetWorkReminderCell * cell) {
        cell.reminderStr = self.reminderTitles[indexPath.row];
    }];

    switch (indexPath.row) {
        case 0:
            height += 15.0;
            break;
        case 1:
            height += 20.0;
            break;
        case 3:
            height += 20.0;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJNoneNetWorkReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGJNoneNetWorkReminderCell" forIndexPath:indexPath];
    cell.reminderTitles = self.reminderTitles;
    cell.reminderStr = self.reminderTitles[indexPath.row];
    return cell;
}

- (NSArray *)reminderTitles {
    if (!_reminderTitles) {
        _reminderTitles = @[@"你的设备未启用移动网络或Wi-Fi", @"如需要连接到互联网，可以参照以下方法：\n在设备的“设置”-“Wi-Fi网络”设置面板中选择一个可用的Wi-Fi热点接入。" ,@"在设备的“设置” - “通用” - “网络” 设置面板中启用蜂窝数据 (启用后运营商可能会收取数据通信费用)",@"如果你已接入Wi-Fi网络：\n请检查你所连接的Wi-Fi热点是否已接入互联网，或该热点是否已允许你的设备访问互联网"];
    }
    return _reminderTitles;
}

@end
