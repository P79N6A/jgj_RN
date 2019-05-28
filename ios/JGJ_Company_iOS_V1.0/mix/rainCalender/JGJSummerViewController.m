//
//  JGJSummerViewController.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSummerViewController.h"
#import "JGJProTableViewCell.h"
#import "JGJSumCalendarTableViewCell.h"
#import "JGJDetailTableViewCell.h"
#import "JGJSumDateTableViewCell.h"
#import "JGJRecordDetailTableViewCell.h"
#import "JGJpeopleRecTableViewCell.h"
#import "JGJSumdetailTableViewCell.h"
#import "JGJSecondDetailTableViewCell.h"
#import "JGJWeatherDetailViewController.h"
#import "JGJRecordWeatherViewController.h"
#import "PopoverView.h"
#import "JGJSetRecorderViewController.h"
#import "NSDate+Extend.h"
#import "JGJTime.h"
#import "YZGDatePickerView.h"

#import "JGJPerInfoVc.h"
#import "JGJHelpCenterTitleView.h"
#import "UILabel+GNUtil.h"


#define calenderHeight 420/375*TYGetUIScreenWidth
#define CalenderTodayRow [NSDate calculateCalendarRows:[NSDate date]] - 5
#define CalenderNowRow [NSDate calculateCalendarRows:[NSDate date]]
#define leftArrow 110
#define rightArrow 100

@interface JGJSummerViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickRecordWeatherButton,
sumerCalendardelegate,
editeRainCalenderdelegate,
tapSummernamedelegate,
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarDelegateAppearance,
FSCalendarHeaderDelegate

>
{
    JGJRecordDetailTableViewCell *recordCell;
    JGJSumCalendarTableViewCell *Sumcell;
    NSMutableArray *dataArr;
    NSMutableArray *monthDataArr;
    NSMutableArray *oldMonthDataArr;
    NSDate *oldDate;

}
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *datesWithSubImage;
@property (strong, nonatomic) NSDate *calenderCurentDate;
@property (strong, nonatomic) UIView *headerCalenderView;
@property (strong, nonatomic) UILabel *pronamelable;
@property (strong, nonatomic) FSCalendar *calender;
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
@property (nonatomic ,strong) UIImageView *closeView;
@property (nonatomic ,assign) BOOL YONclosePro;

//首次滚动到底部
@property (nonatomic, assign) BOOL isScrollBottom;

@end

@implementation JGJSummerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _calenderH = TYGetUIScreenWidth/375*395 + ([NSDate calculateCalendarRows:[NSDate date]] - 5) *68;
    self.title = @"晴雨表";
    [self.view addSubview:self.baseTableview];
    
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthanddayfromstamp:[NSDate date]]];

    [self loadRightView];
    
    [_calender selectDate:[NSDate date]];

#pragma mark - 添加 获取一个月的信息
//    [self getCalendardetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:[NSDate date]]];
    if (self.WorkCicleProListModel.isClosedTeamVc) {
        _YONclosePro = YES;
        [self.headerCalenderView addSubview:self.closeView];
    }
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewWeatherType;
    
    titleView.title = @"晴雨表";
    
    self.navigationItem.titleView = titleView;
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
}
- (void)loadRightView
{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [releaseButton setTitle:@"更多" forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    releaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}
-(void)releaseInfo:(UIButton *)button
{
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:button withActions:[self JGJChatActions]];
}
- (NSArray<PopoverAction *> *)JGJChatActions {
    // 扫一扫 action
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_details"] title:@"天气详情" handler:^(PopoverAction *action) {
        JGJWeatherDetailViewController *detailVC = [JGJWeatherDetailViewController new];
        detailVC.WorkCicleProListModel = self.WorkCicleProListModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    PopoverAction *addFriendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_recorder"] title:@"设置记录员" handler:^(PopoverAction *action) {
        JGJSetRecorderViewController *SetRecordVC = [[UIStoryboard storyboardWithName:@"JGJSetRecorderViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSetRecorderVC"];
        SetRecordVC.WorkCicleProListModel = _WorkCicleProListModel;
        [self.navigationController pushViewController:SetRecordVC animated:YES];
    }];
    
    if (_YONclosePro) {
        return @[sweepAction];

    }

    if ([_WorkCicleProListModel.myself_group integerValue] || _WorkCicleProListModel.can_at_all) {
        return @[sweepAction, addFriendAction];
  
    }else{
    return @[sweepAction];
    }
}
-(float)RowHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14.5];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-24, 1000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.height;
    
}

