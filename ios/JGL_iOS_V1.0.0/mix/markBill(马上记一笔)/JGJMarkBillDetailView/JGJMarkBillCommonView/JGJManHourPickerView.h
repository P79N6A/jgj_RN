//
//  JGJManHourPickerView.h
//  mix
//
//  Created by Tony on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJManHourPickerHalfOrOneSelectedView.h"

typedef enum: NSUInteger{
    JGJManhourOnelineType,//一列
    JGJManhourTwolineType,//两列
}JGJManhourType;
typedef enum: NSUInteger{
    JGJManhourOneHalfType,//以0.5为跨度
    JGJManhouintType,//以1为跨度
}JGJhourHalfType;

@protocol JGJManHourPickerViewDelegate <NSObject>

@optional
- (void)selectManHourTime:(NSString *)Manhour andOverHour:(NSString *)overTime;//返回上班时间和加班时间
- (void)selectManHourTime:(NSString *)Manhour;//返回上班时间

- (void)selectOverHour:(NSString *)overTime;//返回加班时间

- (void)manHourViewSelectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime;
@end
@interface JGJManHourPickerView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIPickerView *JGJPickerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;
@property (strong, nonatomic) IBOutlet UIView *cancelBtn;
@property (strong, nonatomic) IBOutlet UIView *pickerBaseView;

@property (strong, nonatomic) IBOutlet UIView *sureBtn;
@property (strong, nonatomic) IBOutlet UIView *titleLable;
@property (assign, nonatomic)  JGJManhourType manHourType;
@property (assign, nonatomic)  JGJhourHalfType hourHalfType;
@property (strong, nonatomic)  NSMutableArray *oneLineArr;
@property (strong, nonatomic)  NSMutableArray *twoLineArr;
@property (strong, nonatomic)  id <JGJManHourPickerViewDelegate> delegate;
@property (strong, nonatomic)  NSString *manHourStr;
@property (strong, nonatomic)  NSString *overTimeStr;
@property (assign, nonatomic)  float nowManTime;//现在的已经选择的时间用于默认选中多少行
@property (assign, nonatomic)  float nowOverTime;//现在的已经选择的时间用于默认选中多少行

@property (assign, nonatomic)  BOOL isManHourTime;//是不是返回加班时间
@property (assign, nonatomic)  BOOL noShowRest;//是否显示休息无加班 用于设置薪资模板
@property (nonatomic, assign) BOOL isShowHalfOrOneSelectedView;// 是否显示 休息/无加班 半个工  一个工 的界面

@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (weak, nonatomic) IBOutlet JGJManHourPickerHalfOrOneSelectedView *halfOrOneSelectedView;

+ (void)showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType  andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isShowHalfOrOneSelectedView:(BOOL)isShowHalfOrOneSelectedView;

// 包工进入选择考勤模块增加
+ (void)showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType  andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isContractType:(BOOL)isContractType isShowHalfOrOneSelectedView:(BOOL)isShowHalfOrOneSelectedView;

- (instancetype)initWithFrame:(CGRect)frame showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel;
// 包工进入选择考勤模块增加
- (instancetype)initWithFrame:(CGRect)frame showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isContractType:(BOOL)isContractType;

@end
