//
//  JGJContractorListAttendanceTemplateController.h
//  mix
//
//  Created by Tony on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//  包工记考勤 考勤模板

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJMorePeopleViewController.h"
typedef void(^ChoiceAttendanceTemplate) (YZGGetBillModel *yzgGetBillModel);

@interface JGJContractorListAttendanceTemplateController : UIViewController

@property (strong, nonatomic) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic, copy) ChoiceAttendanceTemplate attendanceTemplate;

@property (nonatomic, strong) JGJMorePeopleViewController *targVC;

@end
