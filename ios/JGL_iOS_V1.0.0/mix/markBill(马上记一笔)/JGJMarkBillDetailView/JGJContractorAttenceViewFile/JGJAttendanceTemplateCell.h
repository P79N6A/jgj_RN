//
//  JGJAttendanceTemplateCell.h
//  mix
//
//  Created by Tony on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@interface JGJAttendanceTemplateCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic, copy) NSArray *titleArr;
@property (strong, nonatomic) YZGGetBillModel *yzgGetBillModel;
@end
