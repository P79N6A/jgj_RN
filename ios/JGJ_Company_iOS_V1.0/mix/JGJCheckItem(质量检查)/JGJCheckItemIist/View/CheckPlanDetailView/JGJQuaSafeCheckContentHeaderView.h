//
//  JGJQuaSafeCheckContentHeaderView.h
//  JGJCompany
//
//  Created by yj on 2017/11/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQuaSafeCheckContentHeaderView;

@protocol JGJQuaSafeCheckContentHeaderViewDelegate <NSObject>

@optional

- (void)JGJQuaSafeCheckContentHeaderView:(JGJQuaSafeCheckContentHeaderView *)header checkItemModel:(JGJInspectPlanProInfoContentListModel *)checkItemModel;

@end

@interface JGJQuaSafeCheckContentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) JGJInspectPlanProInfoContentListModel *checkItemModel;

@property (nonatomic, weak) id <JGJQuaSafeCheckContentHeaderViewDelegate> delegate;

+ (instancetype)checkContentHeaderViewWithTableView:(UITableView *)tableView;
@end
