//
//  UITableView+TYSeparatorLine.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "UITableView+TYSeparatorLine.h"

@implementation UITableView (TYSeparatorLine)

//隐藏多余的分割线
+(void)tableViewSetWithTableView:(UITableView *)tableView{
//    [self hiddenExtraCellLine:tableView];
    //tableView 分割线全部显示
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//隐藏tableview没有数据的cell的分割线
+ (void)hiddenExtraCellLine: (UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//tableView 分割线全部显示
+ (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
