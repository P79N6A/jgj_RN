//
//  JGJWeatherDetailViewController.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWeatherDetailViewController.h"
#import "JGJWeatherCalendarTableViewCell.h"
#import "JGJproDetailTableViewCell.h"
#import "JGJWeatherNewDeatailTableViewCell.h"
#import "YZGDatePickerView.h"
#import "JGJTime.h"
#import "NSString+Extend.h"
#import "JGJPerInfoVc.h"
#import "JGJNoDataTableViewCell.h"
#import "JGJSummerViewController.h"
#import "JGJRaincalenderTimeTableViewCell.h"
#import "JGJRaincalenderWeatherTableViewCell.h"
#import "JGJRaincalenderTempTableViewCell.h"
#import "JGJRaincalenderWindTableViewCell.h"
#import "JGJNOTempAndWindDepartTableViewCell.h"
#import "JGJRaincalenderDetailsTableViewCell.h"
@interface JGJWeatherDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickHeaderbutton,
YZGDatePickerViewDelegate,
tapNamelabledelegate
>
{
    JGJWeatherCalendarTableViewCell *CalendarproCell ;
    NSMutableArray <JGJRainCalenderDetailModel *>*dataArr;
}
@property (nonatomic ,strong)NSString *calendarStr;//用于借口的时间
@property (nonatomic ,strong)YZGDatePickerView *yzgDatePickerView;//用于借口的时间
@property (nonatomic ,strong)NSString *currentTime;//当前选中的时间

@end

@implementation JGJWeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.title = @"天气详情";
    [self.view addSubview:self.tableview];
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:[NSDate date]]];
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = AppFontf1f1f1Color;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!CalendarproCell) {
       CalendarproCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWeatherCalendarTableViewCell" owner:nil options:nil]firstObject];
        CalendarproCell.delegate = self;
        CalendarproCell.rightButton.hidden = YES;

        CalendarproCell.selectionStyle = UITableViewCellSelectionStyleNone;
          }
        return CalendarproCell;
       
       
    }else if (indexPath.row == 1){
        JGJproDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJproDetailTableViewCell" owner:nil options:nil]firstObject];
        proCell.proname = _WorkCicleProListModel.all_pro_name;

        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else{
        if (dataArr.count <=0) {
        JGJNoDataTableViewCell *NoDataCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNoDataTableViewCell" owner:nil options:nil]firstObject];
            return NoDataCell;
        }else{
        JGJWeatherNewDeatailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWeatherNewDeatailTableViewCell" owner:nil options:nil]firstObject];
            proCell.delegate = self;
            proCell.nameLable.tag = indexPath.row;
        proCell.calendermodel = dataArr[indexPath.row -2];
//            if (indexPath.row == dataArr.count+1) {
//        proCell.bottomLbale.hidden = YES;
//            }
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
        }
    }
    return 0;
}*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        if (!CalendarproCell) {
            CalendarproCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWeatherCalendarTableViewCell" owner:nil options:nil]firstObject];
            CalendarproCell.delegate = self;
            CalendarproCell.rightButton.hidden = YES;
            
            CalendarproCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return CalendarproCell;
        }else if (indexPath.row == 1)
        {
            JGJproDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJproDetailTableViewCell" owner:nil options:nil]firstObject];
            proCell.proname = _WorkCicleProListModel.all_pro_name;
            
            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;

        
        }else if (indexPath.row == 2)
        {
            if (dataArr.count <= 0) {
                JGJNoDataTableViewCell *NoDataCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNoDataTableViewCell" owner:nil options:nil]firstObject];
                return NoDataCell;
            }else{
            JGJRaincalenderTimeTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderTimeTableViewCell" owner:nil options:nil]firstObject];
            proCell.delegate = self;
            proCell.tag = indexPath.section;
            proCell.calendermodel = dataArr[indexPath.section];
            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            }

        }else if (indexPath.row == 3)
        {
            JGJRaincalenderWeatherTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderWeatherTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;

        }else if (indexPath.row == 4)
        {
            JGJRaincalenderTempTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderTempTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
  
        }else if (indexPath.row == 5)
        {
            JGJRaincalenderWindTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderWindTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
  
        }else if (indexPath.row == 6)
        {
            JGJNOTempAndWindDepartTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNOTempAndWindDepartTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;

        }else if (indexPath.row == 7)
        {
            JGJRaincalenderDetailsTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderDetailsTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
 
        }
    }else{
       if (indexPath.row == 0)
        {
            JGJRaincalenderTimeTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderTimeTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];
            proCell.delegate = self;
            proCell.tag = indexPath.section;

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 1)
        {
            JGJRaincalenderWeatherTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderWeatherTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 2)
        {
            JGJRaincalenderTempTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderTempTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 3)
        {
            JGJRaincalenderWindTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderWindTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 4)
        {
            JGJNOTempAndWindDepartTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNOTempAndWindDepartTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 5)
        {
            JGJRaincalenderDetailsTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRaincalenderDetailsTableViewCell" owner:nil options:nil]firstObject];
            proCell.calendermodel = dataArr[indexPath.section];

            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }
    }
       return nil;
}
-(void)tapDetailNameLable:(NSInteger)indexPathRow
{
    if (dataArr.count <= 0) {
        return;
    }
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.uid =[dataArr[indexPathRow] uid];
        perInfoVc.jgjChatListModel.group_id = _WorkCicleProListModel.group_id;
        perInfoVc.jgjChatListModel.class_type = _WorkCicleProListModel.class_type;
            [self.navigationController pushViewController:perInfoVc animated:YES];
    


}
-(float)RowHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:13.1];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 2000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.height + 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArr.count <= 0) {
        return 1;
    }
    return dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArr.count <= 0) {
        return 3;
    }
    if (section == 0) {
        return 8;
    }else{
    
        return 6;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        }else if (indexPath.row == 1){
            
            return 35;
            
        }else if (indexPath.row == 2){
            
            if (dataArr.count <= 0) {
                return TYGetUIScreenHeight - 100;
            }
            return 45;
            
        }else if (indexPath.row == 3){
            
            return 27;
            
        }else if (indexPath.row == 4){
            
            if ([NSString isEmpty:[dataArr[indexPath.section] temp]]) {
                return 0;
            }
            return 15;
            
        }else if (indexPath.row == 5){
            if ([NSString isEmpty:[dataArr[indexPath.section] wind]]) {
                return 0;
            }
            return 15;
            
        }else if (indexPath.row == 6){
            
            return 12;
            
        }else if (indexPath.row == 7){
            if ([NSString isEmpty:[dataArr[indexPath.section] detail]]) {
                return 7.5;
            }
            return  [self RowHeight:[dataArr[indexPath.section] detail] ] + 31;
            
        }
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else if (indexPath.row == 1){
            
            return 27;
            
        }else if (indexPath.row == 2){
            if ([NSString isEmpty:[dataArr[indexPath.section] temp]]) {
                return 0;
            }
            return 15;
            
        }else if (indexPath.row == 3){
            if ([NSString isEmpty:[dataArr[indexPath.section] wind]]) {
                return 0;
            }
            return 15;
            
        }else if (indexPath.row == 4){
            
            return 12;
            
        }else if (indexPath.row == 5){
            if ([NSString isEmpty:[dataArr[indexPath.section] detail]]) {
                return 7.5;
            }

            return  [self RowHeight:[dataArr[indexPath.section] detail] ] + 31;
            
        }
    }
    
    return 0;
}

