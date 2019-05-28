//
//  JGJPubQuaSafeCheckHeaderView.h
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJPubQuaSafeCheckHeaderView;
@protocol JGJPubQuaSafeCheckHeaderViewDelegate <NSObject>

@optional

- (void)pubQuaSafeCheckHeaderView:(JGJPubQuaSafeCheckHeaderView *)headerView selectedHeader:(BOOL)isSelectedHeader;

@end

@interface JGJPubQuaSafeCheckHeaderView : UITableViewHeaderFooterView

+ (instancetype)checkProHeaderViewWithTableView:(UITableView *)tableView;

+ (CGFloat)pubQuaSafeCheckHeaderView;

@property (nonatomic, weak) id <JGJPubQuaSafeCheckHeaderViewDelegate> delegate;

@property (nonatomic, weak) UIButton *selButton;

@end
