//
//  JGJCheckProHeaderView.h
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatGroupListModel.h"
@class JGJCheckProHeaderView;

@protocol JGJCheckProHeaderViewDelegate <NSObject>

@optional

- (void)checkProHeaderView:(JGJCheckProHeaderView *)headerView;

@end

@interface JGJCheckProHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) JGJChatGroupListModel *groupModel;

@property (nonatomic, weak) id <JGJCheckProHeaderViewDelegate> delegate;

+ (instancetype)checkProHeaderViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) BOOL isUnflod;// 是否展开
@end
