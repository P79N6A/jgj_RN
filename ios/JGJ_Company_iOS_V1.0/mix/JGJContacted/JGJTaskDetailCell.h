//
//  JGJTaskDetailCell.h
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJTaskDetailCell;

@protocol JGJTaskDetailCellDelegate <NSObject>

@optional

- (void)taskDetailCell:(JGJTaskDetailCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index;

- (void)taskDetailCell:(JGJTaskDetailCell *)cell  didSelectedUserInfoModel:(JGJQualityDetailReplayListModel *)userInfoModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JGJTaskDetailCell : UICollectionViewCell

@property (nonatomic, weak) id <JGJTaskDetailCellDelegate>delegate;

@property (nonatomic, strong) JGJQualityDetailReplayListModel *listModel;

@end

NS_ASSUME_NONNULL_END
