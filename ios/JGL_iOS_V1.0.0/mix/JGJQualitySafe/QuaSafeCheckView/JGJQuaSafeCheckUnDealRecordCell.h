//
//  JGJQuaSafeCheckUnDealRecordCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJQuaSafeUnDealedResultView.h"

@class JGJQuaSafeCheckUnDealRecordCell;

@protocol JGJQuaSafeCheckUnDealRecordCellDelegate <NSObject>

@optional

- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell selectedListModel:(JGJInspectPlanProInfoDotListModel *)listModel buttonType:(QuaSafeUnDealedResultViewButtonType)buttonType;

- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell;

@end

@interface JGJQuaSafeCheckUnDealRecordCell : UITableViewCell

//@property (nonatomic, strong) JGJQuaSafeCheckRecordListModel *listModel;

@property (nonatomic, weak) id <JGJQuaSafeCheckUnDealRecordCellDelegate> delegate;

@property (strong, nonatomic) UIView *lineView;

@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel *listModel;
@end