-(UITableView *)baseTableview
{
    if (!_baseTableview) {
        _baseTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64)];
        _baseTableview.dataSource =self;
        _baseTableview.delegate = self;
//        _baseTableview.bounces = NO;
        _baseTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableview.tableHeaderView = self.headerCalenderView;
        _baseTableview.hidden = YES;
    }
    return _baseTableview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (indexPath.row == 0) {
    JGJProTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJProTableViewCell" owner:nil options:nil]firstObject];
        proCell.model = _WorkCicleProListModel;
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return proCell;
    }else if (indexPath.row == 1){
        if (!Sumcell) {
            
        
    Sumcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSumCalendarTableViewCell" owner:nil options:nil]firstObject];
        Sumcell.delegate = self;
        Sumcell.WorkCicleProListModel = _WorkCicleProListModel;
        Sumcell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
//    return Sumcell;
    return nil;

    }else */if (indexPath.row == 0){
    JGJDetailTableViewCell *detailCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJDetailTableViewCell" owner:nil options:nil]firstObject];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return detailCell;
    }else if (indexPath.row == 1){
    JGJSecondDetailTableViewCell *detailCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSecondDetailTableViewCell" owner:nil options:nil]firstObject];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return detailCell;
    }else if (indexPath.row == 2){
    JGJSumDateTableViewCell *dateCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSumDateTableViewCell" owner:nil options:nil]firstObject];
        dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dateCell.delegate = self;
        if (dataArr.count) {
        dateCell.model = dataArr[0];
        dateCell.Workmodel = _WorkCicleProListModel;
//            dateCell.editeButton.hidden = NO;

        }else{
        [dateCell setTime:[JGJTime getChineseCalendarWithDateAndWeek:_calenderCurentDate?:[NSDate date]]];
        dateCell.editeButton.hidden = YES;
        }
        if (_YONclosePro) {
        dateCell.editeButton.hidden = YES;
        }
        return dateCell;
    }else if (indexPath.row == 3){
    JGJSumdetailTableViewCell *detailCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSumdetailTableViewCell" owner:nil options:nil]firstObject];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataArr.count) {
            
        if (dataArr.count>0) {
        detailCell.model = dataArr[0];
        }
        }
        return detailCell;
    }else if (indexPath.row == 4){
        recordCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordDetailTableViewCell" owner:nil options:nil]firstObject];
        recordCell.delegate = self;
        recordCell.hiddenButton = dataArr.count;
        if (![_WorkCicleProListModel.is_report integerValue]) {
            recordCell.hiddenButton = YES;
        }
        recordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataArr.count>0) {
            recordCell.model = dataArr[0];
            recordCell.departLable.hidden = NO;
            recordCell.placeLable.hidden = YES;

        }else{
            recordCell.placeLable.hidden = NO;//之前是隐藏了的
            recordCell.departLable.hidden = YES;
        }
        if (_YONclosePro) {
            recordCell.hiddenButton = YES;
            if (dataArr.count <= 0) {
            recordCell.placeLable.hidden = NO;
            }
        }
        return recordCell;
    }else{
        JGJpeopleRecTableViewCell *peopleCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJpeopleRecTableViewCell" owner:nil options:nil]firstObject];
        peopleCell.delegate = self;
        peopleCell.nameLable.tag = indexPath.row;
        peopleCell.recordPeoplelable.hidden = dataArr.count>0?NO:YES;
        peopleCell.nameLable.hidden =  dataArr.count>0?NO:YES;
//      peopleCell.recordPeoplelable.hidden = peopleCell.nameLable.hidden = !recordCell.hiddenButton;
        if (dataArr.count>0) {
        peopleCell.model = dataArr[0];
        }
        peopleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return peopleCell;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //去掉滚动闪烁
    [self scrollViewToBottom:NO];
    
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            /*
        case 0:
//            return 34;
            return 0;

            break;
        case 1:
//            return 420;
//            return _calenderH;
            return 0;
 
            break;
             */
        case 0:
            return 40;
            
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 40;
            break;
        case 3:
            if (dataArr.count <=0 ) {
                return 0;
            }
            if ([[(JGJRainCalenderDetailModel *)dataArr[0] temp] isEqualToString:@""] && [[(JGJRainCalenderDetailModel *)dataArr[0] wind] isEqualToString:@""]) {
                return 38;
            }else if ((![[(JGJRainCalenderDetailModel *)dataArr[0] temp] isEqualToString:@""] && [[(JGJRainCalenderDetailModel *)dataArr[0] wind] isEqualToString:@""]) ||([[(JGJRainCalenderDetailModel *)dataArr[0] temp] isEqualToString:@""] && ![[(JGJRainCalenderDetailModel *)dataArr[0] wind] isEqualToString:@""])){
            
                return 60;
            }
            return 77;

            break;
        case 4:
            if (dataArr.count) {
                if ([[(JGJRainCalenderDetailModel *)dataArr[0] detail] length] <= 0) {
                    return 5;
                }
          return   [self RowHeight:[(JGJRainCalenderDetailModel *)dataArr[0] detail]]+20;
            }else{
            return 80;
            }

            break;
        case 5:
            
            return 39;

            break;
            

        default:
            break;
    }

    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}
