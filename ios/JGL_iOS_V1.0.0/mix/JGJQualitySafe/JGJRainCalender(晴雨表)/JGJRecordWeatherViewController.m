//
//  JGJRecordWeatherViewController.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordWeatherViewController.h"
#import "JGJrecordDateTableViewCell.h"
#import "JGJselectedWeatherTableViewCell.h"
#import "JGJTempTableViewCell.h"
#import "JGJWindTableViewCell.h"
#import "JGJremarkWeatherTableViewCell.h"
#import "JGJBottomVIewAndButton.h"
#import "CustomAlertView.h"
#import "NSString+Extend.h"
#import "JGJTime.h"
#import "FDAlertView.h"

#import "JGJWeatherPickerview.h"
@interface JGJRecordWeatherViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickBottombutton,
selectWeatherdelegate,
endEditeTempdelegate,
endEditeWinddelegate,
endEditeRemarkdelegate,
FDAlertViewDelegate
>
{
    JGJselectedWeatherTableViewCell *selectedWeatherCell;
}
@property (nonatomic ,strong)JGJBottomVIewAndButton *savebutton;
@property (nonatomic,strong) UIButton *delButton;//删除的按钮
@property (nonatomic, strong) UIView *containSaveButtonView; //容纳保存按钮容器
@property (nonatomic,strong) UIButton *EditesaveButton;//保存的按钮

@end

