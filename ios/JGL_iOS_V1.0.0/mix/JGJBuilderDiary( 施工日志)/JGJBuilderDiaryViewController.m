//
//  JGJBuilderDiaryViewController.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBuilderDiaryViewController.h"
#import "JGJBuilderHeaderTableViewCell.h"
#import "JGJdailyDetailTableViewCell.h"
#import "JGJProductionDetailTableViewCell.h"
#import "JGJChoiceTheCurrentAddressCell.h"
#import "JGJTheDiaryOfRecipientTableViewCell.h"
#import "JGJTeamMemberCell.h"
#import "JGJTaskTracerVc.h"
#import "JGJTechniqueTableViewCell.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JLGAddProExperienceViewController.h"
#import "JGJBottomVIewAndButton.h"
#import "JGJWeatherPickerview.h"
#import "CustomAlertView.h"
#import "UIImageView+WebCache.h"
#import "JGJChatListBaseVc.h"
#import "JGJDetailViewController.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "JLGDatePickerView.h"
#import "JGJTime.h"
#import "JGJDateLogPickerview.h"
#import "JGJHistoryText.h"
#import "JGJLogTimePickerView.h"
#pragma mark - 自定义的模板
#import "JGJlLogChoiceClassfyViewController.h"
#import "JGJSingerInputTableViewCell.h"
#import "JGJSingerNumInputTableViewCell.h"
#import "JGJClassifyChoiceTableViewCell.h"

#import "JGJTimeChoiceSTableViewCell.h"
#import "JGJStartAndEndTimeTableViewCell.h"
#import "JGJLogSelfNoneTableViewCell.h"
#import "JGJUploadImageHeaderTableViewCell.h"
#import "JGJAdjustSignLocaVc.h"

#import "JGJLocationManger.h"

#import "JGJChatMsgDBManger.h"

@interface JGJBuilderDiaryViewController ()
<
JLGMYProExperienceTableViewCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
clickBottombutton,
clickRecordWeatherlable,
editeTextviewAndBuilderDailyTechDelegate,
editeTextviewAndBuilderDailyDelegate,
clickChoiceTimedelegate,
JLGDatePickerViewDelegate,
editeTextfiledBuilderDailyClassFyDelegate,
editeTextfiledBuilderDailyNuminputDelegate,
editeTextfiledBuilderDailytextinputDelegate,
selectDatePickerTimeDatedelegate,
JGJTeamMemberCellDelegate,
JGJTaskTracerVcDelegate
>{
    
    JGJChoiceTheCurrentAddressCell *_currentAddressCell;
    JGJTheDiaryOfRecipientTableViewCell *_recipientCell;
    BOOL _isSelectedAllMembers;
    NSString *_locationJsonStr;
    NSString *_locationJsonKey;
    
    BOOL _isSaveBuilderDiarySuccess;
}

@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;

@property (nonatomic ,strong)JGJBottomVIewAndButton *button;
@property (nonatomic ,strong)NSMutableArray *ApiImageArr;
@property (nonatomic ,assign)NSInteger TimeIndex;
@property (nonatomic ,strong)NSMutableArray *HadUploadArr;

@property (nonatomic ,strong)NSMutableArray *deleImageArr;
@property (nonatomic ,assign)BOOL hadRecordWether;
@property (nonatomic ,assign)NSInteger oldIndexpathRow;//用作区分清除缓存存时间 单选
@property (nonatomic ,assign)NSInteger oldstartIndexpathRow;//用作区分清除缓存存时间 起时间选择

@property (nonatomic ,assign)BOOL hadedite;
@property (nonatomic ,strong)NSMutableArray <JGJSelfLogTempRatrueModel *>*dataArr;
@property (nonatomic ,strong)NSString *startTime;
@property (nonatomic ,strong)NSString *endTime;

@property (nonatomic ,strong)NSString *singerTime;
@property (nonatomic ,assign)NSInteger weaterIndex;
@property (nonatomic ,strong)NSMutableArray *timeArr;

@property (nonatomic ,assign)BOOL frashTable;
@property (nonatomic ,assign)datePickerModelType datePickerType;
@property (nonatomic ,strong)NSIndexPath *timeIndexpath;

//@property (nonatomic ,strong)JGJDateLogPickerview *dateLogPickerView;

@property (nonatomic ,strong)NSMutableArray <JGJHadRecordWeatherModel *>*recordArr;
// 接收人
@property (nonatomic ,strong) NSMutableArray *membersArr;
@property (nonatomic, strong) NSMutableArray *joinMembers;
@property (nonatomic, strong) JGJLocationMangerModel *locationMangerModel;

@end

@implementation JGJBuilderDiaryViewController
@synthesize MoreparmDic = _MoreparmDic;
- (void)viewDidLoad {
    _hadedite = YES;
    if (!_sendDailyModel) {
        _sendDailyModel = [JGJSendDailyModel new];
    }
    [super viewDidLoad];
    //    self.title = @"发工作日志";
    
    self.title = [@"发" stringByAppendingString:_GetLogTemplateModel.cat_name?:@"日志"];
    [self.view addSubview:self.tableview];
    [TYNotificationCenter addObserver:self selector:@selector(reloaDataTableview) name:@"freashImage" object:nil];
    [self.view addSubview:self.button];
    if (!_eidteBuilderDaily) {
        [self getRecordRaincalenderWeatherAPI];
    }
    
    //首次获取位置
    [self getTheCurrentLocation];
    
    //获取接手人员
    
    [self getReceiveMember];
    
}

- (void)getTheCurrentLocation {
    
    TYWeakSelf(self);
    
    
    [JGJLocationManger locationMangerBlock:^(JGJLocationMangerModel *locationMangerModel) {
        
        [TYShowMessage hideHUD];
        weakself.locationMangerModel = locationMangerModel;
        
        NSDictionary *locationDic = @{@"province":locationMangerModel.province,
                                      @"city":locationMangerModel.city,
                                      @"name":locationMangerModel.name,
                                      @"address":locationMangerModel.address,
                                      @"longitude":@(locationMangerModel.pt.longitude),
                                      @"latitude":@(locationMangerModel.pt.latitude)
                                      };
        _locationJsonStr = [NSString getJsonByData:locationDic];
        [weakself.tableview reloadData];
    }];
}

- (JGJLocationMangerModel *)locationMangerModel {
    
    if (!_locationMangerModel) {
        
        _locationMangerModel = [[JGJLocationMangerModel alloc] init];
    }
    return _locationMangerModel;
}

