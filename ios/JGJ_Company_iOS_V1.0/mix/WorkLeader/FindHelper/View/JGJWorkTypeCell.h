//
//  JGJWorkTypeCell.h
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFHLeaderModel.h"

typedef void(^BlockLoadMoreWorktype)();
typedef void(^BlockSelectedtimeModel)(JGJShowTimeModel *);
@interface JGJWorkTypeCell : UICollectionViewCell
@property (nonatomic, strong) FHLeaderWorktype *workTypeModel;
@property (nonatomic, strong) JGJShowTimeModel *timeModel;
@property (nonatomic, copy)   NSString *timeStr;
- (void)setMoreCount:(NSInteger)count indexPath:(NSIndexPath *)indexPath; //设置点击更多展开
@property (nonatomic, copy) BlockLoadMoreWorktype blockLoadMoreWorktype;
@property (nonatomic, copy) BlockSelectedtimeModel blockSelectedtimeModel;
@end