-(void)tapSumerNameLableandTag:(NSInteger)indexpathRow
{
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    if (dataArr.count <=0 || !dataArr) {
        return;
    }
//    if (![[(JGJRainCalenderDetailModel *)dataArr[0] uid] isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        perInfoVc.jgjChatListModel.uid =[(JGJRainCalenderDetailModel *)dataArr[0] uid];
    perInfoVc.jgjChatListModel.group_id = _WorkCicleProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = _WorkCicleProListModel.class_type;
        [self.navigationController pushViewController:perInfoVc animated:YES];
        
//    }



}
#pragma mark - 点击记录天气按钮
-(void)clicKRecordWeatherButtonTagert
{
    if ( _WorkCicleProListModel.isClosedTeamVc) {//关闭项目组不能记录天气
        return;
    }
    _rainCalenderDetailModel = [JGJRainCalenderDetailModel new];
    //优化苏剧不跳转 没数据才跳转到记录界面
    
    
    if ([_WorkCicleProListModel.is_report integerValue]) {
            [self jumpVC];
        }
//    [self.navigationController pushViewController:[JGJRecordWeatherViewController new] animated:YES];
}

#pragma - 点击编辑按钮
-(void)clickEditeRainCalenderButton
{
    if ( _WorkCicleProListModel.isClosedTeamVc) {//关闭项目组不能记录天气
        return;
    }
    JGJRecordWeatherViewController *recordVC = [JGJRecordWeatherViewController new];
    JGJRecordWeatherModel *recordEditeModel = [JGJRecordWeatherModel new];
    if (dataArr.count>0) {
    _rainCalenderDetailModel = dataArr[0];
    recordEditeModel.group_id = _WorkCicleProListModel.group_id;
    recordEditeModel.uid = _WorkCicleProListModel.creater_uid;
    recordEditeModel.weat_one = _rainCalenderDetailModel.weat_one;
    recordEditeModel.weat_two = _rainCalenderDetailModel.weat_two;
    recordEditeModel.weat_three = _rainCalenderDetailModel.weat_three;
    recordEditeModel.weat_four = _rainCalenderDetailModel.weat_four;
    recordEditeModel.temp_am = _rainCalenderDetailModel.temp_am;
    recordEditeModel.temp_pm = _rainCalenderDetailModel.temp_pm;
    recordEditeModel.wind_am = _rainCalenderDetailModel.wind_am;
    recordEditeModel.wind_pm = _rainCalenderDetailModel.wind_pm;
    recordEditeModel.detail = _rainCalenderDetailModel.detail;
    recordEditeModel.id = _rainCalenderDetailModel.id;
    recordVC.WorkCicleProListModel = _WorkCicleProListModel;
    recordVC.recordWeatherModel = recordEditeModel;
    recordVC.EditeCalender = YES;
    recordVC.currentDate = _calenderCurentDate;
    [self.navigationController pushViewController:recordVC animated:YES];
}
}
-(void)jumpVC
{
    JGJRecordWeatherViewController *recordVC = [JGJRecordWeatherViewController new];
    recordVC.WorkCicleProListModel = _WorkCicleProListModel;
    recordVC.currentDate = _calenderCurentDate;
    [self.navigationController pushViewController:recordVC animated:YES];
}

