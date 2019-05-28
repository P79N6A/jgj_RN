//
//  JGJRecordBillDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGMateWorkitemsModel.h"

@interface JGJRecordBillDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *subDetailLable;
@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsItems;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLableconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLineConstance;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLineConstance;
@end
