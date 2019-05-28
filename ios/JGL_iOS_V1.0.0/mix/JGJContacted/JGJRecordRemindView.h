//
//  JGJRecordRemindView.h
//  mix
//
//  Created by Tony on 2017/6/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordRemindView : UIView
@property (strong, nonatomic) IBOutlet UILabel *workTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *hourWorkLable;
@property (strong, nonatomic) IBOutlet UILabel *overWorkLable;
@property (strong, nonatomic) IBOutlet UILabel *billLable;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *thridView;
@property (strong, nonatomic) IBOutlet UILabel *first_up_lable;
@property (strong, nonatomic) IBOutlet UILabel *first_down_lable;
@property (strong, nonatomic) IBOutlet UILabel *second_up_lable;
@property (strong, nonatomic) IBOutlet UILabel *second_down_lable;
@property (strong, nonatomic) IBOutlet UILabel *third_lable;
@property (assign, nonatomic)  BOOL oneLine;

@end
