//
//  JGJWorkReportTypeView.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSUInteger, workReportType) {
//    JGJWorkReportTypeDay,
//    JGJWorkReportTypeWeek,
//    JGJWorkReportTypemonth
//};
@protocol clickWorkReportButtonDelegate <NSObject>
-(void)tapTopButtonWithTag:(NSInteger)workType;

@end
@interface JGJWorkReportTypeView : UIView
@property (strong, nonatomic) IBOutlet UIButton *daySbutton;
@property (strong, nonatomic) IBOutlet UIButton *weekSbutton;
@property (strong, nonatomic) IBOutlet UIButton *monthSbutton;
@property (strong, nonatomic) IBOutlet UILabel *moveLable;
@property (strong, nonatomic)  UILabel *NmoveLable;
@property (strong, nonatomic)  UILabel *departLable;

@property (strong, nonatomic)  id<clickWorkReportButtonDelegate> delegate;

@end