-(void)reloaDataTableview
{
    //    [_tableview reloadData];
    if (_WorkCicleProListModel.logTypes == pubLishNormalLogType) {
        [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArr.count + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(NSMutableArray *)ApiImageArr
{
    if (!_ApiImageArr) {
        _ApiImageArr = [NSMutableArray array];
    }
    return _ApiImageArr;
    
}
-(NSMutableArray *)deleImageArr
{
    if (!_deleImageArr) {
        _deleImageArr = [NSMutableArray array];
    }
    return _deleImageArr;
    
    
}
-(NSMutableArray *)HadUploadArr
{
    
    if (!_HadUploadArr) {
        _HadUploadArr = [NSMutableArray array];
    }
    return _HadUploadArr;
    
}

- (NSMutableArray *)membersArr
{
    if (!_membersArr) {
        
        _membersArr = [NSMutableArray array];
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        [_membersArr addObjectsFromArray:addModels];
    }
    return _membersArr;
}

- (NSMutableArray *)joinMembers {
    
    if (!_joinMembers) {
        
        _joinMembers = [[NSMutableArray alloc] init];
    }
    return _joinMembers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 63)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = AppFontf1f1f1Color;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
    }
    return _tableview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.WorkCicleProListModel.logTypes == choicelogTemplateType) {
        
        //自定义模板的日志
        if (indexPath.row == 0) {
           
            JGJBuilderHeaderTableViewCell *CalendarproCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJBuilderHeaderTableViewCell" owner:nil options:nil]firstObject];
            
            CalendarproCell.proName = _WorkCicleProListModel.group_name ? : @"";
            CalendarproCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return CalendarproCell;
        }
        // 选择图片
        else if (indexPath.row == self.dataArr.count + 1) {
            
            JLGAddProExperienceTableViewCell *returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
            lable.backgroundColor = AppFontf1f1f1Color;
            lable.textColor = AppFont333333Color;
            lable.font = [UIFont systemFontOfSize:15];
            lable.text = @"   添加图片";
            [returnCell addSubview:lable];
            
            returnCell.delegate = self;
            returnCell.imagesArray = self.imagesArray.mutableCopy;
            
            __weak typeof(self) weakSelf = self;
            returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
                [weakSelf removeImageAtIndex:index];
                _hadedite = NO;
                if (index < _ApiImageArr.count) {
                    
                    [self.deleImageArr addObject:_ApiImageArr[index]];
                    [self.ApiImageArr removeObjectAtIndex:index];
                }
                
                //取出url
                __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
                [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    if ([obj isKindOfClass:[NSString class]]) {
                        [deleteUrlArray addObject:obj];
                    }
                }];
                [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
                
                [weakSelf.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataArr.count + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataArr.count + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            };
            returnCell.headDepart.constant = 35;
            return returnCell;
            
        }

        // 选择接收人
        else if (indexPath.row == self.dataArr.count + 2) {
            
            NSString *MyIdentifierID = NSStringFromClass([JGJTheDiaryOfRecipientTableViewCell class]);
            _recipientCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
            if (!_recipientCell) {
                
                _recipientCell = [[JGJTheDiaryOfRecipientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifierID];
            }
            
            _recipientCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _recipientCell;
            
        }else if (indexPath.row == self.dataArr.count + 3){
            
            JGJTeamMemberCell *cell = (JGJTeamMemberCell *)[self registerExecuMemberTableView:tableView didSelectRowAtIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }
        else{
            
            if ([[_dataArr[indexPath.row-1] element_type] isEqualToString:@"location"]) {
                
                _locationJsonKey = [_dataArr[indexPath.row-1] element_key];
            }
            return  [self accordingLogTempretrueType:[_dataArr[indexPath.row-1] element_type] indexpathRow:indexPath];
        }
        
    }else{
        
        //通用日志
        if (indexPath.row == 0) {
            
            JGJBuilderHeaderTableViewCell *CalendarproCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJBuilderHeaderTableViewCell" owner:nil options:nil]firstObject];
            
            CalendarproCell.proName = _WorkCicleProListModel.group_name;
            CalendarproCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return CalendarproCell;
            
        }else if (indexPath.row == 1){
            JGJdailyDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJdailyDetailTableViewCell" owner:nil options:nil]firstObject];
            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            proCell.delegate = self;
            if (_eidteBuilderDaily || _hadRecordWether) {
                [proCell setweather_am:_sendDailyModel.weat_am wether_pm:_sendDailyModel.weat_pm tem_am:_sendDailyModel.temp_am temp_pm:_sendDailyModel.temp_pm wind_am:_sendDailyModel.wind_am wimd_pm:_sendDailyModel.wind_pm];
            }
            return proCell;
            
        }else if(indexPath.row == 2){
            //发生产详情
            JGJProductionDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJProductionDetailTableViewCell" owner:nil options:nil]firstObject];
            proCell.delegate = self;
            if (_eidteBuilderDaily) {
                proCell.TextView.text = _sendDailyModel.msg_text;
                if (_sendDailyModel.msg_text.length) {
                    proCell.placeLable.hidden = YES;
                }
            }
            //通用日志
            if (_WorkCicleProListModel.logTypes == pubLishNormalLogType) {
                proCell.topTitleLable.text = @"   记录内容";
            }
            proCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return proCell;
            
        }else if (indexPath.row == 3){

            JLGAddProExperienceTableViewCell *returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 5)];
            lable.backgroundColor = AppFontf1f1f1Color;
            [returnCell addSubview:lable];
            
            returnCell.delegate = self;
            returnCell.imagesArray = self.imagesArray.mutableCopy;
            
            __weak typeof(self) weakSelf = self;
            returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
                [weakSelf removeImageAtIndex:index];
                _hadedite = NO;
                if (index < _ApiImageArr.count) {
                    [self.deleImageArr addObject:_ApiImageArr[index]];
                    [self.ApiImageArr removeObjectAtIndex:index];                    
                }
                
                //取出url
                __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
                [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [deleteUrlArray addObject:obj];
                    }
                }];
                [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            
            return  returnCell;
        }
    }
    
    return 0;
}

- (UITableViewCell *)registerExecuMemberTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTeamMemberCell *cell  = [JGJTeamMemberCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.isCheckPlanHeader = YES; //使用当前页面的头部高度，内部只做顶部间隔调整
    
    cell.memberFlagType = ShowAddTeamMemberFlagType;
    
    cell.teamMemberModels = self.membersArr;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_WorkCicleProListModel.logTypes == pubLishNormalLogType) {
        
        return 4;
        
    }else{
        
        return self.dataArr.count + 2 + 2;
        
    }
    
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.WorkCicleProListModel.logTypes == pubLishNormalLogType) {
        
        if (indexPath.row == 0) {
           
            return 60;
            
        }else if (indexPath.row == 2){
              
            return 120;
          
        }else if(indexPath.row == 3){
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            return [cell getHeightWithImagesArray:self.imagesArray] + 30;
              
        }
    
    }else{
        
        if (indexPath.row == 0) {
            
            return 40;
            
        }else if (indexPath.row == self.dataArr.count + 1){
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            return [cell getHeightWithImagesArray:self.imagesArray] + 18;
            
        }else if (indexPath.row == self.dataArr.count + 2){
            
            return 37.5;
            
        }else if (indexPath.row == self.dataArr.count + 3){
            
            // 编辑不显示 选择接收人cell
            return [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
            
        }else{
            
            return [self accordingLogTypefromType:[self.dataArr[indexPath.row - 1] element_type]];
        }
    }
    
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[JGJClassifyChoiceTableViewCell class]]) {
        //点击分类的cell类型
        _TimeIndex = indexPath.row - 1;
        JGJlLogChoiceClassfyViewController *choiceVC = [[UIStoryboard storyboardWithName:@"JGJlLogChoiceClassfyViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJlLogChoiceClassfyVC"];
        
        choiceVC.dateArr = [self.dataArr[indexPath.row - 1] select_value_list];
        choiceVC.element_Key = [self.dataArr[indexPath.row - 1] element_key];
        [self.navigationController pushViewController:choiceVC animated:YES];
        _frashTable = YES;
    }else if ([cell isKindOfClass:[JGJTimeChoiceSTableViewCell class]])
    {
        _choiceType = logSingerTimeType;
        //      [self showDatePicker];;
        cell.tag = indexPath.row - 1;
        _TimeIndex = indexPath.row - 1;
        if (_oldIndexpathRow != indexPath.row) {
            _endTime = nil;
        }
        if ([[_dataArr[indexPath.row-1] element_type] isEqualToString:@"logdate"]) {
            [self showDatePicker];
            
        }else{
            
            //之前用的_timeIndexpath
            if ([[_dataArr[indexPath.row - 1] date_type] isEqualToString:@"day"]) {
                
                _datePickerType = year_month_week_dayModel;
            }else if ([[_dataArr[indexPath.row- 1] date_type] isEqualToString:@"time"])
            {
                _datePickerType = hour_minitmodel;
                
            }else if ([[_dataArr[indexPath.row- 1] date_type] isEqualToString:@"all"])
            {
                _datePickerType = year_month_week_day_hourmodel;
                
            }else if ([[_dataArr[indexPath.row- 1] date_type] isEqualToString:@"month"])
            {
                _datePickerType = year_monthmodel;
                
            }else if ([[_dataArr[indexPath.row- 1] date_type] isEqualToString:@"year"])
            {
                _datePickerType = year_model;
                
            }
            __weak typeof(self) weakself = self;
            if (_datePickerType == year_model || _datePickerType == year_monthmodel) {
                __weak typeof(self) weakself = self;
                JGJLogTimeType logTime;
                if (_datePickerType == year_model ) {
                    logTime = LogTimeYearType;
                }else
                {
                    logTime = LogTimeYearAndMonthType;
                }
                
                //选择年和只有年月
                [JGJLogTimePickerView showDatePickerAndSelfview:nil adndelegate:self timePickerType:logTime andblock:^(NSString *date) {
                    [weakself JGJDataPickerSelect:date isStartTime:NO];
                    weakself.oldIndexpathRow = indexPath.row;
                } andCurrentTime:_endTime];
                
            }else{
                [JGJDateLogPickerview showDatePickerAndSelfview:self.view anddatePickertype:_datePickerType andblock:^(NSDate *date) {
                    [weakself JLGDataPickerSelect:date isStartTime:nil];
                    
                }];
            }
        }
        
    }
}

