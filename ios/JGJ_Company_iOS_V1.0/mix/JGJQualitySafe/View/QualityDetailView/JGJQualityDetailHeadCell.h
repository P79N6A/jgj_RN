//
//  JGJQualityDetailHeadCell.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQualityDetailHeadCell;

@protocol JGJQualityDetailHeadCellDelegate <NSObject>

@optional

- (void)qualityDetailHeadCell:(JGJQualityDetailHeadCell *)cell didSelectedHeadButtonType:(JGJQualityDetailStatusButtonType)buttonType;

@end

typedef void(^QualityDetailHeadStatusBlock)(JGJQualityDetailHeadCell *);

@interface JGJQualityDetailHeadCell : UITableViewCell

@property (nonatomic, strong) JGJQualityDetailModel *qualityDetailModel;

@property (nonatomic, assign) JGJQualityDetailStatusButtonType statusButtonType;

@property (nonatomic, copy) QualityDetailHeadStatusBlock qualityDetailHeadStatusBlock;

@property (nonatomic, weak) id <JGJQualityDetailHeadCellDelegate> delegate;

@end