/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArr.count <= 0) {
        return 3;
    }
    return dataArr.count +2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 39;
    }else if (indexPath.row == 1){
        
        return 35;

    }else{
        if (dataArr.count <=0) {
            return TYGetUIScreenHeight - 74;
        }else{
            if (![[(JGJRainCalenderDetailModel *)dataArr[indexPath.row - 2] detail] length]) {
                if ([[dataArr[indexPath.row -2] temp] isEqualToString:@""] && [[dataArr[indexPath.row -2] wind] isEqualToString:@""]) {
                    
                  return   74;
                }else if (([[dataArr[indexPath.row -2] temp] isEqualToString:@""] &&![[dataArr[indexPath.row -2] wind] isEqualToString:@""])||(![[dataArr[indexPath.row -2] temp] isEqualToString:@""] &&[[dataArr[indexPath.row -2] wind] isEqualToString:@""]))
                {
                    return 94;
                }
                return 120;
            }else{
            if ([[dataArr[indexPath.row -2] temp] isEqualToString:@""] && [[dataArr[indexPath.row -2] wind] isEqualToString:@""]) {
                
                return 82 + [self RowHeight:[(JGJRainCalenderDetailModel *)dataArr[indexPath.row - 2] detail] ] + 2;
            }else if (([[dataArr[indexPath.row -2] temp] isEqualToString:@""] &&![[dataArr[indexPath.row -2] wind] isEqualToString:@""])||(![[dataArr[indexPath.row -2] temp] isEqualToString:@""] &&[[dataArr[indexPath.row -2] wind] isEqualToString:@""]))
            {
            return 111 + [self RowHeight:[(JGJRainCalenderDetailModel *)dataArr[indexPath.row - 2] detail] ] + 2;
            }
            return 133 + [self RowHeight:[(JGJRainCalenderDetailModel *)dataArr[indexPath.row - 2] detail] ] + 2;
        }
    }
    }
    return 45;
}*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark -点击日历按钮
-(void)didselectedcalendarButtonandTag:(NSInteger)tag andText:(NSString *)timeStr
{
    NSString *yearStr = [timeStr substringToIndex:4];
    NSString *monthStr = [timeStr substringWithRange:NSMakeRange(5, 2)];
    
  NSString *year =[NSString stringWithFormat:@"%ld", (long)[JGJTime GetyearFromStamp:[NSDate date]]] ;
  NSString *month =[NSString stringWithFormat:@"%ld", (long)[JGJTime GetMonthFromStamp:[NSDate date]]];
    if ([yearStr integerValue] ==[year integerValue] && [monthStr integerValue]>= [month integerValue] && tag == 1) {
        return;
    }

    if (tag == 1) {
    if ([monthStr intValue] == 12) {
        monthStr = @"01";
        yearStr = [NSString stringWithFormat:@"%ld",[yearStr intValue] + tag];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",[monthStr intValue] + tag];

        if (monthStr.length == 1) {
            monthStr = [NSString stringWithFormat:@"0%@",monthStr ];

        }else{
            monthStr = [NSString stringWithFormat:@"%@",monthStr];

        }
    }
    }else if (tag == -1){
        if ([monthStr intValue]==1) {
        monthStr = @"12";
        yearStr = [NSString stringWithFormat:@"%d",[yearStr intValue] + tag];
        }else{
            monthStr = [NSString stringWithFormat:@"%d",[monthStr intValue] + tag];

            if (monthStr.length == 1) {
                monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                
            }else{
                monthStr = [NSString stringWithFormat:@"%@",monthStr];
                
            }
        }
    }

    CalendarproCell.timelable.text = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
    _calendarStr = [NSString stringWithFormat:@"%@%@",yearStr,monthStr];
    
    if ([yearStr integerValue] ==[year integerValue] && [monthStr integerValue]>= [month integerValue] && tag == 1) {
        CalendarproCell.rightButton.hidden = YES;
    }else{
        CalendarproCell.rightButton.hidden = NO;

    
    }

    
    [self getdetailCalenderwithmonth:_calendarStr];
    
}
- (NSDate *)timeChangedate:(NSString *)timeStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy年MM月"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate *date =[dateFormat dateFromString:timeStr];
    return date;
}
-(void)didselectedtimelableandLabletext:(NSString *)str
{
    [self.yzgDatePickerView setSelectedDate:[self timeChangedate:str]?:[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
}
- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}
- (void)YZGDataPickerSelect:(NSDate *)date;
{
    
    if (!date) {
        [TYShowMessage showError:@"日期格式出错"];
        return;
    }
    NSString *todayStr;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSString *selectDate = [dateFormatter stringFromDate:date?:[NSDate date]];
    
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];

    if ([selectDate isEqualToString: todayDate]) {
        
        CalendarproCell.rightButton.hidden = YES;
  
    }else{
        
        CalendarproCell.rightButton.hidden = NO;

    }
    
    NSDateFormatter *showFormatter = [[NSDateFormatter alloc]init];
    
    [showFormatter setDateFormat:@"yyyy年MM月"];
    
    todayStr = [showFormatter stringFromDate:date];
    
    CalendarproCell.timelable.text = todayStr;
    
    
    _calendarStr = selectDate;
    
    [self getdetailCalenderwithmonth:_calendarStr];

}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
        _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;
}
-(void)getdetailCalenderwithmonth:(NSString *)month
{
    if (!_WorkCicleProListModel.class_type) {
        return;
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"getWeatherList" forKey:@"action"];
    [parmDic setObject:_WorkCicleProListModel.class_type forKey:@"class_type"];
    [parmDic setObject:@"manage" forKey:@"client_type"];
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
        [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
        [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    [parmDic setObject:month forKey:@"month"];
    [parmDic setObject:@"" forKey:@"pg"];
    [parmDic setObject:@"" forKey:@"pagesize"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [parmDic setObject:app_Version forKey:@"ver"];

    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/getWeatherList" parameters:parmDic success:^(id responseObject) {
        
        dataArr = [NSMutableArray array];
        dataArr = [JGJRainCalenderDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];

    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];

    }];



}


@end