-(JGJBottomVIewAndButton *)button
{
    if (!_button) {
        _button = [JGJBottomVIewAndButton new];
        [_button setFrame:CGRectMake(0, TYGetUIScreenHeight - 122, TYGetUIScreenWidth, 63)];
        [_button.button setTitle:@"发布" forState:UIControlStateNormal];
        _button.delegate = self;
        _button.hidden = YES;
        
    }
    return _button;
}
//选择上午天气
-(void)selectWeatherAm:(NSString *)am_weather andtag:(NSInteger)tag
{
    _weaterIndex = tag;
    _sendDailyModel.weat_am = am_weather;
    _hadRecordWether = YES;
    
    [self.moreWeatherParm setObject:_sendDailyModel.weat_am?:@"" forKey:@"weat_am"];
    //    [self.MoreparmDic setObject:self.moreWeatherParm forKey:[_dataArr[tag] element_key]];
    _hadedite = NO;
    
}
//选择下午天气
-(void)selectWeatherpm:(NSString *)pm_weather andtag:(NSInteger)tag
{
    _sendDailyModel.weat_pm = pm_weather;
    [self.moreWeatherParm setObject: _sendDailyModel.weat_pm?:@"" forKey:@"weat_pm"];
    //    [self.MoreparmDic setObject:self.moreWeatherParm forKey:[_dataArr[tag] element_key]];
    _weaterIndex = tag;
    _hadRecordWether = YES;
    _hadedite = NO;
    
}
//选择上午风力
-(void)selectWindAm:(NSString *)am_wind andtag:(NSInteger)tag
{
    _sendDailyModel.wind_am = am_wind;
    
    [self.moreWeatherParm setObject: _sendDailyModel.wind_am?:@"" forKey:@"wind_am"];
    //    [self.MoreparmDic setObject:self.moreWeatherParm forKey:[_dataArr[tag] element_key]];
    _weaterIndex = tag;
    _hadRecordWether = YES;
    
    _hadedite = NO;
    
}
//选择下午风力
-(void)selectWindPm:(NSString *)Pm_wind andtag:(NSInteger)tag
{
    _sendDailyModel.wind_pm = Pm_wind;
    _hadRecordWether = YES;
    
    [self.moreWeatherParm setObject:_sendDailyModel.wind_pm?:@"" forKey:@"wind_pm"];
    _weaterIndex = tag;
    
    _hadedite = NO;
    
}
//选择上午温度
-(void)selectTempAm:(NSString *)am_temp andtag:(NSInteger)tag
{
    _sendDailyModel.temp_am = am_temp;
    _hadRecordWether = YES;
    
    [self.moreWeatherParm setObject:_sendDailyModel.temp_am?:@"" forKey:@"temp_am"];
    _weaterIndex = tag;
    
    _hadedite = NO;
    
    
}
//选择下午温度
-(void)selectTempPm:(NSString *)pm_temp andtag:(NSInteger)tag
{
    _hadRecordWether = YES;
    _sendDailyModel.temp_pm = pm_temp;
    
    [self.moreWeatherParm setObject:_sendDailyModel.temp_pm?:@"" forKey:@"temp_pm"];
    _weaterIndex = tag;
    
    _hadedite = NO;
    
}
-(NSMutableDictionary *)MoreparmDic
{
    if (!_MoreparmDic) {
        _MoreparmDic = [NSMutableDictionary dictionary];
    }
    return _MoreparmDic;
}
-(NSMutableDictionary *)moreWeatherParm
{
    if (!_moreWeatherParm) {
        _moreWeatherParm = [NSMutableDictionary dictionary];
    }
    return _moreWeatherParm;
    
}

//编辑生产情况记录  新版是多行输入
-(void)BuilderDailyTextViewEndEidting:(NSString *)text andTag:(NSInteger)tag
{
    [self.MoreparmDic setObject:text forKey:[_dataArr[tag ] element_key]];
    _sendDailyModel.msg_text = text;
    _hadedite = NO;
    
}
//单行数字输入
-(void)BuilderDailyTextfiledNumInputEndEidting:(NSString *)text andTag:(NSInteger)tag
{
    [self.MoreparmDic setObject:text forKey:[_dataArr[tag ] element_key]];
    _sendDailyModel.numtext = text;
    
}

//当单行文本输入
-(void)BuilderDailyTextfiledTextInputEndEidting:(NSString *)text andTag:(NSInteger)tag
{
    [self.MoreparmDic setObject:text forKey:[_dataArr[tag ] element_key]];
    
    _sendDailyModel.text = text;
}

//编辑计数值凉宫坐几路
-(void)BuilderDailyTechTextViewEndEidting:(NSString *)text
{
    _hadedite = NO;
    
    _sendDailyModel.techno_quali_log = text;
}
-(void)clicKRecordWeatherlableAndtag:(NSInteger)tag
{
    [self.view endEditing:YES];
    
}
#pragma mark- 底部保存按钮
- (void)clickBottomButtonevent
{
    [self saveBuilderDiary];
}

//设置模型
- (void)setChatMsgListModel:(JGJChatMsgListModel *)chatMsgListModel
{
    _chatMsgListModel = [JGJChatMsgListModel new];
    _chatMsgListModel = chatMsgListModel;
    
    
}
- (void)setLogEditeModel:(JGJLogDetailModel *)logEditeModel
{
    _logEditeModel = logEditeModel;
    [_tableview reloadData];
}

- (void)setReceiver_uid:(NSString *)receiver_uid {
    
    _receiver_uid = receiver_uid;
}

- (void)setEidteBuilderDaily:(BOOL)eidteBuilderDaily {
    
    _eidteBuilderDaily = eidteBuilderDaily;
    [_tableview reloadData];
}

-(void)setSendDailyModel:(JGJSendDailyModel *)sendDailyModel
{
    _sendDailyModel = [JGJSendDailyModel new];
    _sendDailyModel = sendDailyModel;
    _startTime = sendDailyModel.startTime;
    _endTime = sendDailyModel.endTime;
    _singerTime = sendDailyModel.time;
    [_tableview reloadData];
    _ApiImageArr = [NSMutableArray arrayWithArray:_sendDailyModel.msg_srcs];
    
    [self downEidteImageUrlArr:_sendDailyModel.msg_srcs];
    
}


-(void)downEidteImageUrlArr:(NSArray *)imageArr
{
    if (!self.imagesArray) {
        self.imagesArray = [NSMutableArray array];
    }
    dispatch_group_t group  = dispatch_group_create();
    dispatch_queue_t queue  = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i<imageArr.count; i++) {
        dispatch_group_async(group, queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,imageArr[i]]]]];
            if (image) {
                [self.imagesArray addObject:image];
                [self.HadUploadArr addObject:image];
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [_tableview reloadData];
        });
    });
    
}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    _WorkCicleProListModel = WorkCicleProListModel;
    
}
-(void)setGetLogTemplateModel:(JGJGetLogTemplateModel *)GetLogTemplateModel
{
    if (!_GetLogTemplateModel) {
        
        _GetLogTemplateModel = [[JGJGetLogTemplateModel alloc]init];
    }
    _GetLogTemplateModel = GetLogTemplateModel;
}

