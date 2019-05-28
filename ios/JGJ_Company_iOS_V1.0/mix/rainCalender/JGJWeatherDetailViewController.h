//
//  JGJWeatherDetailViewController.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJWeatherDetailViewController : UIViewController
@property (nonatomic , strong)UITableView *tableview;
@property (nonatomic , strong)JGJMyWorkCircleProListModel *WorkCicleProListModel;
@property (nonatomic , strong)
JGJRainCalenderDetailModel *rainCalenderDetailModel;

@end
