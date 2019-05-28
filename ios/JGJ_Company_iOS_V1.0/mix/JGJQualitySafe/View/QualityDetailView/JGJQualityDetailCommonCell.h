//
//  JGJQualityDetailCommonCell.h
//  JGJCompany
//
//  Created by yj on 2017/6/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@class JGJQualityDetailCommonCell;

@protocol JGJQualityDetailCommonCellDelegate <NSObject>

- (void)qualityDetailCommonCell:(JGJQualityDetailCommonCell *)cell;

@end

@interface JGJQualityDetailCommonCell : UITableViewCell

@property (nonatomic, strong) JGJCreatTeamModel *commonModel;

@property (nonatomic, weak) id <JGJQualityDetailCommonCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