-(void)saveBuilderDiary
{
    NSString *weatherKey;
    
    for (int index = 0; index < self.dataArr.count; index ++) {
       
        if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"weather"]) {
           
            weatherKey = [_dataArr[index] element_key];
           
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"number"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue]) {
            
            if (![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]) {
                
                [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                return;
            }else {
                
                if ([NSString isEmpty:[self.MoreparmDic objectForKey:[_dataArr[index] element_key]]]) {
                    
                    [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                    return;
                }
            }
        
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"dateframe"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue]&&![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]){
            
            if (![self.MoreparmDic.allKeys containsObject:[[_dataArr[index] element_key] stringByAppendingString:@"start"]]) {
                [TYShowMessage showPlaint:[@"请选择" stringByAppendingString:[[(JGJSelfLogTempRatrueModel *)_dataArr[index] list][0] element_name]]];
                return;
                
            }if(![self.MoreparmDic.allKeys containsObject:[[_dataArr[index] element_key] stringByAppendingString:@"end"]]){
              
                [TYShowMessage showPlaint:[@"请选择" stringByAppendingString:[[(JGJSelfLogTempRatrueModel *)_dataArr[index] list][1] element_name]]];
                
                return;
            }
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"textarea"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue]){
            
            if (![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]) {
                
                [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                return;
            }else {
                
                if ([NSString isEmpty:[self.MoreparmDic objectForKey:[_dataArr[index] element_key]]]) {
                    
                    [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                    return;
                }
            }
            
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"select"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue] && ![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]){
            [TYShowMessage showPlaint:[@"请选择" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
            return;
            
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"text"]){
            
            if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue]) {
               
                if (![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]) {
                    
                    [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                    return;
                    
                }else {
                    
                    if ([NSString isEmpty:[self.MoreparmDic objectForKey:[_dataArr[index] element_key]]]) {
                        
                        [TYShowMessage showPlaint:[@"请输入" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
                        return;
                    }
                }
            }
            
            NSArray *array = [[_dataArr[index] length_range ]componentsSeparatedByString:@","];
            if (![NSString isEmpty:array.firstObject]) {
                if ([[self.MoreparmDic objectForKey:[_dataArr[index] element_key]] length] < [array.firstObject intValue]) {
                    [TYShowMessage showPlaint:[[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name] stringByAppendingString:@"输入过短"]];
                    return;
                    
                }
            }
            if (![NSString isEmpty:array.lastObject]) {
                if ([[self.MoreparmDic objectForKey:[_dataArr[index] element_key]] length] > [array.lastObject intValue]) {
                    [TYShowMessage showPlaint:[[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name] stringByAppendingString:@"输入过长"]];
                    return;
                    
                }
            }
            
            
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"date"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue] && ![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]){
            
            [TYShowMessage showPlaint:[@"请选择" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
            
            return;
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"logdate"]&&[[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue] && ![self.MoreparmDic.allKeys containsObject:[_dataArr[index] element_key]]){
            
            [TYShowMessage showPlaint:[@"请选择" stringByAppendingString:[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_name]]];
            
            return;
            
        }
        else if ([[(JGJSelfLogTempRatrueModel *)_dataArr[index] element_type] isEqualToString:@"location"] && [[(JGJSelfLogTempRatrueModel *)_dataArr[index] is_require] intValue] && [NSString isEmpty:_locationJsonStr]) {
            
            [TYShowMessage showPlaint:@"定位失败，请重新定位"];
            
            return;
        }
        
    }

        // 1.未选择接收人
        if (self.membersArr.count == 1) {
            
            [TYShowMessage showPlaint:@"请选择接收人"];
            return;
        }else {
            
            // 是否全部选择
            if (_isSelectedAllMembers) {
                
                [_MoreparmDic setObject:@"-1" forKey:@"rec_uid"];
                
            }else {
                
                NSMutableString *idStr = [[NSMutableString alloc] init];
                for (int i = 0; i < self.membersArr.count - 1; i ++) {
                    
                    JGJSynBillingModel *model = self.membersArr[i];
                    if (i == self.membersArr.count - 2) {
                        
                        if (![NSString isEmpty:model.uid]) {
                            
                            [idStr appendString:[NSString stringWithFormat:@"%@",model.uid]];
                        }
                        
                    }else {
                        
                        if (![NSString isEmpty:model.uid]) {
                           
                            [idStr appendString:[NSString stringWithFormat:@"%@,",model.uid]];
                            
                        }
                        
                    }
                    
                }
                [_MoreparmDic setObject:idStr forKey:@"rec_uid"];
            }
        }
    
    if (![NSString isEmpty:_locationJsonStr] && ![NSString isEmpty:_locationJsonKey]) {
        
        // 设置位置信息
        if (!_eidteBuilderDaily) {
            
            [_MoreparmDic setObject:_locationJsonStr forKey:_locationJsonKey];
        }
        
    }
    
    [self.MoreparmDic setObject:_WorkCicleProListModel.class_type?:@"" forKey:@"class_type"];//
    [self.MoreparmDic setObject:_WorkCicleProListModel.group_id forKey:@"group_id"];
    [self.MoreparmDic setObject:_GetLogTemplateModel.cat_id?:[self.dataArr[0] cat_id]?:@"" forKey:@"cat_id"];
    if ([NSString isEmpty:_GetLogTemplateModel.cat_id]) {
        
        [self.MoreparmDic setObject:[self.dataArr[0] cat_id]?:@"" forKey:@"cat_id"];
    }
    
    if (_eidteBuilderDaily) {

        if (_chatRoomGo) {
            [self.MoreparmDic setObject:_chatMsgListModel.msg_id?:@"" forKey:@"msg_id"];
            
        }else{
            
            [self.MoreparmDic setObject:_chatMsgListModel.id?:@"" forKey:@"id"];
            
        }
        [self.MoreparmDic setObject:[self deleteApendImageURl]?:@"" forKey:@"delimg"];
        
        
    }
    if (![NSString isEmpty:weatherKey]) {
        [self.MoreparmDic setObject:[self dictionaryToJson:self.moreWeatherParm] forKey:weatherKey];
    }
    
    //去掉标志
    for (NSString *key in self.MoreparmDic.allKeys) {
        if ([key containsString:@"end"] || [key containsString:@"start"]) {
            [self.MoreparmDic removeObjectForKey:key];
        }
    }
    
    for (int index = 0; index < self.HadUploadArr.count; index ++) {
        if ([self.imagesArray containsObject: self.HadUploadArr[index]]) {
            [self.imagesArray removeObject:self.HadUploadArr[index]];
        }
    }
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    [alertView showProgressImageView:@"正在发布..."];
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN uploadImagesWithApi:@"pc/Log/pubLog" parameters:self.MoreparmDic imagearray:self.imagesArray otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [weakSelf pubSuccessWithResponse:responseObject];
        
        [weakSelf freshDataList];
        
        [weakSelf ModifySuccespopDeail];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (_eidteBuilderDaily) {
            [TYShowMessage showSuccess:@"修改成功!"];
            
        }else{
            [TYShowMessage showSuccess:@"发布成功!"];
            
        }
        [alertView dismissWithBlcok:nil];
        
        _isSaveBuilderDiarySuccess = YES;
        // 保存成功 清空缓存
        [TYUserDefaults setObject:[NSDictionary dictionary] forKey:JGJBuilderDiarymoreWeatherParm];
        [TYUserDefaults setObject:[NSDictionary dictionary] forKey:JGJBuilderDiaryMoreparmDic];
        
        [TYUserDefaults synchronize];
    } failure:^(NSError *error) {
        if (_eidteBuilderDaily) {
            [TYShowMessage showError:@"修改失败!"];
            
        }else{
            
            [TYShowMessage showError:@"发布失败!"];
        }
        [alertView dismissWithBlcok:nil];
        
    }];
}

- (void)pubSuccessWithResponse:(NSDictionary *)response {
    
    TYLog(@"接收的日志----%@", response);
    
    if (!_isSelectedAllMembers) {
        
        return;
    }
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:response];

    if (![NSString isEmpty:msgModel.msg_id] && ![NSString isEmpty:msgModel.msg_type]) {

        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:response];

        msgModel.local_id = [JGJChatMsgDBManger localID];

        //读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:YES];


        [JGJSocketRequest receiveMySendMsgWithMsgs:@[msgModel] action:@"sendMessage"];

        //取消读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:NO];

    }
    
}

-(void)ModifySuccespopDeail
{
    for (UIViewController *controll in self.navigationController.viewControllers) {
        if ([controll isKindOfClass:[JGJDetailViewController class]]) {
            JGJDetailViewController *detailVC = (JGJDetailViewController *)controll;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                detailVC.ModifyLog = YES;
                detailVC.jgjChatListModel = self.chatMsgListModel;
                
            });
        }
    }
    
    
}
-(NSString *)deleteApendImageURl
{
    NSString *UrlStr;
    for (int i = 0; i< self.deleImageArr.count; i++) {
        if (!UrlStr.length) {
            UrlStr = self.deleImageArr[i];
        }else{
            UrlStr = [NSString stringWithFormat:@"%@,%@",UrlStr,self.deleImageArr[i]];
        }
    }
    return UrlStr;
}


- (void)freshDataList {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListBaseVc class]]) {
            
            JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)vc;
            
            if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
                
                [baseVc.tableView.mj_header beginRefreshing];
                
                break;
            }
            
        }
        
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!_eidteBuilderDaily && !_isSaveBuilderDiarySuccess) {
        
        [TYUserDefaults setObject:self.moreWeatherParm forKey:JGJBuilderDiarymoreWeatherParm];
        
        if ([NSString isEmpty:_GetLogTemplateModel.cat_id]) {
            
            [self.MoreparmDic setObject:[self.dataArr[0] cat_id]?:@"" forKey:@"cat_id"];
        }
        [TYUserDefaults setObject:self.self.MoreparmDic forKey:JGJBuilderDiaryMoreparmDic];
    }
    
    [JGJHistoryText saveWithKey:@"logtext" andContent:@""];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    if (_eidteBuilderDaily) {
        
        
        
    }else {
        
        self.MoreparmDic = [NSMutableDictionary dictionaryWithDictionary:[TYUserDefaults objectForKey:JGJBuilderDiaryMoreparmDic]];
        self.moreWeatherParm = [NSMutableDictionary dictionaryWithDictionary:[TYUserDefaults objectForKey:JGJBuilderDiarymoreWeatherParm]];
    }
    
