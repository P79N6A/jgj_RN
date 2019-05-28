//
//  JGJSelectedCurrentCityVC.m
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSelectedCurrentCityVC.h"
#import "CityMenuView.h"
#import "UILabel+GNUtil.h"
#import "UIView+Extend.h"
#import "TYFMDB.h"
#import "NSString+Extend.h"

//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)
@interface JGJSelectedCurrentCityVC ()

@end

@implementation JGJSelectedCurrentCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
}

- (void)creatSubViews {
    self.title = @"所在城市";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat containViewHeight = 48.0;
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(@(containViewHeight));
    }];
    
    NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
    
    NSString *cityNo = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *parent_id = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:cityNo byColume:@"parent_id"];
    
    NSString *province_name = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:parent_id byColume:@"city_name"];
    
    NSString *provinceCityName = [NSString stringWithFormat:@"%@ %@", province_name, cityName];

    UILabel *currentCityLable = [[UILabel alloc] init];
    
    //是否开启定位
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || status ==  kCLAuthorizationStatusNotDetermined) {
        
        provinceCityName = @"未开启定位,请选择城市";
        
    }else if ([NSString isEmpty:provinceCityName]) {
        
         provinceCityName = @"当前位置暂未获取,请选择城市";
    }
    
    self.cityModel.provinceCityName = provinceCityName;
    
    currentCityLable.text = [NSString stringWithFormat:@"%@%@",@"当前所在城市:", self.cityModel.provinceCityName?:@"未开启定位,请选择城市"];
    
    currentCityLable.font = [UIFont systemFontOfSize:AppFont28Size];
    currentCityLable.textColor = AppFont333333Color;
    [currentCityLable markText:self.cityModel.provinceCityName withColor:AppFontd7252cColor];
    [containView addSubview:currentCityLable];
    [currentCityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(containView).offset(5);
        make.left.mas_equalTo(containView).offset(13);
    }];
    
    CGRect rect = CGRectMake(0, containViewHeight  + TopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - containViewHeight - 64);
    __weak typeof(self) weakSelf = self;
    CityMenuView *cityMenuView = [[CityMenuView alloc] initWithFrame:rect cityName:^(JLGCityModel *cityModel) {
        if ([weakSelf.delegate respondsToSelector:@selector(handleJGJSelectedCurrentCityModel:)]) {
            [weakSelf.delegate handleJGJSelectedCurrentCityModel:cityModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    cityMenuView.isCancelAllProvince = YES;
    [self.view addSubview:cityMenuView];
}
@end
