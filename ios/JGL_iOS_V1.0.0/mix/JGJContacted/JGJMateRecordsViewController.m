//
//  JGJMateRecordsViewController.m
//  mix
//
//  Created by Tony on 2017/3/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMateRecordsViewController.h"
#import "JGJMainCalendarTableViewCell.h"
#import "JGJRecordButtonTableViewCell.h"
#import "JGJRecordDetailTableViewCell.h"
#import "JGJMoneyViewTableViewCell.h"
#import "JGJBillTableViewCell.h"
#import "TYBaseTool.h"
#import "NSDate+Extend.h"
#import "MyCalendarObject.h"
#import "YZGDatePickerView.h"
#import "JGJAddNameHUBView.h"
#import "RecordWorkHomeNoteView.h"
#import "RecordWorkHomeMoneyView.h"
#import "UINavigationBar+Awesome.h"
#import "YZGMateReleaseBillViewController.h"
#import "JGJSelectView.h"
#import "JGJTime.h"
#import "JGJNavView.h"
#import "JGJQRecordViewController.h"
#define leftArrow 110
#define rightArrow 100
static NSString *const calendarFormat = @"yyyy/MM/dd";
@interface JGJMateRecordsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarHeaderDelegate,
JGJAddNameHUBViewDelegate,
YZGDatePickerViewDelegate,
FSCalendarDelegateAppearance,
RecordWorkHomeNoteViewDelegate,
ClickcalenderButtondelegate
>
{
    BOOL _isRecordedBill;//记录今天是否有流水，如果有流水，则"记工流水"需要显示红点
    RecordWorkHomeNoteModel *_recordWorkNoteModel;//马上记一笔使用的Model
    JGJMainCalendarTableViewCell *calendarcell;
}
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
@property (nonatomic ,strong)JGJSelectView *titleView;
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *datesWithSubImage;
@property (strong, nonatomic) JGJNavView *NavView;
@property (strong, nonatomic) IBOutlet RecordWorkHomeNoteView *recordNoteMoney;
@property (strong, nonatomic) IBOutlet RecordWorkHomeMoneyView *recordWorkHomeMoneyView;
@property (strong, nonatomic) IBOutlet YZGMateBillRecordWorkpointsView *billRecordWorkpointsView;
@property (strong, nonatomic) NSMutableArray *recordArray;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
@property (strong, nonatomic) UIButton *backUpButton;
@property (strong, nonatomic) NSMutableArray *ModelArray;
@property (strong, nonatomic) FSCalendar *Matecalendar;


@end

@implementation JGJMateRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppFontf1f1f1Color;
    [self.view addSubview:self.tableview];
    self.calendar = calendarcell.calendar;
    [self.calendar selectDate:[NSDate date]];
    [self setUpCalendar];

}
- (void)setUpCalendar{
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _holidayLunarCalendar = [NSCalendar currentCalendar];
    _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    //    _calendar.appearance.titleSelectionColor = [UIColor blackColor];
    //    _calendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _calendar.appearance.titleDefaultColor = AppFont333333Color;
    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    _calendar.appearance.selectionColor = AppFontfdf0f0Color;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    [self.calendar addSubview:self.backUpButton];
    [self setCalendarTheme];
}
- (void)setCalendarTheme
{
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    
    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
    //    _calendar.appearance.todaySelectionColor = JGJMainColor;
    //    _calendar.appearance.selectionColor = [UIColor blueColor];
    _calendar.appearance.todayColor = AppFontfafafaColor;
    _calendar.appearance.titleTodayColor =AppFontd7252cColor;
    _calendar.header.delegate = self;
    _calendar.header.needSelectedTime = YES;
    //    _calendar.header.leftAndRightShow = YES;
    
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.mainVC = YES;
    //    _calendar.header.delegate = self;
    //    _calendar.header.needSelectedTime = YES;
    //    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    //    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    //田家城左右显示剪头
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _tableview.delegate  = self;
        _tableview.dataSource = self;
        
    }
    return _tableview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
       calendarcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJMainCalendarTableViewCell" owner:nil options:nil]firstObject];
        return calendarcell;
    }else if (indexPath.row == 1){
        JGJRecordDetailTableViewCell *Detailcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordDetailTableViewCell" owner:nil options:nil]firstObject];
        return Detailcell;

    
    }else if (indexPath.row == 2){
        JGJRecordButtonTableViewCell *Detailcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordButtonTableViewCell" owner:nil options:nil]firstObject];
        return Detailcell;
    
    }else if (indexPath.row == 3){
        JGJMoneyViewTableViewCell *Detailcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJMoneyViewTableViewCell" owner:nil options:nil]firstObject];
        return Detailcell;
    
    }else if (indexPath.row == 4){
    
        JGJBillTableViewCell *Detailcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJBillTableViewCell" owner:nil options:nil]firstObject];
        return Detailcell;
    
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 450;
            break;
        case 1:
            return 30;

            break;
        case 2:
            return 65;

            break;
        case 3:
            return 100;

            break;
        case 4:
            return 80;

            break;
            
        default:
            break;
    }

    return 0;
}
@end
