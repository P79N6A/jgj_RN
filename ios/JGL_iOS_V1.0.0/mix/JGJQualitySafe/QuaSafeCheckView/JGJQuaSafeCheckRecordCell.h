//
//  JGJQuaSafeCheckRecordCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJQuaSafeDealedResultView.h"

@class JGJQuaSafeCheckRecordCell;

@protocol JGJQuaSafeCheckRecordCellDelegate <NSObject>

@optional

//点击按钮类型
- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell selectedListModel:(JGJInspectPlanProInfoDotListModel *)listModel buttonType:(QuaSafeDealResultViewButtonType)buttonType;

//展开刷新列表
- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell;

//点击缩略图
- (void)detailThumbnailCell:(JGJQuaSafeCheckRecordCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index;
@end

@interface JGJQuaSafeCheckRecordCell : UITableViewCell

@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel  *listModel;

@property (nonatomic, weak) id <JGJQuaSafeCheckRecordCellDelegate> delegate;

@property (strong, nonatomic) UIView *lineView;
@end
