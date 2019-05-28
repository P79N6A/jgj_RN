//
//  JGJContactedAddressBookBaseVc.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJContactedAddressBookCell.h"
@interface JGJContactedAddressBookBaseVc : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//排序后的模型

@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType; //添加人员、和创建群聊

/**
 *  群聊信息添加人员不显示群里面的人根据group_id区分
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

//添加人员时使用。已添加人员也要显示member_list
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

//头部信息
@property (strong, nonatomic) NSMutableArray *headInfos;
////第一段顶部cell的处理
- (UITableViewCell *)handleRegisterAddressBookHeadCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;
//点击第一段
- (void)JGJAddressBookHeadCellWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//第一段行数
- (NSInteger)JGJAddressBookFirstSectionTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//当前cell类型
- (JGJContactedAddressBookCellType)addressBookCellType;
@end
