//
//  UITableViewCell+Extend.h
//  Carpenter
//
//  Created by 冯成林 on 15/4/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extend)

//返回一个空的cell
+ (UITableViewCell *)getNilViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/**
 *  注册cell
 *
 *  @param tableView     需要注册的tableview
 *  @param esRowHeight   估算的高
 *  @param protoTypeCell 保存的cell
 */
+ (void)registerNib:(UITableView *)tableView estimateRowHeight:(CGFloat )esRowHeight protoTypeCell:(UITableViewCell *)protoTypeCell;

/**
 *  创建cell
 *
 *  @param tableView 所属tableView
 *
 *  @return cell实例
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithTableViewNotXib:(UITableView *)tableView;
@end
