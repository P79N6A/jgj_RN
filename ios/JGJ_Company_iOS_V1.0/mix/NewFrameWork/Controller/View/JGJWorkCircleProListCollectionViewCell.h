//
//  JGJWorkCircleProListCollectionViewCell.h
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CellID = @"JGJWorkCircleProListCollectionViewCell";

@class JGJWorkCircleProListCollectionViewCell;
@protocol JGJWorkCircleProListCollectionViewCellDelegate <NSObject>

- (void)workCircleProListCollectionViewCell:(JGJWorkCircleProListCollectionViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel;

@end
@interface JGJWorkCircleProListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)  JGJWorkCircleMiddleInfoModel *infoModel;

@property (nonatomic, weak) id <JGJWorkCircleProListCollectionViewCellDelegate> delegate;
@end
