//
//  JGJRaincalenderWeatherTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRaincalenderWeatherTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weatherLable;
@property(nonatomic,strong)JGJRainCalenderDetailModel *calendermodel;

@end