-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
    _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;
}
-(void)setRainCalenderDetailModel:(JGJRainCalenderDetailModel *)rainCalenderDetailModel
{
    if (!_rainCalenderDetailModel) {
        _rainCalenderDetailModel = [JGJRainCalenderDetailModel new];
    }
    _rainCalenderDetailModel = rainCalenderDetailModel;
}
//获取一天的天气信息
-(void)getdetailCalenderwithmonth:(NSString *)monthDay
{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGToken] forKey:@"token"];
    [parmDic setObject:@"I" forKey:@"os"];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"getWeatherByDate" forKey:@"action"];
//    [parmDic setObject:JGJSHA1Sign forKey:@"sign"];
    [parmDic setObject:_WorkCicleProListModel.class_type forKey:@"class_type"];
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
        [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
        [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    [parmDic setObject:@"manage" forKey:@"client_type"];
    [parmDic setObject:monthDay forKey:@"month"];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [parmDic setObject:app_Version forKey:@"ver"];
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/getWeatherByDate" parameters:parmDic success:^(id responseObject) {
    dataArr = [NSMutableArray array];
    dataArr = [JGJRainCalenderDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
    [_baseTableview reloadData];
        
        _baseTableview.hidden = NO;
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)scrollViewToBottom:(BOOL)animated {
    
    if (_baseTableview.contentSize.height > _baseTableview.frame.size.height && !_isScrollBottom) {
        
//        CGPoint offset = CGPointMake(0, _baseTableview.contentSize.height - _baseTableview.frame.size.height);
//        
//        [_baseTableview setContentOffset:offset animated:animated];
//        
//        _isScrollBottom = YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取一个月的信息
    [self getCalendardetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:_calender.currentPage]];
    //获取某一天的信息
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthanddayfromstamp:_calenderCurentDate?:[NSDate date]]];
    [Sumcell reloadDataAccordingDate];

}

-(void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{


}

-(UIView *)headerCalenderView
{
    if (!_headerCalenderView) {
        _headerCalenderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, ([NSDate calculateCalendarRows:[NSDate date]] - 5) * 68 + TYGetUIScreenWidth/375*395 + 34)];
        [_headerCalenderView addSubview:self.pronamelable];
        _calender = [[FSCalendar alloc]initWithFrame:CGRectMake(0, [self.WorkCicleProListModel.is_report integerValue] == 1 ? 34 : 50, TYGetUIScreenWidth, CGRectGetHeight(_headerCalenderView.frame) - 34)];
        _headerCalenderView.backgroundColor = [UIColor whiteColor];
        
        [_headerCalenderView addSubview:_calender];
        [self initFscalender];
        
    }
    return _headerCalenderView;
}

