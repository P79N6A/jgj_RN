//
//  JGJWorkTplNormalTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJWorkTplNormalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *workHourLable;
@property (strong, nonatomic) IBOutlet UILabel *overLable;
@property (strong, nonatomic) IBOutlet UILabel *salaryLable;
@property (weak, nonatomic) IBOutlet UILabel *oneHourSalaryLabel;

@end