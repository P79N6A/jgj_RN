//
//  JGJMainYearDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMainYearDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *leftTitleLable;

@property (strong, nonatomic) IBOutlet UILabel *leftAmountLable;
@property (strong, nonatomic) IBOutlet UILabel *rightTitleLable;
@property (strong, nonatomic) IBOutlet UILabel *rightAmountLable;

@property (strong, nonatomic)  JGJRecordMonthBillModel *model;

@end