-(UILabel *)pronamelable
{
    if (!_pronamelable) {
        _pronamelable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 34)];
        _pronamelable.textColor = AppFont000000Color;
        _pronamelable.numberOfLines = 0;
        _pronamelable.font = [UIFont systemFontOfSize:15];
        _pronamelable.backgroundColor = AppFontf1f1f1Color;
        if ([self.WorkCicleProListModel.is_report isEqualToString:@"1"]) {// 管理员或者天气记录员
            
            _pronamelable.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 34);
            _pronamelable.text = [@"  " stringByAppendingString:_WorkCicleProListModel.all_pro_name];
        }else {
            
            _pronamelable.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 50);
            
            _pronamelable.text = [NSString stringWithFormat:@"  %@\n  天气信息由管理员和记录员填写",_WorkCicleProListModel.all_pro_name];
            [_pronamelable markText:@"天气信息由管理员和记录员填写" withFont:FONT(12) color:AppFont666666Color];
        }
    }
    return _pronamelable;
}

-(void)initFscalender
{
    _calender.delegate =self;
    _calender.dataSource = self;
    _calender.appearance.subtitleSelectionColor = [UIColor blackColor];
    _calender.allowsMultipleSelection = NO;
    _calender.appearance.borderSelectionColor = AppFontd7252cColor;
    _calender.appearance.cellShape = FSCalendarCellShapeRectangle;//取消圆角显示
    _calender.appearance.titleSelectionColor = AppFont333333Color;
    _calender.appearance.titleDefaultColor = AppFont333333Color;
    _calender.selectShow = YES;
    _calender.header.delegate = self;
    _calender.appearance.headerDateFormat = @"yyyy年MM月";
    _calender.appearance.titleFont = [UIFont systemFontOfSize:AppFont32Size];
    _calender.appearance.weekdayTextColor = AppFont999999Color;
    _calender.appearance.weekdayFont = [UIFont systemFontOfSize:AppFont20Size];
    _calender.appearance.headerTitleColor = AppFont333333Color;
    _calender.header.leftAndRightShow = YES;
    _calender.appearance.todayColor = [UIColor whiteColor];
    _calender.appearance.titleTodayColor = AppFontd7252cColor;
    _calender.appearance.todaySelectionColor = AppFontf1f1f1Color;
    _calender.appearance.borderSelectionColor = AppFontccccccColor;
    _calender.appearance.headerTitleFont = [UIFont systemFontOfSize:AppFont30Size];
    _calender.header.needSelectedTime = YES;
    _calender.headerHeight = 60;
    _calender.rainCalendar = YES;
    _calender.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
        [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];
    
}

