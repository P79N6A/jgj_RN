//
//  JGJBlackListVc.h
//  mix
//
//  Created by YJ on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JGJBlackListVc : UIViewController
- (void)JGJBlackListVcTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)JGJRegisterTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray *blackListModels;
@property (nonatomic, strong, readonly) JGJAddressBookSortContactsModel *sortContactsModel;//排序后的数据模型
@end
