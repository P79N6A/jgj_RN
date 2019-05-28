//
//  JGJProMangeAddressVc.m
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProMangeAddressVc.h"
#import "CityMenuView.h"
#import "UILabel+GNUtil.h"
#import "UIView+Extend.h"
#import "TYFMDB.h"
#import "NSString+Extend.h"

#import "JLGSearchViewController.h"

#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)

@interface JGJProMangeAddressVc ()
<

    JLGSearchViewControllerDelegate

>

@end

@implementation JGJProMangeAddressVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
}

- (void)creatSubViews {
    self.title = @"项目地址";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = 48.0;
    
    UILabel *proNameLable = [[UILabel alloc] init];
    
    proNameLable.backgroundColor = AppFontf1f1f1Color;
    
    proNameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    proNameLable.text = [NSString stringWithFormat:@"   请为 %@ 设置项目地址", self.proName];
    proNameLable.numberOfLines = 0;
    proNameLable.textColor = AppFont999999Color;
    
    [proNameLable markText:self.proName withColor:AppFont333333Color];
    
    [self.view addSubview:proNameLable];
    
    [proNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    
    UIView *lineView = [UIView new];
    
    lineView.backgroundColor = AppFontdbdbdbColor;
    
     [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(proNameLable.mas_bottom);
        
        make.left.mas_equalTo(self.view).offset(12);
        
        make.right.mas_equalTo(self.view).offset(-12);
        
        make.height.mas_equalTo(0.5);
    }];
    
   
    UILabel *currentCityLable = [[UILabel alloc] init];
    
    currentCityLable.backgroundColor = [UIColor whiteColor];
    
    self.cityModel.provinceCityName = [NSString isEmpty:self.cityModel.city_name] ? @"未开启定位,请选择城市" : self.cityModel.provinceCityName;
    
    currentCityLable.text = [NSString stringWithFormat:@"%@%@",@"当前所在城市:", self.cityModel.provinceCityName];
    currentCityLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    currentCityLable.textColor = AppFont333333Color;
    
    [currentCityLable markText:self.cityModel.provinceCityName withColor:AppFontd7252cColor];
    
    [self.view addSubview:currentCityLable];
    
    currentCityLable.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCurCity)];
    
    tap.numberOfTapsRequired = 1;
    
    [currentCityLable addGestureRecognizer:tap];
    
    [currentCityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(self.view).offset(13);
        make.height.mas_equalTo(height);
    }];
    
    CGFloat maxY = height * 2;

    CGRect rect = CGRectMake(0, maxY  + TopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - maxY - 64);
    __weak typeof(self) weakSelf = self;
    CityMenuView *cityMenuView = [[CityMenuView alloc] initWithFrame:rect cityName:^(JLGCityModel *cityModel) {
//        if ([weakSelf.delegate respondsToSelector:@selector(handleProMangeSelectedCurrentCityModel:)]) {
//            [weakSelf.delegate handleProMangeSelectedCurrentCityModel:cityModel];
//        }
        
        [weakSelf handleSearchDetailAddress:cityModel];
    }];
    
    cityMenuView.isCancelAllProvince = YES;
    
    [self.view addSubview:cityMenuView];
}

- (void)handleSearchDetailAddress:(JLGCityModel *)cityModel {
    
    JLGSearchViewController *searchVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"geosearch"];
    
    searchVc.searchName = cityModel.city_name;
    
    searchVc.delegate = self;
    
    searchVc.cityModel = cityModel;
    
    searchVc.proName = self.proName;
    
    [self.navigationController pushViewController:searchVc animated:YES];

}

- (void)clickCurCity {
    
    [self handleSearchDetailAddress:self.cityModel];
    
}

- (void)searchVcCancel {


}

- (void)searchVcSelectLocation:(NSString *)location addressName:(NSString *)addressName {


}

@end
