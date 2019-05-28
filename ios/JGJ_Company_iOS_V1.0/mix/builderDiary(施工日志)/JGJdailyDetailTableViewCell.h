//
//  JGJdailyDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWeatherPickerview.h"
@protocol clickRecordWeatherlable <NSObject>

-(void)clicKRecordWeatherlableAndtag:(NSInteger)tag;
-(void)selectWeatherAm:(NSString *)am_weather andtag:(NSInteger)tag;//选择上午天气
-(void)selectWeatherpm:(NSString *)pm_weather andtag:(NSInteger)tag;//选择下午天气
-(void)selectTempAm:(NSString *)am_temp andtag:(NSInteger)tag;//选择上午温度
-(void)selectTempPm:(NSString *)pm_temp andtag:(NSInteger)tag;//选择下午温度
-(void)selectWindAm:(NSString *)am_wind andtag:(NSInteger)tag;//选择上午风力
-(void)selectWindPm:(NSString *)Pm_wind andtag:(NSInteger)tag;//选择下午风力

@end

@interface JGJdailyDetailTableViewCell : UITableViewCell
<
didselectweaterindexpath,
UITextFieldDelegate,
UITextViewDelegate
>
@property (nonatomic ,strong)UIView *placeView;
@property (nonatomic ,strong)UILabel *weatherLable;
@property (nonatomic ,strong)UILabel *dispartLableone;
@property (nonatomic ,strong)UILabel *sunylablem;
@property (nonatomic ,strong)UILabel *sunylablea;
@property (nonatomic ,strong)UILabel *templable;
@property (nonatomic ,strong)UITextView *templablem;
@property (nonatomic ,strong)UITextView *templablea;
@property (nonatomic ,strong)UILabel *windlable;
@property (nonatomic ,strong)UILabel *tempPlace_m;//温度上午
@property (nonatomic ,strong)UILabel *tempPlace_a;//温度下午
@property (nonatomic ,strong)UILabel *windPlace_m;//风力上午
@property (nonatomic ,strong)UILabel *windPlace_a;//风力下午
@property (nonatomic ,strong)UITextView *windlablem;
@property (nonatomic ,strong)UITextView *windlablea;
@property (nonatomic ,strong)id <clickRecordWeatherlable> delegate;
@property (nonatomic ,strong)NSMutableArray *morningArr;//上午选择的天气
@property (nonatomic ,strong)NSMutableArray *afterArr;//下午选择的天气
@property (nonatomic ,strong)JGJSendDailyModel *sendDailyModel;//下午选择的天气
-(void)setweather_am:(NSString *)weather_am wether_pm:(NSString *)wether_pm tem_am:(NSString *)temp_am temp_pm:(NSString *)temp_pm wind_am:(NSString *)wind_am wimd_pm:(NSString *)wind_pm;
@end
