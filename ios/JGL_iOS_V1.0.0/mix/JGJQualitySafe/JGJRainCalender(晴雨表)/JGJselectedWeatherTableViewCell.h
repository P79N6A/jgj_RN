//
//  JGJselectedWeatherTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,JGJWeatherModel) {
    FSWeatherModelqing,
    FSWeatherModelyin,
    FSWeatherModelduoyun,
    FSWeatherModelyu,
    FSWeatherModelxue,
    FSWeatherModelwu,
    FSWeatherModelmai,
    FSWeatherModelbingdong,
    FSWeatherModelfeng,
    FSWeatherModeltingdian

};
typedef NS_ENUM(NSUInteger,indexPathRow) {
    indexpathRowOne = 0,
    indexpathRowtwo,
    indexpathRowthree,
    indexpathRowfour,
    indexpathRowfive,
    indexpathRowsix,
    indexpathRowseven
};
@protocol selectWeatherdelegate <NSObject>

-(void)selectWeatherWithWeatherArr:(NSMutableArray *)WeatherArr;

-(void)cleanRainCalenderVC;

-(void)tapCalender;

-(void)removeWeatherShowAler;

@end
@interface JGJselectedWeatherTableViewCell : UITableViewCell
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic ,strong)UIImageView *centerPlaceView;

@property(nonatomic ,strong)UIView *upleftView;//左上角的选择框
@property(nonatomic ,strong)UIView *uprightView;//右上角的选择框
@property(nonatomic ,strong)UIView *downleftView;//做下面的选择框
@property(nonatomic ,strong)UIView *downrightView;//有下面的选择框
@property(nonatomic ,strong)UIImageView  *upleftimageView;//默认选择的图标
@property(nonatomic ,strong)UIImageView  *uprightimageView;//默认选择的图标
@property(nonatomic ,strong)UIImageView  *downleftimageView;//默认选择的图标
@property(nonatomic ,strong)UIImageView  *downrightimageView;//默认选择的图标
@property(nonatomic ,strong)UIView *centerView;
@property(nonatomic ,strong)UILabel  *firsttitlelable;
@property(nonatomic ,strong)UILabel  *secondtitlelable;
@property(nonatomic ,strong)UILabel  *thirdtitlelable;
@property(nonatomic ,strong)UILabel  *fourtitlelable;
@property(nonatomic ,strong)UILabel   *firstnumLable;
@property(nonatomic ,strong)UILabel   *secondnumLable;
@property(nonatomic ,strong)UILabel   *thrednumLable;
@property(nonatomic ,strong)UILabel   *fournumLable;
@property(nonatomic ,strong)NSMutableArray   *WeatherArr;
@property(nonatomic ,strong)UITableView   *tableview;
@property(nonatomic ,strong)id<selectWeatherdelegate> delegate;
/*
 *是不是编辑天气
 */
@property(assign ,nonatomic)BOOL editeRainCalender;
-(void)editeRainCalenderWithArr:(NSMutableArray *)weaterArr;
@end
