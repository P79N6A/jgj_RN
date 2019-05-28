//
//  JGJDetailThumbnailCell.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJDetailThumbnailCell;
@protocol JGJDetailThumbnailCellDelegate <NSObject>

-(void)detailThumbnailCell:(JGJDetailThumbnailCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index;

@end

@interface JGJDetailThumbnailCell : UITableViewCell

@property (nonatomic, strong) JGJQualityDetailModel *qualityDetailModel;

@property (nonatomic, weak) id <JGJDetailThumbnailCellDelegate> delegate;

@end
