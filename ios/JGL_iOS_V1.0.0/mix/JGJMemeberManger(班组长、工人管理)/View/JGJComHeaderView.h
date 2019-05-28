//
//  JGJComHeaderView.h
//  mix
//
//  Created by yj on 2018/11/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJComHeaderView;

@protocol JGJComHeaderViewDelegate <NSObject>

@optional

- (void)headerView:(JGJComHeaderView *)headerView isAllSel:(BOOL)isAllSel;

@end

@interface JGJComHeaderView : UIView

@property (weak, nonatomic) id <JGJComHeaderViewDelegate> delegate;

//当前是否显示全选按钮

@property (assign, nonatomic) BOOL isShowAllSelBtn;

@property (copy, nonatomic) NSString *title;

//选择的人数
@property (copy, nonatomic) NSString *count;

@property (weak, nonatomic, readonly) IBOutlet UIButton *selBtn;

@end
