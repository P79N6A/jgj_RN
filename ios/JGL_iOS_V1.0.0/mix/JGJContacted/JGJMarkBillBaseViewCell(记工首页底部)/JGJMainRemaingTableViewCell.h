//
//  JGJMainRemaingTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMainRemaingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *amountLable;
@property (strong, nonatomic)  JGJRecordMonthBillModel *model;

@end
