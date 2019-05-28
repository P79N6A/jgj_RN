//
//  UITableView+TYSeparatorLine.h
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TYSeparatorLine)
//隐藏多余的分割线
+(void)tableViewSetWithTableView:(UITableView *)tableView;

//隐藏tableview没有数据的cell的分割线
+ (void)hiddenExtraCellLine: (UITableView *)tableView;

//tableView 分割线全部显示
+ (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end
