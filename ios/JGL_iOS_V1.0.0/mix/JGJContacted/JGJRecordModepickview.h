//
//  JGJRecordModepickview.h
//  mix
//
//  Created by Tony on 2017/2/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordModePickerRemarkView.h"
typedef void(^leftSelectActionBlock)(NSString *str);

@protocol CancelButtondelegate <NSObject>

- (void)ClickLeftButtondelegate;

- (void)clickrightbuttontoModel:(jgjrecordselectedModel *)selectedModel;

- (void)clickRecordRemark;
//返回选择的时间模板
- (void)selectpickerViewleft:(NSString *)norTime overTime:(NSString *)overtime;
@end

@interface JGJRecordModepickview : UIView

@property(nonatomic ,weak)id <CancelButtondelegate>delegate;

@property(nonatomic ,copy)NSString *modelstr;

@property (copy, nonatomic) leftSelectActionBlock selectActionBlock;
@property (nonatomic, strong) JGJRecordModePickerRemarkView *remarkView;
@property(nonatomic,strong)UILabel *detailLable;

@property(nonatomic,strong)NSString *detailStr;

@property(nonatomic,strong)NSMutableArray *manhourTimeArr;//上班

@property(nonatomic, strong)NSMutableArray *oversTimeArr;

-(void)setWorkTimeselected:(NSString *)workTime andOverTime:(NSString *)overTime;

-(void)leftButtonBlock:(leftSelectActionBlock)selectblock;

//@property(nonatomic ,strong)NSArray *workTimeArr;
//
//@property(nonatomic ,strong)NSArray *overTimeArr;

-(void)dismissview;

-(void)showPicker;

/*
 *设置标题
 */
- (void)SetTitleAndTitleText:(NSString *)title;
/*
 *设置记工人数
 */
- (void)setReminLableAndNum:(NSString *)num;
@end
