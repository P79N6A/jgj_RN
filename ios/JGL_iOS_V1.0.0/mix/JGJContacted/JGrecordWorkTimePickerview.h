//
//  JGrecordWorkTimePickerview.h
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordModePickerRemarkView.h"
typedef NS_ENUM(NSInteger, ShowPickerModel) {
 
    pickerRecordHaveButton     = 0,
    pickerRecordNoButton = 1
};

typedef void(^leftSelectActionBlock)(NSString *str);

@protocol CancelButton <NSObject>

- (void)ClickLeftButton;
- (void)clickrightbutton:(jgjrecordselectedModel *)selectedModel;
- (void)deleteRecordWorkingModelWithjgjrecordselectedModel:(jgjrecordselectedModel *)recordModel;
//返回选择的时间模板
- (void)pickerViewleft:(NSString *)norTime overTime:(NSString *)overtime;
//修改工资模板
- (void)editeMoneylable;
/*
 *点击项目按钮
 */
- (void)tapProNameLable;

/*
 *点击记工备注
 */
- (void)clickWorkTimePickerviewRemarkTxtWithJgjRecordMorePeoplelistModel:(JgjRecordMorePeoplelistModel *)recorderPeopleModel;
@end
@interface JGrecordWorkTimePickerview : UIView
@property(nonatomic ,weak)id <CancelButton>delegate;
@property(nonatomic ,copy)NSString *modelstr;
@property (copy, nonatomic) leftSelectActionBlock selectActionBlock;

@property (nonatomic, strong) UIView *detailInfoView;
@property (nonatomic, strong) UILabel *detailType;// 工资标准/考勤模板类型
@property(nonatomic ,strong)UILabel *detailLable;// 工资标准/或者考勤模板详情
// 是否需要居左显示, 默认居中
@property (nonatomic, assign) BOOL theDetailLableTexTAlignmentNeedLeft;
@property(nonatomic ,strong)NSString *detailStr;
@property(nonatomic ,assign)int dayNum;
@property(nonatomic ,strong)NSString *nameAndPhone;
@property(nonatomic ,assign)BOOL shouldBoard;
@property(nonatomic ,strong)UILabel *proLable;//底部的项目选择
@property(nonatomic ,strong)UILabel *proName;//底部的项目选择

@property (nonatomic, strong) JgjRecordMorePeoplelistModel *recorderPeopleModel;

@property (nonatomic, strong) JGJRecordModePickerRemarkView *remarkView;
@property (nonatomic, assign) BOOL isAddRemarkView;// 是否显示记工备注view
@property (nonatomic, assign) BOOL isHideDeleteBtn;// 是否显示删除按钮
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长

-(void)leftButtonBlock:(leftSelectActionBlock)selectblock;
//设置默认加班时间显示无加班
-(void)overTimedefults;
@property(nonatomic ,strong)NSArray *workTimeArr;
@property(nonatomic ,strong)NSArray *overTimeArr;
-(void)dismissview;

-(void)MoveCompenttoIndex:(NSString *)str;

- (void)SetdefaultTimeW_tpl:(NSString *)work_time andover_tpl:(NSString *)overtime andManTPL:(NSString *)manHourTpl andOverTimeTPL:(NSString *)overTpl;

//设置默认时间
- (void)SetdefaultTimeW_tpl:(NSString *)work_time workTpl:(NSString *)workTpl andover_tpl:(NSString *)overtime overTpl:(NSString *)overTpl andDefult:(BOOL)defult;

// 是否是从一人记多天过来
- (void)SetdefaultTimeW_tpl:(NSString *)work_time workTpl:(NSString *)workTpl andover_tpl:(NSString *)overtime overTpl:(NSString *)overTpl andDefult:(BOOL)defult isMoreDayComming:(BOOL)isMoreDayComming;


@end
