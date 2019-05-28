//
//  JGJRecrodDetailNoteTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@interface JGJRecrodDetailNoteTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet UILabel *contentLable;

@property (strong, nonatomic) YZGGetBillModel *yzgGetBillModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstance;
@end
