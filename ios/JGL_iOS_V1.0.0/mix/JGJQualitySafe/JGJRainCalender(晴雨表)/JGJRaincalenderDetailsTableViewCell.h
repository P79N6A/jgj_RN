//
//  JGJRaincalenderDetailsTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRaincalenderDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property(nonatomic,strong)JGJRainCalenderDetailModel *calendermodel;
@property (strong, nonatomic) IBOutlet UILabel *departLable;

@end
