//
//  JGJAdjustSignLocaVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAddSignModel.h"

typedef void(^HandleSelSignModelBlock)(JGJAddSignModel *);

@interface JGJAdjustSignLocaVc : UIViewController

@property (nonatomic,strong) JGJAddSignModel *addSignModel;

@property (nonatomic, copy) HandleSelSignModelBlock handleSelSignModelBlock;

@end
