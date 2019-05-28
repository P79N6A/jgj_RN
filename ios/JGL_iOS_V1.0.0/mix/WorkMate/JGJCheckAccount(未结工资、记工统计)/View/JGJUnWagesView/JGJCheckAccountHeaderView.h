//
//  JGJCheckAccountHeaderView.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckAccountHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *time;

+ (instancetype)checkAccountHeaderViewWithTableView:(UITableView *)tableView;

@end