#pragma mark - 获取日志模板
    if (self.WorkCicleProListModel.logTypes == choicelogTemplateType && !_dataArr) {
        [self getLogTempRatrue];
        
    }
    if (_frashTable) {
        [_tableview reloadData];
        if (![NSString isEmpty:_sendDailyModel.selectID]) {
            
            [self.parametersDic setObject:_sendDailyModel.selectID forKey:[_dataArr[_TimeIndex] element_key]];
            
        }
        _frashTable = NO;
    }
    
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(saveBuilderDiary)];
    self.navigationItem.rightBarButtonItem = barbutton;
    
    JGJSynBillingModel *addModel = nil;
    
    if (self.membersArr.count > 0) {
        
        addModel = self.membersArr.lastObject;
        
    }
    
    //数据为空或者最后一个不是添加符号。加上添加符号
    if (self.membersArr.count == 0 || !addModel.isAddModel) {
        
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        
        [self.membersArr addObjectsFromArray:addModels];
        
        [self.tableView reloadData];
    }
    
}
-(void)backButtonPressed
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJDetailViewController class]]) {
            JGJDetailViewController *record = (JGJDetailViewController *)vc;
            record.jgjChatListModel = self.chatMsgListModel;
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(nonnull UINavigationItem *)item {
    
    return YES;
}

#pragma mark - 获取某一天是不是已经记录过晴雨表
- (void)getRecordRaincalenderWeatherAPI
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    [paramDic setObject:_WorkCicleProListModel.class_type forKey:@"class_type"];
    if (self.MoreparmDic.allKeys.count == 0) {
        
        NSString *pushTime = [self getPubTimeFromdate:[NSDate date]];
        [paramDic setObject:pushTime forKey:@"time"];
    }else {
        
        NSString *pushTime = self.MoreparmDic.allValues[0];
        [paramDic setObject:pushTime forKey:@"time"];
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/getWeatherDayByGroup" parameters:paramDic success:^(id responseObject) {
        JGJHadRecordWeatherModel *recordRainModel = [JGJHadRecordWeatherModel mj_objectWithKeyValues:responseObject[@"weather_info"][0]];
        
        if (!_sendDailyModel) {
            _sendDailyModel = [JGJSendDailyModel new];
        }

        _sendDailyModel.weat_am = [[recordRainModel.weat_one?:@"" stringByAppendingString:@">"] stringByAppendingString:recordRainModel.weat_two?:@""];
        _sendDailyModel.weat_pm = [[recordRainModel.weat_three?:@"" stringByAppendingString:@">"] stringByAppendingString:recordRainModel.weat_four?:@""];
        
        if ([NSString isEmpty: recordRainModel.weat_one ] &&[NSString isEmpty: recordRainModel.weat_two] &&[NSString isEmpty: recordRainModel.weat_three ] &&[NSString isEmpty: recordRainModel.weat_four ] ) {
            
            _sendDailyModel.weat_am = @"";
            _sendDailyModel.weat_pm = @"";
        }
        
        _sendDailyModel.wind_am = recordRainModel.wind_am;
        _sendDailyModel.wind_pm = recordRainModel.wind_pm;
        _sendDailyModel.temp_am = recordRainModel.temp_am;
        _sendDailyModel.temp_pm = recordRainModel.temp_pm;
        _hadRecordWether = YES;
        if (![NSString isEmpty:_sendDailyModel.temp_am]) {
            [self.moreWeatherParm setObject:_sendDailyModel.temp_am forKey:@"temp_am"];
        }
        if (![NSString isEmpty:_sendDailyModel.temp_pm]) {
            [self.moreWeatherParm setObject:_sendDailyModel.temp_pm forKey:@"temp_pm"];
            
        }
        if (![NSString isEmpty:_sendDailyModel.weat_am]) {
            [self.moreWeatherParm setObject:_sendDailyModel.weat_am forKey:@"weat_am"];
            
        }
        if (![NSString isEmpty:_sendDailyModel.weat_pm]) {
            [self.moreWeatherParm setObject:_sendDailyModel.weat_pm forKey:@"weat_pm"];
            
        }
        if (![NSString isEmpty:_sendDailyModel.wind_am]) {
            [self.moreWeatherParm setObject:_sendDailyModel.wind_am forKey:@"wind_am"];
            
        }
        if (![NSString isEmpty:_sendDailyModel.wind_pm]) {
            [self.moreWeatherParm setObject:_sendDailyModel.wind_pm forKey:@"wind_pm"];
            
        }
        
        [_tableview reloadData];

    }];
}
//根据自定义的日志模板类型返回不同的cell
-(UITableViewCell *)accordingLogTempretrueType:(NSString *)type indexpathRow:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"textarea"]) {
        //通用行
        JGJProductionDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJProductionDetailTableViewCell" owner:nil options:nil]firstObject];
        proCell.model = self.dataArr[indexPath.row - 1];
        proCell.TextView.tag = indexPath.row - 1;
        proCell.delegate = self;
        if ([self.MoreparmDic.allKeys containsObject:[self.dataArr[indexPath.row - 1]element_key]]) {
            if ([NSString isEmpty:[self.MoreparmDic objectForKey:[self.dataArr[indexPath.row - 1] element_key]]]) {
                
                proCell.placeLable.text = [@"请输入" stringByAppendingString:[self.dataArr[indexPath.row - 1]element_name]];
            }else{
                
                proCell.TextView.text = [self.MoreparmDic objectForKey:[self.dataArr[indexPath.row - 1] element_key]];
            }
        }else{
            
            proCell.placeLable.text = [@"请输入" stringByAppendingString:[self.dataArr[indexPath.row - 1] element_name]];
        }
        
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;

    }else if ([type isEqualToString:@"text"])
    {
        //单行汉字
        JGJSingerInputTableViewCell *singgerInputCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSingerInputTableViewCell" owner:nil options:nil]firstObject];
        singgerInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        singgerInputCell.tag = indexPath.row - 1;
        singgerInputCell.textfiled.tag = indexPath.row - 1;
        singgerInputCell.model = self.dataArr[indexPath.row - 1];
        singgerInputCell.delegate = self;
        
        if ([self.MoreparmDic.allKeys containsObject:[self.dataArr[indexPath.row - 1]element_key]]) {
            singgerInputCell.textfiled.text = [self.MoreparmDic objectForKey:[self.dataArr[indexPath.row - 1]element_key]];
        }
        //去掉第一排的异常显示
        if (indexPath.row ==1 && indexPath.section == 0) {
            
            singgerInputCell.departConstance.constant = 0;
            singgerInputCell.centerconstance.constant = 2;
            singgerInputCell.contentcenterConstance.constant = 0.5;
            
        }else{
            
            singgerInputCell.departConstance.constant = 10;
            singgerInputCell.centerconstance.constant = 7;
            singgerInputCell.contentcenterConstance.constant = 5;
        }
        
        return singgerInputCell;
    }else if ([type isEqualToString:@"number"])
    {
        //单行数字
        JGJSingerNumInputTableViewCell *singgerNumInputCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSingerNumInputTableViewCell" owner:nil options:nil]firstObject];
        singgerNumInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        singgerNumInputCell.model = self.dataArr[indexPath.row - 1];
        singgerNumInputCell.textfiled.tag = indexPath.row - 1;
        singgerNumInputCell.delegate = self;
        
        if ([self.MoreparmDic.allKeys containsObject:[self.dataArr[indexPath.row - 1]element_key]]) {
            singgerNumInputCell.textfiled.text = [self.MoreparmDic objectForKey:[self.dataArr[indexPath.row - 1] element_key]];
        }
        
        //去掉第一排的异常显示
        if (indexPath.row ==1 && indexPath.section == 0) {
            singgerNumInputCell.departConstance.constant = 0;
            singgerNumInputCell.certerconstance.constant = 2;
            singgerNumInputCell.contentCenterconstance.constant = 0.5;
            singgerNumInputCell.imagcenterconstance.constant = 0.5;

        }else{
            singgerNumInputCell.departConstance.constant = 10;
            singgerNumInputCell.certerconstance.constant = 7;
            singgerNumInputCell.contentCenterconstance.constant = 5;
            singgerNumInputCell.imagcenterconstance.constant = 5;
        }
        
        return singgerNumInputCell;
        
    }else if ([type isEqualToString:@"select"])
    {
        //选择框
        JGJClassifyChoiceTableViewCell *classFyCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJClassifyChoiceTableViewCell" owner:nil options:nil]firstObject];
        classFyCell.delegate = self;
        
        classFyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        classFyCell.model = self.dataArr[indexPath.row - 1];
        
        if ([self.MoreparmDic.allKeys containsObject:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"name"]]) {
            classFyCell.contentLable.text = [self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"name"]];
            
            classFyCell.contentLable.textColor =AppFont333333Color;
        }
        
        //去掉第一排的异常显示
        if (indexPath.row ==1 && indexPath.section == 0) {
           
            classFyCell.deaprtConstance.constant = 0;
            
        }else{
            
            classFyCell.deaprtConstance.constant = 10;
            
        }
        return classFyCell;
        
    }else if ([type isEqualToString:@"dateframe"]) {
        
        //起止时间
        JGJStartAndEndTimeTableViewCell *soeTimeCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJStartAndEndTimeTableViewCell" owner:nil options:nil]firstObject];
        _timeIndexpath = indexPath;
        soeTimeCell.tag = indexPath.row - 1;
        soeTimeCell.delegate = self;
        soeTimeCell.model = self.dataArr[indexPath.row - 1];
        
        if ([self.MoreparmDic.allKeys containsObject:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"start"]]) {
            soeTimeCell.startPlaceHolder.text = [self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"start"]];
            soeTimeCell.startPlaceHolder.textColor = AppFont333333Color;
            
            [self.MoreparmDic setObject:[self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"start"]] forKey:[self.dataArr[indexPath.row - 1]element_key]];
            
        }
        if ([self.MoreparmDic.allKeys containsObject:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"end"] ]) {
            
            soeTimeCell.endPlaceHolder.text = [self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"end"]];
            soeTimeCell.endPlaceHolder.textColor = AppFont333333Color;
            
            [self.MoreparmDic setObject:[self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"end"]] forKey:[self.dataArr[indexPath.row - 1]element_key]];
        }
        if ([self.MoreparmDic.allKeys containsObject:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"end"] ] &&[self.MoreparmDic.allKeys containsObject:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"start"] ]) {
            [self.MoreparmDic setObject:[[[self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"start"]] stringByAppendingString:@","] stringByAppendingString:[self.MoreparmDic objectForKey:[[self.dataArr[indexPath.row - 1]element_key] stringByAppendingString:@"end"]]]forKey:[self.dataArr[indexPath.row - 1]element_key]];
        }
        
        soeTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //去掉第一排的异常显示
        if (indexPath.row ==1 && indexPath.section == 0) {
            soeTimeCell.departConstance.constant = 0;
        }else{
            soeTimeCell.departConstance.constant = 10;
            
        }
        return soeTimeCell;
        
    }else if ([type isEqualToString:@"weather"])
    {
        JGJdailyDetailTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJdailyDetailTableViewCell" owner:nil options:nil]firstObject];
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        proCell.delegate = self;
        
        if (![NSString isEmpty:self.moreWeatherParm[@"temp_am"]]) {

            self.sendDailyModel.temp_am = self.moreWeatherParm[@"temp_am"];
        }
        if (![NSString isEmpty:self.moreWeatherParm[@"temp_pm"]]) {

            self.sendDailyModel.temp_pm = self.moreWeatherParm[@"temp_pm"];

        }
        if (![NSString isEmpty:self.moreWeatherParm[@"weat_am"]]) {

            self.sendDailyModel.weat_am = self.moreWeatherParm[@"weat_am"];

        }
        if (![NSString isEmpty:self.moreWeatherParm[@"weat_pm"]]) {

            self.sendDailyModel.weat_pm = self.moreWeatherParm[@"weat_pm"];

        }
        if (![NSString isEmpty:self.moreWeatherParm[@"wind_am"]]) {

            self.sendDailyModel.wind_am = self.moreWeatherParm[@"wind_am"];

        }
        if (![NSString isEmpty:self.moreWeatherParm[@"wind_pm"]]) {

            self.sendDailyModel.wind_pm = self.moreWeatherParm[@"wind_pm"];

        }
        
        if (_eidteBuilderDaily || _hadRecordWether || _weaterIndex) {
            
            [proCell setweather_am:_sendDailyModel.weat_am wether_pm:_sendDailyModel.weat_pm tem_am:_sendDailyModel.temp_am temp_pm:_sendDailyModel.temp_pm wind_am:_sendDailyModel.wind_am wimd_pm:_sendDailyModel.wind_pm];
            
        }
        proCell.tag = indexPath.row - 1;
        return proCell;
        
        
    }else if ([type isEqualToString:@"date"]|| [type isEqualToString:@"logdate"])
    {
        JGJTimeChoiceSTableViewCell *TimeCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTimeChoiceSTableViewCell" owner:nil options:nil] firstObject];
        TimeCell.model = self.dataArr[indexPath.row - 1];
        TimeCell.tag = indexPath.row - 1;
        
#pragma mark - 此处修改默认日志发布时间
        if ([type isEqualToString:@"logdate"]) {
            if (![self.MoreparmDic.allKeys containsObject:[self.dataArr[indexPath.row - 1]element_key]]) {
                _singerTime = [self getWeekDaysString:[NSDate date]];
                _sendDailyModel.pushtime = [self getPubTimeFromdate:[NSDate date]];
                if (_singerTime) {
                    [self.MoreparmDic setObject:_sendDailyModel.pushtime forKey:[_dataArr[_TimeIndex] element_key]];
                }
            }
            
        }
        
        
        if ([self.MoreparmDic.allKeys containsObject:[self.dataArr[indexPath.row - 1]element_key]]) {
            TimeCell.contentLable.text = [self.MoreparmDic objectForKey:[self.dataArr[indexPath.row - 1]element_key]];
            TimeCell.contentLable.textColor = AppFont333333Color;
        }
        TimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row ==1 && indexPath.section == 0) {
            TimeCell.departConstance.constant = 0;
            TimeCell.centerConstance.constant = -5;
            TimeCell.titleCenterconstance.constant = -5;
        }else{
            TimeCell.departConstance.constant = 10;
            TimeCell.centerConstance.constant = 0;
            TimeCell.titleCenterconstance.constant = 0;
            
        }
        return TimeCell;
        
    }else if ([type isEqualToString:@"location"]) {
        
        NSString *MyIdentifierID = NSStringFromClass([JGJChoiceTheCurrentAddressCell class]);
        _currentAddressCell = [_tableview dequeueReusableCellWithIdentifier:MyIdentifierID];
        if (!_currentAddressCell) {
            
            _currentAddressCell = [[JGJChoiceTheCurrentAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifierID];
        }
        _currentAddressCell.isEidteBuilderDaily = _eidteBuilderDaily;
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        
        _currentAddressCell.theCurrentAddress = ^{
            
            TYLog(@"选择地址");
            
            JGJAdjustSignLocaVc *adjustSignLocaVc = [[UIStoryboard storyboardWithName:@"JGJQuaSafeCheck" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAdjustSignLocaVc"];
            
            adjustSignLocaVc.title = @"选择所在位置";
            
            
            // 选择地址微调回调
            adjustSignLocaVc.handleSelSignModelBlock = ^(JGJAddSignModel *signModel) {
                
                weakSelf.locationMangerModel.name = signModel.sign_addr;
                
                weakSelf.locationMangerModel.address = signModel.sign_addr2;
                
                weakSelf.locationMangerModel.pt = signModel.pt;
                
                weakSelf.locationMangerModel.province = signModel.province;
                
                weakSelf.locationMangerModel.city = signModel.city;
                
                NSDictionary *locationDic = @{@"province":weakSelf.locationMangerModel.province,
                                              @"city":weakSelf.locationMangerModel.city,
                                              @"name":weakSelf.locationMangerModel.name,
                                              @"address":weakSelf.locationMangerModel.address,
                                              @"longitude":@(weakSelf.locationMangerModel.pt.longitude),
                                              @"latitude":@(weakSelf.locationMangerModel.pt.latitude)
                                              };
                
                strongSelf -> _locationJsonStr = [NSString getJsonByData:locationDic];
                [weakSelf.tableview reloadData];
                
            };
            
            JGJAddSignModel *addSignModel = [[JGJAddSignModel alloc] init];
            
            addSignModel.sign_addr = weakSelf.locationMangerModel.poiInfo.name?:@"正在定位";
            
            addSignModel.sign_addr2 = weakSelf.locationMangerModel.poiInfo.address;
            
            addSignModel.pt = weakSelf.locationMangerModel.poiInfo.pt;
            
            addSignModel.province = weakSelf.locationMangerModel.province;
            
            addSignModel.city = weakSelf.locationMangerModel.city;
            
            adjustSignLocaVc.addSignModel = addSignModel;
            
            [weakSelf.navigationController pushViewController:adjustSignLocaVc animated:YES];
            
        };
        
        
        // 重新定位
        _currentAddressCell.refreshCurLocation = ^{
            
            [TYShowMessage showHUDWithMessage:@"重新获取所在位置"];
            [weakSelf getTheCurrentLocation];
        };
        
        if (_eidteBuilderDaily) {
            
            for (int i = 0; i < _logEditeModel.element_list.count; i++) {
                
                JGJElementDetailModel *model = _logEditeModel.element_list[i];
                if ([model.element_type isEqualToString:@"location"]) {
                    
                    NSDictionary *locationDic = (NSDictionary *)[model.element_value mj_JSONObject];
                    _currentAddressCell.theCurrentLocationStr = [NSString stringWithFormat:@"%@\n%@",locationDic[@"address"]?:@"",locationDic[@"name"]?:@""];
                    break;
                }
            }
            
        }else {
            
            _currentAddressCell.theCurrentLocationStr = [NSString stringWithFormat:@"%@\n%@",self.locationMangerModel.address?:@"",self.locationMangerModel.name?:@""];
            
        }
        _currentAddressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _currentAddressCell;
    }
    else{
        
        JGJLogSelfNoneTableViewCell *NoneCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJLogSelfNoneTableViewCell" owner:nil options:nil]firstObject];
        NoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return NoneCell;
    }
    return nil;
}

- (float)accordingLogTypefromType:(NSString *)type
{
    
    if ([type isEqualToString:@"dateframe"])
    {
        //起止时间
        return 110;
        
    }else if ([type isEqualToString:@"textarea"])
    {
        
        return 170;
        
    }else if ([type isEqualToString:@"weather"])
    {
        return 124;
        
    }
    else if([type isEqualToString:@"text"]||[type isEqualToString:@"number"]||[type isEqualToString:@"select"]||[type isEqualToString:@"dateframe"] || [type isEqualToString:@"date"]||[type isEqualToString:@"logdate"]){
        return 60;
        
    }else if ([type isEqualToString:@"location"]) {
        
        NSString *address;
        if (_eidteBuilderDaily) {
            
            for (int i = 0; i < _logEditeModel.element_list.count; i++) {
                
                JGJElementDetailModel *model = _logEditeModel.element_list[i];
                if ([model.element_type isEqualToString:@"location"]) {
                    
                    NSDictionary *locationDic = (NSDictionary *)[model.element_value mj_JSONObject];
                    address = [NSString stringWithFormat:@"%@\n%@",locationDic[@"address"]?:@"",locationDic[@"name"]?:@""];
                    break;
                }
            }
            
        }else {
            
            address = [NSString stringWithFormat:@"%@\n%@",self.locationMangerModel.address?:@"",self.locationMangerModel.name?:@""];
            
        }
        CGFloat height = [NSString getContentHeightWithString:address maxWidth:TYGetUIScreenWidth - 82];
        if (height <= 47) {
            
            return 84.5;
            
        }else {
            
            return 37.5 + height;
        }
        
    }
    else{
        return 0;
    }
    return 0;
    
}
#pragma mark - 获取日志模板
-(void)getLogTempRatrue
{
    NSDictionary *paramDic = @{
                               @"id":_GetLogTemplateModel.cat_id?:_chatMsgListModel.cat_id?:@""
                               };
    [JLGHttpRequest_AFN PostWithApi:@"/v2/Approval/getApprovalTemplate" parameters:paramDic success:^(id responseObject) {
        
        _dataArr = [NSMutableArray array];
        _dataArr = [JGJSelfLogTempRatrueModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_tableview reloadData];
        
    }failure:^(NSError *error) {
        
    }];
}

-(void)clickChoiceEndTimeandTag:(NSInteger)tag isStartTime:(BOOL)StartTime
{
    [self.view endEditing:YES];
    if (_oldstartIndexpathRow != tag) {
        _endTime = nil;
        _startTime = nil;
    }
    
    _TimeIndex = tag;
    _choiceType = LogendTimeType;
    if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"day"]) {
        _datePickerType = year_month_week_dayModel;
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"time"])
    {
        _datePickerType = hour_minitmodel;
        
        
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"all"])
    {
        _datePickerType = year_month_week_day_hourmodel;
        
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"month"])
    {
        _datePickerType = year_monthmodel;
        
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"year"])
    {
        _datePickerType = year_model;
        
        
    }
    
    __weak typeof(self) weakself = self;
    
    if (_datePickerType == year_model || _datePickerType == year_monthmodel) {
        __weak typeof(self) weakself = self;
        JGJLogTimeType logTime;
        if (_datePickerType == year_model ) {
            logTime = LogTimeYearType;
        }else
        {
            logTime = LogTimeYearAndMonthType;
        }
        
        //选择年和只有年月
        [JGJLogTimePickerView showDatePickerAndSelfview:nil adndelegate:self timePickerType:logTime andblock:^(NSString *date) {
            [weakself JGJDataPickerSelect:date isStartTime:NO];
            _oldstartIndexpathRow =tag;
            
        } andCurrentTime:_endTime];
    }
    else{
        [JGJDateLogPickerview showDatePickerAndSelfview:self.view anddatePickertype:_datePickerType andblock:^(NSDate *date) {
            [weakself JLGDataPickerSelect:date isStartTime:NO];
            _oldstartIndexpathRow =tag;
            
            
        }];
    }
    
}
-(void)clickChoiceStartTimeandTag:(NSInteger)tag isStartTime:(BOOL)StartTime
{
    [self.view endEditing:YES];
    _TimeIndex = tag;
    _choiceType = LogstartTimeType;
    if (_oldstartIndexpathRow != tag) {
        _startTime = nil;
        _endTime = nil;
    }
    if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"day"]) {
        _datePickerType = year_month_week_dayModel;
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"time"])
    {
        _datePickerType = hour_minitmodel;
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"all"])
    {
        _datePickerType = year_month_week_day_hourmodel;
        
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"month"])
    {
        _datePickerType = year_monthmodel;
        
    }else if ([[_dataArr[_TimeIndex] date_type] isEqualToString:@"year"])
    {
        _datePickerType = year_model;
        
    }
    
    if (_datePickerType == year_model || _datePickerType == year_monthmodel) {
        __weak typeof(self) weakself = self;
        //选择年和只有年月
        JGJLogTimeType logTime;
        if (_datePickerType == year_model ) {
            logTime = LogTimeYearType;
        }else
        {
            logTime = LogTimeYearAndMonthType;
        }
        [JGJLogTimePickerView showDatePickerAndSelfview:nil adndelegate:self timePickerType:logTime andblock:^(NSString *date) {
            [weakself JGJDataPickerSelect:date isStartTime:YES];
            weakself.oldstartIndexpathRow = tag;
            
        } andCurrentTime:_startTime];
    }
    else{
        __weak typeof(self) weakself = self;
        [JGJDateLogPickerview showDatePickerAndSelfview:self.view anddatePickertype:_datePickerType andblock:^(NSDate *date) {
            [weakself JLGDataPickerSelect:date isStartTime:YES] ;
            weakself.oldstartIndexpathRow = tag;
        }];
    }
    
}