@implementation JGJRecordWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录天气";
    [self.view addSubview:self.tableview];
    if (_EditeCalender) {
    [self.view addSubview:self.containSaveButtonView];
    CGRect rect = self.tableview.frame;
        rect.size.height -= 62;
    [self.tableview setFrame:rect];

    }else{
//    [self.view addSubview:self.savebutton];
    }
    self.tableview.backgroundColor = AppFontf1f1f1Color;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [TYNotificationCenter postNotificationName:@"dissMissWeatherPicker" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_EditeCalender) {

    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveRaincalenderApi)];
    self.navigationItem.rightBarButtonItem = barbutton;
    }
    
}
-(JGJBottomVIewAndButton *)savebutton
{
    if (!_savebutton) {
        _savebutton = [[JGJBottomVIewAndButton alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 66 - 60, TYGetUIScreenWidth, 63)];
        _savebutton.delegate = self;
        _savebutton.hidden = YES;

    }
    return _savebutton;
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 60)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JGJrecordDateTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJrecordDateTableViewCell" owner:nil options:nil]firstObject];
        [proCell setDateTimeLableText:[JGJTime getChineseCalendarWithDateAndWeek:_currentDate?:[NSDate date]] andProText:_WorkCicleProListModel.all_pro_name];

        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else if (indexPath.row == 1){
        selectedWeatherCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJselectedWeatherTableViewCell" owner:nil options:nil]firstObject];
        selectedWeatherCell.editeRainCalender = _EditeCalender;

        if (_recordWeatherModel.rainCalenderType == rainCalenderEdite || _EditeCalender) {
            NSMutableArray *arr = [NSMutableArray array];
            
            if (![_recordWeatherModel.weat_one isEqualToString:@"0"] && ![NSString isEmpty:_recordWeatherModel.weat_one]) {
                [arr addObject:[self acordingNumberReturnStr:_recordWeatherModel.weat_one]];
            }
            if (![_recordWeatherModel.weat_two isEqualToString:@"0"]&&![NSString isEmpty:_recordWeatherModel.weat_two]) {
                [arr addObject:[self acordingNumberReturnStr:_recordWeatherModel.weat_two]];

            }
            if (![_recordWeatherModel.weat_three isEqualToString:@"0"]&&![NSString isEmpty:_recordWeatherModel.weat_three]) {
                [arr addObject:[self acordingNumberReturnStr:_recordWeatherModel.weat_three]];

            }
            if (![_recordWeatherModel.weat_four isEqualToString:@"0"]&&![NSString isEmpty:_recordWeatherModel.weat_four]) {
                [arr addObject:[self acordingNumberReturnStr:_recordWeatherModel.weat_four]];

            }
            [selectedWeatherCell editeRainCalenderWithArr:arr];

            
        }
        selectedWeatherCell.delegate = self;
        selectedWeatherCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return selectedWeatherCell;
        
    }else if(indexPath.row == 2){
        
        JGJTempTableViewCell *Cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTempTableViewCell" owner:nil options:nil]firstObject];
        if (_recordWeatherModel.rainCalenderType == rainCalenderEdite || _EditeCalender) {
            [Cell setTempEditetemp_am:_recordWeatherModel.temp_am temp_pm:_recordWeatherModel.temp_pm];
        }
        Cell.delegate = self;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return Cell;
    }else if (indexPath.row == 3){
        JGJWindTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWindTableViewCell" owner:nil options:nil]firstObject];
        proCell.delegate = self;
        if (_recordWeatherModel.rainCalenderType == rainCalenderEdite || _EditeCalender) {
            [proCell setTempEditewind_am:_recordWeatherModel.wind_am wind_pm:_recordWeatherModel.wind_pm];
        }
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return proCell;
    }else if (indexPath.row == 4){
        JGJremarkWeatherTableViewCell *Cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJremarkWeatherTableViewCell" owner:nil options:nil]firstObject];
        Cell.delegate = self;
        if (_recordWeatherModel.rainCalenderType == rainCalenderEdite || _EditeCalender) {
            [Cell setTempEditecontent:_recordWeatherModel.detail];
        }
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;

    }else{
    }
    
    
    return 0;
}
-(NSString *)acordingNumberReturnStr:(NSString *)num
{
    NSString *weather;
    if ([num isEqualToString:@"0"]) {
        
    }else if ([num isEqualToString:@"1"]){
        
        weather = @"晴";
    }else if ([num isEqualToString:@"2"]){
        weather = @"阴";

    }else if ([num isEqualToString:@"3"]){
        weather = @"多云";

    }else if ([num isEqualToString:@"4"]){
        weather = @"雨";

    }else if ([num isEqualToString:@"5"]){
        weather = @"风";

    }else if ([num isEqualToString:@"6"]){
        weather = @"雪";

    }else if ([num isEqualToString:@"7"]){
        weather = @"雾";

    }else if ([num isEqualToString:@"8"]){
        weather = @"霾";

    }else if ([num isEqualToString:@"9"]){
        weather = @"冰冻";

    }else if ([num isEqualToString:@"10"]){
        weather = @"停电";

    }
    return weather;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 34;
        
    }else if (indexPath.row == 1){
        return 234;
        
    }else if(indexPath.row == 2){
        
        return 69;
        
    }else if (indexPath.row == 3){
        
        return 69;

    }else{
        return 120;

    }
    
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
}
#pragma mark - 点击保存按钮
-(void)clickBottomButtonevent
{
    [self saveRaincalenderApi];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setRecordWeatherModel:(JGJRecordWeatherModel *)recordWeatherModel
{
    if (!_recordWeatherModel) {
        _recordWeatherModel = [JGJRecordWeatherModel new];
    }
    _recordWeatherModel = recordWeatherModel;
}
-(void)cleanRainCalenderVC
{
    
    if (_recordWeatherModel) {
        _recordWeatherModel.weat_one =@"0";
        _recordWeatherModel.weat_two = @"0";
        _recordWeatherModel.weat_three = @"0";
        _recordWeatherModel.weat_four =@"0";

    }


}
#pragma mark - 设置天气选中的天气
-(void)selectWeatherWithWeatherArr:(NSMutableArray *)WeatherArr
{
    
    if (!_recordWeatherModel) {
        _recordWeatherModel = [JGJRecordWeatherModel new];
    }
    switch (WeatherArr.count) {
        case 0:
            _recordWeatherModel.weat_one =@"0";
            _recordWeatherModel.weat_two = @"0";
            _recordWeatherModel.weat_three = @"0";
            _recordWeatherModel.weat_four =@"0";

        break;
        case 1:
//          _recordWeatherModel.weat_one = WeatherArr[0];
            _recordWeatherModel.weat_one =[self acordingTextReturnNumbder:WeatherArr[0]];
            _recordWeatherModel.weat_two = @"0";
            _recordWeatherModel.weat_three = @"0";
            _recordWeatherModel.weat_four =@"0";

            break;
        case 2:
//            _recordWeatherModel.weat_one = WeatherArr[0];
//
//            _recordWeatherModel.weat_two = WeatherArr[1];
            _recordWeatherModel.weat_one =[self acordingTextReturnNumbder:WeatherArr[0]];
            _recordWeatherModel.weat_two = [self acordingTextReturnNumbder:WeatherArr[1]];
            _recordWeatherModel.weat_three = @"0";
            _recordWeatherModel.weat_four =@"0";
            break;
        case 3:
            
//            _recordWeatherModel.weat_one = WeatherArr[0];
//            
//            _recordWeatherModel.weat_two = WeatherArr[1];
//            _recordWeatherModel.weat_three = WeatherArr[2];
            
            
            _recordWeatherModel.weat_one = [self acordingTextReturnNumbder:WeatherArr[0]];
            
            _recordWeatherModel.weat_two = [self acordingTextReturnNumbder:WeatherArr[1]];
            _recordWeatherModel.weat_three = [self acordingTextReturnNumbder:WeatherArr[2]];
            _recordWeatherModel.weat_four =@"0";
            break;
        case 4:
            
//            _recordWeatherModel.weat_one = WeatherArr[0];
//            
//            _recordWeatherModel.weat_two = WeatherArr[1];
//            _recordWeatherModel.weat_three = WeatherArr[2];
//            _recordWeatherModel.weat_four = WeatherArr[3];
            _recordWeatherModel.weat_one = [self acordingTextReturnNumbder:WeatherArr[0]];
            _recordWeatherModel.weat_two = [self acordingTextReturnNumbder:WeatherArr[1]];
            _recordWeatherModel.weat_three = [self acordingTextReturnNumbder:WeatherArr[2]];
            _recordWeatherModel.weat_four =[self acordingTextReturnNumbder:WeatherArr[3]];

            break;
        default:
            break;
    }

}
-(NSString *)acordingTextReturnNumbder:(NSString *)text
{
    NSString *Str;
    if ([text isEqualToString:@"晴"]) {
        Str = @"1";
    }else if ([text isEqualToString:@"阴"]){
        Str = @"2";

    }else if ([text isEqualToString:@"多云"]){
        Str = @"3";

    }else if ([text isEqualToString:@"雨"]){
        Str = @"4";

    }else if ([text isEqualToString:@"风"]){
        Str = @"5";

    }else if ([text isEqualToString:@"雪"]){
        Str = @"6";

    }else if ([text isEqualToString:@"雾"]){
        Str = @"7";

    }else if ([text isEqualToString:@"霾"]){
        Str = @"8";

    }else if ([text isEqualToString:@"冰冻"]){
        Str = @"9";

    }else if ([text isEqualToString:@"停电"]){
        Str = @"10";
 
    }else{
        Str = @"0";
    }
    return Str;
}
#pragma mark -  编辑最低最高温度
- (void)endEditeMintemp:(NSString *)min_temp maxTemp:(NSString *)max_temp
{
    if (!_recordWeatherModel) {
    _recordWeatherModel = [JGJRecordWeatherModel new];
    }
//    if ([NSString isEmpty:min_temp] && _recordWeatherModel.temp_am.length&& _EditeCalender) {
//        _recordWeatherModel.temp_am = _recordWeatherModel.temp_am;
//    }else{
    _recordWeatherModel.temp_am = min_temp?:@"";
//    }
//    
//    if ([NSString isEmpty:max_temp] && _recordWeatherModel.temp_pm.length && _EditeCalender) {
//    _recordWeatherModel.temp_pm = _recordWeatherModel.temp_pm;
//    }else{
    _recordWeatherModel.temp_pm = max_temp?:@"";
//    }
}
#pragma mark -编辑风力
-(void)endEditeMinWind:(NSString *)min_wind maxwind:(NSString *)max_wind
{
    if (!_recordWeatherModel) {
    _recordWeatherModel = [JGJRecordWeatherModel new];
    }
//    if ([NSString isEmpty:min_wind] && _recordWeatherModel.wind_am.length&& _EditeCalender) {
//    _recordWeatherModel.wind_am = _recordWeatherModel.wind_am;
//    }else{
    _recordWeatherModel.wind_am = min_wind?:@"";
//    }
//    if ([NSString isEmpty:max_wind] && _recordWeatherModel.wind_pm.length&& _EditeCalender) {
//    _recordWeatherModel.wind_pm = _recordWeatherModel.wind_pm;
//    }else{
    _recordWeatherModel.wind_pm = max_wind?:@"";
//    }
}
#pragma mark - 输入天气对工程的影响
-(void)endEditeRemarkContent:(NSString *)content
{
    if (!_recordWeatherModel) {
        _recordWeatherModel = [JGJRecordWeatherModel new];
    }
    _recordWeatherModel.detail = content;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)saveRaincalenderApi
{
    if ([NSString isEmpty:_recordWeatherModel.weat_one ] ) {
     
        [TYShowMessage showPlaint:@"请至少选择一种天气"];
        return;
    }
    if ([_recordWeatherModel.weat_one isEqualToString:@"0"] ) {
        [TYShowMessage showPlaint:@"请至少选择一种天气"];
        return;
    }
    

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"handleWeather" forKey:@"action"];
//    [parmDic setObject:JGJSHA1Sign forKey:@"sign"];
    [parmDic setObject:@"person" forKey:@"client_type"];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGUserUid] forKey:@"uid"];

    [parmDic setObject:@"I" forKey:@"os"];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGToken] forKey:@"token"];
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
        [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
        [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    //[parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];

    [parmDic setObject:_WorkCicleProListModel.class_type?:@"team" forKey:@"class_type"];//	班组：group；项目组：team
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [parmDic setObject:app_Version forKey:@"ver"];
    
    [parmDic setObject:_recordWeatherModel.weat_one?:@"" forKey:@"weat_one"];//	一种天气
    [parmDic setObject:_recordWeatherModel.weat_two?:@"" forKey:@"weat_two"];//	二中天气
    [parmDic setObject:_recordWeatherModel.weat_three?:@"" forKey:@"weat_three"];//	三中天气
    [parmDic setObject:_recordWeatherModel.weat_four?:@"" forKey:@"weat_four"];//	四中天气
    [parmDic setObject:_recordWeatherModel.temp_am?:@"" forKey:@"temp_am"];//	上午温度
    [parmDic setObject:_recordWeatherModel.temp_pm?:@"" forKey:@"temp_pm"];//	下午温度
    [parmDic setObject:_recordWeatherModel.wind_am?:@"" forKey:@"wind_am"];//	上午风力
    [parmDic setObject:_recordWeatherModel.wind_pm?:@"" forKey:@"wind_pm"];//	下午风力
    [parmDic setObject:_recordWeatherModel.detail?:@"" forKey:@"detail"];//	接受风力的影响
    [parmDic setObject:[JGJTime yearAppendMonthanddayfromstamp:_currentDate?:[NSDate date]] forKey:@"month"];//	接受风力的影响

    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    [alertView showProgressImageView:@"正在发布..."];

    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/handleWeather" parameters:parmDic success:^(id responseObject) {
        [TYShowMessage showSuccess:@"保存成功"];
        [alertView dismissWithBlcok:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [TYShowMessage showSuccess:@""];
    }];
}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
        _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;
}

