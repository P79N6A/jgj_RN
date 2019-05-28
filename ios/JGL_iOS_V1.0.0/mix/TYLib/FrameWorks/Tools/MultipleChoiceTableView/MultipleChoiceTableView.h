//
//  MultipleChoiceTableView.h
//  MultipleChoiceTableView
//
//  Created by fujin on 15/7/9.
//  Copyright (c) 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MultipleChoiceTableViewDelegate <NSObject>
@optional
/**
 滑动回调
 
 @param index 对应的下标（从1开始）
 */
-(void)scrollChangeToIndex:(NSInteger)index;

/**
 滑动回调
 
 @param index 对应的下标（从1开始）
 */
-(void)scrollEndChangeToIndex:(NSInteger)index;
@end

@interface MultipleChoiceTableView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
/**
 存放对应的内容控制器
 */
@property (nonatomic,strong)NSMutableArray *dataArray;
/**
 delegate
 */
@property (nonatomic,assign)id<MultipleChoiceTableViewDelegate> delegate;
/**
 Initialization
 @return instance
 */
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)contentArray;
/**
 手动选中某个页面
 
 @param index 默认为1（即从1开始）
 */
-(void)selectIndex:(NSInteger)index;

/**
 *  更新是否能够滑动的状态
 */
- (void)updateScrollEnabled;
@end
