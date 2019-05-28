//
//  JGJUnreadInfoVc.m
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUnreadInfoVc.h"
#import "TYPhone.h"
#import "UITableViewCell+Extend.h"

#import "JGJPerInfoVc.h"

@interface JGJUnreadInfoVc ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JGJUnreadInfoVc

- (void)setDataSourceArr:(NSMutableArray<ChatMsgList_Read_User_List *> *)dataSourceArr{
    _dataSourceArr = dataSourceArr;
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.dataSourceArr.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (self.dataSourceArr.count == 0) {//没有数据
        cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }else{//有数据
        ChatMsgList_Read_User_List *readedInfo = self.dataSourceArr[indexPath.row];
        
        JGJReadInfoCell *readInfoCell = [JGJReadInfoCell cellWithTableView:tableView];

        readInfoCell.readedInfo = readedInfo;
        cell = readInfoCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMsgList_Read_User_List *readedInfo = self.dataSourceArr[indexPath.row];

    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];

    perInfoVc.jgjChatListModel.uid = readedInfo.uid;
    
    perInfoVc.jgjChatListModel.group_id = readedInfo.uid;
    
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    
    [self.navigationController pushViewController:perInfoVc animated:YES];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        self.view.backgroundColor = AppFontf1f1f1Color;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}


@end
