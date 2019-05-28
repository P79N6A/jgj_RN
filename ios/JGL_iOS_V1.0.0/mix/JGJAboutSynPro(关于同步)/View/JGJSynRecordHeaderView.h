//
//  JGJSynRecordHeaderView.h
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSynRecordHeaderView;

@protocol JGJSynRecordHeaderViewDelegate <NSObject>

@optional

- (void)synRecordHeaderView:(JGJSynRecordHeaderView *)headerView;

@end

@interface JGJSynRecordHeaderView : UITableViewHeaderFooterView

+ (instancetype)synRecordHeaderViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <JGJSynRecordHeaderViewDelegate> delegate;

@property (nonatomic, strong) JGJSynedProModel *synedProModel;

@property (nonatomic, weak,readonly) UILabel *desLable;

@property (nonatomic, weak,readonly) UIButton *expandButton;

@end