- (UIButton *)delButton {
    
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, TYGetUIScreenWidth/2 - 20, 45)];
        _delButton.backgroundColor = [UIColor whiteColor];
        [_delButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_delButton addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
 
    }
    return _delButton;
}
-(UIButton *)EditesaveButton
{
    if (!_EditesaveButton) {
        _EditesaveButton = [[UIButton alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth/2 + 10, 9, TYGetUIScreenWidth/2 - 20, 45)];
        _EditesaveButton.backgroundColor = JGJMainColor;
        _EditesaveButton.titleLabel.textColor = [UIColor whiteColor];
        [_EditesaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_EditesaveButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_EditesaveButton addTarget:self action:@selector(saveRaincalenderApi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _EditesaveButton;
}
-(UIView *)containSaveButtonView
{
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 124 - iphoneXheightscreen, TYGetUIScreenWidth, 60)];
        _containSaveButtonView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        label.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:label];
        [_containSaveButtonView addSubview:self.EditesaveButton];
        [_containSaveButtonView addSubview:self.delButton];
        
    }
    return _containSaveButtonView;
}
//删除
-(void)delBtnClick
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"晴雨表删除后不能恢复，你确定要删除吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
    //    alert.tag = 1;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    
    [alert show];
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        [self deleteRainCalenderAPI];
    }
    
    alertView.delegate = nil;
    alertView = nil;
}
-(void)deleteRainCalenderAPI
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"delWeather" forKey:@"action"];
    [parmDic setObject:@"person" forKey:@"client_type"];
    [parmDic setObject:_recordWeatherModel.uid?:@"" forKey:@"uid"];//记录员的uid
    [parmDic setObject:_recordWeatherModel.id?:@"" forKey:@"id"];
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/delWeather" parameters:parmDic success:^(id responseObject) {
        [TYShowMessage showSuccess:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}
-(void)removeWeatherShowAler
{
    
    [TYNotificationCenter postNotificationName:@"dissMissWeatherPicker" object:nil];
    
}
-(void)tapCalender
{

    [self.view endEditing:YES];
}
@end
