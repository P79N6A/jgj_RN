//
//  JGJRecordWorkpointsChangeNewlyIncreasedView.h
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordWorkpointsChangeModel.h"
@protocol JGJRecordWorkpointsChangeNewlyIncreasedViewDelegate <NSObject>

- (void)didSelectedNewlyIncreasedCellWithIndexPath:(NSIndexPath *)indexPath addInfoModel:(JGJAdd_infoChangeModel *)addInfoModel;

@end
@interface JGJRecordWorkpointsChangeNewlyIncreasedView : UIView

@property (nonatomic, strong) JGJRecordWorkpointsChangeModel *changeInfoModel;
@property (nonatomic, weak) id<JGJRecordWorkpointsChangeNewlyIncreasedViewDelegate> newlyIncreasedDelegate;

@end
