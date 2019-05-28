//
//  JGJPoorBillWorkTimeTableViewCell.h
//  mix
//
//  Created by Tony on 2017/10/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJPoorBillWorkTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *centerLable;
@property (strong, nonatomic) IBOutlet UILabel *subLable;
@property (strong, nonatomic) IBOutlet UILabel *lineLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerTitleComstance;

@end
