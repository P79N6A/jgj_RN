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
#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)
@interface JGJSelectedCurrentCityVC ()

@end

@implementation JGJSelectedCurrentCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
}

- (void)creatSubViews {
    self.title = @"当前所在城市";
    CGFloat containViewHeight = 48.0;
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(@(containViewHeight));
    }];

    UILabel *currentCityLable = [[UILabel alloc] init];
    self.cityModel.provinceCityName = [NSString isEmpty:self.cityModel.city_name] ? @"未开启定位,请选择城市" : self.cityModel.provinceCityName;
    currentCityLable.text = [NSString stringWithFormat:@"%@%@",@"当前所在城市:", self.cityModel.provinceCityName];
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
