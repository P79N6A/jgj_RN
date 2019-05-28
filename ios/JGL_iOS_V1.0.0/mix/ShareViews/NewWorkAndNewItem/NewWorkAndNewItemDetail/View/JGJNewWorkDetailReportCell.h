//
//  JGJNewWorkDetailReportCell.h
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFindProjectModel.h"

typedef void(^BlockReportButtonDidClickedPressed)();
@interface JGJNewWorkDetailReportCell : UITableViewCell
@property (nonatomic, strong) JLGFindProjectModel *jlgFindProjectModel;
@property (nonatomic, copy) BlockReportButtonDidClickedPressed blockReportButtonDidClickedPressed;
@end