-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    oldMonthDataArr = [[NSMutableArray alloc]initWithArray:monthDataArr];
    monthDataArr = [NSMutableArray array];
    if ([calendar.currentPage isEqualToDate:oldDate] || !oldDate) {
        monthDataArr = [[NSMutableArray alloc]initWithArray:oldMonthDataArr];;
        
    }
    [_calender reloadData];
    
    [self getCalendardetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:calendar.currentPage?:[NSDate date]]];
    oldDate = calendar.currentPage;
    UIView *view = _baseTableview.tableHeaderView;
    CGRect frame = view.frame;
    frame.size.height = TYGetUIScreenWidth/375*395 + ([NSDate calculateCalendarRows:_calender.currentPage] - 5) *68 +34;
    view.frame =frame;
    _baseTableview.tableHeaderView = view;
    [_calender reloadData];
}
//获取一个月的记录信息
-(void)getCalendardetailCalenderwithmonth:(NSString *)month
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGToken] forKey:@"token"];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"getWeatherList" forKey:@"action"];
    [parmDic setObject:_WorkCicleProListModel.class_type?:@"" forKey:@"class_type"];
    [parmDic setObject:@"manage" forKey:@"client_type"];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGUserUid] forKey:@"uid"];
    if (_WorkCicleProListModel.class_type) {
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
            [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
            [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    }
    [parmDic setObject:month forKey:@"month"];
    //    [parmDic setObject:@"1" forKey:@"pg"];
    //    [parmDic setObject:@"10" forKey:@"pagesize"];

    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/getWeatherList" parameters:parmDic success:^(id responseObject) {
        monthDataArr = [[NSMutableArray alloc]init];
        monthDataArr = [JGJRainCalenderDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_calender reloadData];
        if (monthDataArr.count) {
            if (monthDataArr.count) {
                if ([[(JGJRainCalenderDetailModel *)monthDataArr[0] is_close] intValue]) {
                    [_headerCalenderView addSubview:self.closeView];
                    _YONclosePro = YES;
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    //此处设置天气信息
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    
    for (int i = 0; i<monthDataArr.count; i++) {
        JGJRainCalenderDetailModel *model =(JGJRainCalenderDetailModel *)monthDataArr[i];
        if ([[model create_time] intValue] ==  index) {
            return [NSString stringWithFormat:@"%@-%@-%@-%@",model.weat_one?:@"0",model.weat_two?:@"0",model.weat_three?:@"0",model.weat_four?:@"0"];
        }
    }
    return @"";
}
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [calendar dateWithYear:2014 month:1 day:1];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    
    return [NSDate getLastDayOfThisMonth];
}
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    _rainCalenderDetailModel = [JGJRainCalenderDetailModel new];
    _calenderCurentDate = date;
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthanddayfromstamp:date]];
    [self.baseTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader{
    
    //    self.yzgDatePickerView.defultTime = YES;
    [self.yzgDatePickerView setSelectedDate:_calender.currentPage?:[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
    
}
- (void)YZGDataPickerSelect:(NSDate *)date{
    [self.calender disChangeMonthDyDate:date];
    
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    
    
    
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
//        color = TYColorHex(0xafafaf);
        color = AppFontccccccColor;

    }else{
        //      color = TYColorHex(0x2e2e2e);
        //      color = AppFont333333Color;/
        color = AppFont333333Color;
    }
    
    return color;
}
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = JGJMainColor;
    }else{
        color = JGJMainColor;
    }
    
    return color;
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}
-(void)reciveNotification:(NSNotification *)obj
{
    if ([obj.object intValue] == leftArrow) {
        NSDate *currentMonth = _calender.currentPage;
        NSDate *previousMonth = [_calender dateBySubstractingMonths:1 fromDate:currentMonth];
        
        [_calender setCurrentPage:previousMonth animated:NO];
        
    }else{
        NSDate *currentMonth = _calender.currentPage;
        NSDate *nextMonth = [_calender dateByAddingMonths:1 toDate:currentMonth];
        [_calender setCurrentPage:nextMonth animated:NO];
    }
}
#pragma mark - 已关闭项目的图标
-(UIImageView *)closeView
{
    if (!_closeView) {
        _closeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 126, 71)];
        _closeView.image = [UIImage imageNamed:@"weather_item-turnoff"];
        _closeView.center =   CGPointMake(TYGetUIScreenWidth/2, CGRectGetMidY(self.headerCalenderView.frame) +30);
    }
    return _closeView;
}
-(void)calendarCurrentScopeWillChange:(FSCalendar *)calendar
{

//    oldMonthDataArr = [[NSMutableArray alloc]initWithArray:monthDataArr];
//    monthDataArr = [NSMutableArray array];
//    if ([calendar.currentPage isEqualToDate:oldDate] || !oldDate) {
//        monthDataArr = [[NSMutableArray alloc]initWithArray:oldMonthDataArr];;
//   
//    }
//    [_calender reloadData];
}
@end