- (void)showDatePicker
{
    NSString *dateFormat = [NSString getNumOlnyByString:[self getWeekDaysString:[NSDate date]]];
    //     NSString *dateFormat = [NSString getNumOlnyByString:[NSDate date]];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    self.jlgDatePickerView.datePicker.date = date?:[NSDate date];
    //    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
    
    [self.jlgDatePickerView showDatePickerByIndexPath:nil];
    
    
}
- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *format ;
    if (_datePickerType == year_month_week_day_hourmodel) {
        format = @"yyyy-MM-dd HH:mm";//
        
    }else if (_datePickerType == year_month_week_dayModel)
    {
        format = @"yyyy-MM-dd";//
        
    }else if (_datePickerType == year_monthmodel)
    {
        format = @"yyyy-MM";//
        
    }else if (_datePickerType == hour_minitmodel)
    {
        format = @"HH:mm";
        
    }else if (_datePickerType == year_model)
    {
        format = @"yyyy";//
        
    }
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:format],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    
    //    if ([date isToday]) {
    //        dateString = [dateString stringByAppendingString:@"(今天)"];
    //    }
    
    return dateString;
}

-(NSString *)getPubTimeFromdate:(NSDate *)date
{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (_datePickerType == year_month_week_day_hourmodel) {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//
        
    }else if (_datePickerType == year_month_week_dayModel)
    {
        [dateFormat setDateFormat: @"yyyy-MM-dd"];//
        
    }else if (_datePickerType == year_monthmodel)
    {
        [dateFormat setDateFormat: @"yyyy-MM"];//
        
    }else if (_datePickerType == hour_minitmodel)
    {
        [dateFormat setDateFormat: @"HH:mm"];
        
    }else if (_datePickerType == year_model)
    {
        [dateFormat setDateFormat: @"yyyy"];//
        
    }
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

//日志发布时间时间
-(void)JLGDataPickerSelect:(NSDate *)date
{
    _singerTime = [self getWeekDaysString:date];
    _sendDailyModel.pushtime = [self getPubTimeFromdate:date];
    if (_singerTime) {
        [self.MoreparmDic setObject:_sendDailyModel.pushtime forKey:[_dataArr[_TimeIndex] element_key]];
    }
    [_tableview reloadData];
    [self getRecordRaincalenderWeatherAPI];
}

- (void)JGJDataPickerSelect:(NSString *)date isStartTime:(BOOL)IsStartTime
{
    if ([NSString isEmpty:date]) {
        return;
    }
    if (_choiceType == LogstartTimeType) {
        _startTime = date;
        _sendDailyModel.startTime = date;
        if (!_timedic) {
            _timedic = [NSMutableDictionary dictionary];
        }
        
        if (![NSString isEmpty:_startTime] && ![NSString isEmpty:_endTime]) {
            if ([_startTime compare:_endTime options:NSCaseInsensitiveSearch] == NSOrderedDescending)
            {
                [TYShowMessage showError:@"完成时间不能小余开始时间"];
                return;
            }
        }
        [self.MoreparmDic setObject:_sendDailyModel.startTime forKey:[[_dataArr[_TimeIndex] element_key]stringByAppendingString:@"start"]];
        [self.MoreparmDic setObject:_sendDailyModel.startTime forKey:[_dataArr[_TimeIndex] element_key]];
    }else{//选择结束时间
        _endTime = date;
        _sendDailyModel.endTime = date;
        if (![NSString isEmpty:_startTime] && ![NSString isEmpty:_endTime]) {
            if ([_startTime compare:_endTime options:NSCaseInsensitiveSearch] == NSOrderedDescending)
            {
                [TYShowMessage showError:@"完成时间不能小余开始时间"];
                return;
            }
        }
        
        [self.MoreparmDic setObject:_sendDailyModel.endTime forKey:[[_dataArr[_TimeIndex] element_key]stringByAppendingString:@"end"]];
        [self.MoreparmDic setObject:_sendDailyModel.endTime forKey:[_dataArr[_TimeIndex] element_key]];
        
    }
    
    if (_startTime && _endTime && _TimeIndex && _choiceType != logSingerTimeType) {
        NSString *time = [[_sendDailyModel.startTime stringByAppendingString:@","] stringByAppendingString:_sendDailyModel.endTime];
        [self.MoreparmDic setObject:time forKey:[_dataArr[_TimeIndex] element_key]];
    }
    
    [_tableview reloadData];
}


- (void)JLGDataPickerSelect:(NSDate *)date isStartTime:(BOOL)IsStartTime
{
    
    if (_choiceType == logSingerTimeType) {
        _singerTime = [self getWeekDaysString:date];
        _sendDailyModel.time = [self getPubTimeFromdate:date];
        if (_singerTime) {
            [self.MoreparmDic setObject:_sendDailyModel.time forKey:[_dataArr[_TimeIndex] element_key]];
        }
    }else{
        if (_choiceType == LogstartTimeType) {
            _startTime = [self getWeekDaysString:date];
            _sendDailyModel.startTime = [self getPubTimeFromdate:date];
            if (!_timedic) {
                _timedic = [NSMutableDictionary dictionary];
            }
            
            if (![NSString isEmpty:_startTime] && ![NSString isEmpty:_endTime]) {
                if ([_startTime compare:_endTime options:NSCaseInsensitiveSearch] == NSOrderedDescending)
                {
                    [TYShowMessage showError:@"完成时间不能小余开始时间"];
                    return;
                }
            }
            [self.MoreparmDic setObject:_sendDailyModel.startTime forKey:[[_dataArr[_TimeIndex] element_key]stringByAppendingString:@"start"]];
            [self.MoreparmDic setObject:_sendDailyModel.startTime forKey:[_dataArr[_TimeIndex] element_key]];
        }else{//选择结束时间
            _endTime = [self getWeekDaysString:date];
            _sendDailyModel.endTime = [self getPubTimeFromdate:date];
            if (![NSString isEmpty:_startTime] && ![NSString isEmpty:_endTime]) {
                if ([_startTime compare:_endTime options:NSCaseInsensitiveSearch] == NSOrderedDescending)
                {
                    [TYShowMessage showError:@"完成时间不能小余开始时间"];
                    return;
                }
            }
            
            [self.MoreparmDic setObject:_sendDailyModel.endTime forKey:[[_dataArr[_TimeIndex] element_key]stringByAppendingString:@"end"]];
            [self.MoreparmDic setObject:_sendDailyModel.endTime forKey:[_dataArr[_TimeIndex] element_key]];
            
        }
    }
    if (_startTime && _endTime && _TimeIndex && _choiceType != logSingerTimeType) {
        
        NSString *time = [[_sendDailyModel.startTime stringByAppendingString:@","] stringByAppendingString:_sendDailyModel.endTime];
        [self.MoreparmDic setObject:time forKey:[_dataArr[_TimeIndex] element_key]];
    }
    
    [_tableview reloadData];
}
-(void)setEditeElementDetailModelArr:(NSMutableArray<JGJElementDetailModel *> *)editeElementDetailModelArr
{
    _editeElementDetailModelArr = [NSMutableArray array];
    _editeElementDetailModelArr = editeElementDetailModelArr;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)setMoreparmDic:(NSMutableDictionary *)MoreparmDic
{
    _MoreparmDic = [NSMutableDictionary dictionary];
    if (![NSString isEmpty:_sendDailyModel.temp_am]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.temp_am forKey:@"temp_am"];
    }
    if (![NSString isEmpty:_sendDailyModel.temp_pm]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.temp_pm forKey:@"temp_pm"];
        
    }
    if (![NSString isEmpty:_sendDailyModel.weat_am]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.weat_am forKey:@"weat_am"];
        
    }
    if (![NSString isEmpty:_sendDailyModel.weat_pm]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.weat_pm forKey:@"weat_pm"];
        
    }
    if (![NSString isEmpty:_sendDailyModel.wind_am]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.wind_am forKey:@"wind_am"];
        
    }
    if (![NSString isEmpty:_sendDailyModel.wind_pm]) {
        
        [self.moreWeatherParm setObject:_sendDailyModel.wind_pm forKey:@"wind_pm"];
        
    }
    
    _MoreparmDic = MoreparmDic;
    [_tableview reloadData];
}
-(NSMutableArray *)timeArr
{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
    
}

