//
//  JGJSumdetailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSumdetailTableViewCell : UITableViewCell
@property (nonatomic ,strong)JGJRainCalenderDetailModel *model;
@property (strong, nonatomic) IBOutlet UILabel *rainLable;
@property (strong, nonatomic) IBOutlet UILabel *tempLable;
@property (strong, nonatomic) IBOutlet UILabel *windLable;

@end
