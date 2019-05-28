//
//  JGJSumCalendarTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
@protocol sumerCalendardelegate <NSObject>
-(void)sumerCalenderdidScorllpagewithDate:(NSDate *)date;
-(void)sumerCalenderdidSelectdWithDate:(NSDate *)date;
-(void)sumerCalenderdidSelectdWithDateAndGetContent:(NSDate *)date;//获取点击这天的详情

@end
@interface JGJSumCalendarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *closeProHoldView;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic ,assign) BOOL closePro;
@property (nonatomic ,assign) BOOL YONclosePro;

@property (nonatomic ,strong) UIImageView *closeView;
@property (nonatomic ,strong) id<sumerCalendardelegate> delegate;
@property (nonatomic , strong)JGJRainCalenderDetailModel *rainCalenderDetailModel;
@property (nonatomic ,strong)JGJRainCalenderDetailModel *model;
@property (nonatomic , strong)JGJMyWorkCircleProListModel *WorkCicleProListModel;
-(void)reloadDataAccordingDate;//刷新界面
@end
