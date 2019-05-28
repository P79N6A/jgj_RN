//
//  JGJLogTimePickerView.h
//  JGJCompany
//
//  Created by Tony on 2017/8/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LogTimeBlock)(NSString *date);
typedef NS_ENUM(NSInteger ,JGJLogTimeType){
   LogTimeYearType,
   LogTimeYearAndMonthType,
};
@protocol LogTimeSelectDelegate <NSObject>

- (void)JLGDataPickerSelect:(NSDate *)date;

@end
@interface JGJLogTimePickerView : UIView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *toplable;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *pickerBaseView;
@property (copy, nonatomic)  LogTimeBlock logBlock;
@property (strong, nonatomic)  NSMutableArray *yearArr;
@property (strong, nonatomic)  NSMutableArray *MonthArr;
@property (assign, nonatomic)  JGJLogTimeType logTimeType;
@property (strong, nonatomic)  id <LogTimeSelectDelegate> delegate;
@property (strong, nonatomic)  NSString *timeStr;
@property (strong, nonatomic)  NSString *yearTime;
@property (strong, nonatomic)  NSString *monthTime;
@property (strong, nonatomic)  NSString *oldTime;

+(void)showDatePickerAndSelfview:(UIView *)view adndelegate:(id)delegate timePickerType:(JGJLogTimeType)type andblock:(LogTimeBlock)logBlock andCurrentTime:(NSString *)time;

@end
