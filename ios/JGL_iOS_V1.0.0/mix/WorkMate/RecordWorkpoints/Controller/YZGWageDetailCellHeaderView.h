//
//  YZGWageDetailCellHeaderView.h
//  mix
//
//  Created by Tony on 16/3/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWageDetailModel.h"

@interface YZGWageDetailCellHeaderView : UIView
@property (nonatomic,assign) BOOL needFaceDown;//是否朝向下，如果是YES:向下,NO:向右
@property (nonatomic,strong) WageDetailValues *wageDetailValues;
@property (nonatomic, assign) CGFloat maxTotalValue;
@end