-(NSString *)jsonStringWithDic:(NSMutableDictionary *)dic
{
    
    NSMutableArray *valueArr = [NSMutableArray array];
    
    for (NSString *value in self.moreWeatherParm.allKeys) {
        [valueArr addObject:[self.moreWeatherParm objectForKey:value]];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < self.moreWeatherParm.allKeys.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",self.moreWeatherParm.allKeys[i],valueArr[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *Jsonsign = [signArray componentsJoinedByString:@","];
    return Jsonsign;
    
}

#pragma mark - TeamMemberCellDelegate
- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel {


    if (self.membersArr.count > 0 && !teamMemberModel.isMangerModel) {

        NSPredicate *existPredicate = [NSPredicate predicateWithFormat:@"telephone=%@", teamMemberModel.telephone];
        
        NSArray *existMembers = [self.membersArr filteredArrayUsingPredicate:existPredicate];
        
        if (existMembers.count > 0) {
            
            for (JGJSynBillingModel *memberModel in existMembers) {
                
                if ([memberModel isKindOfClass:[JGJSynBillingModel class]]) {
                    
                    memberModel.isSelected = NO;
                }
                
            }
        }
        
        NSInteger index = [self.membersArr indexOfObject:teamMemberModel];
        
        [self.membersArr removeObjectAtIndex:index];

        if ([self.joinMembers containsObject:teamMemberModel]) {

            teamMemberModel.isSelected = NO;
        }
        _isSelectedAllMembers = NO;
        [self.tableview reloadData];
        
    }
}

- (void)handleJGJTeamMemberCellAddMember:(JGJTeamMemberCommonModel *)commonModel {

    JGJTaskTracerVc *taskTracerVc = [[UIStoryboard storyboardWithName:@"JGJTask" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTaskTracerVc"];

    taskTracerVc.taskTracerType = JGJLogExecutorTracerType;

    taskTracerVc.delegate = self;

    if (self.membersArr.count > 0) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel == %@", @(YES)];

        JGJSynBillingModel *addModel = [self.membersArr filteredArrayUsingPredicate:predicate].lastObject;

        if (addModel.isMangerModel) {

            [self.membersArr removeObject:addModel];
        }

    }

    taskTracerVc.proListModel = _WorkCicleProListModel;
    taskTracerVc.existedMembers = self.membersArr;
    taskTracerVc.taskTracerModels = self.joinMembers;

    [self.navigationController pushViewController:taskTracerVc animated:YES];
}

- (void)getReceiveMember {
    
    //编辑状态人员的获取，用于修改
    
    if (_eidteBuilderDaily) {
        
        [self selMembers:_logDetailModel.receiver_list.list];
        
        return;
    }
    
    NSDictionary *parameters = @{@"group_id" : self.WorkCicleProListModel.group_id?:@"",
                                 @"class_type" : self.WorkCicleProListModel.class_type?:@"",
                                 @"msg_type"  : @"log"
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/last-recuid_list" parameters:parameters success:^(id responseObject) {
        
        NSArray *members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self selMembers:members];
        
    } failure:^(NSError *error) {
       
        
        
    }];
    
}

- (void)taskTracerVc:(JGJTaskTracerVc *)principalVc didSelelctedMembers:(NSArray *)members isSelectedAllMembers:(BOOL)isSelectedAllMembers{

    _isSelectedAllMembers = isSelectedAllMembers;
    self.joinMembers = principalVc.taskTracerModels;
    
    [self selMembers:members];
    
}

- (void)selMembers:(NSArray *)members {
    
    [self.membersArr removeAllObjects];
    
    [self.membersArr addObjectsFromArray:members];
    
    //得到最后一个添加模型
    NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
    
    [self.membersArr addObjectsFromArray:addModels];
    
    [_tableview reloadData];
}

@end
