//
//  JGJRaincalenderWindTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRaincalenderWindTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *windLable;
@property(nonatomic,strong)JGJRainCalenderDetailModel *calendermodel;

@end
