//
//  JGJQualityDetailReplyCell.h
//  mix
//
//  Created by yj on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@class JGJQualityDetailReplyCell;

@protocol JGJQualityDetailReplyCellDelegate <NSObject>

@optional

- (void)qualityDetailReplyCell:(JGJQualityDetailReplyCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index;

- (void)qualityDetailReplyCell:(JGJQualityDetailReplyCell *)cell  didSelectedUserInfoModel:(JGJQualityDetailReplayListModel *)userInfoModel;

@end

@interface JGJQualityDetailReplyCell : UITableViewCell

@property (nonatomic, strong) JGJQualityDetailReplayListModel *listModel;

@property (nonatomic, weak) id <JGJQualityDetailReplyCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
